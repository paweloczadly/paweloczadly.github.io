---
layout: post
title: "Packer: build and test your VM images"
category: devops
tags: [packer, vagrant]
---
{% include JB/setup %}

## What is Packer?

[Packer](http://www.packer.io/) is an open source tool created by [Mitchell Hashimoto](http://mitchellh.com/). It allows you to build virtual machine images for different platforms. For example: Amazon, VMware or VirtualBox. Thanks to Packer you can store your virtual machine set up in single json file with some bash scripts and keep it in source code repository. Packer works on different operating systems - also on Windows :)

## Packer vs configuration management tools

In fact, Packer could replace available CM tools like Chef, Ansible or Salt. However, better way is to install CM tool during building an image and then use it to the hard work. For example you can create a bash script which installs Chef with proper keys and then registers the node to your Chef Server.

## Prerequisites

Packer needs VirtualBox to build the image. So, you should install the following:

- [VirtualBox](https://www.virtualbox.org/)
- [Packer](http://www.packer.io/)

Then add both tools to **PATH** environment variable.

## Building and testing a VM image

Let's create a base image using Packer and then test if it is usable using [Vagrant](https://www.vagrantup.com/).

### Preparation

Firstly, you need to prepare preseed and json file for your image.

Preseed contains very low level information of the OS, such as locale settings, time/zone and clock, network, disks settings, grub amd many more. For this example I would recommend to use one from Mitchell Hashimoto:

[preseed.cfg](https://github.com/mitchellh/packer-ubuntu-12.04-docker/blob/master/http/preseed.cfg)

Json file contains some information about the image (iso url, checksum), ssh user and also provisioners - where you run your scripts. Let's create a simple json file which will allow us to use it in Vagrant:

{% highlight json %}
{
  "builders": [
    {
      "type": "virtualbox-iso",
      "iso_url": "http://releases.ubuntu.com/13.10/ubuntu-13.10-server-amd64.iso",
      "iso_checksum": "4d1a8b720cdd14b76ed9410c63a00d0e",
      "iso_checksum_type": "md5",
      "boot_wait": "5s",
      "boot_command": [
        "<esc><esc><enter><wait>",
        "/install/vmlinuz noapic preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>",
        "debian-installer=en_US auto locale=en_US kbd-chooser/method=us <wait>",
        "hostname={{ .Name }} <wait>",
        "fb=false debconf/frontend=noninteractive <wait>",
        "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA keyboard-configuration/variant=USA console-setup/ask_detect=false <wait>",
        "initrd=/install/initrd.gz -- <enter><wait>"
      ],
      "guest_os_type": "Ubuntu_64",
      "http_directory": "http",
      "shutdown_command": "echo 'vagrant' | sudo -S shutdown -P now",
      "ssh_wait_timeout": "20m",
      "guest_additions_path": "VBoxGuestAdditions_{{.Version}}.iso",
      "virtualbox_version_file": ".vbox_version",
      "ssh_username": "vagrant",
      "ssh_password": "vagrant",
      "headless": false
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "script": "scripts/vagrant.sh",
      "execute_command": "echo 'vagrant' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    },
    {
      "type": "shell",
      "script": "scripts/virtualbox.sh",
      "override": {
        "virtualbox-iso": {
          "execute_command": "echo 'vagrant' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
        }
      }
    }
  ],
  "post-processors": [
    "vagrant"
  ]
}
{% endhighlight %}

Now, it's time to create two bash scripts (I recommend to create new directory **scripts** for them):

- ```vagrant.sh``` which will set up settings for **vagrant** user.

{% highlight bash %}
#!/bin/bash

# Set up sudo
echo %vagrant ALL=NOPASSWD:ALL > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# Setup sudo to allow no-password sudo for "sudo"
usermod -a -G sudo vagrant

# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Install NFS for Vagrant
apt-get update
apt-get install -y nfs-common
{% endhighlight %}

- ```virtualbox.sh``` which will set up required settings for VirtualBox

{% highlight bash %}
# Without libdbus virtualbox would not start automatically after compile
apt-get -y install --no-install-recommends libdbus-1-3

# The netboot installs the VirtualBox support (old) so we have to remove it
/etc/init.d/virtualbox-ose-guest-utils stop
rmmod vboxguest
aptitude -y purge virtualbox-ose-guest-x11 virtualbox-ose-guest-dkms virtualbox-ose-guest-utils
aptitude -y install dkms

# Install the VirtualBox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
VBOX_ISO=VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop $VBOX_ISO /mnt
yes|sh /mnt/VBoxLinuxAdditions.run
umount /mnt

#Cleanup VirtualBox
rm $VBOX_ISO
{% endhighlight %}

### Building a VM image

The json file and bash scripts are ready. Now, it's time to build the image. To do this you can call:

{% highlight bash %}
$ packer build --force -only virtualbox-iso <name-of-your-file>.json
{% endhighlight %}

This can take a couple of minutes. [Here]({{ site.url }}/assets/2014-09-05-packer-build-and-test-your-vm-images_packer-build-logs.txt) you can find the output of ```packer build``` execution.

### Testing a VM image

In the next, you can test if your image is usable. To do that, you can add freshly create image to ```~/.vagrant.d/boxes```. You can call:

{% highlight bash %}
$ vagrant box add packer_vagrant packer_virtualbox-iso_virtualbox.box --force
{% endhighlight %}

It should generate similar output:

{% highlight bash %}
==> box: Adding box 'packer_vagrant' (v0) for provider:
    box: Downloading: file://C:/hybris/packer-example/packer_virtualbox-iso_virtualbox.box
    box: Progress: 100% (Rate: 597M/s, Estimated time remaining: --:--:--)
==> box: Successfully added box 'packer_vagrant' (v0) for 'virtualbox'!
{% endhighlight %}

Your box is ready to use by Vagrant. Let's create Vagrantfile which will use it:

{% highlight bash %}
$ vagrant init packer_vagrant --minimal
{% endhighlight %}

This will produce a message that Vagrantfile has been created:

{% highlight bash %}
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
{% endhighlight %}

After that you can call ```vagrant up``` to test box built by Packer. This should produce [this output]({{ site.url }}/assets/2014-09-05-packer-build-and-test-your-vm-images_vagrant-up-log.txt).

## Summary

Thanks to Packer we can enable Infrastructure as a Code from the beginning in our project. We can store virtual machine image in source code repository. We can also automate the process of building and testing the image using Continuous Integration system such as Jenkins or TeamCity.
