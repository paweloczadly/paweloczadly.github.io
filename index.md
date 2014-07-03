---
layout: page
title: home
---
{% include JB/setup %}

## Content

This blog contains my notes regarding different topics from dev and devops areas.

## Posts

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
      <p>{{ post.content | strip_html | truncatewords: 50 }}</p>
    </li>
  {% endfor %}
</ul>
