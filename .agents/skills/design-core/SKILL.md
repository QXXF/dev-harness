---
name: design-core
description: >-
  Front-end design craft for building and reviewing product interfaces:
  accessibility (a11y, WCAG, ARIA, focus, keyboard, screen readers, hit areas),
  layout (spacing, alignment, grouping, breakpoints, responsive, RTL, logical
  properties), typography (fonts, type scale, line-height, wrapping,
  truncation, tabular numbers), colors (OKLCH, palettes, contrast, APCA, design
  tokens, dark mode, gamut), and UI polish (border radius, shadows, animations,
  icons, micro-interactions, motion). Use when building UI components, styling
  pages, implementing designs, or reviewing frontend code for design quality.
  Triggers on design review, UI review, interface audit, accessibility, layout,
  spacing, typography, fonts, colors, contrast, dark mode, animations, icons,
  "make it feel better", "feels off", polish, responsive, RTL, focus ring,
  aria, hit area, oklch, type scale, breakpoints.
---

# Design Core

Interface craft for a senior generalist: accessibility is the floor, layout communicates before words, typography is restraint, color has one meaning per hue, and polish compounds from small exact details. Works alongside `dev-core`: same minimal-diff discipline, applied to UI work.

**Match the project's existing systems.** Styling (Tailwind vs. plain CSS vs. CSS-in-JS), component library, design tokens, type system, color notation, density, and motion language are the project's decisions: express every change in them and never introduce a second approach for an isolated fix. UX copy and wording are out of scope; flag copy problems, don't rewrite voice and tone.

## Quick Reference

Load the domain file when the task touches its area; skim only the sections you need.

| Domain | File | Covers |
| --- | --- | --- |
| Accessibility | [accessibility.md](accessibility.md) | Semantics, ARIA, focus, keyboard, hit areas, forms, screen readers, reduced motion, zoom |
| Layout | [layout.md](layout.md) | Grouping, alignment, logical properties, spacing, disclosure, breakpoints, i18n growth |
| Typography | [typography.md](typography.md) | Fonts, type scale, line-height, wrapping, truncation, punctuation, bidi |
| Colors | [colors.md](colors.md) | OKLCH, palettes, contrast (APCA/WCAG), gamut, Tailwind v4, semantic tokens |
| UI polish | [ui.md](ui.md) | Radius, shadows, image outlines, animations, icons, transition performance |

## Core principles (digest)

The load-bearing rules, always in effect. Details and exact recipes live in the domain files.

**Accessibility** — native elements first (`<button>` for actions, `<a href>` for navigation, never `<div onClick>`); style `:focus-visible`, never `outline: none` without a replacement; every pointer interaction has a keyboard path (APG patterns); icon-only controls get `aria-label`; labels are real `<label>`s, never placeholders; errors set `aria-invalid` + `aria-describedby` and focus the first invalid field; hit areas ≥24px (44px touch); motion is opt-in via `prefers-reduced-motion`; the page survives 200% zoom.

**Layout** — group with space, not lines (inter-group gap ≥ 2× intra-group); align to shared edges; logical properties (`ms-*`/`pe-*`), not physical, in localizable layouts; most important content top and leading; hidden content needs a visible affordance; breakpoints where content breaks, not device presets; no fixed widths/heights on text containers; critical actions never where clipping can eat them.

**Typography** — use the project's type scale, no one-off sizes; heading sizes descend with level; line-height unitless (headings ~1.1, body 1.5–1.6, ≥1.4 on any 3+ line text); cap long-form measure at 60–75ch; `text-wrap: balance` on headings, `pretty` on descriptions; `tabular-nums` on changing values; truncated content stays reachable; inputs 16px on mobile; `font-weight` over raw axis tags.

**Colors** — respect the existing notation and token system; semantic tokens by role, never borrowed by value; one color = one meaning; one filled primary action per view; contrast measured on the rendered pair (APCA Lc 75 body / 60 non-body, or WCAG 4.5:1) — report failures, repaint only when asked; every custom color has light and dark variants, both verified.

**UI polish** — concentric radii (`outer = inner + padding`); shadows for elevation, borders for structure; CSS transitions (interruptible) for interactive states, keyframes only for one-shot sequences; exits softer than enters; scale `0.96` on press; no custom animation on high-frequency interactions and never motion as the only feedback; `transition` names exact properties, never `all`; icon stroke matches text weight; one `currentColor` SVG per icon, states via CSS.

## Building

Apply the digest silently while writing UI code; open a domain file when the task centers on that area (a palette task, a modal, an animation). Fix root causes at the token or shared-component level, not per-leaf. Don't recolor, re-space, or re-animate code the task doesn't touch: `dev-core`'s smallest-diff rule applies to design changes too.

## Reviewing

For an explicit design/UI/interface review, review the whole experience as one system, not five stapled audits.

1. **Scope and recon first.** State the resolved scope (screen, flow, component, repo). Identify framework, styling system, tokens, viewports, and available preview/test commands. If the scope is too large to inspect credibly, narrow to the highest-traffic complete flow and say so; never imply uninspected surfaces were reviewed.
2. **Review in foundation order**: accessibility → layout → typography → colors → UI polish, so foundational failures aren't hidden by polish. Include empty, loading, error, and narrow-width states when present.
3. **Evidence required.** Every finding cites `path/to/file:line` and the current implementation. Don't report a code-level finding from visual appearance alone, or a visual finding from source alone when runtime behavior decides it. Inspect the rendered interface when visual judgment matters; label anything unrun as **Not verified** — never convert a verification gap into a finding.
4. **One root cause = one finding.** A systemic issue is one row listing every confirmed location; a token fix outranks the same symptom in one leaf component. Don't pad: a short review or "no findings" is a valid result.
5. **Read-only by default.** A review request doesn't edit code unless implementation is also requested; then the report is the change scope and verification re-runs afterward.

### Severity

- `HIGH`: blocks a task, misleads the user, hides content/controls, data-loss risk, or repeated systemic failure.
- `MEDIUM`: meaningfully harms comprehension, efficiency, adaptability, or consistency.
- `LOW`: isolated polish. Omit in quick reviews; cap findings at ~5 quick / ~15 full.

### Output format

**Scope and coverage**: mode, exact scope, stack, and per-domain coverage (evidence inspected, findings count or `Clear` or `Not reviewed` + why).

**Findings**: one table ordered by severity, then reach:

| # | Severity | Domain | Location | Before | After | Why |
| --- | --- | --- | --- | --- | --- | --- |

**Considered but rejected**: 1–5 real candidates inspected and deliberately not reported (existing convention is intentional, evidence insufficient, or the change adds complexity without user benefit). Restraint is part of the review.

**Verification**: each check run with exact command/steps and observed result; separate passed from **Not verified**.

**Verdict**: exactly one — `Block` (HIGH remains) / `Needs changes` (only MEDIUM/LOW) / `Approve` (nothing actionable and coverage verified).

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Introducing a second styling system for a fix | Express the change in the project's existing system |
| Restyling code the task doesn't touch | Smallest diff; fix at the token/shared level when systemic |
| Same issue reported per-occurrence | One root cause, one finding, all locations listed |
| Visual claim inferred from source alone | Inspect the rendered state or mark it not verified |
| Repainting failing contrast uninvited | Report the pair and threshold; change colors only when asked |
| Polish before foundations | Accessibility and layout before shadows and springs |
| "Approve" with actionable findings pending | `Needs changes` or `Block` |
