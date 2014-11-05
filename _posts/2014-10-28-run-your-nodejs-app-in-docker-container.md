---
layout: post
title: "Run your Node.js app in Docker container"
category: "dev"
tags: [node.js, docker]
comments: true
share: true
---

# Overview

In this post we will create a Docker container for Node.js. Then we can deploy it very easily to production.

# Node.js microservice

For that example we will create a microservice which displays hostname of the application.

{% highlight javascript linenos %}
var http = require('http')
var os = require('os')

var port = process.argv[2]

var server = http.createServer(function (req, resp) {
	resp.writeHead(200, {'Content-Type': 'text/plain'})
  resp.end('I am: ' + os.hostname() + '\n')
}).listen(port)
console.log('Server running at http://127.0.0.1:' + port)
{% endhighlight %}

# Dockerfile

We will use nodejs image provided by the [Dockerfile](http://dockerfile.github.io) group.

{% highlight bash linenos %}
FROM dockerfile/nodejs

ADD app.js /myapp/app.js

EXPOSE 1337
WORKDIR "/myapp"
{% endhighlight %}

# Building and running

- Build image:

`docker build -t myapp .`

- Run container:

`docker run -d -p 1337:1337 --name myapp myapp node /myapp/app.js 1337`
