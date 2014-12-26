 Content

[![Build Status](https://travis-ci.org/paweloczadly/paweloczadly.github.io.svg?branch=master)](https://travis-ci.org/paweloczadly/paweloczadly.github.io)

This blog contains my notes regarding different topics from dev and devops areas.

# Usage

It is possible to run the blog from Docker container.

- Build it:
```
docker build -t paweloczadly/blog .
```

- Execute it:
```
docker run --name blog -v "$PWD:/blog" -dp 4000:4000 paweloczadly/blog
```
