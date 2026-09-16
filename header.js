(() => {
  "use strict";
  const header = document.querySelector('.site-header');
  // Suppress native link/selection dragging without blocking clicks or touch scrolling.
  header.addEventListener('dragstart', event => event.preventDefault());
  const accountLink = header.querySelector('[data-account-link]');

  function updateAuth(detail) {
    if (detail.state === 'loading') return;
    const signedIn = detail.state === 'signed-in';
    accountLink.hidden = !signedIn;
    document.querySelectorAll('[data-header-sign-in]').forEach(link => { link.hidden = signedIn; });
  }
  window.addEventListener('linkmap-auth', event => updateAuth(event.detail));
  if (window.LinkMapAuth) updateAuth(window.LinkMapAuth.current);
})();
