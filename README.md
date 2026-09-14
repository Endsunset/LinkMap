# LinkMap

LinkMap is an iOS app for planning homeless feeding activity with private map workspaces.

Use LinkMap to organize service areas, reusable locations, supply items, project routes, assignments, and distribution records. Workspace data is stored with iCloud and can be shared with collaborators through CloudKit sharing when needed.

**Visit the official [website](https://endsunset.github.io/LinkMap/) for more details.**

## Current Release

- Private workspace maps for regions, layers, and locations
- Project planning with routes, route stops, assignments, supplies, and distributions
- Reusable workspace locations and item records
- iCloud storage and CloudKit sharing for collaborator access
- App Store release and TestFlight beta availability

## Feedback

Use [GitHub Issues](https://github.com/Endsunset/LinkMap/issues) to report bugs or request improvements. Please include device model, iOS version, app version, and steps to reproduce when reporting a problem.

## Web development

The static web home for LinkMap. LinkMap helps teams organize shared projects, map operating areas, manage places and resources, and plan activity cycles such as routes, assignments, supplies, and distributions.

This repository is intentionally separate from the native [LinkMap app](https://github.com/Endsunset/LinkMap-core). The web home is a public entry point for the product; the app remains the primary project workspace while the web experience is developed.

### Stack

- Plain HTML, CSS, and JavaScript
- CloudKit JS for Apple sign-in and future web data workflows
- GitHub Pages for static hosting

No build step or package manager is required for the current site.

### CloudKit setup

The website uses CloudKit JS authentication with the native app's container,
`iCloud.name.Endsunset.LinkMap`. Apple's SDK renders the sign-in/sign-out controls,
restores its persisted session on page load, and notifies the page when the user
signs in or out. Account names are displayed only when Apple provides them.
Signing in does not yet expose project editing on the web.

1. In [CloudKit Console](https://icloud.developer.apple.com/), select
   `iCloud.name.Endsunset.LinkMap` and create a **web API token** under API Access.
2. Restrict Allowed Origins to `https://endsunset.github.io` (no `/LinkMap/` path).
   Add a local preview origin separately if needed. Leave the custom sign-in
   callback unset so CloudKit JS can manage its standard sign-in window.
3. Paste the browser token into `apiToken` in `cloudkit-config.js`. The checked-in
   environment is `production`, matching the released app; use `development`
   only for development data and accounts.
4. Commit and push the configuration, then test at
   `https://endsunset.github.io/LinkMap/`. Allow Apple's sign-in window if your
   browser blocks it.

The browser API token is public configuration and is delivered to every visitor.
Never add an Apple password, private key, server-to-server key, or user session
token to these files. CloudKit JS manages user credentials and session cookies.
Until a web API token is supplied, the site clearly reports sign-in as unavailable.
SDK/network failures show a retry action without claiming the user is signed in.

Implementation follows Apple's [authentication reference](https://developer.apple.com/documentation/cloudkitjs/cloudkit.container/setupauth)
and [CloudKit Catalog](https://cdn.apple-cloudkit.com/cloudkit-catalog/).

### Local preview

Serve the repository over HTTP from its root, for example:

```sh
python3 -m http.server 8000
```

Then open `http://localhost:8000`.

### GitHub Pages

In the repository settings, enable Pages from the branch and root directory containing `index.html`. The site has no generated output directory.

### Related project

The native app and its CloudKit data model live in [LinkMap-core](https://github.com/Endsunset/LinkMap-core).
