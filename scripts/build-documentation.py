"""Build the curated LinkMap DocC catalog for GitHub Pages."""

from pathlib import Path
import os
import shutil
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[1]
CATALOG = ROOT / "docc" / "LinkMap.docc"
OUTPUT = ROOT / "documentation"

LEGACY_ARTICLES = {
    "how-linkmap-works": "how-linkmap-works",
    "basic-workflow": "basic-workflow",
    "project": "project",
    "map": "map",
    "regions-and-layers": "regions-and-layers",
    "locations": "locations",
    "items": "items-and-inventory",
    "activities": "activities",
    "routes-and-stops": "routes-and-stops",
    "assignments-and-supplies": "assignments-and-resources",
    "logging-and-reports": "transactions-and-reports",
    "sharing": "sharing",
}


def redirect(directory: Path, target: Path):
    directory.mkdir(parents=True, exist_ok=True)
    relative = os.path.relpath(target, directory) + "/"
    (directory / "index.html").write_text(f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="refresh" content="0; url={relative}">
  <link rel="canonical" href="{relative}">
  <title>LinkMap Documentation</title>
</head>
<body><p><a href="{relative}">Open LinkMap documentation</a></p></body>
</html>
""")


def main():
    with tempfile.TemporaryDirectory(prefix="linkmap-docc-") as temporary:
        archive = Path(temporary) / "site"
        subprocess.run(
            [
                "xcrun", "docc", "convert", str(CATALOG),
                "--fallback-display-name", "LinkMap",
                "--fallback-bundle-identifier", "io.github.endsunset.LinkMap",
                "--output-path", str(archive),
                "--hosting-base-path", "/LinkMap/documentation",
                "--experimental-transform-for-static-hosting-with-content",
                "--warnings-as-errors",
            ],
            check=True,
        )
        if not (archive / "documentation" / "linkmap" / "index.html").is_file():
            raise RuntimeError("DocC did not create the LinkMap landing page")
        if OUTPUT.exists():
            shutil.rmtree(OUTPUT)
        shutil.copytree(archive, OUTPUT)

    shutil.copyfile(ROOT / "docc" / "doc-theme.css", OUTPUT / "doc-theme.css")
    for page in OUTPUT.rglob("*.html"):
        html = page.read_text()
        html = html.replace('data-color-scheme="auto"', 'data-color-scheme="light"')
        html = html.replace(
            "</head>",
            '<link rel="stylesheet" href="/LinkMap/documentation/doc-theme.css"></head>',
        )
        page.write_text(html)

    # DocC's generated landing article lives at documentation/linkmap/. Make
    # the website's /documentation/ URL enter that same DocC site directly.
    landing = OUTPUT / "documentation" / "linkmap"
    redirect(OUTPUT, landing)
    redirect(OUTPUT / "web", landing / "web")
    redirect(OUTPUT / "ios", landing / "ios")
    for old, new in LEGACY_ARTICLES.items():
        redirect(OUTPUT / "ios" / old, landing / new)
    # The current iOS app still opens /docs/. Keep its link working until the
    # native app points at the canonical /documentation/ URL.
    redirect(ROOT / "docs", OUTPUT)
    print(f"Built DocC documentation in {OUTPUT}")


if __name__ == "__main__":
    main()
