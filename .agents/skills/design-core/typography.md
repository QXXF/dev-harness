# Typography

Good typography is mostly restraint. A sensible scale, comfortable spacing and enough contrast beat any clever effect; a label, a table cell, a headline and an article paragraph should not share one set of rules. When reviewing, read the page instead of scanning the code: squint to check the hierarchy holds, read one full paragraph for comfort, and resize the viewport to catch bad wrapping, widows and truncation at real content lengths.

Applying or reviewing typography never requires a new typeface. Use the product's existing type system unless the task explicitly asks for a type change.

## Fonts and formats

- Serve `.woff2` on the web (Brotli compression, broadly supported). `.ttf`/`.otf` are raw desktop formats. How files are loaded is the project's concern.
- Rarely more than three fonts. Pair for contrast, not similarity: serif headline + sans body reads as deliberate; two near-identical sans-serifs read as a mistake. "Display" variants are for large sizes, "Text" variants for small — use the one matching the size you set.
- Thin weights are display-only: below `18px` stay at weight `400`+; `100`–`300` strokes disappear at text sizes. Reserve them for `28px`+ and check them against the background.
- Two fonts at the same `font-size` can look different sizes — x-height decides the apparent size.

### Properties over raw tags

When a CSS property exists, use it — properties keep working when a non-variable fallback renders; `font-variation-settings`/`font-feature-settings` silently do nothing on fallbacks:

| Use | Not |
| --- | --- |
| `font-weight: 650` | `font-variation-settings: "wght" 650` |
| `font-optical-sizing: auto` | `"opsz"` |
| `font-variant-numeric: tabular-nums` (`tabular-nums`) | `font-feature-settings: "tnum" 1` |
| `font-variant-numeric: slashed-zero` | `"zero" 1` |
| `font-variant-caps` / `font-variant-position` | raw small-cap/super/sub tags |

Reserve raw tags for custom axes (`"GRAD" 80`) and numbered slots (`"ss01" 1`, `cv01`–`cv99`) that have no property; what each slot does differs per font.

### Synthesis

Browsers may synthesize a weight or style the family doesn't provide. Prefer loading the faces the design actually uses. Set `font-synthesis: none` only after verifying every required bold, italic, small-cap, super- and subscript form stays distinct across the full fallback stack — it must not erase emphasis. If only one mode is unwanted, use the longhand (`font-synthesis-weight`, `font-synthesis-style`).

## Scale and spacing

Define a small set of sizes and deviate as little as possible. On a team, name sizes by use (`text-body-sm`), not by size. A role-based scale pairs each size with line-height and weight, so a role is one decision instead of three:

| Role | Size | Line-height | Weight |
| --- | --- | --- | --- |
| Display | `2.25rem` (36px) | `1.1` | `600` |
| Title | `1.5rem` (24px) | `1.2` | `600` |
| Heading | `1.125rem` (18px) | `1.3` | `600` |
| Body | `1rem` (16px) | `1.5` | `400` |
| Caption | `0.8125rem` (13px) | `1.4` | `400` |

Emphasis within a role is one weight step up (`400` → `500`), not a size change.

