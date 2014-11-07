---
layout: page
title: archive
---

<ul class="post-list">
  {% for post in site.posts %}
  {% unless post.next %}
    <h1>
      {{ post.date | date: '%Y' }}
    </h1>
    {% else %}
      {% capture year %}{{ post.date | date: '%Y' }}{% endcapture %}
      {% capture nyear %}{{ post.next.date | date: '%Y' }}{% endcapture %}
      {% if year != nyear %}
        <h3>
          {{ post.date | date: '%Y' }}
        </h3>
      {% endif %}
    {% endunless %}
    <article>
      <li>
        <a href="{{ site.url }}{{ post.url }}" title="{{ post.title }}">
          {{ post.title }}
          <span class="entry-date">
            <time datetime="{{ post.date | date_to_xmlschema }}">
              {{ post.date | date: "%B %d, %Y" }}
            </time>
          </span>
        </a>
      </li>
    </article>
  {% endfor %}
</ul>
