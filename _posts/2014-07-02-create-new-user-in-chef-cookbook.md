---
layout: post
title: "Create new user in Chef cookbook"
category: devops
tags: [chef, ruby]
---
{% include JB/setup %}

## Overview

During working on creating new user in my Chef cookbook I encountered a problem with setting up proper password. I fixed this with **unix_crypt** gem and [chef_gem](http://docs.opscode.com/resource_chef_gem.html) resource.

{% highlight ruby %}
chef_gem 'unix-crypt'

require 'unix_crypt'

username    = 'paweloczadly'
password    = 'top_secret'

user username do
    action       :create
    home         "/home/#{username}"
    shell        '/bin/bash'
    password     UnixCrypt::SHA256.build(password)
    manage_home  true
end
{% endhighlight %}
