(() => {
  "use strict";

  // One lifecycle per document, even if this script is accidentally included twice.
  if (window.LinkMapAuth) return;
  let container;
  let configured = false;
  let attempt = 0;
  let snapshot = Object.freeze({ state: "loading", identity: null });

  window.LinkMapAuth = Object.freeze({
    get current() { return snapshot; },
    get container() { return container; },
    retry: initializeAuth
  });

  function publish(state, identity = null) {
    snapshot = Object.freeze({ state, identity });
    window.dispatchEvent(new CustomEvent("linkmap-auth", { detail: snapshot }));
  }

  function withTimeout(promise) {
    let timer;
    return Promise.race([promise, new Promise((_, reject) => {
      timer = setTimeout(() => reject(new Error('Connection timed out')), 15000);
    })]).finally(() => clearTimeout(timer));
  }

  function updateSession(identity, currentAttempt) {
    if (currentAttempt !== attempt) return;
    publish(identity ? "signed-in" : "signed-out", identity || null);
    // SDK transition promises resolve once; re-arm after each transition.
    const next = identity ? container.whenUserSignsOut() : container.whenUserSignsIn();
    next.then(user => updateSession(identity ? null : user, currentAttempt))
      .catch(() => { if (currentAttempt === attempt) publish("error"); });
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
    publish("loading");
    const config = window.LINKMAP_CLOUDKIT;
    if (!config?.apiToken?.trim() || !config.containerIdentifier?.startsWith("iCloud.") ||
        !["development", "production"].includes(config.environment)) {
      publish("unavailable");
      return;
    }

    try {
      await waitForCloudKit();
      if (currentAttempt !== attempt) return;
      if (!configured) {
        configured = true;
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
      }
      container = window.CloudKit.getDefaultContainer();
      updateSession(await withTimeout(container.setUpAuth()), currentAttempt);
    } catch {
      if (currentAttempt === attempt) {
        publish("error");
      }
    }
  }

  window.addEventListener("pageshow", event => { if (event.persisted) initializeAuth(); });
  initializeAuth();
})();
