# Shared documentation pilot

Only `ios/` and `ios/how-linkmap-works/` use the client renderer. Their original
`docs/` URLs and the first pilot `/documentation/how-linkmap-works/` URL load the same renderer and content, preserving existing bookmarks
and section fragments. Other guides remain generated under `docs/`.

- `pages.js`: page content, platform-relative paths, version, and navigation/card metadata. Edit directly.
  Keep iOS articles under `ios/<slug>/`, alongside the `ios/` overview.
- `documentation.js`: shared layout and component rendering. Uses the existing
  `components/header.html`, `components/footer.html`, `header.js`, and
  `docs/sidebar.js`; no router or build step.
- `documentation.css`: common styles. Legacy `docs/docs.css` imports this file.
- Each `index.html`: loader, page key, and static title/description for metadata.

The old catalog retains only navigation metadata for migrated pages and marks
these entries `client_rendered`. Existing generators skip their loaders. During
this pilot, keep titles/summaries in the loader and legacy navigation catalog in
sync with `pages.js`. Navigation metadata for other guides is a snapshot; update
it here when changing legacy guide titles, summaries, groups, or parents.

Serve over HTTP (as on GitHub Pages); the renderer fetches shared site components.
JavaScript is required for these two pages; a noscript message links to the static
documentation home. A failed component request displays a reload message.
