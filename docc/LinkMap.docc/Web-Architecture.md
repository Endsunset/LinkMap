# Web Architecture

`app/index.html` is the map page. `app/app.js` owns the selected Project, Project list, and visible Locations. It coordinates authentication, loading, selection, retries, and updates to the map and selector. A request version discards responses that arrive after a Project switch, sign-out, or retry.

`app/project.js` and `app/location.js` turn CloudKit records into page data. `app/project-selector.js` renders the selector and status without owning selection. `app/map.js` owns the MapKit JS instance. Search, place detail, and coordinates live in their own modules and keep their selection marker separate from Project Location annotations.

See `app/README.md` and `app/app.js` for the module boundaries and their current verification notes.
