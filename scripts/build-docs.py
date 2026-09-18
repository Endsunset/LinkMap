"""Render the checked-in documentation snapshot: python3 scripts/build-docs.py."""
from pathlib import Path
import html
import json
from site_header import render_header, render_auth_scripts

root = Path(__file__).resolve().parents[1]
docs = root / 'docs'
pages = json.loads((docs / 'content.json').read_text())
e = html.escape

def shell(title, description, content, active='index'):
    docs_prefix = './' if active == 'index' else '../'
    site_prefix = '../' if active == 'index' else '../../'
    navigation = ''
    for group in dict.fromkeys(p['group'] for p in pages):
        navigation += f'<details class="docs-nav-group" open><summary>{e(group)}</summary><ul>'
        for page in pages:
            if page['group'] == group:
                current = ' aria-current="page"' if active == page['slug'] else ''
                navigation += f'<li><a href="{docs_prefix}{page["slug"]}/"{current}>{e(page["title"])}</a></li>'
        navigation += '</ul></details>'
    return f'''<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="{e(description, quote=True)}">
  <title>{e(title)} | LinkMap Documentation</title>
  <link rel="stylesheet" href="{site_prefix}styles.css">
  <link rel="stylesheet" href="{docs_prefix}docs.css">
  <script src="{docs_prefix}sidebar.js" defer></script>
{render_auth_scripts(site_prefix)}
</head>
<body class="docs-page">
  <a class="skip-link" href="#main">Skip to content</a>
  {render_header(site_prefix, docs=True)}
  <nav class="docs-subheader" aria-label="Documentation navigation">
    <button class="docs-sidebar-button" type="button" aria-label="Hide documentation sidebar" aria-controls="docs-sidebar" aria-expanded="true" hidden>
      <svg width="20" height="20" viewBox="0 0 20 20" fill="none" aria-hidden="true"><rect x="2" y="3" width="16" height="14" rx="2" stroke="currentColor" stroke-width="1.5"/><path d="M7 3v14M4 7h1M4 10h1M4 13h1" stroke="currentColor" stroke-width="1.5"/></svg>
    </button>
    <a href="{docs_prefix}"{' aria-current="page"' if active == 'index' else ''}>Documentation</a>
  </nav>
  <button class="docs-backdrop" type="button" aria-label="Close documentation sidebar" tabindex="-1" aria-hidden="true"></button>
  <div class="docs-layout">
    <aside class="docs-sidebar" id="docs-sidebar" aria-label="Guide navigator">
      <div class="docs-sidebar-heading">LinkMap documentation</div>
      <div class="docs-filter" hidden>
        <label for="guide-filter">Filter guides</label>
        <input id="guide-filter" type="search" placeholder="Filter guides" autocomplete="off" aria-controls="guide-navigation">
        <p class="docs-filter-status" role="status" hidden></p>
      </div>
      <nav class="docs-navigation" id="guide-navigation" aria-label="Documentation">{navigation}</nav>
    </aside>
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
