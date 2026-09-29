"""Check the checked-in LinkMap DocC library under the /LinkMap/ base path."""

from html.parser import HTMLParser
import json
from pathlib import Path
from urllib.parse import unquote, urlsplit


ROOT = Path(__file__).resolve().parents[1]
SITE = ROOT / "documentation"
LANDING = SITE / "linkmap"


class References(HTMLParser):
    def __init__(self):
        super().__init__()
        self.urls = []

    def handle_starttag(self, tag, attrs):
        attributes = dict(attrs)
        self.urls.extend(attributes[key] for key in ("href", "src") if key in attributes)


def children(node):
    return {item["title"]: item for item in node.get("children", []) if item.get("path")}


def check_navigation():
    index = json.loads((ROOT / "index" / "index.json").read_text())
    assert index["includedArchiveIdentifiers"] == ["io.github.endsunset.LinkMap"]
    [library] = index["interfaceLanguages"]["swift"]
    assert library["path"] == "/documentation/linkmap"
    sections = children(library)
    assert set(sections) == {"Essentials", "Handbook", "Shared Concepts", "Reference"}
    handbook = children(sections["Handbook"])
    assert set(handbook) == {"iOS Handbook", "Web Handbook"}
    assert "iOS Implementation" in children(handbook["iOS Handbook"])
    assert "Web Implementation" in children(handbook["Web Handbook"])
    assert "Selected Swift Models" in children(sections["Reference"])


def main():
    check_navigation()
    assert not (SITE / "documentation").exists(), "Duplicated documentation/documentation output"
    assert 'href="linkmap/"' in (SITE / "index.html").read_text()
    landing = LANDING / "index.html"
    assert landing.is_file()
    assert 'var baseUrl = "/LinkMap/"' in landing.read_text()
    assert len(list(LANDING.rglob("index.html"))) == len(list((ROOT / "docc" / "LinkMap.docc").glob("*.md")))
    assert (ROOT / "data" / "documentation" / "linkmap.json").is_file()
    assert not (ROOT / "data" / "documentation" / "ios.json").exists()
    assert not (ROOT / "data" / "documentation" / "web.json").exists()

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
    print(f"Checked {len(pages)} pages, one curated navigator, and local references.")


if __name__ == "__main__":
    main()
