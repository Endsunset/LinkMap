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
      const response = await withTimeout(window.LinkMapAuth.container.publicCloudDatabase.fetchAllRecordZones());
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
  function render(state, message, identity) {
    if (panel) {
      panel.dataset.state = state;
      panel.setAttribute("aria-busy", String(state === "loading"));
    }
    if (status) status.textContent = message;
    if (controls) controls.hidden = state !== "signed-in" && state !== "signed-out";
    if (retry) retry.hidden = state !== "error";
    if (account) account.hidden = state !== "signed-in";
    const signInLink = document.querySelector('[data-sign-in-link]');
    if (signInLink) signInLink.hidden = state !== 'signed-out';
    const name = identity?.nameComponents;
    if (account) account.textContent = state === "signed-in"
      ? [name?.givenName, name?.familyName].filter(Boolean).join(" ") || "Your iCloud account"
      : "";
  }

  const messages = {
    loading: "Connecting to iCloud…",
    "signed-in": "You’re signed in to iCloud. Use the LinkMap app to work with your projects; web project tools are still in development.",
    "signed-out": "Sign in with your Apple Account to connect to LinkMap.",
    error: "We couldn’t connect to iCloud. Check your connection and try again. If this continues, please contact us using the Feedback link.",
    unavailable: "Web sign-in is not available yet. You can continue using LinkMap in the iOS app."
  };

  function updateUI({ state, identity }) {
    render(state, messages[state], identity);
    if (state === "signed-in" || state === "signed-out" ||
        (state === "error" && window.LinkMapAuth?.container)) {
      checkPublicDatabase();
    } else if (publicStatus) {
      ++publicAttempt;
      if (publicRetry) publicRetry.disabled = true;
      publicStatus.textContent = state === "loading" ? "Waiting to check the connection…"
        : "Connection check unavailable: CloudKit could not start.";
    }
  }

  publicRetry?.addEventListener("click", checkPublicDatabase);
  retry?.addEventListener("click", () => {
    if (!window.CloudKit) {
      window.location.reload();
      return;
    }
    window.LinkMapAuth?.retry();
  });
  window.addEventListener("linkmap-auth", event => updateUI(event.detail));
  if (window.LinkMapAuth) updateUI(window.LinkMapAuth.current);
})();
