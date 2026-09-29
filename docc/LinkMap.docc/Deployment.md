# Deployment

LinkMap is a static GitHub Pages site served below `/LinkMap/`. Website page links use relative clean directory URLs. The web map, account, and login pages are checked-in HTML, CSS, and JavaScript.

Documentation is generated from the single `docc/LinkMap.docc` catalog with `python3 scripts/build-documentation.py`. The build uses DocC's `/LinkMap` hosting base path, checks warnings as errors, and commits its static output. DocC's article URLs live under `/LinkMap/documentation/linkmap/`; `/LinkMap/documentation/` is the stable entry URL. The `.nojekyll` file lets GitHub Pages serve DocC's files directly.

Run `python3 tests/documentation.py` and `git diff --check` after rebuilding. For website behavior, run the relevant JavaScriptCore tests described in `app/README.md`. Check the published site in a browser after deployment, especially search, sign-in, and assets under the GitHub Pages base path.
