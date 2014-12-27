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

ADD http://get.docker.io install-docker.sh
RUN chmod +x install-docker.sh
RUN /install-docker.sh

RUN apt-get install -yqq openjdk-7-jdk

VOLUME /var/lib/docker

ADD http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/1.22/swarm-client-1.22-jar-with-dependencies.jar /var/lib/jenkins/swarm-client.jar

WORKDIR /var/lib/jenkins
ENTRYPOINT ["/var/lib/jenkins/start.sh"]
{% endhighlight %}

Description:

- lines **3** - **5** install Docker
- line **7** installs openjdk
- line **9** - creates Docker volume for `/var/lib/docker` directory. It is required for sharing Docker containers between the container and the host.
- line **11** - downloads Jenkins Swarm client
- line **13** - sets current directory to `/var/lib/jenkins`
- line **14** - runs the start script

Then, let's create **start.sh** script which will run 'Docker in Docker' and start the Jenkins slave.

{% highlight bash linenos %}
#!/bin/bash

### DOCKER ###
CGROUP=/sys/fs/cgroup

[ -d $CGROUP ] ||
mkdir $CGROUP

mountpoint -q $CGROUP ||
mount -n -t tmpfs -o uid=0,gid=0,mode=0755 cgroup $CGROUP || {
  echo "Could not make a tmpfs mount. Did you use -privileged?"
  exit 1
}

for SUBSYS in $(cut -d: -f2 /proc/1/cgroup)
do
  [ -d $CGROUP/$SUBSYS ] || mkdir $CGROUP/$SUBSYS
  mountpoint -q $CGROUP/$SUBSYS ||
  mount -n -t cgroup -o $SUBSYS cgroup $CGROUP/$SUBSYS
done

pushd /proc/self/fd
for FD in *
do
  case "$FD" in
    [012])
    ;;
    *)
    eval exec "$FD>&-"
    ;;
  esac
done
popd

docker -d &

### JENKINS SLAVE ###
function append() {
  if [ -n "$2" ]; then
  OPTS="$OPTS \
  $1 $2"
  fi
}

JENKINS_HOME=/var/lib/jenkins

if [ -z "$MASTER_URL" ]; then
  echo "You have to specify \$MASTER_URL variable"
  exit 1
fi

OPTS=

append "-master" $MASTER_URL
append "-executors" $EXECUTORS
append "-fsroot" $JENKINS_HOME
append "-labels" \"$LABELS\"
append "-name" $JENKINS_SLAVE_NAME
append "-username" $JENKINS_USERNAME
append "-password" $JENKINS_PASSWORD

java -jar $JENKINS_HOME/swarm-slave.jar $OPTS
{% endhighlight %}
