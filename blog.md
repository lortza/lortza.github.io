---
layout: page
title: tech blog
permalink: /blog/
---

<ul class="post-list">
  {% for post in site.posts %}
    <li>
      <h2><a class="post-title" href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a></h2>
      <p class="post-meta">{{ post.date | date: '%B %-d, %Y' }}</p>
      <p>{{ post.content | strip_html | truncatewords:25}}</p>
      <br/>
      <hr/>
    </li>
  {% endfor %}
</ul>