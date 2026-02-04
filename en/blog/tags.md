---
layout: blog
title: Tags
permalink: /en/blog/tags/
lang: en
---

{% assign tags = site.tags %}
<ul>
  {% for tag in tags %}
    <li>{{ tag[0] }} ({{ tag[1].size }})</li>
  {% endfor %}
</ul>
