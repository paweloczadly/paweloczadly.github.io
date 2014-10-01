# Content

[![Build Status](https://travis-ci.org/paweloczadly/paweloczadly.github.io.svg?branch=master)](https://travis-ci.org/paweloczadly/paweloczadly.github.io)

This blog contains my notes regarding different topics from dev and devops areas.

# Usage

It is possible to run the blog from Docker container.

- Build it:
```
sudo docker build --no-cache -t paweloczadly/blog .
```

- Execute it:
```
docker run -t -i -p 4000:4000 paweloczadly/blog
```
