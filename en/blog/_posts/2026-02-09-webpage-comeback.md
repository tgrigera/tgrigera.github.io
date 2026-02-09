---
layout: post
title: "Personal pages reloaded"
date: 2026-02-09
lang: en
tags: [Jekyll, Web, GitHub]
categories: [computers]
comments: true
---

This is a new reincarnation of my personal web page.  After trying `Wordpress` and some other CMS (perhaps it was `Droopal`), I learnt to stick to static page generators.  My first attempt was `Nikola`.  It mostly worked, but a version update broke the theme I was using, so I decided to try something more stable.  A [colleague](http://manuxch.github.io) (the same who had introduced me to `Nikola`) pointed out `Hugo`, and I went for that, seeing it had a nice bilingual academic theme.  However, it ended up being too complicated for me.  I had a hard time setting it up, though I eventually succeeded, but then after a while I wanted to make minor changes and couldn't; I was stuck with the theme I had chosen I couldn't even make minor tweaks.  It's not necessarily `Hugo`'s fault (or my colleague's :) ).  I'm far from an expert on web publishing, but I cannot afford to become one.

So now I turned to [Jekyll](https://jekyllrb.com/).  I had considered `Jekyll` before `Hugo`, but the documentation scared me away (or more accurately, the fact that it seemed to imply that I would have to write my own `.css`).  But this time I went through: now we have LLMs to help, and I got one to set up a Jekyll configurations with a `.css` that produces a decent-looking site.  The whole setup looks simpler, with the added advantage that there is no need to build locally.  I just run the local server to check the appearance of any added/updated pages, then simply push the source to my `tgrigera.github.io` repository at GitHub and the site is built automatically with next to zero configuration.

I migrated the site to the new configuration with the exception of old blog posts that no longer make sense.  I only kept a few, in particular this post on [reference management](../../../2015-12-03/) which is still useful, I only regret that I lost the nice discussion it sparkled, which included comments from the author of `helm-bibtex`.


