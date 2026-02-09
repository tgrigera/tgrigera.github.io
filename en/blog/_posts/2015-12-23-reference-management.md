---
layout: post
title: "Reference management with Emacs, BibTeX, and Zotero"
date: 2015-12-03
lang: en
tags: [Emacs, BibTex, Zotero]
permalink: /en/blog/computers/2015-12-03/
categories: [computers]
comments: true
---

In this entry I describe what I use for reference and citation
management in Emacs.  It is nothing original, and relies on a couple
of excellent packages, to whose authors I am deeply indebted.
However, it took me a while to figure out which tools where most
suitable for me, so I share this summary in the hope that it may be of
help to others.

My setup allows me to:

 - get citations easily into my database from journals' websites or
   from pdf metadata (`Zotero`)
 - backup the database and synchronise it among computers through the
   cloud (`Zotero`)
 - export data to a BibTeX file, kept automatically updated,
   from which various Emacs packages take the job (`Zotero`)
 - insert citations into LaTeX documents with a powerful and
   convenient search interface (`reftex` and `helm-bibtex`)
 - insert citations into org-mode documents, which correctly export to
   LaTex and HTML (`org-ref` and `helm-bibtex`)
 - open the article's PDF from Emacs (from the link or through a
   search interface)
 - take notes about an article and get at them through the citation
   link or a search interface (`helm-bibtex`)


## Getting citations: Zotero

[Zotero](http://www.zotero.org/) is a reference database manager which can generate
bibliographies in different formats, which works as a standalone
application or as a Firefox extension (which is an especially
convenient way to add citations to the database).  It can also take a
PDF file and use the PDF metadata to find the appropriate citation.
It is widely documented online.

I use Zotero as a BibTeX manager.  That is, references are stored in
Zotero's database (that I keep synchronised in the office and the
laptop through a `Nextcloud` account ~~thanks to Zotero's DAV support~~).
It is very convenient to collect references from websites and for
a quick search, but I do not use it to generate citations.  Instead, I
rely on [BetterBibTex](http://github.com/ZotPlus/zotero-better-bibtex) (a Zotero extension) to export to a `.bib` file
(I freely use TeX markup in Zotero, which BetterBibTex respects if the
entry is marked with a `#LaTeX` tag).  I write exclusively in Emacs
and insert references and generate bibliographies using several Emacs
packages, directly in LaTeX documents, or in org-mode documents which
get eventually exported to LaTeX or HTML.

## Writing in LaTeX

When writing directly a LaTeX document, I insert with `reftex` or
[helm-bibtex](http://github.com/tmalsburg/helm-bibtex) (the first is bundled with Emacs, the second is available from MELPA).  You need to specify the `.bib` files you will be using, plus some useful key-bindings.

```lisp
 (setq reftex-default-bibliography '("~/biblio/main.bib") )
 (setq helm-bibtex-bibliography '("~/biblio/main.bib")
 (add-hook 'TeX-mode-hook
   (lambda() (define-key TeX-mode-map "\C-ch" 'helm-bibtex)) )
```

Both packages, when you hit the chosen keybinding (for `reftex`
it is `C-c [` by default), open a search window from which you select
the reference (powerful regexp-based queries are possible, check the
respective documentations) and a `\cite` or similar command is
inserted for you.  I have not explored `helm-bibtex` sufficiently to
have an opinion on which interface is superior as regards the search
facilities.  However, `helm-bibtex` has the ability to open the PDF
file and the notes related to the reference (see below).

## Writing in org-mode

When writing org-mode documents, I insert citations with [org-ref](http://github.com/jkitchin/org-ref) (available from MELPA).  I changed the key binding from `C-c ]` to
`C-c [` to have it the same as `reftex` (though this hides another
`org-mode` key).  `org-ref` opens `helm-bibtex` for the search, but
inserts the citation in its own format (as `cite:key`).  This is
converted to the appropriate LaTeX command on export; you also need to
include bibliography and bibliographystyle links at some place in the
document (usually the end) to get the reference list at that point:

```
bibliographystyle:unsrtnat
bibliography:~/biblio/main.bib
```

`org-ref` supports other link types besides citation links (like
references to figures or other labels).  Check out the documentation.

## Opening the article's PDF

From the `helm-bibtex` search window, one of the actions is to open
the pdf.  This relies on a link in the corresponding BiBTeX entry.
When exporting from Zotero, the files are listed in a `file` field
(there is no need to export both entries and files, since BetterBibTex
will link directly to the Zotero attached file).  You must tell
`helm-bibtex` which field to look for.  It will open all the specified
files, by default in Emacs itself, but you can change this to another
viewer as shown:

```emacs
(setq bibtex-completion-pdf-field "file")
(setq bibtex-completion-pdf-open-function
  (lambda (fpath)
    (start-process "evince" "*helm-bibtex-evince*" "/usr/bin/evince" fpath)))
```

(The names `helm-bibtex-pdf-field` and `helm-bibtex-pdf-open-function`
were formerly used for variables `bibtex-completion-pdf-field` and
`bibtex-completion-pdf-open-function` and still work as aliases).

If you move to an already-entered citation command, in both LaTeX and
Org modes the minibuffer shows information on the cited entry.  In
Org, you can click with the mouse for additional options (an approach
I don't like).  One of the options is open the PDF file, but I haven't
been able to get it to work.  I prefer to open the link with
`org-open-at-point` (by default `C-c C-o`) and then I get the option
to open the PDF.

<!-- Another option is to open the `helm-bibtex` search window and insert the citation key as a search -->
<!-- term: this will get directly to the entry, and then one can invoke the -->
<!-- open PDF action as if the whole process originated from a search from -->
<!-- scratch.  This is almost what I want, except that inserting the key is -->
<!-- not straightforward.  In principle, typing =M-n= with the search -->
<!-- window open inserts the word-at-point in the minibuffer.  This is -->
<!-- great except that sometimes the keys comprise more than one word -->
<!-- (because they include characters such as colons or underscores).  Then -->
<!-- =M-n= doesn't work.  For multiword keys, one can use =C-w=, which -->
<!-- inserts from point to end of word, and inserts the following words on -->
<!-- repeating the key.  However, apart from the multiple key presses, this -->
<!-- will only work if the point is exactly at the beginning of the key. -->
<!-- This is an issue, while minor, I would like to fix but currently don't -->
<!-- know how. -->

## Notes

With =helm-bibtex= one can link BibTeX entries to notes in an
`org-mode` file.  I use an `.org` file for each bibliographic
note, which can be accessed as one of the actions (press `TAB`) from
the `helm-bibtex` search window.  The variables `bibtex-completion-notes-path` and `bibtex-completion-notes-template-multiple-files` specify the path where notes are stored and a template so that you get the reference details automatically pasted into your new note.  I use

```lisp
(setq bibtex-completion-notes-template-multiple-files ":PROPERTIES:\n:ROAM_REFS: cite:&${=key=}\n:END:\n#+TITLE: ${author-abbrev}, ${journal} ${year}\n#+startup: latexpreview\n\n - ${author}, _${title}_. /${journal}/ *${volume}*, ${pages} (${year}).\n\n")
```

You can also access the notes from a previously-inserted citation like
you access the PDF (except you select a different action from the
search window).  All comments above apply also to opening the notes.

## Conclusion

I am rather happy with this solution for reference management, which
combines the best of Zotero's convenience for getting references in a
database with the power of the Emacs tools described above to make
effective use of the database.  However, it is only recently that I
discovered `org-ref` and `helm-bibtex`, so I expect to learn more on
them and hopefully share on updates to this post.

