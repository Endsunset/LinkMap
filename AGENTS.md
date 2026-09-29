# Repository instructions

## HTML links

Use clean URLs for internal page links in authored HTML. Do not end page hyperlinks with
`.html` or `.md`: link to `documentation/` and `privacy-policy/` instead.
Omit `index.html` from hyperlinks too: use the folder URL (`./`, `../`, or
`documentation/`), which automatically serves its index page.
Use relative paths so the site works under the GitHub Pages `/LinkMap/` base path.
Keep fragments when linking to a section.

Back each clean URL with a directory containing `index.html`; do not simply remove
an extension without providing a working destination. Asset references such as
CSS and JavaScript retain their extensions. Preserve external URLs as provided by
their owners.

Apply this convention to website generators. DocC owns its generated internal
links and static-hosting URLs. After changing links, verify local destinations
and fragments, and run `git diff --check`.

## Documentation

Documentation source lives in `docc/iOS.docc` and `docc/Web.docc`. Run
`python3 scripts/build-documentation.py` to regenerate the checked-in
`documentation/ios/` and `documentation/web/` static guides. The
`/documentation/` page lets readers choose a platform. The two DocC catalogs
contain separate, user-facing guidance; do not edit generated files directly.
The build leaves a redirect at `/docs/` for the native app's current link.
The privacy policy source remains in
`privacy-policy.md`; regenerate its public page with `python3 scripts/build-privacy.py`.
Commit generated pages with their source changes. No deployment build is required.

Treat `/Library/Developer/Projects/LinkMap-core` as read-only when referencing native
app code or documentation. Make web changes in this repository only.

## Visual style

Follow `guide/style.md` for all web UI changes. Use white backgrounds throughout
and red accents for emphasis, actions, and trailing badge or active-state edges.

## Commit and push

Unless the user explicitly specifies otherwise, commit and push completed changes
after the relevant verification passes. Stage only files belonging to the requested
work, use a descriptive commit message, and push to the current branch's configured
remote. Do not include unrelated local changes or force-push. Report the commit and
push result when finished.
