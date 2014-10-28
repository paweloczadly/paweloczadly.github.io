---
layout: post
title: "Run your Node.js app in Docker container"
category: "dev"
tags: [node.js, docker]
---

# Note

This post is still in progress. I will update it soon. Please, come back in the future. Sorry, for inconvenience...

# Node.js microservice

{% highlight javascript linenos %}
var http = require('http')
var os = require('os')

var url = process.argv[3]
var port = process.argv[2]
var body = ''

var request = http.get(url, function(res) {
  res.on('data', function (chunk) {
    body = chunk
  });
})

var server = http.createServer(function (req, resp) {
	resp.writeHead(200, {'Content-Type': 'text/plain'})
  resp.end('I am: ' + os.hostname() + '\n'
         + 'Requesting: ' + url + '\n'
         + 'Response: ' + body.toString().split('\n')[0])
}).listen(port)
console.log('Server running at http://127.0.0.1:' + port)
{% endhighlight %}

# Dockerfile

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

`docker run -d -p 1337:1337 --name myapp myapp node /myapp/app.js 1337 http://127.0.0.1:1337`
