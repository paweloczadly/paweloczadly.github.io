---
layout: post
title: "Groovy: reading and writing to properties file"
category: dev
tags: [groovy]
comments: true
share: true
---

Thanks to Groovy MOP capabilities we can create flexible and readable code. Last time I created PropertyReader class inspired by [MarkupBuilder](http://groovy.codehaus.org/Creating+XML+using+Groovy's+MarkupBuilder) and [XmlSlurper](http://groovy.codehaus.org/Reading+XML+using+Groovy's+XmlSlurper). This class allows to read and write from/to properties files. Data in that file is store in ```key=value``` notation.

{% highlight groovy %}
class PropertyReader {

    String filePath

    PropertyReader(String filePath) {
        this.filePath = filePath
    }

    def propertyMissing(String name) {
        Properties props = new Properties()
        File propsFile = new File(filePath)
        propsFile.withInputStream {
            props.load it
        }
        props."$name"
    }

    def methodMissing(String name, args) {
        Properties props = new Properties()
        File propsFile = new File(filePath)

        props.load propsFile.newDataInputStream()
        props.setProperty name, args.toString() - '[' - ']'
        props.store propsFile.newWriter(), null
    }

}
{% endhighlight %}

## Usage

Here is the example of **gradle.properties** file:

{% highlight bash %}
name = Pawel Oczadly
page.url = http://paweloczadly.github.io
{% endhighlight %}

To read the property just call ```propertyReader.'yourProperty'```. And to update or write new property call ```propertyReader.'yourPropertyKey'('yourPropertyValue')```. Here is the example of usage of PropertyReader class:

{% highlight groovy %}
def propertyReader = new PropertyReader('c:/gradle.properties')

assert propertyReader.name == 'Pawel Oczadly'
assert propertyReader.'page.url' == 'http://paweloczadly.github.io'
assert propertyReader.interests == null

propertyReader.interests('football', 'climbing', 'swimming')
assert propertyReader.interests == 'football, climbing, swimming'
{% endhighlight %}

## Result

After running the above script and refreshing **c:/gradle.properties** file it should contain similar content:

{% highlight bash %}
#Wed Sep 24 08:21:15 CEST 2014
name=Pawel Oczadly
page.url=http\://paweloczadly.github.io
interests=football, climbing, swimming
{% endhighlight %}
