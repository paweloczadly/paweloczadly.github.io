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

> The daemon listens on a Unix socket at `/var/run/docker.sock` for incoming Docker requests.

> Any user that belongs to the docker group can run Docker without needing to use the sudo command.

## The container details

> The container has a network, IP address, and a bridge interface to talk to the local host.

Containers are stored in: `/var/lib/docker/container`.

> This location must be a real filesystem rather than mount point like layers in a Docker image.

The `docker inspect` command displays information about Docker container.

Example:

    $ docker inspect redis
    [{
      "AppArmorProfile": "",
      "Args": [],
      "Config": {
        "AttachStderr": false,
        "AttachStdin": false,
        "AttachStdout": false,
        "Cmd": null,
        "CpuShares": 0,
        "Cpuset": "",
        "Domainname": "",
        "Entrypoint": [
        "/usr/bin/redis-server"
        ],
        "Env": [
        "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        "REFRESHED_AT=2014-06-01"
        ],
        "ExposedPorts": {
          "6379/tcp": {}
        },
    ...

To inspect only specific information (e.g. IP address), run the following:

    docker inspect -f '{ { .NetworkSettings.IPAddress } }' redis
    172.17.0.10

## Running containers

> The `-i` flag keeps STDIN open from the container

> The `-t` flag assigns a pseudo-tty to the container we're about to create. This provides us with an interactive shell in the new container.

> Docker also comes with a command line option called `--cidfile` that captures the container's ID and stores it in a file specified in the `--cidfile` option.

Example:

    $ docker run -v $PWD:/data/ --name blog --cidfile=dupa.txt paweloczadly/jekyll
    Configuration file: /data/_config.yml
    Source: /data
    Destination: /var/www/html
    Generating...
    Build Warning: Layout 'nil' requested in atom.xml does not exist.
    Build Warning: Layout 'nil' requested in rss.xml does not exist.
    done.
    Auto-regeneration: disabled. Use --watch to enable.
    $ cat dupa.txt
    0bc117eca02bcad8bfa7f29ee50f4938b879165fe2133c693f7fe9f3f7a92297%  

## Displaying containers

> By default, when we run just docker ps, we will only see the running container. When we specify the `-a` flag, the docker ps command will show us all containers, both stopped and running.

> The `-q` flag only returns container IDs.

## Working with the container's logs

> You can get last ten lines of a log by using `docker logs --tail 10`

> To make debugging a little easier, we can also add the `-t` flag to prefix our log entries with timestamps.

## Inspecting the container's processes

> To inspect the processes running inside the container, we can use `docker top` command.

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

> We can also run additional process inside our containers using `docker exec` command.

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

## Killing a process in a container

It is possible to send a signal to a Docker container to kill a process.

Example:

    $ docker kill -s <signal> <container>

## Listing Docker images

> Each repository can contain multiple images (e.g., the ubuntu repository contains images for Ubuntu 12.04, 12.10, 13.04, 13.10, and 14.04).

## Pulling images

> By default, if you don't specify a specific tag, Docker will download the latest tag.

## Credentials for Docker hub

> Your credentials will be stored in the `$HOME/.dockercfg` file.

## Dockerfile workspace

> This directory is our build environment, which is what Docker calls a context or build context.

> Docker will upload the build context, as well as any files and directories contained in it, to our Docker daemon when the build is run.

> If a file named **.dockerignore** exists in the root of the build context then it is interpreted as a newline-separated list of exclusion patterns.

## Dockerfiles and the build cache

> As a result of each step being committed as an image, Docker is able to be really clever about building images. It will treat previous layers as a cache.

> If we want to drill down into how our image was created, we can use the docker history command.

> Docker can randomly assign a high port from range **49000** to **49900**

## Instructions in Dockerfile

> Each instruction, for example `FROM`, should be in upper-case

> Each instruction adds a new layer to the image and then commits the image.

### RUN

> By default, the `RUN` instruction executes inside a shell using the command wrapper `/bin/sh -c`.

### CMD

> You can also specify the `CMD` instruction without an array, in which case Docker will prepend `/bin/sh -c` to the command.

> You can **only specify** one `CMD` instruction in a Dockerfile. If more than one is specified, then the last CMD instruction will be used.

> If you need to run multiple processes or commands as part of starting a container you should use a service management tool like **Supervisor**.

### ENTRYPOINT

> The `ENTRYPOINT` instruction provides a command that isn't as easily overridden. Instead, any arguments we specify on the docker run command line will be passed as arguments to the command specified in the `ENTRYPOINT`.

> If required at runtime, you can override the `ENTRYPOINT` instruction using the docker run command with `--entrypoint` flag.

### ENV

You can also pass environment variables on the docker run command line using the `-e` flag.

### USER

> The `USER` instruction specifies a user that the image should be run as;

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

> You can also override this at runtime by specifying the `-u` flag with the docker run command.

The default user is **root** if it is not specified.

### VOLUME

> Volumes can be shared and reused between containers.

> A container doesn't have to be running to share its volumes.

> Volumes persist until no containers use them.

> We can also specify the read/write status of the destination by adding either **rw** or **ro** after that destination.

example:

    docker run -v $PWD:/opt:ro

> Volumes live on your Docker host, in the `/var/lib/docker/volumes` directory.

> You can identify the location of specific volumes using the `docker inspect` command; for example, `docker inspect -f "{{ .Volumes }}"`

example:

    $ docker inspect -f "{ { .Volumes } }" blog
    map[/data:/Users/paweloczadly/dev/docker/06-building-services-with-docker/james_blog /var/www/html:/mnt/sda1/var/lib/docker/vfs/dir/54decec9f70e079bdff474ec4f98737fb8106e52c1c1e04bc67dabd3b0f49a9c]

### ADD

> If the destination ends in a `/`, then it considers the source a directory.

> If a tar archive (valid archive types include gzip, bzip2, xz) is specified as the source file, then Docker will automatically unpack it for you.

example:

    ADD consul-template_0.3.1_linux_amd64.tar.gz /tmp/consul-template/

> New files and directories will be created with a mode of 0755 and a UID and GID of 0.

### COPY

> The key difference is that the `COPY` instruction is purely focused on copying local files from the build context and does not have any extraction or decompression capabilities.

> You cannot copy anything that is outside of this directory, because the build context is uploaded to the Docker daemon, and the copy takes place there.

## Local Docker registry

> Since Docker 1.3.1 you need to add the flag `--insecure_registry <url-to-registry:5000>` to your Docker daemon startups flags and restart to use a local registry.

## Docker network

Docker creates it's own network during installation.

> Every Docker container is assigned an IP address, provided through an interface created when we installed Docker. That interface is called `docker0`

> The `docker0` interface is a virtual Ethernet bridge that connects our containers and the local host network.

interfaces:

    $ ifconfig
    docker0   Link encap:Ethernet  HWaddr 56:84:7a:fe:97:99  
    inet addr:172.17.42.1  Bcast:0.0.0.0  Mask:255.255.0.0
    inet6 addr: fe80::5484:7aff:fefe:9799/64 Scope:Link
    ...

    eth0      ...

    IPs:

    $ ip a show docker0
    3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
    link/ether 56:84:7a:fe:97:99 brd ff:ff:ff:ff:ff:ff
    inet 172.17.42.1/16 scope global docker0
    valid_lft forever preferred_lft forever
    inet6 fe80::5484:7aff:fefe:9799/64 scope link
    valid_lft forever preferred_lft forever

The `docker0` interface has private IP addresses in between **172.16-172.30**.

The gateway address for the Docker network and all Docker container is **172.17.42.1**.

> Every time Docker creates a container, it creates a pair of peer interfaces that are like opposite ends of a pipe.It gives one of the peers to the container to become its `eth0` interface and keeps the other peer, with unique name like `vethec6a`, out on the host machine.

When five containers are started on a host:

    $ ifconfig
    veth2888a15 Link encap:Ethernet  HWaddr 46:10:09:52:99:50  
    inet6 addr: fe80::4410:9ff:fe52:9950/64 Scope:Link
    ...

    veth35b2154 Link encap:Ethernet  HWaddr de:c4:9d:28:25:ce  
    inet6 addr: fe80::dcc4:9dff:fe28:25ce/64 Scope:Link
    ...

    veth5f7d0ef Link encap:Ethernet  HWaddr 96:cc:19:7b:1e:c8  
    inet6 addr: fe80::94cc:19ff:fe7b:1ec8/64 Scope:Link
    ...

    vethe58621d Link encap:Ethernet  HWaddr 2e:29:cd:9f:c6:dc  
    inet6 addr: fe80::2c29:cdff:fe9f:c6dc/64 Scope:Link
    ...

    vethfbf8c82 Link encap:Ethernet  HWaddr 82:d6:fe:a5:4e:d0  
    inet6 addr: fe80::80d6:feff:fea5:4ed0/64 Scope:Link
...

> You can think of a `veth` interface as one end of a virtual network cable.

During restarting a container, an IP address is updated.

## Linking Docker containers

Docker enables the communication between containers with the help of links.

> The `--link` flag creates a parent-child link between two containers. The flag takes two arguments: the container name to link and an alias for the link.

> The link gives the parent container the ability to communicate with the child container and shares some connection details with it to help you configure applications to make use of the link.

During linking containers, there is no need to expose ports. The parent container is allowed to communicate to any open ports on the child container.

It is possible to link multiple containers together. For example, there is a container with Redis database and other containers (different applications) connect to it and read/write the data.

> Docker links populate information about the parent container in two places:

- The `/etc/hosts` file
- Environment variables with the alias prefix

For example the container is connected to the **db** container:

    root@3165dc6df1bb:/# cat /etc/hosts
    172.17.0.14	3165dc6df1bb
    ...
    172.17.0.13	db

It is possible to ping the **db** container as well:

    root@3165dc6df1bb:/# ping db
    PING db (172.17.0.13) 56(84) bytes of data.
    64 bytes from db (172.17.0.13): icmp_seq=1 ttl=64 time=0.079 ms
    64 bytes from db (172.17.0.13): icmp_seq=2 ttl=64 time=0.080 ms
    64 bytes from db (172.17.0.13): icmp_seq=3 ttl=64 time=0.074 ms

Environment variables (these with the DB prefix comes with the linked container):

    root@3165dc6df1bb:/# env
    HOSTNAME=3165dc6df1bb
    ...
    DB_NAME=/webapp/db
    DB_PORT_6379_TCP_PORT=6379
    DB_PORT=tcp://172.17.0.13:6379
    DB_PORT_6379_TCP=tcp://172.17.0.13:6379
    DB_ENV_REFRESHED_AT=2014-06-01
    DB_PORT_6379_TCP_ADDR=172.17.0.13
    DB_PORT_6379_TCP_PROTO=tcp
    ...

These environment variables can be used in applications to consistently link between containers. For example in Ruby:

{% highlight ruby %}
uri = URI.parse(ENV['DB_PORT'])
{% endhighlight %}

On the other hand DNS and the information from `/etc/hosts` can be used in applications. For example in Ruby:

{% highlight ruby %}
redis = Redis.new(:host => 'db', :port => '6379')
{% endhighlight %}

> Since Docker version 1.3 if the linked container is restarted then the IP address in the `etc/hosts` file will be updated with the new IP address.

## Privileged flag

> The `--privileged` flag is special and enables Docker's privileged mode. Privileged mode allows us to run containers with (almost) all the capabilities of their host machine, including kernel features and device access.
