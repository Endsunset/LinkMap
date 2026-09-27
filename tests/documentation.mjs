// Run with node tests/documentation.mjs. This checks HTML output, not browser layout.
import { readFileSync, existsSync } from 'node:fs';
import { runInNewContext } from 'node:vm';
import assert from 'node:assert/strict';

const repo = new URL('../', import.meta.url);
const read = path => readFileSync(new URL(path, repo), 'utf8');
const data = read('documentation/pages.js');
const source = read('documentation/documentation.js');
const { pages, navigation } = runInNewContext(`${data}\n({ pages: documentationPages, navigation: documentationNavigation })`);
export const renderedPages = {};

async function render(key, route, base, failFetch = false) {
  const location = new URL(`https://example.test${base}${route}#section-1`);
  let html = '', fallback = '', scrolled = '';
  const scripts = [], errors = [];
  const local = path => {
    const url = new URL(path, location);
    assert.ok(url.pathname.startsWith(base), `Lost hosting base: ${url}`);
    const relative = url.pathname.slice(base.length);
    assert.ok(existsSync(new URL(relative, repo)), `Missing asset: ${relative}`);
    return relative;
  };
  const root = {
    isConnected: true,
    replaceWith(template) { html = template.innerHTML; this.isConnected = false; },
    replaceChildren(message) { fallback = message.textContent; }
  };
  runInNewContext(`${data}\n${source}`, {
    URL, location,
    console: { error(error) { errors.push(error); } },
    fetch: async path => ({ ok: !failFetch, text: async () => read(local(path)) }),
    document: {
      currentScript: { src: `https://example.test${base}documentation/documentation.js` },
      body: { dataset: { documentationPage: key } },
      getElementById(id) {
        return id === 'documentation-root' ? root : { scrollIntoView() { scrolled = id; } };
      },
      createElement(tag) {
        const element = {};
        if (tag === 'template') element.content = element;
        return element;
      },
      head: { append(script) {
        assert.ok(html, 'Scripts must initialize after the shared DOM exists');
        scripts.push(local(script.src));
        script.onload();
      } }
    }
  });
  // Drain promise-only rendering and script loading; no real network or timers.
  for (let turn = 0; turn < 40; turn++) await Promise.resolve();
  return { html, fallback, scripts, errors, scrolled };
}

for (const [key, page] of Object.entries(pages)) {
  if (page.kind === 'article') {
    assert.equal(page.path, `ios/${key}/`);
    assert.ok(navigation.includes(key));
    if (page.parent) {
      assert.ok(pages[page.parent]);
      const ancestors = new Set([key]);
      let parent = page.parent;
      while (parent) {
        assert.ok(!ancestors.has(parent), `Cyclic topic hierarchy: ${key}`);
        ancestors.add(parent);
        parent = pages[parent].parent;
      }
    }
  }
  const routes = [`documentation/${page.path}`, `docs/${key === 'index' ? '' : key + '/'}`];
  if (key === 'how-linkmap-works') routes.push('documentation/how-linkmap-works/');
  for (const base of ['/', '/LinkMap/']) for (const route of routes) {
    const result = await render(key, route, base);
    assert.deepEqual(result.errors, []);
    assert.ok(result.html.includes('<h1>'));
    assert.equal((result.html.match(/<main\b/g) || []).length, 1);
    assert.equal(result.scrolled, 'section-1');
    assert.deepEqual(result.scripts, ['header.js', 'documentation/sidebar.js',
      'components/notification/notification.js', 'shared/errors/cloudkit-errors.js',
      'cloudkit-config.js', 'cloudkit-auth.js']);
    const ids = [...result.html.matchAll(/\bid="([^"]+)"/g)].map(match => match[1]);
    assert.equal(ids.length, new Set(ids).size, 'Unique IDs');
    for (const [, href] of result.html.matchAll(/\bhref="([^"]+)"/g)) {
      const target = new URL(href, `https://example.test${base}${route}`);
      assert.ok(target.pathname.startsWith(base));
      if (href.startsWith('#')) assert.ok(ids.includes(href.slice(1)), `Missing fragment ${href}`);
      else {
        assert.ok(!/\.(?:html|md)$/.test(target.pathname));
        assert.ok(existsSync(new URL(target.pathname.slice(base.length) + 'index.html', repo)), `Missing page ${href}`);
        assert.ok(!target.pathname.startsWith(`${base}docs/`), 'Navigation must use canonical routes');
      }
    }
    const loader = read(route + 'index.html');
    assert.ok(loader.includes(`data-documentation-page="${key}"`));
    assert.ok(!loader.includes('docs-sidebar'), 'Loader must not duplicate layout');
    if (page.kind === 'article') {
      assert.equal(ids.filter(id => id.startsWith('section-')).length, page.sections.length);
      const index = navigation.indexOf(key);
      assert.equal(result.html.includes('Previous:'), index > 0);
      assert.equal(result.html.includes('Next:'), index < navigation.length - 1);
    }
    if (key === 'web') {
      assert.ok(result.html.includes('data-slide="web"'));
      assert.ok(!result.html.includes('data-slide="ios"'));
      assert.ok(!result.html.includes('Documentation version'));
    }
    renderedPages[route] = result.html;
  }
}
for (const [key, failFetch] of [['unknown', false], ['ios', true]]) {
  const result = await render(key, 'documentation/ios/', '/LinkMap/', failFetch);
  assert.ok(result.fallback.includes('Unable to load'));
  assert.equal(result.html, '');
}
console.log('Documentation: 15 pages, 31 canonical/legacy routes at both base paths, fragments, pagination, script order, and error fallbacks passed.');
