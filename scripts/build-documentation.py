"""Build separate iOS and Web DocC guides at their public GitHub Pages URLs."""

from pathlib import Path
import json
import os
import shutil
import subprocess
import tempfile

from site_footer import render_footer
from site_header import render_auth_scripts, render_header


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "documentation"
ASSET_DIRECTORIES = ("css", "js", "data", "index", "img", "images", "videos", "downloads")
ASSET_FILES = ("metadata.json", "theme-settings.json")
DOC_IMAGE_FILES = ("favicon.ico", "favicon.svg", "developer-og.jpg", "developer-og-twitter.jpg")
CATALOGS = {
    "ios": (ROOT / "docc" / "iOS.docc", "iOS", "io.github.endsunset.LinkMap.iOS"),
    "web": (ROOT / "docc" / "Web.docc", "Web", "io.github.endsunset.LinkMap.Web"),
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


def render_entry():
    return f'''<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="Choose the LinkMap guide for iOS or web.">
  <title>Documentation | LinkMap</title>
  <link rel="stylesheet" href="../styles.css">
  <link rel="stylesheet" href="entry.css">
{render_auth_scripts()}
  <script src="../header.js" defer></script>
</head>
<body>
  <a class="skip-link" href="#main">Skip to content</a>
{render_header('../', docs=True)}
  <main id="main" class="documentation-entry" tabindex="-1">
    <p class="eyebrow">LinkMap documentation</p>
    <h1>Choose a guide</h1>
    <p>Learn how to use LinkMap on your device or in a browser.</p>
    <div class="documentation-choices">
      <a href="ios/"><h2>iOS</h2><p>Set up Projects, organize places, plan Activities, and share work.</p></a>
      <a href="web/"><h2>Web</h2><p>Sign in, explore Projects, search places, and use coordinates.</p></a>
    </div>
  </main>
{render_footer('../')}
</body>
</html>
'''


def main():
    with tempfile.TemporaryDirectory(prefix="linkmap-docc-") as temporary:
        temporary = Path(temporary)
        archives = {}
        for slug, (catalog, title, bundle_id) in CATALOGS.items():
            archive = temporary / slug
            subprocess.run(
                ["xcrun", "docc", "convert", str(catalog),
                 "--fallback-display-name", title,
                 "--fallback-bundle-identifier", bundle_id,
                 "--output-path", str(archive),
                 "--hosting-base-path", "/LinkMap",
                 "--experimental-transform-for-static-hosting-with-content",
                 "--warnings-as-errors"],
                check=True,
            )
            if not (archive / "documentation" / slug / "index.html").is_file():
                raise RuntimeError(f"DocC did not create the {title} landing page")
            archives[slug] = archive

        staged = temporary / "staged"
        staged.mkdir()
        documentation = staged / "documentation"
        documentation.mkdir()
        for slug, archive in archives.items():
            shutil.copytree(archive / "documentation" / slug, documentation / slug)
            for directory in ASSET_DIRECTORIES:
                source = archive / directory
                if source.exists():
                    shutil.copytree(source, staged / directory, dirs_exist_ok=True)
            for name in ASSET_FILES:
                source = archive / name
                if source.exists() and not (staged / name).exists():
                    shutil.copyfile(source, staged / name)

        # Each DocC catalog has its own navigator. The shared DocC runtime
        # reads one index at the /LinkMap/ base path, so include both trees.
        indexes = [json.loads((archives[slug] / "index" / "index.json").read_text()) for slug in CATALOGS]
        navigator = indexes[0]
        for other in indexes[1:]:
            navigator["includedArchiveIdentifiers"].extend(other["includedArchiveIdentifiers"])
            for language, topics in other["interfaceLanguages"].items():
                navigator["interfaceLanguages"].setdefault(language, []).extend(topics)
        (staged / "index" / "index.json").write_text(json.dumps(navigator, separators=(",", ":")))

        # DocC's dictionary key order changes across builds. Normalize JSON so
        # a content-neutral rebuild does not churn the checked-in site.
        for data_file in staged.rglob("*.json"):
            data_file.write_text(json.dumps(
                json.loads(data_file.read_text()), ensure_ascii=False,
                sort_keys=True, separators=(",", ":"),
            ))

        shutil.copyfile(ROOT / "docc" / "doc-theme.css", documentation / "doc-theme.css")
        shutil.copyfile(ROOT / "docc" / "entry.css", documentation / "entry.css")
        for name in DOC_IMAGE_FILES:
            shutil.copyfile(archives["ios"] / name, documentation / name)
        (documentation / "index.html").write_text(render_entry())
        for page in documentation.rglob("*.html"):
            html = page.read_text()
            if 'var baseUrl = "/LinkMap/"' in html:
                html = html.replace('data-color-scheme="auto"', 'data-color-scheme="light"')
                html = html.replace('/LinkMap/favicon.', '/LinkMap/documentation/favicon.')
                html = html.replace(
                    "</head>",
                    '<link rel="stylesheet" href="/LinkMap/documentation/doc-theme.css"></head>',
                )
                page.write_text(html)

        # Replace only the paths owned by this generator. The main website's
        # HTML, CSS, and JavaScript remain untouched.
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

        for name in DOC_IMAGE_FILES:
            legacy = ROOT / name
            if legacy.exists():
                legacy.unlink()

    # The current iOS app still opens /docs/. Lead it to the platform chooser.
    redirect(ROOT / "docs", OUTPUT)
    print("Built iOS and Web DocC guides at /documentation/ios/ and /documentation/web/")


if __name__ == "__main__":
    main()
