---
layout: post
title: "Set up JAVA_HOME on Jenkins agents using Groovy script"
category: dev
tags: [jenkins, groovy]
---
{% include JB/setup %}

## Overview

Sometimes you need to set up JAVA_HOME environment variable on many Jenkins slaves. You can do that manually or by configuration management tools such as (Chef, Ansible or Puppet). You can also do that from Jenkins user interface. To do this manually, navigate to Manage Jenkins -> Manage Nodes -> select node -> Configure -> select checkbox Environment Variables in Node Properties -> click Add button. In the name field type JAVA_HOME and in the value field specify the location.

This is a lot of actions. It is possible to automate it using Groovy script in **Jenkins Script Console**. To this navigate to Manage Jenkins -> Script Console and paste the following. Then pick **run** button.

{% highlight groovy %}
import hudson.slaves.*

def javaHome = new EnvironmentVariablesNodeProperty(
    new EnvironmentVariablesNodeProperty.Entry('JAVA_HOME', '/usr/lib/jvm/java-7-oracle-amd64'))

hudson.model.Hudson.instance.slaves.each { it.nodeProperties.add(javaHome) }
{% endhighlight %}