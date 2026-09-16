"""Shared, statically rendered site header (no deployment build required)."""
from pathlib import Path
from string import Template

ROOT = Path(__file__).resolve().parents[1]
START = '<!-- Shared header: edit components/header.html, then run scripts/build-headers.py -->'
END = '<!-- End shared header -->'


def render_header(site_prefix='./', *, home=False, docs=False, account=False):
    toggle = '''<button class="docs-sidebar-button" type="button" aria-label="Hide documentation sidebar" aria-controls="docs-sidebar" aria-expanded="true" hidden>
      <svg width="20" height="20" viewBox="0 0 20 20" fill="none" aria-hidden="true"><rect x="2" y="3" width="16" height="14" rx="2" stroke="currentColor" stroke-width="1.5"/><path d="M7 3v14M4 7h1M4 10h1M4 13h1" stroke="currentColor" stroke-width="1.5"/></svg>
    </button>''' if docs else ''
    sign_in = ('<button class="button button-small button-outline" type="button" data-header-sign-in aria-haspopup="dialog" aria-controls="sign-in">Sign in</button>' if home else
               f'<a class="button button-small button-outline" href="{site_prefix}#sign-in" data-header-sign-in>Sign in</a>')
    markup = Template((ROOT / 'components/header.html').read_text()).substitute(
        header_class=' docs-header' if docs else '', sidebar_toggle=toggle,
        site_prefix=site_prefix, home_prefix='' if home else site_prefix,
        docs_current=' aria-current="page"' if docs and site_prefix == '../' else (' aria-current="true"' if docs else ''),
        account_current=' aria-current="page"' if account else '', sign_in=sign_in)
    return START + '\n' + markup.rstrip() + '\n' + END
