"""Check the checked-in DocC site as it will be hosted below /LinkMap/."""

from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit


ROOT = Path(__file__).resolve().parents[1]
SITE = ROOT / "documentation"
LANDING = SITE / "documentation" / "linkmap"


class References(HTMLParser):
    def __init__(self):
        super().__init__()
        self.urls = []

    def handle_starttag(self, tag, attrs):
        attributes = dict(attrs)
        self.urls.extend(attributes[key] for key in ("href", "src") if key in attributes)


def main():
    pages = [*SITE.rglob("*.html"), ROOT / "docs" / "index.html"]
    assert (SITE / "index.html").is_file()
    assert (LANDING / "index.html").is_file()
    assert '/LinkMap/documentation/' in (LANDING / "index.html").read_text()
    assert len(list(LANDING.rglob("index.html"))) == len(list((ROOT / "docc" / "LinkMap.docc").glob("*.md")))

    missing = []
    for page in pages:
        parser = References()
        parser.feed(page.read_text())
        for url in parser.urls:
            path = unquote(urlsplit(url).path)
            if not path or path.startswith(("http:", "https:", "mailto:", "data:")):
                continue
            if path.startswith("/LinkMap/documentation/"):
                target = SITE / path.removeprefix("/LinkMap/documentation/")
            elif path.startswith("/"):
                continue
            else:
                target = page.parent / path
            if not target.exists() and not (target / "index.html").is_file():
                missing.append(f"{page.relative_to(ROOT)}: {url}")
    assert not missing, "Missing local DocC references:\n" + "\n".join(missing)
    print(f"Checked {len(pages)} documentation pages and local references.")


if __name__ == "__main__":
    main()
