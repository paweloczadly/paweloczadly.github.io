---
layout: post
title: "Books notes"
category: books
tags: []
comments: true
share: true
---

Today I want to start a series of creating blog posts with notes from different books. I will try to publish them continuously.

# Books list:

{% for category in site.categories %}
  {% assign ctg = category[0] | join: "/" %}
  <ul class="post-list">
    {% if ctg == "books" %}
      {% assign pages_list = category[1] %}
      {% for post in pages_list %}{% if post.title != null %}
        <li>
          <a href="{{ site.url }}{{ post.url }}">
            {{ post.title }}
            <span class="entry-date">
              <time datetime="{{ post.date | date_to_xmlschema }}">
                {{ post.date | date: "%B %d, %Y" }}
              </time>
            </span>
          </a>
        </li>
      {% endif %}{% endfor %}
    {% endif %}
  </ul>
{% endfor %}
