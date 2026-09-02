---
name: flow-mirror
description: >-
  Produces a discursive, operational end-state UI/UX flow mirror for a feature:
  routes, click path, screens, accordion/layout, labels/copy, buttons, tables
  and data sources, forms with validations and prefills, and GET/POST/PUT/DELETE
  endpoints wired to each interaction. Use after a technical analysis when the
  user wants the complete FE/BE journey, flusso UI/UX, specchio funzionale,
  walkthrough schermate, contratto interazioni, mappa endpoint per azione,
  user journey implementabile, or a human-readable screen-by-screen spec for
  agents/QA/PMs. Companion to breakdown (see the problem) and design-core
  (craft UI); this skill documents the runnable user path.
---

# Flow Mirror

After analysis, write the **mirror of the finished feature**: what a human can click, see, type, and which HTTP call fires — not a backlog, not a class diagram.

Tone: discursive, clear, operational — wording from `voice-core`. Readable in pieces (low attention span). Headings carry the skimmable spine; prose under them fills the how/why. Not telegraphic bullets-only; not a novel.

Companion: `breakdown` frames the problem; `design-core` judges UI craft; `flow-mirror` locks the **interaction contract** FE↔BE.

## When to run

1. User asks for flusso UI/UX completo, specchio funzionale, walkthrough schermate, contratto interazioni, mappa endpoint↔azioni.
2. End of a technical analysis / requirements extraction — before or instead of coding.
3. Handoff to another agent that must implement or QA the feature without re-deriving the journey.
4. Skip for pure backend jobs with no UI, or one-screen copy tweaks — say so in one line.

## Pipeline (always this order)

```
Flow Mirror:
- [ ] 1. Scope & assumptions
- [ ] 2. Ground in AS-IS UI patterns
- [ ] 3. Map happy path (entry → done)
- [ ] 4. Expand each tappa (screen contract)
- [ ] 5. Endpoint matrix
- [ ] 6. Emit document (+ optional QA checklist)
```

### 1. Scope & assumptions

State in the opening of the doc:

| Field | Rule |
|-------|------|
| **Subject** | Feature / area name (1 line) |
| **Mode** | `TO-BE` (target after work) vs `AS-IS` (document current) vs `DELTA` (AS-IS → TO-BE) — default **TO-BE** after analysis |
| **Entry surface** | Route + control that opens the feature (tab, menu, button) |
| **Assumptions** | Open decisions that shape the mirror; mark proposed API paths as **proposti** until confirmed |
| **Out of scope** | Explicit one-liners (parallel tracks, downstream modules) |

Never invent official status labels, checklist items, or business rules absent from sources — use placeholders + “da AR / decisione aperta”.

### 2. Ground in AS-IS UI patterns

Before inventing chrome, read the host screen in the target codebase:

- Routing module / path that will host the feature
- Existing tabs, accordions, toolbars, modals, empty states
- How sibling sections name buttons and place primary CTAs
- Existing upload / currency / date / disable patterns (`appFormDisabled` etc. if project-specific)

Prefer **reuse** of those patterns in the mirror. New layout only when the domain forces it — and call it out.

### 3. Map happy path

One short narrative (≤12 sentences) from entry to “done” for the primary actor. Then list secondary actors (revisore, admin, …) as alternate branches, not a second novel.

### 4. Expand each tappa (screen contract)

For **every** stop the user can land on, fill the fixed slots below. Empty slot = `n/a` + why.

| Slot | Answers |
|------|---------|
| **Rotta attiva** | Exact route / hash / query (`#/…`, `/app/…`). Same route + view-state is OK — say so. |
| **Come ci arrivi** | Click path from a known place (menu → list → tab → …). |
| **Cosa vedi** | Layout: accordion / tabs / master-detail / modal / drawer. Match AS-IS or justify new. |
| **Cosa leggi** | Labels, titles, help copy, empty states, error messages (propose if missing; mark *copy proposto*). |
| **Bottoni** | Label, position (header / row / toolbar left-center-right / modal footer), visibility rules, effect. |
| **Tabelle** | Columns (label), who populates (BE field / FE computed), row actions. |
| **Form / input** | Field, type, required, validation, who prefills (BE / FE / empty / lookup). |
| **Endpoint** | Method + path at this exact moment (load, save, delete, download). Mark `AS-IS` vs `PROPOSTO`. |
| **Stati UI** | loading / empty / readonly / error / disabled — when and why. |

Group stops under stable headings (`## 0. Entry`, `## 1. Lista`, `## 2. Dettaglio`, …). One primary CTA per context (toolbar rule: don’t multiply primaries).

### 5. Endpoint matrix

After the tappe, emit one table:

| Quando in UI | Method | Path | Note |
|--------------|--------|------|------|
| … | GET/POST/PUT/DELETE | … | AS-IS / PROPOSTO; multipart yes/no |

Separate **read** vs **write**. List AS-IS support endpoints reused (lookups, parent detail) in a small second table.

Path naming: follow the project’s existing REST style; if inventing, say **proposto** and align to nearest controllers.

### 6. Emit document

**Default:** write a markdown file in the place the user asked for (docs folder, `documentazione-*`, handoff path). If they didn’t specify, propose a path and write there.

**Filename pattern:** `flusso-ui-ux-<feature>.md` or the project’s local convention.

**Opening paragraph must say:** this is the end-state mirror (or AS-IS), skimmable by headings + Endpoint boxes.

Optional closing: **QA / demo checklist** (checkboxes) derived from the happy path.

Full skeleton: [template.md](template.md). Condensed exemplar: [examples.md](examples.md).

## Writing rules (non-negotiable)

1. **Answer-shaped headings** — a tired reader can skim only `##` / `###` and still know the journey.
2. **Concrete tokens** — real routes, button labels, column names, HTTP methods. No “apposita API”.
3. **Copy in the user’s product language** (IT/EN as the app UI). Technical path/entity names stay literal.
4. **Endpoint next to the action** — don’t bury all APIs in an appendix only; the matrix is the index, tappe hold the when.
5. **AS-IS vs PROPOSTO** — always labeled. Never present a guessed path as existing code.
6. **Validations + prefills** live in the form tables, not in a separate essay.
7. **Low attention span** — one idea per subsection; spoken connectives inside prose blocks; avoid nested meta-commentary.
8. **No implementation code** unless the user asks — this skill produces the mirror, not the PR.
9. If Design System constraints matter (a11y, spacing), defer craft judgment to `design-core`; here only structure + contract.

## Anti-patterns

- Backlog / story list disguised as a flow
- Wireframe ASCII art with no endpoints
- Endpoint laundry list with no UI moment
- Inventing business states not in the source analysis
- Redesigning the whole host page when a tab/accordion suffices
- Mixing Diari/parallel tracks into the mirror unless in scope
- English UI copy on an Italian PA app (or the reverse) without being told to

## Handoff line for next agents

End with 3–5 lines: where the file lives, Mode (TO-BE/AS-IS), which paths are still `PROPOSTO`, which open decisions block coding.
