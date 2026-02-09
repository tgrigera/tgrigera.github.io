from pybtex.database import parse_file
from jinja2 import Template
from pathlib import Path
from collections import defaultdict
import html

# Paths
BIB_FILE = Path("../../biblio/self.bib")
OUTPUT_FILE = Path("_includes/publications.html")
BIB_OUT_DIR = Path("assets/bib")
BIB_OUT_DIR.mkdir(parents=True, exist_ok=True)

def format_authors(persons):
    def format_person(p):
        last = " ".join(p.last_names)
        first = " ".join(p.first_names + p.middle_names)
        if first:
            return f"{last}, {first[0]}."
        return last
    authors = [format_person(p) for p in persons]
    if len(authors) == 1:
        return authors[0]
    elif len(authors) == 2:
        return f"{authors[0]} and {authors[1]}"
    else:
        return ", ".join(authors[:-1]) + f", and {authors[-1]}"

def format_entry(key, entry):
    fields = entry.fields
    persons = entry.persons

    authors = format_authors(persons.get("author", []))
    title = fields.get("title", "").rstrip(".")
    journal = fields.get("journal", "")
    volume = fields.get("volume", "")
    pages = fields.get("pages", "")
    year = fields.get("year", "")

    doi = fields.get("doi")
    pdf = fields.get("file")
    eprint = fields.get("eprint")
    archive = fields.get("archivePrefix", "").lower()

    parts = []
    if authors:
        parts.append(authors)
    if title:
        parts.append(f'“{title}”')
    if journal:
        parts.append(f"<em>{journal}</em>")
    vol_page = []
    if volume:
        vol_page.append(f"<strong>{volume}</strong>")
    if pages:
        vol_page.append(pages)
    if vol_page:
        parts.append(", ".join(vol_page))
    if year:
        parts.append(f"({year})")

    main = ", ".join(parts)

    links = []
    if pdf:
        links.append(f'<a href="{pdf}" target="_blank">PDF</a>')
    if doi:
        links.append(f'<a href="https://doi.org/{doi}" target="_blank">DOI</a>')
    if eprint and archive == "arxiv":
        links.append(f'<a href="https://arxiv.org/abs/{eprint}" target="_blank">arXiv</a>')

    # Write BibTeX file
    bib_filename = f"{key}.bib"
    bib_path = BIB_OUT_DIR / bib_filename
    bib_path.write_text(entry.to_string("bibtex"), encoding="utf-8")
    links.append(f'<a href="/{bib_path.as_posix()}" download>BibTeX</a>')

    return main, links, year

# Load bibliography
bib_data = parse_file(BIB_FILE)

entries = []
for key, entry in bib_data.entries.items():
    main, links, year = format_entry(key, entry)
    entries.append({
        "year": year or "Unknown",
        "html": main,
        "links": links
    })

# Group by year
grouped = defaultdict(list)
for e in entries:
    grouped[e["year"]].append(e)

# Sort years descending
sorted_years = sorted(grouped.keys(), reverse=True)

# HTML template
template = Template("""
<div class="publications">
{% for year in years %}
  <h2 class="pub-year">{{ year }}</h2>
  <ol class="pub-list">
  {% for entry in grouped[year] %}
    <li class="pub-item">
      {{ entry.html | safe }}
      {% if entry.links %}
        <span class="pub-links">
          [{{ entry.links | join(" | ") | safe }}]
        </span>
      {% endif %}
    </li>
  {% endfor %}
  </ol>
{% endfor %}
</div>
""")

html_output = template.render(grouped=grouped, years=sorted_years)

# Write output
OUTPUT_FILE.write_text(html_output, encoding="utf-8")
print(f"✔ Generated {OUTPUT_FILE}")
print(f"✔ BibTeX files written to {BIB_OUT_DIR}/")
