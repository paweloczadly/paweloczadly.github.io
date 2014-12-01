---
layout: post
title: "Book notes: The Docker book..."
category: books
tags: []
comments: true
share: true
---

# Book info

- **Title**: The Docker Book: Containerization is the new virtualization
- **Authors**: James Turnbull
- **Pages**: 246
- **Language**: English
- **Link**: http://www.dockerbook.com

# Notes

## The deamon

> Docker runs as a root-privileged daemon process to allow it to handle operations that can't be executed by normal users.

> The daemon listens on a Unix socket at **/var/run/docker.sock** for incoming Docker requests.

> Any user that belongs to the docker group can run Docker without needing to use the sudo command.

## The container details

> The container has a network, IP address, and a bridge interface to talk to the local host.

Containers are stored in: `/var/lib/docker/container`

## Running containers

> The **-i** flag keeps STDIN open from the container

> The **-t** flag assigns a pseudo-tty to the container we're about to create. This provides us with an interactive shell in the new container.

## Displaying containers

> By default, when we run just docker ps, we will only see the running container. When we specify the **-a** flag, the docker ps command will show us all containers, both stopped and running.

> The **-q** flag only returns container IDs.

## Working with the container's logs

> You can get last ten lines of a log by using **docker logs --tail 10**

> To make debugging a little easier, we can also add the **-t** flag to prefix our log entries with timestamps.

## Inspecting the container's processes

> To inspect the processes running inside the container, we can use **docker top** command.

Example:

    $ docker top dockerloadbalancer_lb_1
    PID                 USER                COMMAND
    5287                root                /usr/bin/runsvdir /etc/service
    5295                root                runsv consul-template
    5296                root                runsv nginx
    5298                root                nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf -g daemon off;
    5369                root                consul-template -consul=consul:8500 -template /etc/consul-templates/nginx.conf:/etc/nginx/conf.d/app.conf:sv hup nginx
    5384                101                 nginx: worker process

## Running a process inside a container

> We can also run additional process inside our containers using **docker exec** command.

Thanks to that, it is possible to log in to the container:

    $ docker exec -it dockerloadbalancer_consul_1 /bin/bash
    bash-4.3# ps ax
    PID   USER     COMMAND
    1 root     /bin/consul agent -config-dir=/config -server -bootstrap -advertise 10.0.2.15
    30 root     /bin/bash
    35 root     ps ax

## Removing containers

There is a workaround to remove all containers:

    $ docker rm -f $(docker ps -aq)

## What is a Docker image?

> A Docker image is made up of filesystems layered over each other.

> At the base is a boot filesystem, bootfs, which resembles the typical Linux/Unix boot filesystem.

> Docker next layers a root filesystem, rootfs, on top of the boot filesystem. This rootfs can be one or more operating systems (e.g., a Debian or Ubuntu filesystem).

## Listing Docker images

> Each repository can contain multiple images (e.g., the ubuntu repository contains images for Ubuntu 12.04, 12.10, 13.04, 13.10, and 14.04).

## Pulling images

> By default, if you don't specify a specific tag, Docker will download the latest tag.

## Credentials for Docker hub

> Your credentials will be stored in the $HOME/.dockercfg file.

## Dockerfile workspace

> This directory is our build environment, which is what Docker calls a context or build context.

> Docker will upload the build context, as well as any files and directories contained in it, to our Docker daemon when the build is run.

> If a file named **.dockerignore** exists in the root of the build context then it is interpreted as a newline-separated list of exclusion patterns.

## Dockerfiles and the build cache

> As a result of each step being committed as an image, Docker is able to be really clever about building images. It will treat previous layers as a cache.

> If we want to drill down into how our image was created, we can use the docker history command.

> Docker can randomly assign a high port from range **49000** to **49900**

## Instructions in Dockerfile

> Each instruction, for example FROM, should be in upper-case

### RUN

> By default, the RUN instruction executes inside a shell using the command wrapper /bin/sh -c.

### CMD

> You can also specify the CMD instruction without an array, in which case Docker will prepend /bin/sh -c to the command.

> You can only specify one CMD instruction in a Dockerfile. If more than one is specified, then the last CMD instruction will be used.

> If you need to run multiple processes or commands as part of starting a container you should use a service management tool like **Supervisor**.

### ENTRYPOINT

> The ENTRYPOINT instruction provides a command that isn't as easily overridden. Instead, any arguments we specify on the docker run command line will be passed as arguments to the command specified in the ENTRYPOINT.

> If required at runtime, you can override the ENTRYPOINT instruction using the docker run command with --entrypoint flag.

### ENV

You can also pass environment variables on the docker run command line using the -e flag.

### USER

> The USER instruction specifies a user that the image should be run as;

example:

    USER jenkins

> We can specify a username or a UID and group or GID.

example:

    USER user
    USER user:group
    USER uid
    USER uid:gid
    USER user:gid
    USER uid:group

> You can also override this at runtime by specifying the -u flag with the docker run command.

The default user is **root** if it is not specified.

### VOLUME

> Volumes can be shared and reused between containers.

> A container doesn't have to be running to share its volumes.

> Volumes persist until no containers use them.

### ADD

> If the destination ends in a /, then it considers the source a directory.

> If a tar archive (valid archive types include gzip, bzip2, xz) is specified as the source file, then Docker will automatically unpack it for you.

example:

    ADD consul-template_0.3.1_linux_amd64.tar.gz /tmp/consul-template/

> New files and directories will be created with a mode of 0755 and a UID and GID of 0.

### COPY

> The key difference is that the COPY instruction is purely focused on copying local files from the build context and does not have any extraction or decompression capabilities.

> You cannot copy anything that is outside of this directory, because the build context is uploaded to the Docker daemon, and the copy takes place there.
