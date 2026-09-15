"""Render the checked-in documentation snapshot: python3 scripts/build-docs.py."""
from pathlib import Path
import html
import json

root = Path(__file__).resolve().parents[1]
docs = root / 'docs'
pages = json.loads((docs / 'content.json').read_text())
e = html.escape

def shell(title, description, content, active='index'):
    docs_prefix = './' if active == 'index' else '../'
    site_prefix = '../' if active == 'index' else '../../'
    navigation = f'<a href="{docs_prefix}"' + (' aria-current="page"' if active == 'index' else '') + '>Documentation home</a>'
    for group in dict.fromkeys(p['group'] for p in pages):
        navigation += f'<h2>{e(group)}</h2><ul>'
        for page in pages:
            if page['group'] == group:
                current = ' aria-current="page"' if active == page['slug'] else ''
                navigation += f'<li><a href="{docs_prefix}{page["slug"]}/"{current}>{e(page["title"])}</a></li>'
        navigation += '</ul>'
    return f'''<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="{e(description, quote=True)}">
  <title>{e(title)} | LinkMap Documentation</title>
  <link rel="stylesheet" href="{site_prefix}styles.css">
  <link rel="stylesheet" href="{docs_prefix}docs.css">
</head>
<body>
  <a class="skip-link" href="#main">Skip to content</a>
  <header class="site-header docs-header">
    <a class="brand" href="{site_prefix}">LinkMap</a>
    <a href="{docs_prefix}">Documentation</a>
    <a href="https://apps.apple.com/us/app/linkmap/id6745166200">Get the app</a>
  </header>
  <div class="docs-layout">
    <details class="docs-sidebar" open>
      <summary class="docs-sidebar-toggle"><span class="sidebar-expanded">Hide guides</span><span class="sidebar-collapsed">Show guides</span></summary>
      <nav class="docs-navigation" aria-label="Documentation">{navigation}</nav>
    </details>
    <main id="main" class="docs-main" tabindex="-1">{content}</main>
  </div>
  <footer class="site-footer"><a href="{site_prefix}">LinkMap home</a><a href="{site_prefix}privacy-policy/">Privacy policy</a></footer>
</body>
</html>
'''

cards = ''
for group in dict.fromkeys(p['group'] for p in pages):
    cards += f'<section class="docs-group"><h2>{e(group)}</h2><div class="docs-cards">'
    for page in pages:
        if page['group'] == group:
            cards += f'<a class="docs-card" href="{page["slug"]}/"><h3>{e(page["title"])}</h3><p>{e(page["summary"])}</p></a>'
    cards += '</div></section>'
(docs / 'index.html').write_text(shell('Documentation', 'Learn how to set up a LinkMap project, plan activities, and collaborate with your team.', '<p class="eyebrow">LinkMap user guide</p><h1>Documentation</h1><p class="docs-intro">Learn how to build your project map, plan a round of work, and coordinate with your team.</p><p class="docs-note">These guides describe the LinkMap iOS app. Screen names and navigation steps refer to the app; web project tools are still in development.</p>' + cards))
for index, page in enumerate(pages):
    content = f'<p class="docs-breadcrumb"><a href="../">Documentation</a> / {e(page["group"])}</p><h1>{e(page["title"])}</h1><p class="docs-intro">{e(page["summary"])}</p><p class="docs-note">This guide describes the LinkMap iOS app.</p>'
    content += '<nav class="docs-toc" aria-label="On this page"><strong>On this page</strong><ul>'
    for number, section in enumerate(page['sections'], 1):
        content += f'<li><a href="#section-{number}">{e(section["title"])}</a></li>'
    content += '</ul></nav><article>'
    for number, section in enumerate(page['sections'], 1):
        content += f'<section id="section-{number}"><h2>{e(section["title"])}</h2>'
        if section['body']:
            content += f'<p>{e(section["body"])}</p>'
        if section['points']:
            content += '<ul>' + ''.join(f'<li>{e(point)}</li>' for point in section['points']) + '</ul>'
        content += '</section>'
    content += '</article><nav class="docs-pagination" aria-label="Guide navigation">'
    if index > 0:
        previous = pages[index - 1]
        content += f'<a href="../{previous["slug"]}/">Previous: {e(previous["title"])}</a>'
    if index + 1 < len(pages):
        following = pages[index + 1]
        content += f'<a href="../{following["slug"]}/">Next: {e(following["title"])}</a>'
    content += '</nav>'
    destination = docs / page['slug']
    destination.mkdir(exist_ok=True)
    (destination / 'index.html').write_text(shell(page['title'], page['summary'], content, page['slug']))
print(f'Rendered documentation home and {len(pages)} guides.')
