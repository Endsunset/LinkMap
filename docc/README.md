# LinkMap documentation

`LinkMap.docc` is the authored source for the entire `/documentation/` section.
The articles are curated from the read-only native app repository at
`/Library/Developer/Projects/LinkMap-core`, especially `ARCHITECTURE.md`,
`UX.md`, `WORKFLOW.md`, and the referenced Swift model files. Recheck those
sources when app behavior changes. `Model-Reference.md` selects only a few types
that explain the conceptual guides; the build does not export the whole app's
symbol graph.

Run `python3 scripts/build-documentation.py` from the website checkout. The
script invokes Xcode's `docc`, treats warnings as errors, uses the GitHub Pages
base path `/LinkMap/documentation`, and replaces the checked-in `documentation/`
output. Commit source and generated output together. `documentation/index.html`
is a static entry redirect to DocC's generated landing article at
`documentation/documentation/linkmap/`.
The script also writes redirects for former `/documentation/ios/` and
`/documentation/web/` routes and the native app's current `/docs/` link. They
are compatibility entries into the same DocC site, not separate frontends.

Serve the repository under `/LinkMap/` when checking locally. For example, run
`python3 -m http.server 8000` from the parent directory and open
`http://localhost:8000/LinkMap/documentation/`. Check the landing page, iOS and
Web topics, a conceptual article, the model reference, search, and links at
desktop and mobile widths. DocC's static hosting output includes its own
assets, topic JSON, and article routes.
Run `python3 tests/documentation.py` to validate generated local links and
the `/LinkMap/documentation/` asset base path.
