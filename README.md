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

1. Create or select the web-enabled CloudKit container in CloudKit Console.
2. Update `containerIdentifier` and `environment` in `app.js`.
3. Add the deployed GitHub Pages origin to the CloudKit web service configuration.
4. Test sign-in from the deployed HTTPS site. CloudKit JS does not work from an unconfigured local origin.

The checked-in identifier is a placeholder so the page does not accidentally connect to a real container before configuration.

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
