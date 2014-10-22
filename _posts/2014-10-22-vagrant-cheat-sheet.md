---
layout: post
title: "Vagrant cheat sheet"
category: devops
tags: [vagrant]
comments: true
share: true
---
# Boxes

Interacting with Vagrant boxes. The are stored in ```~/.vagrant.d/boxes```

## vagrant box list

lists all boxes

## vagrant box add

installs new box

*examples*:

- local: ```vagrant box add debian-76 packer_virtualbox-iso_virtualbox.box```

- remote: ```vagrant box add ubuntu-64 http://my.domain.com/ubuntu-64.box```

## vagrant box remove

uninstalls box

*examples*:

```vagrant box remove coreos-alpha```

*note*: it doesn't remove box directory

{% highlight bash %}
$ tree ~/.vagrant.d/boxes
/Users/paweloczadly/.vagrant.d/boxes
├── coreos-alpha
│   ├── 459.0.0
│   └── metadata_url
├── coreos-stable
│   ├── 444.5.0
│   │   └── virtualbox
│   │       ├── Vagrantfile
│   │       ├── base_mac.rb
│   │       ├── box.ovf
│   │       ├── change_host_name.rb
│   │       ├── configure_networks.rb
│   │       ├── coreos_production_vagrant_image.vmdk
│   │       └── metadata.json
│   └── metadata_url
├── debian-76-amd64
│   └── 0
│       └── virtualbox
│           ├── Vagrantfile
│           ├── box.ovf
│           ├── metadata.json
│           └── packer-virtualbox-iso-disk1.vmdk
└── hashicorp-VAGRANTSLASH-precise64
    ├── 1.1.0
    │   └── virtualbox
    │       ├── Vagrantfile
    │       ├── box-disk1.vmdk
    │       ├── box.ovf
    │       └── metadata.json
    └── metadata_url

1 directory, 1 file
{% endhighlight %}

# Workspace

Interacting with your Vagrant environment inside workspace.

## vagrant init

initializes workspace and creates *Vagrantfile* and *.vagrant* directory

*note*: you can use ```--minimal``` option

## vagrant up

runs Vagrant environment

*note*: you can use ```--no-provision``` option

## vagrant status

example:

{% highlight bash %}
$ vagrant status
Current machine states:

core-01                   running (virtualbox)
core-02                   running (virtualbox)
core-03                   running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`
{% endhighlight %}

## vagrant provision

reruns box configuration, doesn't recreate box

*note*: if you have > 1 provisioners you can specify it with ```provision-with``` option

## vagrant ssh

connects to the machine

## vagrant destroy

cleans the workspace, destroy box

*note*: ```-f``` option destroys destroys box without prompt
