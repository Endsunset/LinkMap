# MapKit JS

`app/map.js` maintains one MapKit JS map and replaces Project Location annotations when the selected Project changes. Search or coordinate selection uses a separate marker, so exploring another place does not change the Project's annotations.

`app/place-search.js` handles autocomplete, full search, cancellation, and keyboard-accessible results. `app/place-details.js` replaces Apple's PlaceDetail card on selection changes. `app/coordinates.js` validates decimal latitude/longitude pairs and supports copying the current coordinate, with a manual fallback when clipboard access is unavailable.

The map loads the MapKit JS libraries it needs for the full map and services. See `app/README.md` and the corresponding modules in `app/`.
