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

# Usage

Here is example usage of that image:


    $ docker-compose run berks --help
    Commands:
      berks apply ENVIRONMENT     # Apply version locks from Berksfile.lock to a Chef environment
      berks contingent COOKBOOK   # List all cookbooks that depend on the given cookbook in your Berksfile
      berks cookbook NAME [PATH]  # Create a skeleton for a new cookbook
      berks help [COMMAND]        # Describe available commands or one specific command
      berks info [COOKBOOK]       # Display name, author, copyright, and dependency information about a cookbook
      berks init [PATH]           # Initialize Berkshelf in the given directory
      berks install               # Install the cookbooks specified in the Berksfile
      berks list                  # List cookbooks and their dependencies specified by your Berksfile
      berks outdated [COOKBOOKS]  # List dependencies that have new versions available that satisfy their constraints
      berks package [PATH]        # Vendor and archive the dependencies of a Berksfile
      berks search NAME           # Search the remote source for cookbooks matching the partial name
      berks shelf SUBCOMMAND      # Interact with the cookbook store
      berks show [COOKBOOK]       # Display the path to a cookbook on disk
      berks update [COOKBOOKS]    # Update the cookbooks (and dependencies) specified in the Berksfile
      berks upload [COOKBOOKS]    # Upload the cookbook specified in the Berksfile to the Chef Server
      berks vendor [PATH]         # Vendor the cookbooks specified by the Berksfile into a directory
      berks verify                # Perform a quick validation on the contents of your resolved cookbooks
      berks version               # Display version
      berks viz                   # Visualize the dependency graph

    Options:
      -c, [--config=PATH]          # Path to Berkshelf configuration to use.
      -F, [--format=FORMAT]        # Output format to use.
                                   # Default: human
      -q, [--quiet], [--no-quiet]  # Silence all informational output.
      -d, [--debug], [--no-debug]  # Output debug information


You can also use Rubocop, Foodcritic, ChefSpec and Test Kitchen from this image.

# Current problems

For now, kitchen doesn't work properly... When you call **kitchen converge** it hangs on the following step:


    Waiting for localhost:49153...


I'll try to fix that.

# Conclusion

Thanks to that you can use (almost) all the functionality provided by ChefDK without installing Ruby, Chef, Vagrant and required Ruby gems for local cookbook development. The setup is very easy and portable. It can be used by every automation engineer.
