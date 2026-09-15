(() => {
  "use strict";

  const panel = document.querySelector("[data-auth]");
  const status = document.querySelector("[data-status]");
  const account = document.querySelector("[data-account]");
  const controls = document.querySelector("[data-auth-controls]");
  const retry = document.querySelector("[data-auth-retry]");
  const publicStatus = document.querySelector('[data-public-status]');
  const publicRetry = document.querySelector('[data-public-retry]');
  let publicAttempt = 0;
  let container;

  function withTimeout(promise) {
    let timer;
    return Promise.race([promise, new Promise((_, reject) => {
      timer = setTimeout(() => reject(new Error('Connection timed out')), 15000);
    })]).finally(() => clearTimeout(timer));
  }

  async function checkPublicDatabase() {
    if (!publicStatus || !publicRetry) return;
    const currentCheck = ++publicAttempt;
    publicRetry.disabled = true;
    publicStatus.textContent = 'Checking the public database…';
    try {
      const response = await withTimeout(container.publicCloudDatabase.fetchAllRecordZones());
      if (currentCheck !== publicAttempt) return;
      if (!response || response.hasErrors || response.errors?.length) throw new Error('CloudKit rejected the check');
      publicStatus.textContent = 'Connected: the public CloudKit database responded successfully.';
    } catch {
      if (currentCheck !== publicAttempt) return;
      publicStatus.textContent = 'Could not confirm public database access. The connection or this operation may be unavailable. This does not determine your sign-in status.';
    } finally {
      if (currentCheck === publicAttempt) publicRetry.disabled = false;
    }
  }
  let attempt = 0;

  function render(state, message, identity) {
    panel.dataset.state = state;
    panel.setAttribute("aria-busy", String(state === "loading"));
    status.textContent = message;
    controls.hidden = state !== "signed-in" && state !== "signed-out";
    retry.hidden = state !== "error";
    account.hidden = state !== "signed-in";
    const signInLink = document.querySelector('[data-sign-in-link]');
    if (signInLink) signInLink.hidden = state !== 'signed-out';
    window.dispatchEvent(new CustomEvent('linkmap-auth', { detail: { state } }));
    const name = identity?.nameComponents;
    account.textContent = state === "signed-in"
      ? [name?.givenName, name?.familyName].filter(Boolean).join(" ") || "Your iCloud account"
      : "";
  }

  function showError() {
    render("error", "We couldn’t connect to iCloud. Check your connection and try again. If this continues, please contact us using the Feedback link.");
  }

  function updateSession(identity, currentAttempt, checkConnection = true) {
    if (currentAttempt !== attempt) return;
    if (checkConnection) checkPublicDatabase();
    render(identity ? "signed-in" : "signed-out", identity
      ? "You’re signed in to iCloud. Use the LinkMap app to work with your projects; web project tools are still in development."
      : "Sign in with your Apple Account to connect to LinkMap.", identity);

    // These promises resolve once. Re-arm the opposite event after every transition.
    const next = identity ? container.whenUserSignsOut() : container.whenUserSignsIn();
    next.then((user) => updateSession(identity ? null : user, currentAttempt))
      .catch(() => { if (currentAttempt === attempt) showError(); });
  }

  function waitForCloudKit() {
    if (window.CloudKit) return Promise.resolve();
    return new Promise((resolve, reject) => {
      const loaded = () => {
        clearTimeout(timeout);
        window.removeEventListener("cloudkitloaded", loaded);
        resolve();
      };
      const timeout = setTimeout(() => {
        window.removeEventListener("cloudkitloaded", loaded);
        reject(new Error("CloudKit did not load"));
      }, 15000);
      window.addEventListener("cloudkitloaded", loaded);
    });
  }

  async function initializeAuth() {
    const currentAttempt = ++attempt;
    render("loading", "Connecting to iCloud…");
    const config = window.LINKMAP_CLOUDKIT;
    if (!config?.apiToken?.trim() || !config.containerIdentifier?.startsWith("iCloud.") ||
        !["development", "production"].includes(config.environment)) {
      render("unavailable", "Web sign-in is not available yet. You can continue using LinkMap in the iOS app.");
      if (publicStatus) publicStatus.textContent = 'Connection check unavailable: web sign-in is not configured.';
      return;
    }

    try {
      await waitForCloudKit();
      if (currentAttempt !== attempt) return;
      if (!container) {
        window.CloudKit.configure({
          containers: [{
            containerIdentifier: config.containerIdentifier,
            environment: config.environment,
            apiTokenAuth: {
              apiToken: config.apiToken.trim(),
              persist: true,
              signInButton: { id: "apple-sign-in-button", theme: "black" },
              signOutButton: { id: "apple-sign-out-button", theme: "black" }
            }
          }]
        });
        container = window.CloudKit.getDefaultContainer();
      }
      checkPublicDatabase();
      updateSession(await withTimeout(container.setUpAuth()), currentAttempt, false);
    } catch {
      if (currentAttempt === attempt) {
        showError();
        if (!container && publicStatus) publicStatus.textContent = 'Connection check unavailable: CloudKit could not start.';
      }
    }
  }

  publicRetry?.addEventListener('click', checkPublicDatabase);
  retry.addEventListener("click", () => {
    if (!window.CloudKit) {
      window.location.reload();
      return;
    }
    initializeAuth();
  });
  window.addEventListener('pageshow', event => { if (event.persisted) initializeAuth(); });
  initializeAuth();
})();
