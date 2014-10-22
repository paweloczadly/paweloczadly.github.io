---
layout: post
title: "Vagrant tips and tricks"
category: devops
tags: [vagrant]
comments: true
share: true
---

# Why this post?

In this post I would like to focus on some *this and that* for Vagrant. These thighs are really helpful in everyday's work with Vagrant.

# Multiple boxes

It is possible to spin up more than one box.

{% highlight ruby linenos %}
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "node1" do |n1|
    n1.vm.box = "hashicorp/precise64"
    # this could provisioned by shell script for example
  end

  config.vm.define "node2" do |n2|
    n2.vm.box = "chef/centos-6.5"
    # and this with Chef
  end

end
{% endhighlight %}

# Environment variables

It is possible to use environment variables in Vagrantfile. You can do it in the same way as in Ruby by calling ```ENV['variable_name']```

{% highlight ruby linenos %}
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # firstly, export boxname=hashicorp/precise64
  config.vm.box = "#{ENV['boxname']}"
end
{% endhighlight %}

# Random number of boxes

Vagrantfile allows to use Ruby code. Let's create a random number of Vagrant boxes.

{% highlight ruby linenos %}
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Random.rand(3..8).times do |i|
    config.vm.define "horst-box#{i + 1}" do |node|
      node.vm.box = "hashicorp/precise64"
    end
  end
end
{% endhighlight %}

# Network settings

In Vagrantfile you can configure ip address for your boxes and forward specific ports.

{% highlight ruby linenos %}
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.network "private_network", ip: "192.168.1.2"
  config.vm.network "forwarded_port", guest: 80, host: 8888
end
{% endhighlight %}

# Synchronized folders

Vagrant also allows to synchronize folders. By default current workspace (directory on the host where is Vagrantfile) is available in ```/vagrant``` on guest.

{% highlight ruby linenos %}
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.synced_folder "/Users/paweloczadly/dev", "/dev_data"
end
{% endhighlight %}

# Virtualbox settings

Last thing which I would like to show is customization of some settings for Virtualbox provider: box name, it's memory and processors.

{% highlight ruby linenos %}
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise64"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.name = 'new-name-of-the-box'
    vb.memory = 2048
    vb.cpus = 4
  end
end
{% endhighlight %}
