---
layout: academic
title: Publications
permalink: /en/publications/
lang: en
---

<ul class="publications">
{% assign pubs = site.data.publications | sort: "year" | reverse %}
{% for pub in pubs %}
  <li>
    <span class="title">{{ pub.title }}</span><br>
    <span class="authors">{{ pub.author }}</span><br>
    <span class="journal">{{ pub.journal }}</span> ({{ pub.year }})
  </li>
{% endfor %}
</ul>
