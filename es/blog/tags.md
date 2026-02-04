---
layout: blog
title: Etiquetas
permalink: /es/blog/tags/
lang: es
---

{% assign tags = site.tags %}
<ul>
  {% for tag in tags %}
    <li>{{ tag[0] }} ({{ tag[1].size }})</li>
  {% endfor %}
</ul>
