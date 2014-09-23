---
layout: post
title: "Gradle: set different name for wrapper and default build script"
category: dev
tags: [gradle, groovy]
---
{% include JB/setup %}

## Overview

Thanks to [mrhaki](http://www.mrhaki.com/) and his awesome presentation on [GR8Conf](http://gr8conf.eu/#/) in Copenhagen I learnt that in Gradle it is possible to change the name of the wrapper and default build script. On his talk mrhaki showed us how we can confuse people that we are using Gradle instead of Maven :)

Thank you!

In this post I would like to show similar stuff but present Ant replacement.

## Simple project

Let's create a **build.gradle** with the following content:

{% highlight groovy %}
task createMyOwnWrapper(type: Wrapper) {
    gradleVersion = '2.0'
    scriptFile = 'ant'
}
{% endhighlight %}

and run it:

    gradle cMOW

It should create the following stucture:

    .
    ├── ant
    ├── ant.bat
    ├── build.gradle
    └── gradle
        └── wrapper
            ├── gradle-wrapper.jar
            └── gradle-wrapper.properties


Now, let's create **settings.gradle** file with the following content:

{% highlight groovy %}
rootProject.buildFileName = 'build.xml'
{% endhighlight %}

And that's it. We can do the switch. When we call:

    ./ant tasks --all

It will display all available tasks:

    :tasks

    ------------------------------------------------------------
    All tasks runnable from root project
    ------------------------------------------------------------

    Build Setup tasks
    -----------------
    init - Initializes a new Gradle build. [incubating]
    wrapper - Generates Gradle wrapper files. [incubating]

    Help tasks
    ----------
    dependencies - Displays all dependencies declared in root project 'gradle-ant'.
    dependencyInsight - Displays the insight into a specific dependency in root project 'gradle-ant'.
    help - Displays a help message
    projects - Displays the sub-projects of root project 'gradle-ant'.
    properties - Displays the properties of root project 'gradle-ant'.
    tasks - Displays the tasks runnable from root project 'gradle-ant'.

    Other tasks
    -----------
    createMyOwnWrapper

    BUILD SUCCESSFUL

    Total time: 27.701 secs


We can tell our managers that we are still using Ant :)
