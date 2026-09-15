(() => {
  "use strict";
  const accountLink = document.querySelector('[data-account-link]');
  const signIn = document.querySelector('[data-home-sign-in]');
  let container;
  let checking = false;

  function render(identity) {
    accountLink.textContent = identity ? 'Account' : 'Sign in';
    signIn.hidden = Boolean(identity);
  }

  async function refreshSession() {
    if (checking || !window.CloudKit) return;
    const config = window.LINKMAP_CLOUDKIT;
    if (!config?.apiToken) return;
    checking = true;
    let timer;
    try {
      if (!container) {
        window.CloudKit.configure({ containers: [{
          containerIdentifier: config.containerIdentifier,
          environment: config.environment,
          apiTokenAuth: { apiToken: config.apiToken, persist: true }
        }] });
        container = window.CloudKit.getDefaultContainer();
      }
      // No SDK button containers exist here. Login controls stay on /login/.
      const identity = await Promise.race([
        container.setUpAuth(),
        new Promise((_, reject) => {
          timer = setTimeout(() => reject(new Error('Session check timed out')), 15000);
        })
      ]);
      render(identity);
    } catch {
      // An unconfirmed session must not be presented as an authenticated account.
      render(null);
    } finally {
      clearTimeout(timer);
      checking = false;
    }
  }

  window.addEventListener('cloudkitloaded', refreshSession);
  window.addEventListener('pageshow', refreshSession);
  window.addEventListener('focus', refreshSession);
  document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'visible') refreshSession();
  });
  refreshSession();
})();
