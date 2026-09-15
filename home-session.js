(() => {
  "use strict";
  const accountLink = document.querySelector('[data-account-link]');
  const signIn = document.querySelector('[data-home-sign-in]');
  const dialog = document.querySelector('#sign-in');
  const announcement = document.querySelector('[data-home-auth-status]');
  let signedIn = false;

  function openLogin() {
    if (signedIn) {
      window.location.assign(accountLink.href);
      return;
    }
    if (!dialog.open) dialog.showModal();
  }

  accountLink.addEventListener('click', event => {
    if (!signedIn) { event.preventDefault(); openLogin(); }
  });
  signIn.addEventListener('click', event => { event.preventDefault(); openLogin(); });
  dialog.addEventListener('click', event => {
    if (event.target !== dialog) return;
    const rect = dialog.getBoundingClientRect();
    if (event.clientX < rect.left || event.clientX > rect.right ||
        event.clientY < rect.top || event.clientY > rect.bottom) dialog.close();
  });
  dialog.addEventListener('close', () => {
    if (window.location.hash === '#sign-in') {
      history.replaceState(null, '', window.location.pathname + window.location.search);
    }
  });

  window.addEventListener('linkmap-auth', event => {
    const state = event.detail.state;
    if (state === 'loading') return;
    signedIn = state === 'signed-in';
    accountLink.textContent = signedIn ? 'Account' : 'Sign in';
    signIn.hidden = signedIn;
    if (signedIn) {
      const wasOpen = dialog.open;
      if (wasOpen) dialog.close();
      if (wasOpen) accountLink.focus();
      announcement.textContent = 'Signed in to LinkMap. Your account is available from the header.';
    } else {
      announcement.textContent = '';
    }
  });
  window.addEventListener('hashchange', () => {
    if (window.location.hash === '#sign-in') openLogin();
  });
  if (window.location.hash === '#sign-in') openLogin();
})();
