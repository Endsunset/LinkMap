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
  let saved;
  try { saved = sessionStorage.getItem('linkmap-docs-sidebar'); } catch {}

  function setOpen(open, remember = false) {
    if (!open && sidebar.contains(document.activeElement)) button.focus();
    sidebar.hidden = !open;
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
  setOpen(saved ? saved === 'open' : !smallScreen.matches);
  button.addEventListener('click', () => setOpen(sidebar.hidden, true));
  sidebar.addEventListener('keydown', event => {
    if (event.key === 'Escape') { setOpen(false, true); button.focus(); }
  });
  smallScreen.addEventListener('change', () => {
    if (!saved) setOpen(!smallScreen.matches);
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
