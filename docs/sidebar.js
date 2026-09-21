(() => {
  "use strict";
  const button = document.querySelector('.docs-sidebar-button');
  const sidebar = document.querySelector('#docs-sidebar');
  const closeButton = sidebar?.querySelector('.docs-sidebar-close');
  const filter = document.querySelector('#guide-filter');
  if (!button || !sidebar || !filter) return;
  // Follow the part of the site header still visible as it scrolls away.
  const header = document.querySelector('.site-header');
  function updateHeaderOffset() {
    const visibleHeight = Math.max(0, header.getBoundingClientRect().bottom);
    document.body.style.setProperty('--docs-visible-header-height', `${visibleHeight}px`);
  }
  updateHeaderOffset();
  window.addEventListener('scroll', updateHeaderOffset, { passive: true });
  window.addEventListener('resize', updateHeaderOffset);
  new ResizeObserver(updateHeaderOffset).observe(header);

  const slides = [...sidebar.querySelectorAll('[data-slide]')];
  let activeSlide = slides.find(slide => !slide.hidden);
  const filterStates = new Map();
  const status = sidebar.querySelector('.docs-filter-status');
  const smallScreen = window.matchMedia('(max-width: 700px)');
  const backdrop = document.querySelector('.docs-backdrop');
  const background = [...document.querySelectorAll('.docs-main, .site-footer, .site-header, .docs-subheader, .skip-link')];
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
  closeButton.hidden = false;
  closeButton.addEventListener('click', () => { setOpen(false, true); button.focus(); });
  sidebar.querySelector('.docs-filter').hidden = false;
  document.body.classList.add('sidebar-ready');
  setOpen(!smallScreen.matches && saved !== 'closed');
  button.addEventListener('click', () => {
    setOpen(!isOpen, true);
    if (isOpen && smallScreen.matches) closeButton.focus();
  });
  backdrop.addEventListener('click', () => { setOpen(false, true); button.focus(); });
  document.addEventListener('keydown', event => {
    if (!isOpen) return;
    if (event.key === 'Escape') { setOpen(false, true); button.focus(); }
    if (event.key === 'Tab' && smallScreen.matches) {
      const targets = [...sidebar.querySelectorAll('button, input, summary, a[href]')]
        .filter(element => element.getClientRects().length && !element.closest('[hidden]'));
      const first = targets[0], last = targets[targets.length - 1];
      if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
      else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
    }
  });
  smallScreen.addEventListener('change', () => {
    setOpen(!smallScreen.matches && saved !== 'closed');
  });

  function filterSlide() {
    const groups = [...activeSlide.querySelectorAll('.docs-nav-group, .docs-nav-topic')];
    const links = [...activeSlide.querySelectorAll('[data-filter-item]')];
    const query = filter.value.trim().toLowerCase();
    let previousGroups = filterStates.get(activeSlide);
    if (query && !previousGroups) {
      previousGroups = groups.map(group => group.open);
      filterStates.set(activeSlide, previousGroups);
    }
    let count = 0;
    links.forEach(link => {
      const matches = link.textContent.toLowerCase().includes(query);
      (link.closest('li') || link).hidden = !matches;
      if (matches) count++;
    });
    // A matching descendant keeps its complete parent path visible.
    links.forEach(link => {
      const row = link.closest('li');
      if (!row || row.hidden) return;
      let ancestor = row.parentElement?.closest('li');
      while (ancestor) {
        ancestor.hidden = false;
        ancestor = ancestor.parentElement?.closest('li');
      }
    });
    groups.forEach((group, index) => {
      const ownRow = group.classList.contains('docs-nav-topic') ? group.closest('li') : null;
      group.hidden = ownRow ? ownRow.hidden : ![...group.querySelectorAll('li')].some(item => !item.hidden);
      if (query) group.open = true;
      else if (previousGroups) group.open = previousGroups[index];
    });
    if (!query) filterStates.delete(activeSlide);
    status.hidden = !query;
    const noun = activeSlide.dataset.slide === 'platforms' ? 'platform' : 'page';
    status.textContent = count ? `${count} ${noun}${count === 1 ? '' : 's'} found` : `No ${noun}s found.`;
  }
  function updateFilterLabel() {
    const name = activeSlide.dataset.slide === 'platforms' ? 'platforms' : `${activeSlide.dataset.slide === 'ios' ? 'iOS' : 'Web'} documentation`;
    filter.placeholder = `Filter ${name}`;
    sidebar.querySelector('label[for="guide-filter"]').textContent = `Filter ${name}`;
  }
  sidebar.querySelector('[data-platform-back]')?.addEventListener('click', event => {
    // Modified clicks retain normal navigation to the documentation homepage.
    if (event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
    event.preventDefault();
    filter.value = '';
    filterSlide();
    activeSlide.hidden = true;
    activeSlide = slides.find(slide => slide.dataset.slide === 'platforms');
    activeSlide.hidden = false;
    updateFilterLabel();
    filterSlide();
    sidebar.querySelector('.docs-navigation').scrollTop = 0;
    activeSlide.querySelector('a').focus();
  });
  updateFilterLabel();
  filter.addEventListener('input', filterSlide);
})();
