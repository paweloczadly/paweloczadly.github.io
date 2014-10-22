---
layout: post
title: "Chef cookbook build pipeline"
category: devops
tags: [chef, jenkins]
comments: true
share: true
---

## Overview

Build pipeline is continuous delivery pattern which allows to produce clean and well tested piece of software. In this case I will focus how to implement this pipeline for Chef cookbook.

![My helpful screenshot]({{ site.url }}/assets/single_pipeline.png)

## Description

- In the first phase (fast feedback) the fastest tests are run for every commit. In this step linting tools such as knife cookbook test, [foodcritic](http://acrmp.github.io/foodcritic/) for Chef code and [tailor](https://github.com/turboladen/tailor) for Ruby code can be used for static code analysis (1-sca) and [chefspec](https://github.com/sethvargo/chefspec) for unit tests (1-unit-tests).
- In the second phase (heavy tests) 'real' integration tests are run. This step is run if every step from the first phase passes. Here [test-kitchen](http://kitchen.ci/) is very useful. It allows you to spin up virtual machine (base on Vagrant, Docker or even Amazon EC2).
- If the second phase passes the cookbook is uploaded to the Chef server.

## My recommendations

- To implement this I can highly recommend [Jenkins](http://jenkins-ci.org/) and [Jenkins Build Flow plugin](https://wiki.jenkins-ci.org/display/JENKINS/Build+Flow+Plugin).
- You could build phase-0 which pulls a Git repository and then use [Clone Workspace SCM plugin](https://wiki.jenkins-ci.org/display/JENKINS/Clone+Workspace+SCM+Plugin) to pass the workspace instead of cloning a repo in every plan. This allows you commit isolation.
- [Berkshelf](http://berkshelf.com/) for dependency management and uploading Chef cookbooks.
- Running plans from the first phase in parallel (if you will use Clone Workspace SCM plugin).
