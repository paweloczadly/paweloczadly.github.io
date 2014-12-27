---
layout: post
title: "Jenkins slave as Docker container"
category: devops
tags: []
comments: true
share: true
---

# Acknowledgments

Thanks to [James Turnbull](https://twitter.com/kartar), the author of "The Docker Book: Containerization is the new virtualization" and [Jerome Petazzoni](https://twitter.com/jpetazzo) the creator of the "Docker in Docker" [Github repository](https://github.com/jpetazzo/dind), I learned how to run Docker recursively.

# Overview

In this post I would like to describe how to use Docker to create Jenkins slaves which can also build and run Docker containers :)

Let's assume that Jenkins server is up and running. To connect the slave to the master I will use [Jenkins Swarm plugin](https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin).

# Preparation

Firstly, let's prepare **Dockerfile**

{% highlight bash linenos %}
FROM ubuntu

RUN apt-get update -qq && apt-get install -qqy curl
RUN curl https://get.docker.io/gpg | apt-key add -
RUN echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get update -qq && apt-get install -qqy iptables ca-certificates lxc wget git lxc-docker

VOLUME /var/lib/docker

# Jenkins slave installation...

ENTRYPOINT ["/var/lib/jenkins/start.sh"]
{% endhighlight %}

Then, let's create **start.sh** script which will run 'Docker in Docker' and start the Jenkins slave.

{% highlight bash linenos %}
{% endhighlight %}
