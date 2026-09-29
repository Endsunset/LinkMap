# LinkMap documentation library

`LinkMap.docc` is the single authored Swift-DocC catalog. Its root page curates
Essentials, Handbook, Shared Concepts, and Reference. The Handbook page curates
iOS and Web branches. Keep each child in a parent's `## Topics` section; folders
and filenames alone do not define the visible navigator hierarchy.

Use the read-only native repository at `/Library/Developer/Projects/LinkMap-core`
for iOS architecture, SwiftUI, CloudKit, MapKit, resource workflow, and Swift model
reference content. Use this website repository's `app/`, shared authentication
modules, and scripts for web and deployment content. Keep common concepts in
Shared Concepts and platform-specific instructions in the matching handbook.
Select reference types intentionally rather than publishing every internal
symbol discovered from the app target.

Run `python3 scripts/build-documentation.py` from the website checkout. It
builds the catalog with warnings treated as errors and the `/LinkMap` hosting
base path, then checks in the static output. DocC's generated landing article
is at `/documentation/linkmap/`; `/documentation/` is the stable entry URL and
redirects there. This avoids a duplicated `/documentation/documentation/` path.
Former `/documentation/ios/` and `/documentation/web/` roots redirect to their
handbook branches, and `/docs/` still leads to the library for the native app.
DocC's shared static assets live at the repository root because DocC's route
base is `/LinkMap`.

Run `python3 tests/documentation.py` to validate the hierarchy, article output,
and local links. For visual verification, serve the repository from its parent
directory and open `http://localhost:8000/LinkMap/documentation/`.
