# LinkMap web style guide

Use white backgrounds throughout the website. Red is the distinguishing accent:
apply it to selected text, actions, active navigation, and the trailing edge of
badges. Keep long-form reading text neutral and surfaces quiet.

## Color tokens

Define shared colors in `styles.css`; use the same tokens in `docs/docs.css`.

| Token | Value | Use |
| --- | --- | --- |
| `--surface` | `#ffffff` | Page, section, card, button, badge, and illustration backgrounds |
| `--ink` | `#202124` | Headings and primary body text |
| `--muted` | `#5f6368` | Supporting text and descriptions |
| `--accent` | `#b4232c` | Red emphasis, links, focus outlines, and accent edges |
| `--accent-hover` | `#8e1820` | Hover emphasis for actions |
| `--line` | `#dedfe2` | Quiet separators and card borders |

Avoid colored section fills, dark background bands, cream panels, and secondary
accent colors. Use spacing and borders to separate white surfaces. Apple’s
SDK-owned authentication buttons retain their official appearance.

## Accent placement

- Highlight a short phrase in a headline, rather than coloring the entire page red.
- Use red for text links; underline links within prose.
- Keep buttons white with red labels and borders. Primary buttons have a thicker
  trailing border to distinguish them from secondary actions.
- Badges use white fill, a neutral thin border, red text, and a 3px red trailing
  edge. Use `border-inline-end` so the edge follows the text direction. The shared
  `.badge` class and map labels demonstrate this treatment.
- Active documentation links use bold red text and a trailing red edge. Preserve
  `aria-current="page"`; color alone must not communicate the active state.
- Map illustrations use white surfaces, fine neutral grid lines, and red or dark
  paths. Numbered markers remain readable on white.

## Typography and layout

The homepage uses Space Grotesk for headings and DM Sans for body text. Documentation
and policy pages use system fonts for reading. Keep body text at least 16px, and
small labels at least 14px. Use comfortable line spacing for paragraphs and lists.

Keep the existing responsive page structure. Let controls and footer links wrap,
collapse guide cards on narrow screens, and keep long documentation readable.

## Accessibility and interaction

Red text must remain legible against white. The accent token has greater than 6:1
contrast on white; primary and muted text also exceed 4.5:1. Keep visible keyboard
focus outlines, meaningful link labels, text explanations for errors, and reduced
motion support. Do not use red alone to distinguish errors from ordinary emphasis.

## Maintenance

Apply these rules to the homepage, guides, privacy policy, and future web pages.
Update shared styles instead of adding conflicting page-specific color values.
Follow `AGENTS.md` for clean folder links. Documentation renderers keep using the
shared stylesheets, so regeneration must preserve this theme.

## Documentation sidebar

Use a dedicated left navigation pane below the documentation subheader on desktop,
with independent scrolling, a thin vertical divider, and compact indented links.
Group topics in expandable sections. Highlight the current guide with red text
and a trailing red edge. Include a labeled filter with result feedback.

Keep the sidebar icon toggle in the documentation subheader even when the pane is hidden. Collapsing
it releases the full column for reading. Expose the toggle state through
`aria-expanded` and `aria-controls`, and support Escape from inside the pane.
Remember the visibility choice for the browsing session. On narrow screens, start
collapsed and slide over the article from the left, with a dismissible backdrop.
Keep background content inert and contain keyboard focus while open. Desktop
uses an animated grid column to push the article; mobile never shifts it.
Use 240ms transitions and disable them for reduced-motion preferences. Without JavaScript, keep the links available
and group disclosures functional through native `details` elements.

The homepage Sign in action opens a white modal dialog with Apple’s SDK sign-in
button. Keep a visible Close control, native Escape and focus handling, and backdrop
dismissal. A successful session closes the dialog and changes the header to Account.
Use `account/` for account information, connection status, and the SDK sign-out button.

The documentation subheader is a compact white bar below the shared site header,
with a borderless sidebar icon, a thin divider, and a prominent Documentation home
link. Let the shared site header scroll away with the page; pin only the documentation
subheader to the viewport top. Keep a visible bottom border and space around the
control divider. Offset the sidebar and mobile backdrop below the subheader,
including the visible portion of the site header while it scrolls out of view.
