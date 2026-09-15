# Contributing to LinkMap Web

This repository contains LinkMap’s public website and browser authentication flow,
served by GitHub Pages at [endsunset.github.io/LinkMap](https://endsunset.github.io/LinkMap/).
For product information, see the website. The native iOS app and CloudKit data model
live in [LinkMap-core](https://github.com/Endsunset/LinkMap-core).

## Working locally

Clone this repository and serve its root over HTTP:

```sh
git clone https://github.com/Endsunset/LinkMap.git
cd LinkMap
python3 -m http.server 8000
```

Open `http://localhost:8000`. The site uses plain HTML, CSS, and JavaScript;
there is no package installation, compilation, or generated output directory.

## Repository map

| File | Responsibility |
| --- | --- |
| `index.html` | User-facing product content, navigation, and account controls |
| `styles.css` | Shared styles and responsive layouts |
| `login/account.js` | CloudKit authentication, session state, and error recovery |
| `cloudkit-config.js` | Public configuration for LinkMap’s existing CloudKit integration |
| `privacy-policy.md` | Privacy policy source; rendered to `privacy-policy/index.html` |
| `docs/` | Documentation home, individual user guides, and their content snapshot |
| `scripts/build-docs.py` | Optional renderer for updating documentation HTML |

Apple’s CloudKit JS SDK provides the sign-in and sign-out buttons and manages the
persisted session. The web app currently supports authentication; project viewing
and editing remain in the native app. Keep website copy accurate about this boundary.

## Making a contribution

1. Check existing [issues](https://github.com/Endsunset/LinkMap/issues), or open one
   describing the problem. Discuss larger changes before implementation.
2. Create a branch from `main` and make a focused change. Keep unrelated formatting
   and refactoring out of the patch.
3. Preview your changes and complete the relevant checks below.
4. Open a pull request against `main`. Explain the problem, the resulting behavior,
   and how you verified it. Include desktop and mobile screenshots for visible changes
   and link any related issue.

Useful contributions include clearer product explanations, accessibility improvements,
responsive layout fixes, and authentication reliability. Native features and data
model changes belong in LinkMap-core; coordinate changes that affect both repositories.

## Implementation conventions

- Keep the site build-free unless a proposed feature justifies changing the stack.
- Use semantic HTML, descriptive link labels, visible keyboard focus, and accessible
  status messages. Preserve the existing visual style across screen sizes.
- Use relative asset paths and links: the deployed site lives under `/LinkMap/`.
- Keep user-facing copy focused on what people can do and how their data is handled.
- Render account information as text and let Apple’s SDK handle authentication.
  Do not store user credentials or session tokens in application code.
- Use the existing CloudKit integration. Content and layout contributions do not
  require a new container or token. Coordinate configuration changes with the maintainer;
  never commit private keys or account credentials.

## Verification

For content and layout changes, check navigation, local asset loading, keyboard access,
and narrow and wide layouts. Run `git diff --check` before submitting.

For JavaScript changes, run `node --check login/account.js` and
`node --check cloudkit-config.js` if Node.js is available. Authentication changes
should cover signed-out startup, restored sessions, sign-in, sign-out, repeated
transitions, and SDK or network failures. Confirm account information clears on sign-out.

Local origins may not be authorized for live CloudKit authentication. A local sign-in
failure alone does not indicate a UI regression. Coordinate live authentication checks
with the maintainer on an authorized origin, and state any unverified behavior in the PR.

## Publishing

GitHub Pages serves the repository root from `main`. Changes merged into `main`
update the public site after the Pages deployment completes. Review product claims,
links, and authentication behavior before merging; there is no separate build artifact
to publish.

## Reporting a bug

Use [GitHub Issues](https://github.com/Endsunset/LinkMap/issues). Include the page URL,
browser and device, steps to reproduce, expected behavior, and actual behavior.
Remove personal account details and session tokens from screenshots or logs.

## Updating the user guides

The `docs/` section mirrors the 12 guides in the native app’s Settings → Documentation
section. Its initial content was copied from `Documentation/Contents/Documentation*Content.swift`
in LinkMap-core. The original app repository is not modified by this website.

Edit `docs/content.json`, then run `python3 scripts/build-docs.py` and commit the
updated HTML alongside the content. Each entry records its original source filename
and SHA-256 checksum for comparison with future native documentation changes.
The renderer reads only the snapshot in this repository; it does not require or write
to LinkMap-core. Keep instructions clear that they describe the iOS app.

GitHub Pages serves the checked-in HTML directly. Documentation works without
JavaScript and adds no deployment build step.

## Internal page URLs

Follow `AGENTS.md`: page hyperlinks use directory URLs such as `docs/`,
`docs/project/`, and `privacy-policy/`, backed by `index.html` files. Asset URLs
keep their extensions. Update the rendering scripts alongside generated pages.
Run `python3 scripts/build-privacy.py` after editing the policy source.

## Visual style

Follow [the style guide](guide/style.md) for colors, typography, component accents,
and accessibility. Shared CSS applies the white-surface and red-accent theme across
the homepage, user guides, and privacy policy.

## Login and account page

`login/` owns CloudKit authentication and account status. The homepage links there
without loading CloudKit or account scripts. The page restores the SDK session,
handles sign-in/sign-out, and independently checks the public database with
`publicCloudDatabase.fetchAllRecordZones()`. This read-only probe does not fetch
project records or verify access to private/shared data. Rejections, response errors,
and timeouts are shown as unconfirmed access rather than successful connectivity.
