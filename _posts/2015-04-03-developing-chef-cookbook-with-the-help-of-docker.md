---
layout: post
title: "Developing Chef cookbook with the help of Docker"
category: devops
tags: [chef, docker]
comments: true
share: true
---

# Problems

* You don't want to install Ruby and Chef tools for local Chef cookbooks development.
* You have a problem with configure properly all Ruby gems and Vagrant and required plugins together.
* You don't have proper settings for your private berks-api and you don't know how to configure it.
* You want to get everyone in your company stable environment for developing Chef cookbooks.

# Solution

Use Docker :)

# How to do that?

Create a Docker image image which will contain:

* ChefDK - all required tools such as:
  * Rubocop, Foodcritic - static code analysis both for Ruby code and Chef cookbook structure.
  * ChefSpec - unit test framework.
  * Test Kitchen - integration test framework.
  * Berkshelf - dependency manager.
  * embedded Ruby
* kitchen-docker Ruby gem which will allow you to run your integration tests inside Docker container - yes, Docker in Docker :)

Here is full content of the **Dockerfile**:

{% highlight bash linenos %}
FROM debian:wheezy

ADD https://opscode-omnibus-packages.s3.amazonaws.com/debian/6/x86_64/chefdk_0.3.6-1_amd64.deb /tmp/chefdk.deb
RUN dpkg -i /tmp/chefdk.deb
RUN rm -rf /tmp/chefdk.deb
RUN chef gem install kitchen-docker

VOLUME /opt/chefdk
WORKDIR /src
{% endhighlight %}

# docker-compose

I would recommend to upgrade your Docker to 1.5 and setup [docker-compose](https://docs.docker.com/compose/). Thanks to that it is quite easy to use Docker with volumes, links, etc. Here is the content of the **docker-compose.yml**:

{% highlight bash linenos %}
berks:
  build: .
  entrypoint: berks
  volumes:
    - $PWD/src:/src
foodcritic:
  build: .
  entrypoint: foodcritic
  volumes:
    - $PWD/src:/src
rubocop:
  build: .
  entrypoint: rubocop
  volumes:
    - $PWD/src:/src
kitchen:
  build: .
  entrypoint: kitchen
  volumes:
    - /usr/local/bin/docker:/usr/local/bin/docker # $(which docker)
    - /var/run/docker.sock:/var/run/docker.sock
    - $PWD/src:/src
chefsolo:
  build: .
  entrypoint: chef-solo
  volumes:
    - $PWD/src:/src
chefclient:
  build: .
  entrypoint: chef-client
  volumes:
    - $PWD/src:/etc/chef
{% endhighlight %}

# Current problems

For now, kitchen doesn't work properly... When you call **kitchen converge** it hangs on the following step:


    Waiting for localhost:49153...


I'll try to fix that.

# Conclusion

Thanks to that you can use (almost) all the functionality provided by ChefDK without installing Ruby, Chef, Vagrant and required Ruby gems for local cookbook development. The setup is very easy and portable. It can be used by every automation engineer.
