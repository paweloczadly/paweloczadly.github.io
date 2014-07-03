---
layout: post
title: "Jenkins Groovy script: List all jobs"
category: dev
tags: [jenkins, groovy]
---
{% include JB/setup %}

## Overview

To list all available jobs in the Jenkins server, navigate to Manage Jenkins -> Script Console and paste the following content. Then click **run** button.

{% highlight groovy %}
println Jenkins.instance.projects.collect { it.name }
{% endhighlight %}