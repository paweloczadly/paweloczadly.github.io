---
layout: post
title: "GVM on Windows"
category: dev
tags: [groovy, gvm, windows]
---
{% include JB/setup %}

## What is GVM

GVM allows you to manage different versions of Gradle. It also contains some other useful Groovy tools and frameworks such as:

- crash
- gaiden
- glide
- grails
- griffon
- groovy
- groovyserv
- lazybones
- springboot
- vertx

More info: <http://gvmtool.net/>

## Installation

- Check your PowerShell version

{% highlight PowerShell %}
$PSVersionTable.PSVersion
{% endhighlight %}

- If the version is less than 3 update PowerShell by installing [this update](http://www.microsoft.com/en-us/download/details.aspx?id=34595)

- Check your PowerShell modules path

{% highlight PowerShell %}
$env:PSModulePath
{% endhighlight %}

- If the modules directory does not exist, create it (C:\Users\paweloczadly\Documents\WindowsPowerShell\Modules)

- Clone the [posh-gvm](https://github.com/flofreud/posh-gvm) repository to the modules directory:

{% highlight PowerShell %}
git clone https://github.com/flofreud/posh-gvm
{% endhighlight %}

- Import posh-gvm module

{% highlight PowerShell %}
Import-Module posh-gvm
{% endhighlight %}

## Verification

    > gvm help

    Usage: gvm <command> <candidate> [version]
        gvm offline <enable|disable>
        commands:
            install   or i    <candidate> [version]
            uninstall or rm   <candidate> <version>
            list      or ls   <candidate>
            use       or u    <candidate> [version]
            default   or d    <candidate> [version]
            current   or c    [candidate]
            version   or v
            broadcast or b
            help      or h
            offline           <enable|disable>
            selfupdate        [-Force]
            flush             <candidates|broadcast|archives|temp>
        candidate  :  crash, gaiden, glide, gradle, grails, griffon, groovy, groovyserv, lazybones, springboot, vertx
        version    :  where optional, defaults to latest stable if not provided
    eg: gvm install groovy
