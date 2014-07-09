---
layout: post
title: "Gradle: How to use variables and methods from another Gradle file"
category: dev
tags: [gradle, groovy]
---
{% include JB/setup %}

## Overview

Sometimes in your build script you have to import some variables and methods from another build scripts.

Let's assume, we have the following structure:

    .
    ├── build.gradle
    └── sub
        ├── file1.gradle
        └── file2.gradle


the main build script (build.gradle file) will use files included in **sub** directory to import some variables and methods. To do this, we have to tell Gradle to have a look to these files. In the main script we have two tasks which list variables and methods available in other build scripts:

{% highlight groovy %}
fileTree('sub').each { apply from: "${it}" }

task listVars << {
  println "var1 = $var1"
  println "var2 = $var2"
}

task listMethods << {
  println "m1 = ${m1(var1)}"
  println "m2 = ${m2(var2)}"
}
{% endhighlight %}

Then inside the **sub/file1.gradle** let's define **var1** variable and **m1** closure in ext:

{% highlight groovy %}
ext.var1 = 'val1'

ext.m1 = {
  "inside m1 $it"
}
{% endhighlight %}

The **sub/file2.gradle** will look similar:

{% highlight groovy %}
ext.var2 = 'val2'

ext.m2 = {
  "inside m2 $it"
}
{% endhighlight %}

[Gradle ext](http://www.gradle.org/docs/current/dsl/org.gradle.api.plugins.ExtraPropertiesExtension.html) doesn't allow to specify methods inside. However, thanks to Groovy language we can use [closures](http://groovy.codehaus.org/Closures) instead of methods. To pass more than one parameter to the method -> in this case closure, we have to do this in this way:

{% highlight groovy %}
ext.m3 = { val1, val2 ->
  // body...
}
{% endhighlight %}

and invoke it in this way:
{% highlight groovy %}
m3('1', '2')
{% endhighlight %}
