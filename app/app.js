(() => {
  "use strict";

  // Public MapKit JS token restricted to endsunset.github.io.
  const token = "eyJraWQiOiI1WVgzNlk5M1U1IiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiJYMzlBWFBSUkNRIiwiaWF0IjoxNzg5NjQzNzc2LCJvcmlnaW4iOiJlbmRzdW5zZXQuZ2l0aHViLmlvIiwic2NvcGUiOiJtYXBraXRfanMifQ.MOBNygJnZ0geEID4WOPFqLy1Ii_PP2F75MkrFbfs0uGt0b96HsofPygIKIqJgNc5GuFIj0tD98c0ZYDqU6zpPw";
  const status = document.getElementById("map-status");
  const notice = status.parentElement;
  const retry = document.getElementById("map-retry");
  const timeout = window.setTimeout(() => showError(), 20000);

  function showError(message = "Apple Maps could not load. Please check your connection and try again.") {
    window.clearTimeout(timeout);
    status.textContent = message;
    notice.hidden = false;
    retry.hidden = false;
  }

  retry.addEventListener("click", () => window.location.reload());
  window.initMapKit = () => {
    try {
      const mapkit = window.mapkit;
      mapkit.addEventListener("error", () => showError());
      mapkit.addEventListener("load-error", () => showError());
      const map = new mapkit.Map("map", {
        colorScheme: "light",
        tintColor: getComputedStyle(document.documentElement).getPropertyValue("--accent").trim(),
        showsCompass: mapkit.FeatureVisibility.Visible,
        showsScale: mapkit.FeatureVisibility.Visible,
        showsMapTypeControl: true,
        showsZoomControl: true,
        showsUserLocationControl: true,
        showsPointsOfInterest: true,
        isZoomEnabled: true,
        isScrollEnabled: true,
        isRotationEnabled: true,
      });
      map.addEventListener("user-location-error", () => {
        showError("Your location is unavailable. Allow location access in your browser or explore the map manually.");
      });
      window.clearTimeout(timeout);
      notice.hidden = true;
    } catch {
      showError();
    }
  };

  const script = document.createElement("script");
  script.src = "https://cdn.apple-mapkit.com/mk/6/mapkit.core.js";
  script.crossOrigin = "anonymous";
  script.async = true;
  script.dataset.callback = "initMapKit";
  script.dataset.libraries = "map";
  script.dataset.token = token;
  script.addEventListener("error", () => showError());
  document.head.append(script);
})();
