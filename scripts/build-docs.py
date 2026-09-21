"""Render the checked-in documentation snapshot: python3 scripts/build-docs.py."""
from pathlib import Path
import html
import json
from site_header import render_header, render_auth_scripts

root = Path(__file__).resolve().parents[1]
docs = root / 'docs'
catalog = json.loads((docs / 'content.json').read_text())
pages = catalog['pages']
platforms = catalog['platforms']
e = html.escape
documentation_version = "LinkMap 3.0.0 Beta 8"
version_line = f'<p class="docs-availability" aria-label="Documentation version">{e(documentation_version)}</p>'

def shell(title, description, content, active='index', platform=None):
    docs_prefix = './' if active == 'index' else '../'
    site_prefix = '../' if active == 'index' else '../../'
    navigation = '<section class="docs-slide" data-slide="platforms"' + (' hidden' if platform else '') + '><h2 class="docs-slide-title">Platforms</h2><ul class="docs-platform-list">'
    for item in platforms:
        navigation += f'<li><a class="docs-platform-row" href="{docs_prefix}{item["slug"]}/" data-filter-item><span>{e(item["title"])}</span><span aria-hidden="true">›</span></a></li>'
    navigation += '</ul></section>'
    if platform:
        current = ' aria-current="page"' if active == platform['slug'] else ''
        navigation += f'<section class="docs-slide" data-slide="{platform["slug"]}"><a class="docs-platform-back" href="{docs_prefix}" data-platform-back><span aria-hidden="true">‹</span> Platforms</a><a class="docs-platform-overview" href="{docs_prefix}{platform["slug"]}/"{current} data-filter-item>{e(platform["title"])} overview</a>'
        platform_pages = [p for p in pages if p['platform'] == platform['slug']]
        for group in dict.fromkeys(p['group'] for p in platform_pages):
            navigation += f'<details class="docs-nav-group" open><summary>{e(group)}</summary><ul>'
            for page in platform_pages:
                if page['group'] == group:
                    current = ' aria-current="page"' if active == page['slug'] else ''
                    navigation += f'<li><a href="{docs_prefix}{page["slug"]}/"{current} data-filter-item>{e(page["title"])}</a></li>'
            navigation += '</ul></details>'
        if not platform_pages:
            navigation += '<p class="docs-nav-note">Get started with the platform overview. More web guides are on the way.</p>'
        navigation += '</section>'
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
    <aside class="docs-sidebar" id="docs-sidebar" aria-label="Documentation navigator">
      <div class="docs-sidebar-header">
        <div class="docs-sidebar-heading">LinkMap documentation</div>
        <button class="docs-sidebar-close" type="button" aria-label="Close documentation sidebar" hidden>
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none" aria-hidden="true"><path d="m5 5 10 10M15 5 5 15" stroke="currentColor" stroke-width="1.5"/></svg>
        </button>
      </div>
      <nav class="docs-navigation" id="guide-navigation" aria-label="Documentation">{navigation}</nav>
      <div class="docs-filter" hidden>
        <label for="guide-filter">Filter current view</label>
        <div class="docs-filter-field">
          <svg width="18" height="18" viewBox="0 0 20 20" fill="none" aria-hidden="true"><path d="M3 5h14M6 10h8M8 15h4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
          <input id="guide-filter" type="search" placeholder="Filter" autocomplete="off" aria-controls="guide-navigation">
        </div>
        <p class="docs-filter-status" role="status" hidden></p>
      </div>
    </aside>
    <main id="main" class="docs-main" tabindex="-1">{content}</main>
  </div>
  <footer class="site-footer"><a href="{site_prefix}">LinkMap home</a><a href="{site_prefix}privacy-policy/">Privacy policy</a></footer>
</body>
</html>
'''

def platform_cards(platform, prefix):
    cards = ''
    platform_pages = [p for p in pages if p['platform'] == platform['slug']]
    for group in dict.fromkeys(p['group'] for p in platform_pages):
        cards += f'<section class="docs-group"><h2>{e(group)}</h2><div class="docs-cards">'
        for page in platform_pages:
            if page['group'] == group:
                cards += f'<a class="docs-card" href="{prefix}{page["slug"]}/"><h3>{e(page["title"])}</h3><p>{e(page["summary"])}</p></a>'
        cards += '</div></section>'
    return cards

home = catalog['home']
content = f'<p class="eyebrow">LinkMap documentation</p><h1>{e(home["title"])}</h1><p class="docs-intro">{e(home["summary"])}</p><section class="docs-group"><h2>Platforms</h2><div class="docs-cards">'
for platform in platforms:
    content += f'<a class="docs-card" href="{platform["slug"]}/"><h3>{e(platform["title"])}</h3><p>{e(platform["summary"])}</p></a>'
content += '</div></section>'
(docs / 'index.html').write_text(shell(home['title'], home['summary'], content))
for platform in platforms:
    content = f'<p class="docs-breadcrumb"><a href="../">Documentation</a> / {e(platform["title"])}</p><h1>LinkMap for {e(platform["title"])}</h1><p class="docs-intro">{e(platform["summary"])}</p>'
    if platform['slug'] == 'ios':
        content += version_line
    for section in platform['sections']:
        content += f'<section class="docs-group"><h2>{e(section["title"])}</h2><p>{e(section["body"])}</p></section>'
    if platform['slug'] == 'web':
        content += '<p><a class="button button-primary" href="../../app/">Open the web map</a></p>'
    else:
        content += '<p><a href="../../download/">Download LinkMap for iOS</a></p>'
    content += platform_cards(platform, '../')
    destination = docs / platform['slug']
    destination.mkdir(exist_ok=True)
    (destination / 'index.html').write_text(shell(platform['title'], platform['summary'], content, platform['slug'], platform))
for index, page in enumerate(pages):
    platform = next(p for p in platforms if p['slug'] == page['platform'])
    content = f'<p class="docs-breadcrumb"><a href="../">Documentation</a> / <a href="../{platform["slug"]}/">{e(platform["title"])}</a> / {e(page["group"])}</p><h1>{e(page["title"])}</h1><p class="docs-intro">{e(page["summary"])}</p>{version_line}<p class="docs-note">This documentation describes the LinkMap iOS app.</p>'
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
    content += '</article><nav class="docs-pagination" aria-label="Documentation pagination">'
    if index > 0:
        previous = pages[index - 1]
        content += f'<a href="../{previous["slug"]}/">Previous: {e(previous["title"])}</a>'
    if index + 1 < len(pages):
        following = pages[index + 1]
        content += f'<a href="../{following["slug"]}/">Next: {e(following["title"])}</a>'
    content += '</nav>'
    destination = docs / page['slug']
    destination.mkdir(exist_ok=True)
    (destination / 'index.html').write_text(shell(page['title'], page['summary'], content, page['slug'], platform))
print(f'Rendered documentation home, {len(platforms)} platform overviews, and {len(pages)} articles.')
