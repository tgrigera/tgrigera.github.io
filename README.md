# Source for GitHub pages personal site

This constitutes the source material and configuration to generate my website using [Jekyll](https://jekyllrb.com/).  This produces a bilingual site with static content plus a blog (two actually, one for each language).  Blog posts allow comments through [giscus](https://giscus.app), and the bibliography page is built from `BibTex` source through a `Python` script.  This is the only script that has to be run locally before committing to GitHub (because it is not default Jekyll and I wanted to stick to standard Jekyll and gems supported by GitHub without having to set up special build environments).

## Directory structure

Directories and files with names starting with an underscore contain files with instructions on how to build the site (general configuration, page styles, .html bits), but will not be present in the rendered site.  The other ones give rise to a directory with the same name in the final site, with some files copied verbatim and `.md` and `.html` files processed by Jekyll  they start with an appropriate header (called "front matter").

 - `_config.yml` : basic configuration and some defaults.
 - `_layouts/` : "Blueprints" for the pages (html with liquid).
 - `_data/` : YAML files with variable definitions, currently the navigation data.
 - `_includes/` : HTML files included by the layouts (header, footer, language switcher, giscus)
 - `_scripts/`: script to generate bibliography from BibTex
 - `Gemfile` and `Gemfile.lock`: Ruby gems needed to generate the site.
 - `assets/`:  Images, bib files, PDFs, CSS.  Mostly copied verbatim (except for .scss files, which produce .css)
 - `index.md`: The landing page; this one merely redirects to the English index page.
 - `en/` Source for the directory of the same name in the rendered site.  Contains one Markdown file for each of the main navigation entries (linked from the navigation bar): index, research, publications, cv, docencia.  These are processed by Jekyll to produce HTML pages.
 - `en/blog/`: Source for the blog index, tags, and XML feed.
 - `en/blog/_posts/`: Source for posts (one file per post, Markdown).
 - `es`, `es/blog`, `es/blog/_posts`: Equivalent directories for the Spanish site.


## How files are processed (approximately)

Files in non-underscore directories are copied verbatim unless they start with _front matter_: a line with three hyphens, followed by optional Yaml (typically key-value assignments), closed by another line with three hyphens.  If Jekyll sees the front matter, then the file is treated as a `Liquid` template.  Jekyll will process .html and .md (Markdown) files, evaluating Liquid expressions to produce HTML files for the static site.  Also, `.scss` files (in `assets/`) will be processed (if starting with front matter) to produce `.css` style files.  The files will go under the same directory they are in unless `permalink` is specified in the front matter.

### Layouts

Layouts are .html (with liquid) files that wrap around normal files, and they are used to get uniform formatting of pages and avoid repetition.  Setting `layout` in the front matter selects the layout to be used.

### Pages and posts

Pages are static pages, posts are meant to be blog posts.  Front matter is used to set the `layout`, `title` and `lang`uage.  One can also use `permalink` to force a destination file different from the default.  Posts typically add `date`, `tag` (or `tags` fro multiple tags), `category` (or `categories`) and `comments: true` to enable commments.  To link to other pages of the site you don't include verbatim links but call them through `Liquid` using `{% link xx %}` or `{% post_url xx %}` (see the [Jekyll docs](https://jekyllrb.com/docs/liquid/tags/#link)).

Some defaults for the front matter are defined in `_config.yml` (they can be defined so that they apply only to files in certain directories).  I added defined `excerpt: "auto"` and modified the `blog.html` layout so that it displays the first 50 words in the blog index as default excerpt if `excerpt==auto`, or else the content of the `excerpt` variable if it was redefined in the front matter.

Posts have categories and tags, which can be used to collect related posts.  At this point, tags are not fully functional.  I know how to make tags appear in a post, and link to a page collecting the tags, but the collecting page is not generated.  Apparently I need to define a Jekyll collection (the explanation in [this blog post](https://nathan.gs/2024/01/03/tags-in-jekyll/) looks pretty reasonable, I should implement it).

 
## Giscus Setup (one-time)

1. Go to: https://giscus.app
2. Select your repository and discussion category.
3. Copy the `repo-id` and `category-id` values and replace them in `_includes/giscus.html`.

 
## Preview

Run

```bash
bundle exec jekyll serve
```

and visit http://localhost:4000


## 16. Deploy

```bash
git add .
git commit -m "Update"
git push origin main
```

and site will be live at https://tgrigera.github.io


