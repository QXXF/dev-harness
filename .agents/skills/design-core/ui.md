# UI polish

Great interfaces are a collection of small details that compound. Apply after the underlying interaction is sound (semantics, keyboard, layout first). When reviewing, slow the interface down: replay motion at 10% speed in the browser's Animations panel and walk every state — hover, focus, active, loading, empty. What feels off at 10% speed is what's subtly wrong at full speed. Preserve the project's component library, tokens, density, and motion language except where a principle below prescribes an exact interaction pattern.

## Surfaces

### Concentric border radius

Nested rounded elements: `outerRadius = innerRadius + padding`. Mismatched radii on closely nested surfaces is the most common thing that makes interfaces feel off.

```tsx
<div className="rounded-2xl p-2">   {/* 16px radius, 8px padding */}
  <div className="rounded-lg">      {/* 8px = 16 - 8 ✓ */}
```

If padding exceeds `24px`, treat the layers as separate surfaces and pick radii independently.

### Optical over geometric alignment

- Buttons with a trailing icon: icon-side padding = text-side padding − 2px (`ps-4 pe-3.5`).
- Play triangles: geometric center ≠ visual center — shift ~`2px` toward the point.
- Asymmetric icons (stars, arrows, carets): best fixed in the SVG itself (viewBox/path), fallback `translate-x-px`.

### Shadows for elevation, borders for structure

