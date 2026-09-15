(() => {
  "use strict";
  const button = document.querySelector('.docs-sidebar-button');
  const sidebar = document.querySelector('#docs-sidebar');
  const filter = document.querySelector('#guide-filter');
  if (!button || !sidebar || !filter) return;
  const groups = [...sidebar.querySelectorAll('.docs-nav-group')];
  const links = [...sidebar.querySelectorAll('nav a')];
  const status = sidebar.querySelector('.docs-filter-status');
  const smallScreen = window.matchMedia('(max-width: 700px)');
  const backdrop = document.querySelector('.docs-backdrop');
  const background = [...document.querySelectorAll('.docs-main, .site-footer, .docs-header a, .skip-link')];
  let isOpen = true;
  let saved;
  try { saved = sessionStorage.getItem('linkmap-docs-sidebar'); } catch {}

  function setOpen(open, remember = false) {
    if (!open && sidebar.contains(document.activeElement)) button.focus();
    isOpen = open;
    sidebar.inert = !open;
    sidebar.setAttribute('aria-hidden', String(!open));
    background.forEach(element => { element.inert = open && smallScreen.matches; });
    document.body.classList.toggle('sidebar-collapsed', !open);
    button.setAttribute('aria-expanded', String(open));
    button.setAttribute('aria-label', `${open ? 'Hide' : 'Show'} documentation sidebar`);
    button.title = `${open ? 'Hide' : 'Show'} sidebar`;
    if (remember) {
      saved = open ? 'open' : 'closed';
      try { sessionStorage.setItem('linkmap-docs-sidebar', saved); } catch {}
    }
  }

  button.hidden = false;
  sidebar.querySelector('.docs-filter').hidden = false;
  document.body.classList.add('sidebar-ready');
  setOpen(!smallScreen.matches && saved !== 'closed');
  button.addEventListener('click', () => {
    setOpen(!isOpen, true);
    if (isOpen && smallScreen.matches) filter.focus();
  });
  backdrop.addEventListener('click', () => { setOpen(false, true); button.focus(); });
  document.addEventListener('keydown', event => {
    if (!isOpen) return;
    if (event.key === 'Escape') { setOpen(false, true); button.focus(); }
    if (event.key === 'Tab' && smallScreen.matches) {
      const targets = [button, ...sidebar.querySelectorAll('input, summary, a[href]')]
        .filter(element => element.getClientRects().length && !element.closest('[hidden]'));
      const first = targets[0], last = targets[targets.length - 1];
      if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
      else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
    }
  });
  smallScreen.addEventListener('change', () => {
    setOpen(!smallScreen.matches && saved !== 'closed');
  });

  let previousGroups;
  filter.addEventListener('input', () => {
    const query = filter.value.trim().toLowerCase();
    if (query && !previousGroups) previousGroups = groups.map(group => group.open);
    let count = 0;
    links.forEach(link => {
      const matches = link.textContent.toLowerCase().includes(query);
      (link.closest('li') || link).hidden = !matches;
      if (matches) count++;
    });
    groups.forEach((group, index) => {
      group.hidden = ![...group.querySelectorAll('li')].some(item => !item.hidden);
      if (query) group.open = true;
      else if (previousGroups) group.open = previousGroups[index];
    });
    if (!query) previousGroups = null;
    status.hidden = !query;
    status.textContent = count ? `${count} guide${count === 1 ? '' : 's'} found` : 'No guides found.';
  });
})();
