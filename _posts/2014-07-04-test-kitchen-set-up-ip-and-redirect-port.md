---
layout: post
title: "Test Kitchen: Set up IP and redirect port"
category: devops
tags: [chef, test-kitchen]
comments: true
share: true
---

## Overview

To configure IP address and port redirection in Test Kitchen, you should add the following lines to yor **platfrom** section:

    platforms:
    - name: ubuntu-12.04
    driver:
        network:
            - ["forwarded_port", {guest: 8080, host: 8080}]
            - ["private_network", {ip: "192.168.33.34"}]

If you use Vagrant provider, you should see the following line during **kitchen converge**:

    [default] -- 8080 => 8080 (adapter 1)
