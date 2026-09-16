(() => {
  "use strict";
  const header = document.querySelector('.site-header');
  // Suppress native link/selection dragging without blocking clicks or touch scrolling.
  header.addEventListener('dragstart', event => event.preventDefault());
  const accountLink = header.querySelector('[data-account-link]');
  const signIn = header.querySelector('[data-header-sign-in]');

  window.addEventListener('linkmap-auth', event => {
    if (event.detail.state === 'loading') return;
    const signedIn = event.detail.state === 'signed-in';
    accountLink.hidden = !signedIn;
    signIn.hidden = signedIn;
  });
})();
