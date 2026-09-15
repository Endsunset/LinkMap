(() => {
  "use strict";
  const accountLink = document.querySelector('[data-account-link]');
  const headerSignIn = document.querySelector('[data-header-sign-in]');
  const signIn = document.querySelector('[data-home-sign-in]');
  const dialog = document.querySelector('#sign-in');
  const announcement = document.querySelector('[data-home-auth-status]');
  let signedIn = false;

  function openLogin() {
    if (signedIn) return;
    if (!dialog.open) dialog.showModal();
  }

  headerSignIn.addEventListener('click', openLogin);
  signIn.addEventListener('click', openLogin);
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
    accountLink.hidden = !signedIn;
    headerSignIn.hidden = signedIn;
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
