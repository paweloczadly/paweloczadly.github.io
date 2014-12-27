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
ADD start.sh /var/lib/jenkins/start.sh
RUN chmod +x /var/lib/jenkins/start.sh

WORKDIR /var/lib/jenkins
ENTRYPOINT ["/var/lib/jenkins/start.sh"]
{% endhighlight %}

Description:

- lines **3** - **5** install Docker
- line **7** installs openjdk
- line **9** - creates Docker volume for `/var/lib/docker` directory. It is required for sharing Docker containers between the container and the host.
- line **11** - downloads Jenkins Swarm client
- line **12** - **13** - add the start script and make it executable
- line **15** - sets current directory to `/var/lib/jenkins`
- line **16** - runs the start script

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

java -jar $JENKINS_HOME/swarm-client.jar $OPTS
{% endhighlight %}

Description:

- lines **4** - **35** configures Docker in Docker and start the Docker daemon. For further details, please have a look at "Docker in Docker" Github repository or chapter 5th in "The Docker Book".
- lines **38** - **43** a function which configures parameters for Jenkins Swarm client.
- lines **47** - **50** check if MASTER_URL is configured.
- lines **54** - **60** configure other options for Jenkins Swarm client.
- line **62** runs Jenkins Swarm client.

# Demo

After you build the image, you have to run the container with `--privileged` flag

    $ docker run --privileged -ti -e MASTER_URL=http://my.jenkins.com:8080 jks
    /proc/self/fd /var/lib/jenkins
    /var/lib/jenkins
    INFO[0000] +job serveapi(unix:///var/run/docker.sock)
    INFO[0000] +job init_networkdriver()
    INFO[0000] Listening for HTTP on unix (/var/run/docker.sock)
    INFO[0000] -job init_networkdriver() = OK (0)
    INFO[0000] Loading containers: start.

    INFO[0000] Loading containers: done.
    INFO[0000] docker daemon: 1.4.1 5bc2ff8; execdriver: native-0.2; graphdriver: aufs
    INFO[0000] +job acceptconnections()
    INFO[0000] -job acceptconnections() = OK (0)
    Discovering Jenkins master
    Attempting to connect to http://my.jenkins.com:8080/ 3549a2c2-b7ae-44ab-8037-e1e402495258
    Could not obtain CSRF crumb. Response code: 404
    Dec 27, 2014 3:39:00 PM hudson.remoting.jnlp.Main createEngine
    INFO: Setting up slave: 687b092b6b14
    Dec 27, 2014 3:39:00 PM hudson.remoting.jnlp.Main$CuiListener <init>
    INFO: Jenkins agent is running in headless mode.
    Dec 27, 2014 3:39:00 PM hudson.remoting.jnlp.Main$CuiListener status
    INFO: Locating server among [http://my.jenkins.com:8080/]
    Dec 27, 2014 3:39:01 PM hudson.remoting.jnlp.Main$CuiListener status
    INFO: Connecting to acid-jkm.yrdrt.fra.hybris.com:42534
    Dec 27, 2014 3:39:01 PM hudson.remoting.jnlp.Main$CuiListener status
    INFO: Handshaking
    Dec 27, 2014 3:39:02 PM hudson.remoting.jnlp.Main$CuiListener status
    INFO: Connected

# Conclusion

Thanks to that setup we have immutable Jenkins slaves. It is possible to extend it by installing other tools and frameworks. Moreover, it is very easy to remove the slave and create it again. To log in to debug why the Jenkins job fails on the Jenkins slave, just use `docker exec -ti <container-id> /bin/bash`
