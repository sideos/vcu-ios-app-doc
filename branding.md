---
title: Branding
nav_order: 5
---

# Branding

A brand re-skins the wallet without a new build: **name, colours and logo** come from a JSON file that you paste into the app. It's the same idea as the [browser wallet's brand config](https://sideos.github.io/vcu-browser-wallet-doc/branding.html), applied as far as iOS has an equivalent. Everything on this page works from **build 24**.

<div class="shot-row">
{% include shot.html src="home-default.png" alt="The Home screen with the default etonec wordmark and dark buttons" caption="Default branding." %}
{% include shot.html src="home.png" alt="The Home screen after importing the sideos brand: sideos logo and purple buttons" caption="After importing the sideos brand." %}
</div>

## Quick start

1. Write a brand file, or start from one of the examples: [`brand-sideos.json`]({{ '/assets/brands/brand-sideos.json' | relative_url }}) (purple, PNG logo) or [`brand-bastion.json`]({{ '/assets/brands/brand-bastion.json' | relative_url }}) (camouflage palette, SVG logo).
2. Copy its contents to the iPhone's clipboard. Universal Clipboard from a Mac works: `pbcopy < my-brand.json`.
3. In the app: **Settings → Branding → Import brand from clipboard**.
4. Read the report. It lists what was **Applied**, what was **Ignored** (and why), and any **Note**.
5. **Reset branding** (same screen) returns to the default.

<div class="shot-row">
{% include shot.html src="branding-default.png" alt="The Branding screen with the default etonec wordmark" caption="Settings → Branding, before." %}
{% include shot.html src="branding.png" alt="The Branding screen after importing the sideos brand" caption="After the import." %}
</div>

The brand is stored on the device, so the app, the lock screen and the Safari consent sheet all use it. It is per device: nothing is sent anywhere.

A brand carries a colour set for light **and** dark mode:

<div class="shot-row">
{% include shot.html src="home-dark.png" alt="The Home screen in dark mode with the sideos brand" caption="Home." %}
{% include shot.html src="credentials-dark.png" alt="My Credentials in dark mode" caption="My Credentials." %}
{% include shot.html src="share-consent-dark.png" alt="The consent screen in dark mode" caption="Consent." %}
</div>

## File format

```json
{
  "name": "Bastion",
  "font": "squares-bold",
  "logo": { "light": "<svg …>", "dark": "<svg …>" },
  "colors": {
    "light": { "--accent": "#4A5D23", "--success-fg": "#1E6B3A", "--danger-fg": "#A32B1E", "--surface": "#EEEBDD", "--ink": "#0F1B2D" },
    "dark":  { "--accent": "#A6BE6B", "--success-fg": "#7BD389", "--danger-fg": "#FF8070", "--surface": "#0B1622", "--ink": "#E7E9D8" }
  }
}
```

| Key | Used by iOS | Notes |
|---|---|---|
| `name` | yes | 1 to 60 characters. Shown in Settings and read by VoiceOver as the logo's label. It isn't the Home Screen name or the app icon: those are fixed by the build. |
| `logo` | yes | See [Logo](#logo). Missing or unusable: the etonec wordmark stays. |
| `colors.light` / `colors.dark` | yes | See [Colours](#colours). A token given for only one appearance is used for both. |
| `font` | **no** | Reported as ignored. The UI is Raleway. |
| `locale` | **no** | Reported as ignored. The language follows iOS Settings for the app. |
| other keys, unknown `--tokens` | no | Listed as ignored. A browser wallet export imports fine; its extra tokens (hover, gradients, orbs) are ignored. |

Colour values: `#RGB`, `#RRGGBB`, `#RRGGBBAA`, `rgb(r, g, b)`, `rgba(r, g, b, a)`. Gradients and other CSS are reported as unsupported.

## Colours

| Token | What it colours |
|---|---|
| `--accent` | Filled buttons, the scan card on Home, links, selected filter pills, accent icon tints. The text on those (white or near-black) is chosen automatically for at least 4.5:1, per appearance. |
| `--success-fg` | Verified and valid text and icons, and their banner background (the colour at 13 %). |
| `--danger-fg` | Errors, expired, blocked, destructive buttons, and their banner background (13 %). |
| `--surface` + `--ink` | Page and card background, and text. **Set both or neither**: with only one, nothing is applied (the report still lists the token). |

When `--surface` and `--ink` are both present, the rest of the chrome is derived from them, so the brand reads as itself and not as etonec with a different button colour: borders at 12 % ink, secondary text at 62 %, captions at 45 %, field borders at 28 %, icon tiles at 7 % (all ink over surface), and accent icon tiles at 14 % accent over surface.

Not brandable: the amber used for warnings and "expires soon" (it carries meaning), system alerts, and the app icon.

### Contrast is your responsibility

The app doesn't correct a brand's colours, apart from the button label above. Check these pairs in **both** appearances:

| Pair | Aim for |
|---|---|
| `--ink` on `--surface` | 7:1 |
| `--accent` on `--surface` (it is used as link text) | 4.5:1 |
| `--success-fg`, `--danger-fg` on `--surface` and on their own 13 % tint | 4.5:1 |

Style-guide colours often fail as **text** in light mode (a bright purple or mint on white). Derive a darker shade of the same hue for light mode and keep the guide's colour for dark mode. The sideos example does this: the guide's purple `#A258FF` is 3.9:1 on white, so light mode uses `#9048F2` (4.8:1) and dark mode keeps `#A258FF`.

## Logo

`logo` can be:

| Form | Example |
|---|---|
| a PNG or an SVG for both appearances | `"logo": "data:image/png;base64,…"` or `"logo": "<svg …>…</svg>"` |
| separate light and dark | `"logo": { "light": "…", "dark": "…" }` (each is a PNG data URI or an SVG; they can differ) |
| a name bundled in the app | `"logo": "sideos"` (builds 23 and later; new brands should carry their artwork) |

Use separate light and dark artwork unless the logo works on both backgrounds. If you give only one of `light` and `dark`, it is used for both.

The logo is drawn in a box of at most about **180 × 48 pt** (on Home about 148 × 39 pt), scaled to fit with its proportions kept.

### PNG: shown unchanged

Use PNG for anything with gradients, effects or photographic detail. The app embeds the bytes as they are and only ever scales down.

- Transparent background, sRGB, **cropped tight** (no padding).
- Size: on a 3x screen the box is 540 × 144 px, so a logo 3.75:1 or wider should be **at least 540 px wide**; a squarer one needs **at least 144 px tall**. Twice that (for example 1080 × 288) is the comfortable choice. Smaller still imports, with a Note saying it may look soft.
- Limits: at most **256 KB** and **2048 px** per side, a single frame (no animated PNG), a complete file.
- Encode with `base64 -i logo-light.png | tr -d '\n'`, prefixed with `data:image/png;base64,`.

### SVG: sharp at any size

Use SVG for simple wordmarks. The app has its own small renderer, because iOS has no public API that draws SVG from data at run time, so only a **plain subset** is drawn.

| Drawn | Refused (the logo isn't imported; the etonec wordmark stays) |
|---|---|
| `path` (all commands, including arcs), `rect` (also rounded), `circle`, `ellipse`, `line`, `polyline`, `polygon` | gradients and patterns, `text`, `image`, `use` and `symbol`, `filter`, `mask`, `clipPath`, `marker`, `style` sheets, `script`, `a`, `switch`, dashed strokes, named colours other than black and white |
| `g` groups, `transform` (translate, scale, rotate, skew, matrix) | `DOCTYPE` and entity declarations |
| `fill`, `stroke`, `stroke-width`, caps, joins, `fill-rule`, opacity, `currentColor` (the app's text colour), `style="…"` attributes | more than 64 KB, 24 levels of nesting, 5,000 shapes or 50,000 path segments |
| a `viewBox` (or `width` and `height`) | |

Tips:

- **Convert text to outlines** before you export. `brand-bastion.json` is the wordmark set in Squares Bold, outlined.
- Use hex colours, not names. In Illustrator, export with *Styling: Presentation Attributes* rather than *Internal CSS*.
- Hidden elements (`display="none"`), `<title>`, `<desc>`, `<defs>` and editor metadata are skipped.
- If the report says "SVG uses gradients…", use a PNG instead.

### Putting artwork into the JSON

SVG contains quotes, so let a tool escape it:

```sh
jq -n --rawfile l logo-light.svg --rawfile d logo-dark.svg \
  '{name:"Acme", logo:{light:$l, dark:$d}, colors:{light:{"--accent":"#123456"}, dark:{"--accent":"#89abcd"}}}' > acme.json
```

For PNGs use `--arg l "data:image/png;base64,$(base64 -i light.png | tr -d '\n')"` instead.

## What the report says

| Report line | Meaning and fix |
|---|---|
| `Applied: name, logo, --accent, …` | Will be used. (`--surface` and `--ink` are listed even if only one was given; see above.) |
| `font … (not bundled on iOS; system font used)` | Expected: fonts aren't applied. |
| `logo (light SVG uses gradients or patterns, which iOS can't draw; the default wordmark is used)` | Outside the SVG subset: fix the SVG or use a PNG. Other reasons read the same way: size, malformed, text, filters. |
| `logo (dark PNG is 2049×10 px; at most 2048 px per side; …)` | Over a limit (256 KB, 2048 px), truncated, animated, or not really a PNG. |
| `logo X (not bundled on iOS; …)` | A name the app doesn't contain. Embed the artwork instead. |
| `--token (unsupported value, e.g. a gradient)` | The colour couldn't be parsed. |
| `Note: light logo is 300×80 px; at least 540 px wide stays sharp on 3x screens` | Imported, but it will be scaled up. Provide a larger PNG. |
| "That isn't a valid brand config" | Not JSON, or `name` is empty or over 60 characters. |

If part of a brand is refused, the rest still applies: a refused logo doesn't stop the colours.

## Build support

| Build | Brand support |
|---|---|
| 22 and earlier | `name`, `--accent`, `--success-fg`, `--danger-fg`; the logo is fixed to etonec |
| 23 | adds `--surface` and `--ink`, and `"logo": "sideos"` (a bundled image) |
| 24 | adds SVG and PNG logos inside the config |

An older build ignores what it doesn't know and lists it in the report, so one file works across builds; the logo shows from build 24.

## Known limits

- Fonts and `locale` aren't applied. The Squares Bold in the Bastion example exists only in its logo.
- No gradients or textures in the interface: colours are flat.
- The app icon, Home Screen name and launch screen are fixed per build.
- One brand at a time per device. Storage is shared with the Safari extension, so artwork is capped (two PNGs at the limit are about 700 KB).
