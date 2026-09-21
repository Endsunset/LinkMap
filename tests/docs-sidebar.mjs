// Run with node tests/docs-sidebar.mjs.
import { readFileSync } from 'node:fs';
import { runInNewContext } from 'node:vm';
import assert from 'node:assert/strict';
function element(extra = {}) {
  return { hidden: false, handlers: {}, attrs: {}, style: { setProperty() {} },
    classList: { add() {}, toggle() {}, contains() { return false; } },
    addEventListener(type, fn) { this.handlers[type] = fn; },
    setAttribute(key, value) { this.attrs[key] = value; },
    focus() { document.activeElement = this; }, ...extra };
}
let document;
for (const mobile of [false, true]) {
  const row = text => element({ textContent: text, closest() { return null; } });
  const platformRows = [row('Web'), row('iOS')];
  const overview = row('iOS overview');
  const article = row('Map');
  const child = row('Locations');
  const parentRow = element({ parentElement: { closest() { return null; } } });
  const childRow = element({ parentElement: { closest() { return parentRow; } } });
  article.closest = () => parentRow;
  child.closest = () => childRow;
  const topic = element({ open: false, classList: { contains() { return true; } },
    closest() { return parentRow; }, querySelectorAll() { return [childRow]; } });
  const group = element({ querySelectorAll() { return [parentRow, childRow]; } });
  const platforms = element({ hidden: true, dataset: { slide: 'platforms' },
    querySelectorAll(s) { return s === '[data-filter-item]' ? platformRows : []; }, querySelector() { return platformRows[0]; } });
  const ios = element({ dataset: { slide: 'ios' },
    querySelectorAll(s) { return s === '[data-filter-item]' ? [overview, article, child] : [group, topic]; } });
  const button = element(), close = element(), filter = element({ value: '' }), back = element();
  const status = element(), label = element(), navigation = element({ scrollTop: 80 });
  const sidebarElements = { '.docs-sidebar-close': close, '.docs-filter': element(), '.docs-filter-status': status,
    '[data-platform-back]': back, 'label[for="guide-filter"]': label, '.docs-navigation': navigation };
  const sidebar = element({ querySelector(s) { return sidebarElements[s]; },
    querySelectorAll(s) { return s === '[data-slide]' ? [platforms, ios] : []; }, contains() { return false; } });
  const background = [element()];
  const elements = { '.docs-sidebar-button': button, '#docs-sidebar': sidebar, '#guide-filter': filter,
    '.site-header': element({ getBoundingClientRect() { return { bottom: 70 }; } }), '.docs-backdrop': element() };
  document = element({ body: element(), querySelector(s) { return elements[s]; }, querySelectorAll() { return background; } });
  const media = element({ matches: mobile });
  const window = element({ matchMedia() { return media; } });
  runInNewContext(readFileSync('docs/sidebar.js', 'utf8'), { document, window,
    sessionStorage: { getItem() { return null; }, setItem() {} }, ResizeObserver: class { observe() {} } });
  assert.equal(button.attrs['aria-expanded'], String(!mobile));
  if (mobile) { button.handlers.click(); assert.equal(background[0].inert, true); }
  filter.value = 'map'; filter.handlers.input();
  assert.equal(article.hidden, false); assert.equal(overview.hidden, true);
  assert.equal(group.open, undefined, 'section dividers never expand'); assert.equal(status.textContent, '1 page found');
  assert.equal(platformRows[0].hidden, false, 'inactive slide is unaffected');
  filter.value = 'locations'; filter.handlers.input();
  assert.equal(childRow.hidden, false);
  assert.equal(parentRow.hidden, false, 'matching child retains its parent');
  assert.equal(topic.hidden, false); assert.equal(topic.open, true);
  assert.equal(status.textContent, '1 page found', 'ancestors do not inflate result counts');
  filter.value = 'missing'; filter.handlers.input();
  assert.equal(parentRow.hidden, true); assert.equal(group.hidden, true);
  filter.value = ''; filter.handlers.input();
  assert.equal(topic.open, false, 'clearing restores nested disclosure state');
  assert.equal(childRow.hidden, false);
  let prevented = false;
  back.handlers.click({ preventDefault() { prevented = true; } });
  assert.equal(prevented, true); assert.equal(ios.hidden, true); assert.equal(platforms.hidden, false);
  assert.equal(group.open, undefined, 'section dividers have no disclosure state');
  assert.equal(filter.value, ''); assert.equal(status.hidden, true);
  assert.equal(document.activeElement, platformRows[0]); assert.equal(navigation.scrollTop, 0);
  filter.value = 'web'; filter.handlers.input();
  assert.equal(platformRows[1].hidden, true); assert.equal(status.textContent, '1 platform found');
  filter.value = 'map'; filter.handlers.input();
  assert.equal(status.textContent, 'No platforms found.');
  filter.value = ''; filter.handlers.input(); assert.equal(platformRows[1].hidden, false);
  document.handlers.keydown({ key: 'Escape' });
  assert.equal(button.attrs['aria-expanded'], 'false'); assert.equal(background[0].inert, false);
}
console.log('Sidebar platform navigation, scoped filters, focus, and mobile state passed.');
