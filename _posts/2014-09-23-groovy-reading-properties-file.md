---
layout: post
title: "Groovy: reading properties file"
category: dev
tags: [groovy]
---
{% include JB/setup %}

## Dupa

Last time I had to use **gradle.properties** file in my **Spock** tests. It contained some settings of the project which had to be read and assert.

To implement this I decided to use Groovy's MOP capabilities (propertyMissing method). I wrote the following class which allow to read properties store in key=value notation:

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
            props.load(it)
        }
        props."$name"
    }

}
{% endhighlight %}

## Usage

Here is my **gradle.properties** file:

```
name = Pawel Oczadly
page.url = http://paweloczadly.github.io
```

And usage of the **PropertyReader** class:

{% highlight groovy %}
def propertyReader = new PropertyReader('gradle.properties')

assert propertyReader.name == 'Pawel Oczadly'
assert propertyReader.'page.url' == 'http://paweloczadly.github.io'
assert propertyReader.age == null
{% endhighlight %}
