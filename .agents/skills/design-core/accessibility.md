# Accessibility

Accessibility is the floor for interface craft, not a compliance checkbox. Most of it is free if you use the platform: native elements ship with keyboard support, real labels announce themselves, a visible focus ring is one CSS rule. When reviewing, walk the interface keyboard-only first (every flow must complete without a mouse), then as a screen-reader user: does each control announce a name, a role, and its state? When unsure, prefer the platform default over a custom rebuild, and remove ARIA rather than add it.

## Semantics and ARIA

The rules of ARIA: (1) use the native element when one exists; (2) don't change native semantics without need; (3) a role is a promise of the full keyboard model — every interactive ARIA control must be keyboard-operable; (4) never put `role="presentation"` or `aria-hidden="true"` on a focusable element; (5) every interactive element needs an accessible name. No ARIA is better than bad ARIA.

- `<a href>` for navigation (free Cmd/Ctrl/middle-click, copy link), `<button>` for actions (free focus, Enter *and* Space), `<div onClick>` for nothing. If it looks clickable it must be clickable; a "button" that navigates is a styled `<a>`.
- Full polyfill when native is truly impossible: `role="button"` + `tabindex="0"` + Enter and Space handlers — which is why native is always less code.
- One visible primary `<main>` landmark; multiple landmarks of the same type get distinguishing labels (`<nav aria-label="Breadcrumbs">`). Headings form a coherent outline: one page-level `<h1>`, properly nested levels (recommended default, not a standalone WCAG pass/fail). Pick the tag for structure, style the size with CSS.
- `<title>` matches current context, most specific first: `Billing · Settings · Acme`. Anchored headings get `scroll-margin-top`.

### Accessible names

Precedence: `aria-labelledby` > `aria-label` > native label (`<label>`, text content, `alt`) > `title`. Prefer visible text over `aria-label` (invisible, drifts, translates inconsistently). Icon-only controls always need a name, with the icon `aria-hidden="true"`:

```tsx
<button aria-label="Delete"><TrashIcon aria-hidden="true" /></button>
```

Visible label text must appear inside the accessible name (WCAG 2.5.3): a button showing "Send" with `aria-label="Submit message"` breaks voice control. Add `translate="no"` to brand names, code tokens, and identifiers.

### Common ARIA mistakes

| Mistake | Why it fails |
| --- | --- |
| `aria-label` on a plain `<div>`/`<span>` | Ignored on role-less non-interactive elements |
| `aria-hidden="true"` on or above a focusable element | Tab stops that don't exist for screen readers |
| `aria-labelledby`/`describedby` pointing at a missing ID | Silently produces nothing |
| `role="menu"` on site navigation | `menu` promises app-style arrow keys; use `<nav>` + list |

### Disabled states

Native `disabled` gives the platform's complete behavior (out of tab order, no activation, `:disabled`, excluded from submission) — use it when a control is genuinely unavailable. `aria-disabled="true"` only announces: use it when staying discoverable in the tab order is intentional, then block pointer/keyboard/submit in code and style the state explicitly. Never set both. Don't disable submit buttons pre-validation (see Forms).

## Focus and keyboard