- **Headings descend with level**: map levels to descending scale steps (`h1` → `text-2xl`, `h2` → `text-xl`, `h3` → `text-lg`, centralized, not inline). A child heading must not overpower its parent; deep levels may share a size when weight or spacing keeps them distinct. Pick the element for structure (see accessibility), style the size in CSS.
- **Line-height by role**: headings ~`1.1`, body `1.5`–`1.6`, always unitless (fixed `24px` doesn't scale). Anything that wraps to 3+ lines needs at least `1.4`, even in tight rows and cards.
- **Letter-spacing by size**: large headings slightly negative (`-0.02em`); small uppercase labels slightly positive (`0.05em`); body copy neither. Kerning is built into the font — leave `font-kerning` alone.
- **Text trimming**: fonts reserve space above/below letters, so text sits low in buttons and badges. `text-box: trim-both cap alphabetic` trims it (Chromium 133+/Safari 18.2+; progressive enhancement).

### Size floors

| Text | Size |
| --- | --- |
| Long-form body | ~`16px`, judged in the actual typeface and measure |
| Inputs and menus | ~`14px` (but `16px` on mobile — see below) |
| Captions | `13px` |
| Floor | Rarely below `12px` |

When text appears low-contrast, measure the rendered pair (see colors) and classify the requirement (see accessibility); don't change colors unless asked.

## Wrapping and measure

- **Cap the measure** for long-form text at 60–75 characters per line. Any unit works: `65ch`, or at `16px` body roughly `560–680px` (Tailwind `max-w-xl`/`max-w-2xl`).
- **Wrap deliberately**: `text-wrap: balance` on headings, `text-wrap: pretty` on descriptions; skip both in long-form text (browsers ignore `balance` past a few lines). `overflow-wrap: break-word` where long words, links or IDs could escape. `white-space: nowrap` on labels and badges where a break looks broken.
- **Tabular numbers on changing values**: timers, counters and prices shift layout as they update — `tabular-nums`.
- **Truncation**: single line = `text-overflow: ellipsis` + `overflow: hidden` + `white-space: nowrap` (`truncate`); multi-line = `line-clamp`. Truncation hides content: if the missing text matters, keep the full value reachable (tooltip or expanded view).
- **Justified text** doesn't belong in interfaces: `text-align: start`; reserve justify for specific editorial layouts.

## Copy and punctuation

Store text in natural case and control presentation with `text-transform`, so redesigns never require rewriting copy. Smart punctuation: curly quotes in prose (straight in code), en dash for ranges (`2010–2020`), em dash for asides, the single ellipsis character `…`, `&nbsp;` to keep values like `16 px` together, `&shy;` to control where long words may break.

### Language and bidi

Set `lang` so browsers and assistive tech pick the right pronunciation, quotes and hyphenation. Set `dir` at the boundary where direction changes (spatial mirroring and logical properties are layout concerns). Paragraphs of 3+ lines align to their own script's direction even inside an opposite-direction UI. Never reverse digit order; wrap mixed number/text values in `<bdi>` when adjacent RTL text disturbs them.

## Details

- **Underlines from the font**: `text-underline-position: from-font` and `text-decoration-thickness: from-font`, or tune with `text-decoration-thickness`, `text-underline-offset`, `text-decoration-skip-ink: auto`. Dotted underline hints at extra info (abbreviations, defined terms). Unless only the color animates, build animated underlines as a separate element — color is the only part of `text-decoration` that animates reliably.
- **Selection**: keep text selectable by default, including app chrome — users copy labels, IDs and errors. `user-select: none` only on a specific draggable/gesture surface with a verified conflict. `::selection` can carry brand if the combination stays legible.
- **Inputs at 16px on mobile**: iOS Safari zooms the page when input text is under `16px` — use `text-base sm:text-sm`. Never `maximum-scale=1` (Safari ignores it, every other browser blocks zoom and fails WCAG).
- **Font smoothing on the root**: macOS renders text heavier than intended; apply `-webkit-font-smoothing: antialiased` + `-moz-osx-font-smoothing: grayscale` (Tailwind `antialiased`) once at the root.
- Decorative text: `::first-letter` for drop caps, `background-clip: text` for gradient text, `text-shadow` follows glyph shapes, `-webkit-text-stroke` outlines letters (inside-lines on variable fonts are the font's unmerged contours, not a bug).

## Common mistakes

| Mistake | Fix |
| --- | --- |
| `.ttf`/`.otf` served on the web | Convert to `.woff2` |
| `font-variation-settings: "wght"` for weight | `font-weight` |
| Hard-coded one-off font sizes | Use the type scale |
| Child heading overpowers its parent | Descending scale steps per level |
| `line-height: 24px` on scalable text | Unitless (`1.5`) |
| `leading-none` on a 3-line card description | At least `1.4` on any 3+ line text |
| Full-width paragraphs | Cap at 60–75 characters per line |
| Orphan on a paragraph's last line | `text-wrap: pretty` |
| Lopsided two-line heading | `text-wrap: balance` |
| Numbers cause layout shift | `tabular-nums` |
| Truncated text with no way to read it | Tooltip or expanded view |
| `UPPERCASE` typed into copy | Natural case + `text-transform` |
| Underline cuts through descenders | `text-decoration-skip-ink: auto`, `from-font` metrics |
| Inputs below `16px` zoom on iOS | `text-base sm:text-sm` |
| Root layout omits font smoothing | `antialiased` once at the root |
| Thin/Light weight on `14px` UI text | Weight `400`+ below `18px` |
| Selection disabled across app chrome | Restore it; suppress only on verified drag/gesture conflicts |
