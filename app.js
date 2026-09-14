const cloudKitConfiguration = {
  containerIdentifier: "iCloud.com.example.LinkMap",
  environment: "development"
};

const statusMessage = document.querySelector("[data-status]");

function setStatus(message) {
  if (statusMessage) statusMessage.textContent = message;
}

function isConfigured() {
  return !cloudKitConfiguration.containerIdentifier.includes("example");
}

async function signIn() {
  if (!window.CloudKit || !isConfigured()) {
    setStatus("CloudKit is not configured yet. Add your container identifier in app.js.");
    return;
  }

  const container = CloudKit.getDefaultContainer();
  setStatus("Connecting to iCloud...");

  try {
    await container.signIn();
    setStatus("Signed in. Your LinkMap workspace is ready.");
  } catch (error) {
    setStatus(error.message || "Sign-in was cancelled. Please try again.");
  }
}

if (window.CloudKit) {
  CloudKit.configure({ containers: [cloudKitConfiguration] });
}

document.querySelectorAll("[data-sign-in]").forEach((button) => {
  button.addEventListener("click", signIn);
});