Style `:focus-visible`, not bare `:focus` (keyboard gets a ring, mouse doesn't). Never `outline: none` without a verified replacement. Prefer the browser's unmodified indicator — adding only `outline-offset: 2px` preserves it. Custom ring: use a project focus token, at least a `2px` solid perimeter, and verify it against every adjacent color it crosses; `currentColor` only after that check. In `forced-colors: active`, keep the default adjustment or use a system color like `Highlight`.

```css
:focus-visible { outline: 2px solid var(--focus-ring); outline-offset: 2px; }
```

- **tabindex**: only `0` (join natural tab order) and `-1` (programmatic focus). Positive values never — fix the DOM order instead.
- **Roving tabindex** for composite widgets (tabs, menus, toolbars, radio groups): one Tab stop for the group, active item `tabindex="0"`, others `-1`, arrow keys move both focus and the `0`.
- **Skip link**: when repeated chrome precedes content, first focusable element is "Skip to content" targeting `<main id="main">`, visually hidden until focused.
- **SPA route changes**: update `document.title`, move focus to the new view's `<h1>` (`tabindex="-1"`) or `<main>`; restore scroll on back/forward.

### Focus trapping (modals)

Prefer native `<dialog>` with `showModal()`: trap, `inert` background, and Escape for free. Custom overlays need `role="dialog"`, `aria-modal="true"`, an accessible name, and `inert` on everything behind:

```tsx
// open: background inert, focus first focusable (or least destructive action)
appContent.inert = true;
// close: restore, always return focus to the trigger
appContent.inert = false; triggerRef.current?.focus();
```

Add `overscroll-behavior: contain` so scrolling inside never scrolls the page behind.

### Keyboard patterns (ARIA APG)

| Widget | Keys |
| --- | --- |
| Dialog | Tab/Shift+Tab cycle inside; Escape closes |
| Tabs | Arrows move between tabs (wrapping); Tab exits to panel; Home/End |
| Menu button | Enter/Space/ArrowDown opens + focuses first item; Escape closes and refocuses button |
| Disclosure/accordion | Header is `<button aria-expanded>`; Enter and Space toggle |
| Combobox | ArrowDown opens/moves into list; Enter accepts; Escape closes back to input |
| Listbox/radio group | Arrows move selection; one Tab stop for the group |

Universal: Escape dismisses whatever opened last (tooltip → menu → dialog). Arrows move *within* a composite widget, Tab moves *between* widgets. Enter submits the focused input's form; in `<textarea>`, Enter is newline and ⌘/Ctrl+Enter submits.

## Hit areas

| Standard | Minimum |
| --- | --- |
| WCAG 2.5.8 (AA) | 24×24px hard floor (or a defined exception) |
| Touch target (recommended) | 44×44px |
| Desktop target (recommended) | 40×40px when density permits |

Smaller controls are not automatic failures: check the spacing, equivalent-control, inline, user-agent, and essential exceptions first (spacing exception: a 24px circle centered on the target must not intersect another target's; 20px targets need ≥4px gap).

The visible element can stay small; the hit area must be big. Extend with a pseudo-element on the wrapping `<label>`/`<button>` (never on the `<input>` — replaced elements don't render `::after` reliably):

```tsx
<button className="relative size-5 after:absolute after:top-1/2 after:left-1/2 after:size-11 after:-translate-1/2">
```

Extended hit areas must never overlap another interactive element — shrink to the largest non-colliding size. No dead zones: a checkbox and its label share one hit target. Add `touch-action: manipulation` to remove the double-tap zoom delay.

## Forms

- Every control gets `<label for>` or a wrapping `<label>`; a placeholder is never a label (disappears on input, fails contrast). Placeholders show format examples only.
- `autocomplete` with a meaningful `name` (WCAG 1.3.5): `email`, `tel`, `street-address`, `postal-code`, `cc-number`, `username`, `current-password`, `new-password`, `one-time-code`. Prefix with section when relevant (`shipping street-address`).
- Correct `type`/`inputmode` for the mobile keyboard: `type="email"`/`url`/`tel`; OTP/PIN/card = `type="text" inputmode="numeric"`; money = `inputmode="decimal"`; true quantity = `type="number"`. `spellcheck="false"` on emails, codes, usernames.
- Never block paste (passwords, OTP codes). Stay compatible with password managers: real `<form>`, correct `autocomplete`, no fake inputs. Never `user-scalable=no` or `maximum-scale=1` (keep mobile input text at 16px instead — see typography).

### Errors that announce

```html
<input id="email" type="email" aria-invalid="true" aria-describedby="email-error" />
<p id="email-error">Enter a valid email address.</p>
```

Validate on submit, not while typing; trim before validating. Errors render inline with icon or text — never a red border alone. On submit, focus the first invalid field. Keep submit enabled until the request starts, then disable with a spinner *while keeping the original label*. Warn on unsaved changes; never lose typed input to a re-render.

## Screen readers

Choosing how to announce a change — stop at the first match:

1. **Focus moves there anyway** (opened modal, first invalid field): nothing extra needed.
2. **Tied to a control** (field error, char count): `aria-describedby`.
3. **Non-urgent, not tied to a control** (toast, "Saved", result count): polite live region `role="status"`.
4. **Urgent, not tied to a control** (form-level failure, session expiring): `role="alert"`.

Live-region rules: for repeated polite updates, render a stable empty region first and update its text (inserting region+content together is inconsistently announced). Default to polite; overused `assertive` is the most common mistake. Don't move focus to toasts; give them a generous timeout or dismiss button, and never put the only path to an action in an auto-dismissing toast. Loading: `aria-busy="true"` on the region, announce "Loading…" then the outcome.

- `.sr-only` (Tailwind ships it): `1px` boxes, not `0`; `white-space: nowrap`. Never `display: none` for this.
- Alt text by purpose: decorative/redundant = `alt=""` (empty but present — missing alt reads the filename); informative = the meaning; functional = the action (`alt="Search"`, not `alt="magnifying glass"`); image of text = the exact text; complex chart = short summary + full data nearby.
- SVG: decorative = `aria-hidden="true" focusable="false"`; meaningful inline = `role="img"` + `aria-label`.
- Video needs captions, audio needs transcripts; never autoplay with sound.

## Motion and zoom

Make motion opt-in: wrap animations in `@media (prefers-reduced-motion: no-preference)` (Tailwind `motion-safe:`). Global fallback for existing codebases: under `reduce`, force `animation-duration: 0.01ms !important` (not `none`, so `animationend` events still fire).

Reduced ≠ eliminated: **disable** parallax, autoplaying video/GIFs, spinning and large movement; **replace** slide/scale/zoom with opacity crossfades, smooth scroll with instant jump, auto-rotating carousels start paused; **keep** spinners, instant state changes, brief press feedback.

Independent of the preference (WCAG 2.2.2): anything auto-moving/updating >5s needs a visible pause control — muted looping hero videos included. Toasts carrying actions or errors stay until dismissed; timed toasts get ≥5s and pause on hover/focus. Never put critical information only in a timed element.

Zoom (WCAG 1.4.4 / 1.4.10): everything must survive 200% zoom and reflow at 320px width with vertical scrolling only (genuinely 2D content — tables, maps, code — scrolls in its own container). Fixed heights are what break: use `min-height` on text containers. Where the codebase allows the choice, `rem` for font-size, text-container max-widths, and breakpoints; `px` for borders, focus outlines, shadows.
