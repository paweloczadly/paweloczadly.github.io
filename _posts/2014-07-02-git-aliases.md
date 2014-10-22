---
layout: post
title: "Git aliases"
category: dev
tags: [git]
comments: true
share: true
---

## Overview

It is possible to set up some shortcuts in Git. To do this, let's edit **~/.gitconfig** file and add the following content:

    [alias]
        br = branch
        cl = clone
        ck = checkout
        cm = commit
        df = diff
        lst = log -1 HEAD
        ps = push
        pl = pull
        rmt = remote
        st = status
        m = merge

To test it, we can run:

    git lst

Which gives us latest commit. For example:

    commit 7f9c78fa23e975cc6c0f58632315b478e58446c1
    Author: Pawel Oczadly <pawel.oczadly@hybris.com>
    Date:   Wed Jul 2 14:55:50 2014 +0200

        migration from Maruku

## Dropbox sync

If you use Dropbox, you can synchronize these settings on many machines. To do this run the following commands.

In the first machine:

    mkdir ~/Dropbox/Git
    mv .gitconfig ~/Dropbox/Git/.gitconfig
    ln -s ~/Dropbox/Git/.gitconfig

In the next machine:

    rm ~/.gitconfig
    ln -s ~/Dropbox/Git/.gitconfig
