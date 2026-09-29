# LinkMap user guides

`iOS.docc` and `Web.docc` are separate Swift-DocC catalogs. Their generated
landing pages are served directly at `/documentation/ios/` and
`/documentation/web/`. The `/documentation/` page helps readers choose between
them. iOS articles are checked against the read-only native repository at
`/Library/Developer/Projects/LinkMap-core`; web articles are checked against
the `app/` and account pages in this website repository.

Keep the guides focused on user tasks. Transaction, inventory, architecture,
and internal model reference content is intentionally absent for now. Put a
child article in its parent's `## Topics` list to maintain the DocC navigation
tree. Do not put iOS subjects in the web catalog or web subjects in the iOS
catalog.

Run `python3 scripts/build-documentation.py` from the website checkout. The
script builds both catalogs with warnings treated as errors and the GitHub Pages
base path `/LinkMap`. It places DocC article routes under `documentation/ios/`
and `documentation/web/`, merges the two navigator trees, and places DocC's
shared runtime assets at the repository root. The main site pages remain
separate. Commit the authored catalogs and generated output together. The
`/docs/` redirect preserves the current native app Documentation link.

Run `python3 tests/documentation.py` to check public routes, navigator hierarchy,
and local asset paths. For a visual check, serve the repository from its parent
directory and open `http://localhost:8000/LinkMap/documentation/`, then visit
both platform guides at desktop and mobile widths.
