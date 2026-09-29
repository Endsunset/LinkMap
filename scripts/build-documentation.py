"""Build the single LinkMap DocC library for GitHub Pages."""

from pathlib import Path
import json
import os
import shutil
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[1]
CATALOG = ROOT / "docc" / "LinkMap.docc"
OUTPUT = ROOT / "documentation"
ASSET_DIRECTORIES = ("css", "js", "data", "index", "img", "images", "videos", "downloads")
ASSET_FILES = ("metadata.json", "theme-settings.json")
DOC_IMAGE_FILES = ("favicon.ico", "favicon.svg", "developer-og.jpg", "developer-og-twitter.jpg")


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
        temporary = Path(temporary)
        archive = temporary / "archive"
        subprocess.run(
            ["xcrun", "docc", "convert", str(CATALOG),
             "--fallback-display-name", "LinkMap",
             "--fallback-bundle-identifier", "io.github.endsunset.LinkMap",
             "--output-path", str(archive),
             "--hosting-base-path", "/LinkMap",
             "--experimental-transform-for-static-hosting-with-content",
             "--warnings-as-errors"],
            check=True,
        )
        landing = archive / "documentation" / "linkmap"
        if not (landing / "index.html").is_file():
            raise RuntimeError("DocC did not create the LinkMap landing page")

        staged = temporary / "staged"
        documentation = staged / "documentation"
        documentation.mkdir(parents=True)
        shutil.copytree(landing, documentation / "linkmap")
        for directory in ASSET_DIRECTORIES:
            source = archive / directory
            if source.exists():
                shutil.copytree(source, staged / directory)
        for name in ASSET_FILES:
            source = archive / name
            if source.exists():
                shutil.copyfile(source, staged / name)

        # DocC's key order varies between builds; stable JSON avoids churn.
        for data_file in staged.rglob("*.json"):
            data_file.write_text(json.dumps(
                json.loads(data_file.read_text()), ensure_ascii=False,
                sort_keys=True, separators=(",", ":"),
            ))

        shutil.copyfile(ROOT / "docc" / "doc-theme.css", documentation / "doc-theme.css")
        for name in DOC_IMAGE_FILES:
            shutil.copyfile(archive / name, documentation / name)
        redirect(documentation, documentation / "linkmap")
        # Former platform roots lead into the two branches of this one library.
        redirect(documentation / "ios", documentation / "linkmap" / "ios-handbook")
        redirect(documentation / "web", documentation / "linkmap" / "web-handbook")

        for page in (documentation / "linkmap").rglob("*.html"):
            html = page.read_text()
            html = html.replace('data-color-scheme="auto"', 'data-color-scheme="light"')
            html = html.replace('/LinkMap/favicon.', '/LinkMap/documentation/favicon.')
            html = html.replace(
                "</head>",
                '<link rel="stylesheet" href="/LinkMap/documentation/doc-theme.css"></head>',
            )
            page.write_text(html)

        # Replace only paths owned by this generator, preserving website pages.
        for name in (*ASSET_DIRECTORIES, *ASSET_FILES, "documentation"):
            destination = ROOT / name
            if destination.is_dir():
                shutil.rmtree(destination)
            elif destination.exists():
                destination.unlink()
            source = staged / name
            if source.is_dir():
                shutil.copytree(source, destination)
            elif source.exists():
                shutil.copyfile(source, destination)

    # The current iOS app still opens /docs/.
    redirect(ROOT / "docs", OUTPUT)
    print("Built the LinkMap DocC library at /documentation/")


if __name__ == "__main__":
    main()
