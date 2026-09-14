(() => {
  "use strict";

  const panel = document.querySelector("[data-auth]");
  const status = document.querySelector("[data-status]");
  const account = document.querySelector("[data-account]");
  const controls = document.querySelector("[data-auth-controls]");
  const retry = document.querySelector("[data-auth-retry]");
  const accountLink = document.querySelector("[data-account-link]");
  let container;
  let attempt = 0;

  function render(state, message, identity) {
    panel.dataset.state = state;
    panel.setAttribute("aria-busy", String(state === "loading"));
    status.textContent = message;
    controls.hidden = state !== "signed-in" && state !== "signed-out";
    retry.hidden = state !== "error";
    account.hidden = state !== "signed-in";
    const name = identity?.nameComponents;
    account.textContent = state === "signed-in"
      ? [name?.givenName, name?.familyName].filter(Boolean).join(" ") || "Your iCloud account"
      : "";
    accountLink.textContent = state === "signed-in" ? "Account" : "Sign in";
  }

  function showError() {
    render("error", "We couldn’t connect to iCloud. Check your connection and try again. If this continues, please contact us using the Feedback link.");
  }

  function updateSession(identity, currentAttempt) {
    if (currentAttempt !== attempt) return;
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
      updateSession(await container.setUpAuth(), currentAttempt);
    } catch {
      if (currentAttempt === attempt) showError();
    }
  }

  retry.addEventListener("click", () => {
    if (!window.CloudKit) {
      window.location.reload();
      return;
    }
    initializeAuth();
  });
  initializeAuth();
})();
