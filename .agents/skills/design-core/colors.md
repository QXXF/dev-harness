# Colors

OKLCH is a perceptually uniform color space where lightness, chroma and hue are useful design controls. Use it when the project already uses OKLCH, when creating a new color system, or when asked for conversion or palette work. Otherwise **respect the existing system**: a consistent hex or RGB token system beats introducing a second color notation for an isolated fix. Never convert notation merely because this skill was loaded.

## OKLCH syntax and behavior

```
oklch(L C H)          oklch(L C H / alpha)
oklch(0.637 0.237 25.331)   oklch(0.8 0.05 200 / 0.5)
```

| Channel | Range | Notes |
| --- | --- | --- |
| L | 0–1 | Perceptually uniform: `0.5` is visually mid (HSL lightness is not) |
| C | 0–~0.4 | Absolute colorfulness; max depends on L and H |
| H | 0–360 | Stable across lightness (HSL blue drifts purple as it lightens) |
| alpha | 0–1 | Slash syntax only, never commas |

Three decimals for L and C, up to three for H; drop trailing zeros. Not every oklch value maps to a displayable sRGB color — gamut awareness is required (below).

### Conversion

Only when asked, when the project standardizes on OKLCH, or during an agreed migration. Convert color stops but leave gradient interpolation and CSS structure unchanged. Leave alone: `currentColor`, `inherit`, `transparent`, keywords, and third-party configs that expect hex.

```css
#3b82f6 → oklch(0.623 0.188 259.815)
rgba(0, 0, 0, 0.1) → oklch(0 0 0 / 0.1)
```

## Palette generation

Scale convention: 50 (lightest) → 950 (darkest); 11 steps matches Tailwind, 9 is a leaner default.

Algorithm, given a base L, chroma percentage, and H:

1. Lightness bounds: `minL = max(0.05, baseL - 0.4)`, `maxL = min(0.95, baseL + 0.4)` (avoid pure black/white — zero chroma).
2. Distribute L evenly from maxL (step 50) to minL (step 950).
3. Clamp chroma per step: `stepC = (chroma% / 100) * maxChroma(stepL, hue, space)`. Lower chroma at the extremes is correct and expected.

**Multi-hue palettes**: same L and same chroma *percentage* across hues — same L guarantees equal perceived brightness, same C% equal vividness. The same absolute C across hues makes some appear more vivid (max chroma differs wildly per hue).

**Dark mode**: swap the light/dark semantic roles as a starting point (`--color-bg: var(--color-50)` → `var(--color-950)`), then tune chroma and lightness independently. Never mechanically reverse every step; recheck every foreground/background pair in the dark appearance.

**Hue drift detection**: convert an HSL ramp to oklch and compare H across steps; a spread >10° is visible drift (HSL blue shifts ~16–18° toward purple between 20% and 90% lightness).

## Contrast

Contrast is measured between a foreground and the background it actually renders on (nearest painted ancestor). **Report, don't repaint**: when a check fails, report the pair, its measured value, and the threshold it misses; change colors only when asked.

APCA (perceptually accurate, pairs naturally with oklch) as default; WCAG 2 for formal conformance claims:

| Content | APCA minimum | APCA preferred | WCAG 2 AA |
| --- | --- | --- | --- |
| Body text | Lc 75 | Lc 90 | 4.5:1 |
| Non-body text (labels, headlines) | Lc 60 | Lc 75 | 4.5:1 |
| Large text (≥36px / ≥24px WCAG) | Lc 45 | Lc 60 | 3:1 |
| UI components | Lc 30 | — | 3:1 |

Use |Lc| for comparison (the sign encodes polarity). Quick heuristics:

- Light/dark boundary: background L > 0.73 → dark text; below it, light text still scores higher (the crossover is higher than intuition — in the 0.6–0.73 band the background already looks light).
- Body text on a light background (L > 0.9): foreground L < 0.35. On a dark background (L < 0.25): foreground L > 0.9.
- Mid-lightness backgrounds cap achievable contrast: on L 0.75, even black text only reaches ~Lc 60.

**Fixing (on request)**: adjust L first, preserve C and H when possible, reduce C if needed to stay in gamut, then remeasure the rendered pair.

## Gamut and Tailwind v4

Max chroma varies irregularly by L and H (at L=0.5 in sRGB: purple peaks at C≈0.29, cyan bottoms at C≈0.09). If chroma exceeds the max for its L/H/space it clips — fix by reducing C, keeping L and H:

```css
.accent { color: oklch(0.7 0.2 150); }              /* sRGB-safe */
@media (color-gamut: p3) {
  .accent { color: oklch(0.7 0.3 150); }             /* P3 enhancement */
}
```

Tailwind v4 defines its palette in oklch; custom `@theme` scales follow the same convention (`--color-brand-500: oklch(0.623 0.188 250);` gives `bg-brand-500` etc., opacity modifiers work: `bg-brand-500/50`). No hex in `@theme`.

## Color usage

- **One color, one meaning.** If the brand hue signals interactive, that hue (±15°) on non-interactive text tells users to click something that isn't clickable. Give the second use a neutral.
- **Semantic tokens over raw values.** Name by role, use only in that role: never a separator token as text or a text token as background. If a role has no token, add one; don't borrow by value.
- **One colored action per view.** When filled color encodes primary emphasis, fill only the single primary action; peers stay neutral. Put the color on the background, not the label (a blue label on a neutral button reads as a link). Selected states (active tab) may use the accent on glyph and label — that's state, not emphasis. Preserve an established hierarchy that communicates emphasis another way.
- **Color across cultures.** If a color is load-bearing (finance, status), verify per locale: Chinese financial UIs show gains in red, losses in green. Make gain/loss colors a per-locale token.
- **Appearance variants.** Every custom color needs light and dark variants, plus `prefers-contrast: more` where relevant (widen the foreground/background L gap by ≥0.15 over the default, then re-verify at Lc 90 body / Lc 75 non-body). Recheck every pair in both appearances — the palettes aren't mirror images. Account for translucency: a color on a `backdrop-filter` surface shifts with what scrolls behind it; test over the lightest and darkest possible content or make the surface opaque enough.

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Raw color bypasses the token system | Reuse or add the role token in the project's notation |
| Isolated OKLCH in a hex/RGB codebase | Preserve the established notation |
| HSL palette ramp with hue drift | Rebuild with constant oklch hue |
| Failing contrast | Report pair + measured value + missed threshold; fix only on request |
| High chroma without a gamut check | Clamp to max chroma for the L/H |
| Same absolute C across hues | Same C% of each hue's maximum |
| P3 color without sRGB fallback | `@media (color-gamut: p3)` pattern |
| Dark mode by mechanical reversal | Tune independently; recheck every pair |
| Hex in Tailwind v4 `@theme` | oklch values |
| Alpha with commas | `oklch(L C H / alpha)` |
| Several colored control backgrounds per view | Fill only the primary action |
| Palette verified only in light mode | Recheck both appearances |
