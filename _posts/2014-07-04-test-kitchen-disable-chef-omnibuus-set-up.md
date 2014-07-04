---
layout: post
title: "Test Kitchen: Disable Chef omnibuus set up"
category: devops
tags: [chef, test-kitchen]
---
{% include JB/setup %}

## Overview

By default Test Kitchen during converge process does the following:

- Spin up the machine based on provider set up (e.g. Vagrant box)
- Installs [omnibus chef package](http://www.getchef.com/blog/2012/06/29/omnibus-chef-packaging/) in the machine
- Apply the run list specified in .kitchen.yml

You can have prepared your own box with preconfigured chef. In this case there is no sense to download the omnibus chef package every time.

To disable it, open your **.kitchen.yml** file and add the following line to the **provisioner** section:

  require_chef_omnibus: true
