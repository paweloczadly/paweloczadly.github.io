---
layout: post
title: "Orchestrating more than one node using Chef"
category: devops
tags: [chef]
comments: true
share: true
---

If you want to provision or update more than one node with Chef, there are two possibilities to do this.

- Pull on each agent. You can connect via ssh to each client and call:

{% highlight bash %}
$ sudo chef-client
{% endhighlight %}

- Push to each agent. You can connect via ssh to Chef server and call:

{% highlight bash %}
$ knife ssh -x user -P password 'name:(name-regex-of-your-clients)' 'sudo chef-client'
{% endhighlight %}

This will provision all clients which match regular expression specified in name attribute.
