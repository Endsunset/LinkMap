// Run with node tests/login-redirect.mjs. No network or Apple credentials needed.
import { readFileSync } from 'node:fs';
import { runInNewContext } from 'node:vm';
import assert from 'node:assert/strict';
const loginSource = readFileSync('login/login.js', 'utf8');
const headerSource = readFileSync('header.js', 'utf8');
for (const base of ['/', '/LinkMap/']) {
  const home = `https://example.com${base}`;
  for (const [redirect, expected] of [
    [null, home], ['', home],
    [`${base}docs/project/?view=all#sharing`, `${home}docs/project/?view=all#sharing`],
    ['../app/', `${home}app/`],
    [`${base}account/`, `${home}account/`],
    ['https://other.example/', home], ['//other.example/', home],
    ['javascript:alert(1)', home], ['http://[', home],
    [`${base}login/`, home], [`${base}login/index.html`, home],
    ...(base === '/' ? [] : [['/outside/', home]])
  ]) {
    for (const restored of [true, false]) {
      let result;
      const listeners = {};
      const href = `${home}login/${redirect === null ? '' : '?redirect=' + encodeURIComponent(redirect)}`;
      const window = {
        location: { href, replace(value) { result = value; } },
        addEventListener(name, fn) { listeners[name] = fn; },
        LinkMapAuth: { current: { state: restored ? 'signed-in' : 'signed-out' } }
      };
      const document = { querySelector() { return { dataset: {}, setAttribute() {}, addEventListener() {} }; } };
      runInNewContext(loginSource, { window, document, URL });
      if (!restored) {
        assert.equal(result, undefined);
        listeners['linkmap-auth']({ detail: { state: 'signed-in' } });
      }
      assert.equal(result, expected, `return from ${href}`);
    }
  }
  const listeners = {};
  const element = { addEventListener() {}, getAttribute() { return '../../account/'; } };
  const header = { ...element, querySelector() { return element; } };
  const links = ['../../login/', '../../login/', '../../docs/'].map(href => ({
    href, getAttribute() { return this.href; }, setAttribute(key, value) { this.href = value; }
  }));
  const location = new URL(`${home}docs/project/?view=all#sharing`);
  const window = { location, matchMedia() { return element; }, addEventListener(name, fn) { listeners[name] = fn; } };
  const document = {
    querySelector() { return header; }, querySelectorAll() { return links; },
    addEventListener(name, fn) { listeners[name] = fn; }
  };
  runInNewContext(headerSource, { window, document, URL });
  listeners.DOMContentLoaded();
  for (const link of links.slice(0, 2)) {
    assert.ok(link.href.startsWith('../../login/?redirect='));
    assert.equal(new URL(link.href, location).searchParams.get('redirect'), `${base}docs/project/?view=all#sharing`);
  }
  assert.equal(links[2].href, '../../docs/');
  location.hash = '#updated';
  listeners.hashchange();
  assert.equal(new URL(links[0].href, location).searchParams.get('redirect'), `${base}docs/project/?view=all#updated`);
}
console.log('Sign-in return links and redirects passed for root and /LinkMap/ hosting.');
