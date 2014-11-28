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

## Running containers

> -i flag keeps STDIN open from the container

> -t assigns a pseudo-tty to the container we're about to create. This provides us with an interactive shell in the new container.

## Displaying containers

> By default, when we run just docker ps, we will only see the running container. When we specify the **-a** flag, the docker ps command will show us all containers, both stopped and running.

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
