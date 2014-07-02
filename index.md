---
layout: page
title: Posts
---
{% include JB/setup %}

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
      <p>{{ post.content | strip_html | truncatewords: 50 }}</p>
    </li>
  {% endfor %}
</ul>
