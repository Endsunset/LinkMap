"""Shared, statically rendered site header (no deployment build required)."""
from pathlib import Path
from string import Template

ROOT = Path(__file__).resolve().parents[1]
START = '<!-- Shared header: edit components/header.html, then run scripts/build-headers.py -->'
END = '<!-- End shared header -->'


def render_header(site_prefix='./', *, home=False, docs=False, account=False):
    sign_in = ('<button class="button button-small button-outline" type="button" data-header-sign-in aria-haspopup="dialog" aria-controls="sign-in">Sign in</button>' if home else
               f'<a draggable="false" class="button button-small button-outline" href="{site_prefix}#sign-in" data-header-sign-in>Sign in</a>')
    markup = Template((ROOT / 'components/header.html').read_text()).substitute(
        site_prefix=site_prefix,
        docs_current=' aria-current="page"' if docs and site_prefix == '../' else (' aria-current="true"' if docs else ''),
        account_current=' aria-current="page"' if account else '', sign_in=sign_in)
    return START + '\n' + markup.rstrip() + '\n' + END


def render_auth_scripts():
    return '''  <script src="https://cdn.apple-cloudkit.com/ck/2/cloudkit.js" async></script>
  <script src="/LinkMap/cloudkit-config.js" defer></script>
  <script src="/LinkMap/cloudkit-auth.js" defer></script>'''
