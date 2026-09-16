(() => {
  "use strict";

  const panel = document.querySelector("[data-auth]");
  const status = document.querySelector("[data-status]");
  const controls = document.querySelector("[data-auth-controls]");
  const retry = document.querySelector("[data-auth-retry]");
  const messages = {
    loading: "Checking your sign-in status…",
    "signed-out": "",
    error: "We couldn’t connect to iCloud. Check your connection and try again.",
    unavailable: "Web sign-in is not available yet. You can continue using LinkMap in the iOS app."
  };

  function updateUI({ state }) {
    if (state === "signed-in") {
      window.location.replace("../account/");
      return;
    }
    panel.dataset.state = state;
    panel.setAttribute("aria-busy", String(state === "loading"));
    status.textContent = messages[state];
    status.hidden = state === "signed-out";
    controls.hidden = state !== "signed-out";
    retry.hidden = state !== "error";
  }

  retry.addEventListener("click", () => {
    if (!window.CloudKit) {
      window.location.reload();
      return;
    }
    window.LinkMapAuth?.retry();
  });
  window.addEventListener("linkmap-auth", event => updateUI(event.detail));
  if (window.LinkMapAuth) updateUI(window.LinkMapAuth.current);
})();
