---
layout: page
title: Pawel Oczadly
---
{% include JB/setup %}

## Posts

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
      <p>{{ post.content | strip_html | truncatewords: 50 }}</p>
    </li>
  {% endfor %}
</ul>