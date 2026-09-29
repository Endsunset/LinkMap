"""Check the two checked-in DocC guides under the GitHub Pages /LinkMap/ path."""

from html.parser import HTMLParser
import json
from pathlib import Path
from urllib.parse import unquote, urlsplit


ROOT = Path(__file__).resolve().parents[1]
SITE = ROOT / "documentation"


class References(HTMLParser):
    def __init__(self):
        super().__init__()
        self.urls = []

    def handle_starttag(self, tag, attrs):
        attributes = dict(attrs)
        self.urls.extend(attributes[key] for key in ("href", "src") if key in attributes)


def check_navigation():
    index = json.loads((ROOT / "index" / "index.json").read_text())
    roots = index["interfaceLanguages"]["swift"]
    assert {root["path"] for root in roots} == {"/documentation/ios", "/documentation/web"}
    assert len(index["includedArchiveIdentifiers"]) == 2
    assert any(child.get("children") for child in roots[0]["children"]), "iOS topics must have a hierarchy"
    assert any(child.get("children") for child in roots[1]["children"]), "Web topics must have a hierarchy"


def main():
    check_navigation()
    assert not (SITE / "documentation").exists(), "Remove duplicated documentation/documentation output"
    entry = (SITE / "index.html").read_text()
    assert 'href="ios/"' in entry and 'href="web/"' in entry

    for slug, catalog in (("ios", "iOS.docc"), ("web", "Web.docc")):
        landing = SITE / slug / "index.html"
        assert landing.is_file(), f"Missing /documentation/{slug}/"
        assert 'var baseUrl = "/LinkMap/"' in landing.read_text()
        assert len(list((SITE / slug).rglob("index.html"))) == len(list((ROOT / "docc" / catalog).glob("*.md")))
        assert (ROOT / "data" / "documentation" / f"{slug}.json").is_file()

    missing = []
    pages = [*SITE.rglob("*.html"), ROOT / "docs" / "index.html"]
    for page in pages:
        parser = References()
        parser.feed(page.read_text())
        for url in parser.urls:
            parsed = urlsplit(url)
            if parsed.scheme or parsed.netloc:
                continue
            path = unquote(parsed.path)
            if not path:
                continue
            if path.startswith("/LinkMap/"):
                target = ROOT / path.removeprefix("/LinkMap/")
            elif path.startswith("/"):
                continue
            else:
                target = page.parent / path
            if not target.exists() and not (target / "index.html").is_file():
                missing.append(f"{page.relative_to(ROOT)}: {url}")
    assert not missing, "Missing local references:\n" + "\n".join(missing)
    print(f"Checked {len(pages)} documentation pages, two navigators, and local references.")


if __name__ == "__main__":
    main()
