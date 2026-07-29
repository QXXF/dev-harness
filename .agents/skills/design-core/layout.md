# Layout

Layout communicates before a single word is read: position, spacing, and alignment carry hierarchy on their own, and generous space beats decoration. A good layout survives stress: resize it, translate it, mirror it for RTL, and it should still hold together. Treat the numeric values below as starting points for interfaces without an established density or spacing system; preserve deliberate platform chrome, compact professional tools, and project tokens when they remain usable under hit-area, zoom, localization, and viewport stress tests.

## Grouping and alignment

### Group with space, not lines

Three grouping tools, in order of preference: (1) **negative space** — the default; (2) **background shapes** — when a group must read as one unit (selectable row, draggable card); (3) **separator lines** — last resort, for dense data where space costs too much (tables, long settings lists). When a separator is genuinely needed, keep it quiet: hairline, low contrast, never combined with a large gap.

Structural rule: the gap between groups is at least 2× the gap within a group (`8px` intra → `16px`+ inter), or the grouping reads as noise.

```html
<div class="space-y-6">
  <div class="space-y-2">…field group…</div>
  <div class="space-y-2">…field group…</div>
</div>
```

### Keep controls distinct from content

Interactive elements need a visual signal: a background, border, underline, or a consistent control zone. A control styled identically to adjacent static text is invisible. The inverse holds too: a non-clickable badge shaped like the buttons beside it collects dead clicks.

### Align to shared edges

Pick a small set of alignment edges and put everything on them; every stray edge (icon 2px off the text edge, card padded differently from its neighbor) reads as noise. Use one project spacing step per level of subordination (`16px` default), repeated for deeper nesting. Numbers in tables right-align to the trailing edge; text aligns to the leading edge.

### Logical properties, not physical

Express direction-dependent position as leading/trailing so the layout mirrors under `dir="rtl"`:

| Physical (avoid) | Logical (use) |
| --- | --- |
| `margin-left` / `ml-4` | `margin-inline-start` / `ms-4` |
| `padding-right` / `pr-6` | `padding-inline-end` / `pe-6` |
| `left: 0` | `inset-inline-start: 0` |
| `text-align: left` | `text-align: start` |
| `border-right` | `border-inline-end` |

Reserve physical properties for genuinely physical geometry (device notch, physical gesture direction). Sequences that encode progression (star ratings, steppers, progress bars) mirror in RTL: flex/grid with logical properties mirror automatically, hand-positioned elements don't. Digit order never reverses (bidi text rules live in typography).

### Order by importance

Readers scan top-to-bottom, leading-to-trailing. The most important content sits near the top and the leading edge. Within a row, identifying content (name, title) leads; metadata and actions trail. Don't bury the one number the user came for under secondary detail — push it into collapsed sections, tabs, or detail views.

### Don't overload the entry point

The first screenful is a table of contents, not the whole book. One primary action per view (color enforces this — see colors). Group secondary actions behind a menu once they exceed two or three. Prefer a short view that links deeper over a long view showing everything at level one.

## Spacing and adaptivity

### Breathing room between targets

| Between | Starting point |
| --- | --- |
| Adjacent bordered/filled controls | `12px` |
| Around borderless text/icon controls | `24px` |
| Unrelated control groups | `24px`+ (2× intra-group gap) |

Borderless controls need more clearance because space itself is the boundary. Compact layouts may use less when hit areas stay distinct and don't overlap (see accessibility for target sizes).

### Inset buttons from the edges

In content layouts, keep full-width buttons inside the layout margins (start near `16px` inline on mobile) with a visible radius; the button can still span the full content width inside those margins. Edge-to-edge actions are valid only as intentional platform/application chrome that accounts for safe areas:

```css
.action-bar { padding-inline: 16px; padding-bottom: calc(16px + env(safe-area-inset-bottom)); }
```

### Progressive disclosure needs an affordance

Content hidden with zero cue may as well not exist. Preserve the product's established cue; otherwise:

- **Peeking items**: size scroller/carousel items so the next one peeks `16–32px` past the edge — a row ending exactly at the edge looks complete and nobody scrolls it.
- **Disclosure controls**: chevron or "Show 12 more results" (state what's hidden, not just "More").
- **Truncation cues**: ellipsis plus a way to expand (mechanics in typography).

```html
<!-- 80% width keeps the next card's leading 16-32px visible -->
<div class="flex gap-3 overflow-x-auto px-6 [scroll-padding-inline:1.5rem] snap-x snap-mandatory">
  <div class="w-[80%] shrink-0 snap-start">…</div>
</div>
```

### Content bleeds, controls float

Backgrounds, hero media, and scrollable lists extend to the viewport edges; text and controls stay inside layout margins and safe areas (`env(safe-area-inset-*)`), floating above the content. Sticky chrome floats above the content layer, it doesn't dam it.

```css
/* Full-bleed media inside a constrained article */
.article { display: grid; grid-template-columns: 1fr min(65ch, calc(100% - 48px)) 1fr; }
.article > * { grid-column: 2; }
.article > .full-bleed { grid-column: 1 / -1; }
```

### Hold structure until it breaks

Breakpoints belong to the content, not the device catalog. Break where the layout actually stops fitting (sidebar squeezes content below its minimum measure, card grid drops below usable column width), not at `768px` because a preset says so. Collapse late: premature collapsing throws away space users paid for. Prefer **container queries** for components — a card adapts to its column, not the viewport:

```css
.card-list { container-type: inline-size; }
@container (max-width: 400px) { .card { grid-template-columns: 1fr; } }
```

Test the smallest and largest supported sizes first; those break first.

### Plan for growth and clipping

String expansion varies substantially by language; don't rely on a universal percentage:

- No fixed widths sized to English labels; `max-width` plus wrapping.
- No fixed heights on text containers; `min-height` if a floor is needed.
- Buttons size from their label (`padding-inline`), never a hardcoded width.
- Test with pseudo-localization or a long-string locale.

Never park critical actions where they can be clipped: the bottom of a resizable pane, below the fold of a fixed-height modal, behind an expanding keyboard. Keep primary actions in stable chrome (sticky footer with safe-area padding, or the top of the view). If a modal's content scrolls, its action row doesn't.

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Separator line where spacing would do | Remove the line, double the gap between groups |
| `margin-left` / `padding-right` in a localizable layout | `margin-inline-start` / `padding-inline-end` |
| Content-layout button touching the viewport edge | Inset within the project margins; preserve intentional chrome |
| Carousel/scroller that looks complete | Let the next item peek `16–32px` past the edge |
| Adjacent controls merge or hit areas overlap | Increase the gap; `12px`/`24px` starting points |
| Breakpoints at 768/1024 because they're defaults | Break where content actually stops fitting |
| Fixed-width text container sized to one language | `max-width` + wrapping; test representative locales |
| Primary action at the clip-prone bottom of a pane | Sticky positioning or stable chrome with safe-area padding |
