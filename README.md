# iOS Wallet docs

Source of the documentation site for the VCu iOS Wallet, in the sideos
branding: <https://sideos.github.io/vcu-ios-app-doc/>

A [Jekyll](https://jekyllrb.com/) site using the
[Just the Docs](https://just-the-docs.com/) theme, built by GitHub Pages from
the `main` branch (Settings → Pages → Deploy from a branch → `main`, `/ (root)`).
There is no build step to run: push Markdown, the site updates. It is the
sibling of the [browser wallet docs](https://github.com/sideos/vcu-browser-wallet-doc)
and is laid out the same way.

## Layout

| Path | What |
|---|---|
| `index.md` | Landing page |
| `getting-started.md` | Install through TestFlight, first launch, permissions |
| `user-guide/` | Receiving, your credentials, sharing, activity, settings, trust and security |
| `integration.md` | Issuer and verifier guide for the iPhone app |
| `branding.md` | How to build and import a brand |
| `assets/img/` | Screenshots (generated, see below) and the sideos logos |
| `assets/brands/` | The example brand files the branding page links to |
| `assets/fonts/` | Poppins and Source Sans 3 (SIL OFL), self-hosted |
| `_sass/` | The sideos colour scheme and styles |
| `_includes/shot.html` | Embeds a phone screenshot |
| `tools/screenshots/` | Regenerates the screenshots |

## Branding of the site

From the sideos style guide: Pure White and Rich Black (`#08141E`) dominate,
Purple is the accent, Green and Magenta are used sparingly. Headings are
Poppins, text is Source Sans. The fonts are served from `assets/fonts`, so
visitors make no request to a font CDN. Purple on white is `#8236E8` (5.8:1);
the guide's `#A258FF` is 3.9:1 as text on white and is used on dark surfaces
only. Change colours in `_sass/color_schemes/sideos.scss` and
`_sass/custom/custom.scss`.

## Screenshots are generated, not hand-made

`assets/img/*.png` come from the app itself, in the iOS Simulator, with made-up
data (the holder "Ada Lovelace", fictional issuers and verifiers). Nothing in
them is real.

```sh
tools/screenshots/capture.sh                    # build the app, capture everything
SKIP_BUILD=1 tools/screenshots/capture.sh       # reuse the last build
ONLY=home,credentials tools/screenshots/capture.sh
```

Needs Xcode, XcodeGen, ImageMagick (`magick`) and a checkout of the app repo
next to this one (`../vcu-ios-app`, or set `VCU_IOS_APP`). The script:

1. copies the app's source to `~/.cache/vcu-ios-app-doc` (the app repository is
   never modified), adds `tools/screenshots/ScreenshotSeed.swift` and patches a
   few lines so the copy can be driven by launch arguments;
2. builds it for the simulator and installs it fresh;
3. imports `Scripts/brand-sideos.json` from the app repo (set `BRAND` to use
   another), seeds the demo credentials and activity, and opens each screen;
4. feeds consent screens through the app's real code path with by-value
   OpenID4VP links, so what you see is what the wallet really shows;
5. saves 600 px wide PNGs into `assets/img/`.

The simulator has no Secure Enclave and no camera, so there are no screenshots of
the scanner or of the Safari sheet, and the Developer page isn't shown.

After regenerating, update `wallet_build` in `_config.yml` to the build the app
repo was at.

If the script stops with "patch anchor not found", the app source moved: update
the `patch` function in `capture.sh`.

## Preview locally

GitHub builds the site, so this is optional. With Ruby and Bundler:

```sh
cat > Gemfile <<'EOF'
source "https://rubygems.org"
gem "jekyll", "~> 4.3"
gem "just-the-docs", "0.12.0"
gem "webrick"
EOF
printf 'remote_theme: null\ntheme: just-the-docs\nplugins: []\n' > _config.local.yml
bundle install
bundle exec jekyll serve --config _config.yml,_config.local.yml
```

`Gemfile` and `_config.local.yml` are for preview only and are ignored by git.

## What is deliberately not here

The app's source, internal planning documents, change requests to the platform
and the release process stay in the (private) app repository.

## Licence

Proprietary: see [LICENSE](LICENSE). The content is subject to the sideos Terms and Conditions; the bundled fonts keep their SIL Open Font License.