Buttons, cards, and containers whose border exists only for depth: replace with layered transparent `box-shadow` (adapts to any background; solid border colors don't). Keep borders that communicate structure or state: dividers, table cells, form input outlines, hairline separators.

```css
:root {
  --shadow-border:
    0px 0px 0px 1px oklch(0 0 0 / 0.06),   /* 1px border ring */
    0px 1px 2px -1px oklch(0 0 0 / 0.06),  /* subtle lift */
    0px 2px 4px 0px oklch(0 0 0 / 0.04);   /* ambient depth */
  --shadow-border-hover:
    0px 0px 0px 1px oklch(0 0 0 / 0.08),
    0px 1px 2px -1px oklch(0 0 0 / 0.08),
    0px 2px 4px 0px oklch(0 0 0 / 0.06);
}
/* Dark mode: single white ring; layered depth isn't visible on dark */
--shadow-border: 0 0 0 1px oklch(1 0 0 / 0.08);
```

Transition on hover with `transition-property: box-shadow; 150ms ease-out`.

### Image outlines

Subtle `1px` low-opacity outline on images for consistent depth. Color rules are non-negotiable: pure black `oklch(0 0 0 / 0.1)` in light mode, pure white `oklch(1 0 0 / 0.1)` in dark — never a tinted neutral (slate/zinc/near-black), which picks up the surface color and reads as dirt on the edge.

```tsx
<img className="outline outline-1 -outline-offset-1 outline-black/10 dark:outline-white/10" />
```

`outline` (not border) never affects layout; `-1px` offset hugs the corner radius.

## Animations

### Interruptible by default

CSS transitions retarget mid-animation; keyframes restart from the beginning. Always use transitions for interactive state changes (hover, toggle, open/close); reserve keyframes for one-shot staged sequences (entrances, loading). A drawer animated with keyframes snaps when closed mid-open — that's what "feels broken" means.

### Split and stagger enter animations

For *infrequent* staged entrances where sequence communicates hierarchy (first load of a hero, success state, empty state): split into semantic chunks (title, description, buttons), stagger ~100ms apart (words of a title ~80ms), animate with `opacity` + `translateY(12px)` + `blur(4px)` → identity, `ease-out`. Never stagger routine, high-frequency interactions.

### Subtle exits

Exits are softer than enters: small fixed `translateY` (`-12px`), never full container height; duration shorter than the enter (150ms vs 300ms); `ease-out` for both. Remove immediately (`display: none`) when motion adds no context, the interaction repeats frequently, or reduced motion is requested.

### Contextual icon animations

Icons that appear/disappear on hover or state change (play→pause, like→liked, contextual toolbars) animate with **exactly** these values — do not deviate:

- `scale`: `0.25` → `1` (never `0.5`/`0.6`), `opacity`: `0` → `1`, `filter`: `blur(4px)` → `blur(0px)`
- Motion library: `transition: { type: "spring", duration: 0.3, bounce: 0 }` — bounce always `0`.

Check `package.json`: import from `"motion/react"` if `motion` is installed, `"framer-motion"` if that is; if both, follow nearby imports; never mix. If neither, don't add a dependency: keep both icons in the DOM (one absolute-positioned) and cross-fade with CSS `transition-[opacity,filter,scale] duration-300 ease-[cubic-bezier(0.2,0,0,1)]` — both enter and exit animate because nothing unmounts.

Don't animate static navigation icons, decorative icons, or always-visible icons.

### Scale on press

`scale(0.96)` on `:active` — always `0.96`, never below `0.95` (feels exaggerated). CSS transition for interruptibility. Provide a `static` prop to disable it where motion would distract.

### Skip animation on page load

`initial={false}` on `AnimatePresence` so default-state elements (icon swaps, toggles, tabs) don't animate in on first render — only on state changes. Don't apply it where the `initial` prop sets up an intentional first-time entrance (staggered hero); verify with a full page refresh.

### Motion restraint

Motion is a budget, not a garnish:

- **No custom animation on high-frequency interactions** (keystrokes, row hovers, tab switches in a work tool): the attention cost repeats on every trigger. Those get instant feedback or ≤150ms opacity/color transitions. Expressive motion is for infrequent moments.
- **Motion is never the only feedback channel**: every animated state change also needs a static cue (color, icon, label) for reduced-motion users and anyone who blinked.
- **Brief and precise beats prominent**: when in doubt, cut duration, not clarity.

Reduced-motion handling is an accessibility requirement (see accessibility); apply it to every animation here.

## Icons

- **Match stroke to text weight** (24px grid): `1.5px` beside regular (400) 14–16px text, `2px` beside medium/semibold (500–600), `2.5px` beside bold. One optical strategy per surface — never mix icon libraries with incompatible stroke conventions on one toolbar. Size inline icons `1em`–`1.25em` relative to the text.
- **One SVG, recolored per state**: draw with `currentColor`, drive hover/selected/disabled from CSS color and opacity (`text-zinc-500 hover:text-zinc-900 aria-pressed:text-blue-600 disabled:opacity-40`). Strip hardcoded fills (`fill="#666"`) when importing. Never separate assets per state.
- **Outline default, fill active**: outline variant for toolbars, rows, inline; fill marks the selected/active state (active tab, toggled bookmark). Filled everywhere = no state signal. The variant swap uses the contextual icon animation values above.
- **Design at render size**: test every icon at its smallest render size (often `16px`); use the set's native grid sizes (16/20/24), not fractional scaling; simplified glyphs for small contexts; always SVG.
- **RTL**: flip icons tied to reading direction (back/forward arrows, nav chevrons, text-block glyphs, send); don't flip logos, checkmarks, physical objects, or media playback (tape convention stays LTR). `rtl:-scale-x-100` on directional icons only; analyze composite icons part by part.

## Performance

- **Never `transition: all`** (or `transition-all`): it watches every property, causes unintended transitions, and blocks optimizations. Name exactly what changes: `transition-property: scale, opacity` / `transition-[scale,opacity,filter]`. Tailwind's `transition-transform` covers `transform, translate, scale, rotate`.
- **`will-change` sparingly**: only for GPU-compositable properties (`transform`, `opacity`, `filter`), never `will-change: all`, never layout/paint properties (`top`, `width`, `background-color`). Add it only when you notice first-frame stutter (Safari benefits most); each layer costs memory.

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Same radius on closely nested parent and child | `outerRadius = innerRadius + padding` |
| Icons look off-center | Adjust optically; fix the SVG directly when possible |
| Border used only to fake elevation | Layered transparent `box-shadow`; keep structural/state borders |
| Tinted (slate/zinc) image outline | Pure `black/10` light, `white/10` dark |
| Keyframes on an interactive toggle | CSS transition (interruptible) |
| Dramatic exit stealing focus | `-12px` translateY, 150ms, softer than the enter |
| Stateful icon animates its default state on load | `initial={false}` on that `AnimatePresence` |
| `transition: all` | Explicit property list |
| First-frame animation stutter | `will-change: transform` (sparingly) |
| Hairline icon beside bold text | Match stroke width to text weight |
| Separate icon assets per state | One `currentColor` SVG, states via CSS |
| Filled icons everywhere | Outline default, fill for active |
| Entrance animation on every hover/keystroke | Instant feedback or ≤150ms opacity/color |
