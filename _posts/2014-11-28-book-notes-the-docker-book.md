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

> Docker runs as a root-privileged daemon process to allow it to handle operations that can't be executed by normal users.

> The daemon listens on a Unix socket at **/var/run/docker.sock** for incoming Docker requests.

> Any user that belongs to the docker group can run Docker without needing to use the sudo command.

> -i flag keeps STDIN open from the container

> -t assigns a pseudo-tty to the container we're about to create. This provides us with an interactive shell in the new container.

> The container has a network, IP address, and a bridge interface to talk to the local host.

> By default, when we run just docker ps, we will only see the running container. When we specify the **-a** flag, the docker ps command will show us all containers, both stopped and running.

> You can get last ten lines of a log by using **docker logs --tail 10**

> To make debugging a little easier, we can also add the **-t** flag to prefix our log entries with timestamps.

> To inspect the processes running inside the container, we can use **docker top** command.

> We can also run additional process insisde our containers using **docker exec** command.
