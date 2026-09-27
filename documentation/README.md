# Shared documentation

All 15 documentation pages use one renderer: the home page, Web and iOS overviews,
and 12 iOS articles. Canonical routes are `documentation/`, `documentation/web/`,
`documentation/ios/`, and `documentation/ios/<slug>/`.

- `pages.js`: the single content source, metadata, paths, version, and ordered
  platform/article keys. Sidebar labels, overview cards and pagination read these
  same entries; there is no separate JSON catalog or documentation generator.
- `documentation.js`: shared layout, header/footer loading, sections, navigation,
  and initialization of existing authentication and sidebar behavior.
- `documentation.css`: all common documentation styles; also used by the policy.
- `sidebar.js`: filtering, disclosure restoration, collapse/session preferences,
  sticky header offsets, and the mobile overlay with focus containment.
- Each `index.html`: a page key and minimal loader with static title/description.

To edit content, change `pages.js` and update matching loader metadata if the title
or description changes. To add a page, add its content entry and ordered navigation
key, then a minimal loader under its platform folder. No build step is required.
Keep section ordering stable when possible: `section-1`, `section-2`, etc. are
public fragment identifiers. Article provenance records the initial native import.

The original `docs/` URLs and `/documentation/how-linkmap-works/` remain small
compatibility loaders using the same renderer and page keys. Do not restore
article content or shared layout inside them. Header/footer refresh scripts skip
all documentation loaders because shared site components are fetched at runtime.

Serve over HTTP, as on GitHub Pages. JavaScript is required. A noscript message
links to LinkMap home; failed component requests show a reload message.

Validation: `node tests/documentation.mjs` and `node tests/docs-sidebar.mjs`.
Also verify local destinations/fragments and run `git diff --check`.
