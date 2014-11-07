---
layout: page
title: categories
header: Posts By Category
group: navigation
---
<ul class="tag_box inline">
  {% assign categories_list = site.categories %}
</ul>


{% for category in site.categories %}
  <h2 id="{{ category[0] }}-ref">
    {{ category[0] | join: "/" }}
  </h2>
  <ul class="post-list">
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
  </ul>
{% endfor %}
