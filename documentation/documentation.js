(() => {
  "use strict";
  const root = document.getElementById('documentation-root');
  const pageKey = document.body.dataset.documentationPage;
  const page = documentationPages[pageKey];
  // Resolve site-relative links from any platform depth or legacy loader.
  const siteRoot = new URL('../', document.currentScript.src);
  const pageDirectory = new URL('.', location.href);
  const depth = pageDirectory.pathname.slice(siteRoot.pathname.length).split('/').filter(Boolean).length;
  const sitePrefix = '../'.repeat(depth);
  const escape = value => String(value).replace(/[&<>"']/g, character => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
  })[character]);
  const pageURL = slug => `${sitePrefix}documentation/${documentationPages[slug].path}`;
  const link = (item, active = false) => `<a href="${pageURL(item.slug)}"${active ? ' aria-current="page"' : ''} data-filter-item>${escape(item.title)}</a>`;
  const platform = page?.platform ? documentationPages[page.platform] : null;
  const topics = documentationNavigation.map(slug => ({ slug, ...documentationPages[slug] }))
    .filter(item => item.platform === page?.platform);
  const groups = [...new Set(topics.map(item => item.group))];

  function renderTopic(item) {
    const children = topics.filter(child => child.parent === item.slug);
    const title = link(item, item.slug === pageKey);
    return `<li>${children.length ? `<details class="docs-nav-topic"><summary>${title}</summary><ul>${children.map(renderTopic).join('')}</ul></details>` : title}</li>`;
  }

  function renderNavigation() {
    const platforms = `<section class="docs-slide" data-slide="platforms"${platform ? ' hidden' : ''}><h2 class="docs-slide-title">Platforms</h2><ul class="docs-platform-list">${documentationPlatforms.map(slug => `<li><a class="docs-platform-row" href="${pageURL(slug)}" data-filter-item><span>${escape(documentationPages[slug].shortTitle)}</span><span aria-hidden="true">›</span></a></li>`).join('')}</ul></section>`;
    if (!platform) return platforms;
    return platforms + `<section class="docs-slide" data-slide="${page.platform}"><a class="docs-platform-back" href="${pageURL('index')}" data-platform-back><span aria-hidden="true">‹</span> Platforms</a><a class="docs-platform-overview" href="${pageURL(page.platform)}"${pageKey === page.platform ? ' aria-current="page"' : ''} data-filter-item>${escape(platform.shortTitle)} overview</a>${groups.map(group => `<section class="docs-nav-group"><h2>${escape(group)}</h2><ul>${topics.filter(item => item.group === group && !item.parent).map(renderTopic).join('')}</ul></section>`).join('')}${!topics.length ? `<p class="docs-nav-note">${escape(platform.navigationNote)}</p>` : ''}</section>`;
  }

  function renderSidebar() {
    return `    <aside class="docs-sidebar" id="docs-sidebar" aria-label="Documentation navigator">
      <div class="docs-sidebar-header">
        <div class="docs-sidebar-heading">LinkMap documentation</div>
        <button class="docs-sidebar-close" type="button" aria-label="Close documentation sidebar" hidden>
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none" aria-hidden="true"><path d="m5 5 10 10M15 5 5 15" stroke="currentColor" stroke-width="1.5"/></svg>
        </button>
      </div>
      <nav class="docs-navigation" id="guide-navigation" aria-label="Documentation">${renderNavigation()}</nav>
      <div class="docs-filter" hidden>
        <label for="guide-filter">Filter current view</label>
        <div class="docs-filter-field">
          <svg width="18" height="18" viewBox="0 0 20 20" fill="none" aria-hidden="true"><path d="M3 5h14M6 10h8M8 15h4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
          <input id="guide-filter" type="search" placeholder="Filter" autocomplete="off" aria-controls="guide-navigation">
        </div>
        <p class="docs-filter-status" role="status" hidden></p>
      </div>
    </aside>`;
  }

  function renderPageHeader() {
    if (page.kind === 'home') return `<p class="eyebrow">LinkMap documentation</p><h1>${escape(page.title)}</h1><p class="docs-intro">${escape(page.summary)}</p>`;
    const breadcrumb = page.kind === 'overview' ? escape(platform.shortTitle) : `<a href="${pageURL(page.platform)}">${escape(platform.shortTitle)}</a> / ${escape(page.group)}`;
    return `<p class="docs-breadcrumb"><a href="${pageURL('index')}">Documentation</a> / ${breadcrumb}</p><h1>${escape(page.title)}</h1><p class="docs-intro">${escape(page.summary)}</p>${page.platform === 'ios' ? `<p class="docs-availability" aria-label="Documentation version">${escape(documentationVersion)}</p>` : ''}${page.kind === 'article' ? `<p class="docs-note">${escape(platform.articleNote)}</p>` : ''}`;
  }

  function renderOnThisPage() {
    return `<nav class="docs-toc" aria-label="On this page"><strong>On this page</strong><ul>${page.sections.map((section, index) => `<li><a href="#section-${index + 1}">${escape(section.title)}</a></li>`).join('')}</ul></nav>`;
  }

  function renderSections() {
    return page.sections.map((section, index) => `<section${page.kind === 'overview' ? ' class="docs-group"' : ` id="section-${index + 1}"`}><h2>${escape(section.title)}</h2>${section.body ? `<p>${escape(section.body)}</p>` : ''}${section.points?.length ? `<ul>${section.points.map(point => `<li>${escape(point)}</li>`).join('')}</ul>` : ''}</section>`).join('');
  }

  function renderCards() {
    if (page.kind === 'home') return `<section class="docs-group"><h2>Platforms</h2><div class="docs-cards">${documentationPlatforms.map(slug => {
      const item = documentationPages[slug];
      return `<a class="docs-card" href="${pageURL(slug)}"><h3>${escape(item.shortTitle)}</h3><p>${escape(item.summary)}</p></a>`;
    }).join('')}</div></section>`;
    return groups.map(group => `<section class="docs-group"><h2>${escape(group)}</h2><div class="docs-cards">${topics.filter(item => item.group === group).map(item => `<a class="docs-card" href="${pageURL(item.slug)}"><h3>${escape(item.title)}</h3><p>${escape(item.summary)}</p></a>`).join('')}</div></section>`).join('');
  }

  function renderPagination() {
    const index = topics.findIndex(item => item.slug === pageKey);
    return `<nav class="docs-pagination" aria-label="Documentation pagination">${[[topics[index - 1], 'Previous'], [topics[index + 1], 'Next']].map(([item, label]) => item ? `<a href="${pageURL(item.slug)}">${label}: ${escape(item.title)}</a>` : '').join('')}</nav>`;
  }

  async function renderComponent(name) {
    const response = await fetch(`${sitePrefix}components/${name}.html`);
    if (!response.ok) throw new Error(`Unable to load ${name}`);
    return (await response.text()).replace(/\$\{site_prefix\}|\$site_prefix/g, sitePrefix)
      .replace(/\$docs_current/g, page.kind === 'home' ? ' aria-current="page"' : ' aria-current="true"')
      .replace(/\$(?:download|account)_current/g, '')
      .replace(/<script\b[^>]*>[\s\S]*?<\/script>/g, '');
  }
  const renderHeader = () => renderComponent('header');
  const renderFooter = () => renderComponent('footer');

  function loadScript(path) {
    return new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.src = sitePrefix + path;
      script.onload = resolve;
      script.onerror = reject;
      document.head.append(script);
    });
  }

  async function render() {
    if (!page) throw new Error('Unknown documentation page');
    const [header, footer] = await Promise.all([renderHeader(), renderFooter()]);
    const content = renderPageHeader() + (page.kind === 'home' ? renderCards() : page.kind === 'article'
      ? renderOnThisPage() + `<article>${renderSections()}</article>` + renderPagination()
      : renderSections() + `<p><a${page.action.primary ? ' class="button button-primary"' : ''} href="${sitePrefix}${escape(page.action.href)}">${escape(page.action.title)}</a></p>` + renderCards());
    const template = document.createElement('template');
    template.innerHTML = `<a class="skip-link" href="#main">Skip to content</a>${header}
  <nav class="docs-subheader" aria-label="Documentation navigation">
    <button class="docs-sidebar-button" type="button" aria-label="Hide documentation sidebar" aria-controls="docs-sidebar" aria-expanded="true" hidden>
      <svg width="20" height="20" viewBox="0 0 20 20" fill="none" aria-hidden="true"><rect x="2" y="3" width="16" height="14" rx="2" stroke="currentColor" stroke-width="1.5"/><path d="M7 3v14M4 7h1M4 10h1M4 13h1" stroke="currentColor" stroke-width="1.5"/></svg>
    </button>
    <a href="${pageURL('index')}"${page.kind === 'home' ? ' aria-current="page"' : ''}>Documentation</a>
  </nav>
  <button class="docs-backdrop" type="button" aria-label="Close documentation sidebar" tabindex="-1" aria-hidden="true"></button>

      <div class="docs-layout">${renderSidebar()}<main id="main" class="docs-main" tabindex="-1">${content}</main></div>${footer}`;
    root.replaceWith(template.content);
    // Existing behavior must initialize after the shared DOM is in place.
    await Promise.all([loadScript('header.js'), loadScript('documentation/sidebar.js')]);
    if (location.hash) {
      let fragment = location.hash.slice(1);
      try { fragment = decodeURIComponent(fragment); } catch {}
      document.getElementById(fragment)?.scrollIntoView();
    }
    // Authentication is independent of rendering and sidebar interaction.
    for (const path of ['components/notification/notification.js', 'shared/errors/cloudkit-errors.js', 'cloudkit-config.js', 'cloudkit-auth.js']) await loadScript(path);
  }
  render().catch(error => {
    console.error('Documentation initialization failed:', error);
    if (root.isConnected) {
      const message = document.createElement('p');
      message.textContent = 'Unable to load this documentation. Please reload the page.';
      root.replaceChildren(message);
    }
  });
})();
