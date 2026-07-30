---
name: breakdown
description: >-
  Decomposes any problem and its solution (bugfix, algorithm, debug,
  prototype, refactor, technical decision) into atomic comprehension bits and
  an ordered act sequence: a fixed schema anyone can follow, with zero
  unexplained jargon. Coding focus. Use when the user asks for breakdown,
  scomponi, riassunto, schema, bit, spiegami il problema, come funziona il
  fix, handoff, PR summary, sequenza logica, or a mental model of what was or
  will be solved. Also use after a non-trivial fix when asked to explain or
  structure the resolution.
---

# Breakdown

Make any problem — and its solution — **trivially understandable to anyone**: same schema every time, no narrative, no unexplained jargon.

A **bit** is one irreducible fact: one sentence, one mechanism, one file, one `prima → dopo`. If it needs an "and", split it.

Works **before** coding (plan), **during** (steer), and **after** (handoff). Companion: `dev-core` says how to code; this skill says how to **see** the problem.

## Comprehension rules (every bit, no exceptions)

1. **No undefined jargon.** Replace terms of art with plain words, or define them inline in ≤5 words: "race condition (due scritture, ordine sbagliato)".
2. **Concrete over abstract.** Numbers, names, paths — never adjectives: "perde 3 decimali", not "perde precisione".
3. **One idea per bit.** Cause, change, and side effect never share a sentence.
4. **≤20 words per bit.** Only the Superficie list may run longer.

## When to run

1. User asks to explain, break down, or summarize a problem, solution, or algorithm.
2. User asks for a logical sequence to implement or debug something.
3. After a non-trivial fix, when asked for riassunto / schema / handoff.
4. Skip for one-line trivia (typo, rename) — say so in one line.

## Pipeline (always this order)

Copy and track:

```
Breakdown:
- [ ] 1. Frame
- [ ] 2. Extract bits
- [ ] 3. Order act sequence
- [ ] 4. Emit schema
- [ ] 5. (Optional) Execute / verify
```

### 1. Frame

One line each:

| Field | Question | Cap |
|-------|----------|-----|
| **Goal** | What becomes true when done? | 1 sentence |
| **Kind** | bug / algo / debug / prototype / refactor / decision | 1 word |
| **Budget** | Fits in one day of work? | yes/no |
| **Invariant** | What must stay true throughout? | 1 sentence |

If budget > 1 day: stop, split into day-sized scopes, run the skill once per scope. The day gate prevents fake "simple" explanations of week-sized work.

### 2. Extract bits (fixed slots)

Fill every slot. Empty slot = write `n/a` + why (one short clause).

| # | Slot | The bit answers | Must not contain |
|---|------|-----------------|------------------|
| B1 | **Sintomo** | What does the user/system observe? | The suspected cause |
| B2 | **Locus** | Where in the code/stack? (`path` or layer) | The full call graph |
| B3 | **Meccanismo** | Why does that place produce the symptom? | The fix |
| B4 | **Invariante rotta** | Expected vs actual: which rule failed? | The implementation plan |
| B5 | **Delta** | `prima → dopo` — what changes? | A file laundry list |
| B6 | **Superficie** | Which files/symbols get edited? | Untouched dependents |
| B7 | **Ereditarietà** | Who benefits with zero further edits? | Hopeful refactors |
| B8 | **Residuo** | What stays broken/approximate on purpose? | A "should also…" wishlist |

### 3. Order act sequence

Turn bits into ordered steps a human or agent can execute. The order is forced by dependency: evidence (B1–B4) → one root change (B5–B6) → inheritance check (B7) → residue + verify (B8).

1. **Evidence before change** — prove B1–B4 before touching B5–B6.
2. **Shared before leaf** — fix the shared util/root (B7) before patching callers.
3. **One lever** — prefer one change that flips many symptoms.
4. **Verify last** — one minimal check that would have failed before the fix.
5. Max **7** steps. More means the frame is too wide: re-split.

Step format, verbs limited to Read, Trace, Reproduce, Change, Align, Verify, Document:

```
A{n}. <verb> <target> — <why this bit>
```

### 4. Emit schema (mandatory output shape)

Use this exact structure, in the user's language:

```markdown
## Frame
- Goal: …
- Kind: …
- Budget: …
- Invariant: …

## Bits
| Slot | Bit |
|------|-----|
| Sintomo | … |
| Locus | … |
| Meccanismo | … |
| Invariante rotta | … |
| Delta | … |
| Superficie | … |
| Ereditarietà | … |
| Residuo | … |

## Act
1. …
…
n. Verify: …

## One-liner
<≤15 words that carry the whole solution>
```

Optional compact ASCII, when the user asks for "schema" or "efficace":

```
[sintomo] --meccanismo--> [locus]
                              |
                         delta: prima → dopo
                              |
                    superficie → ereditarietà
                              |
                           residuo
```

### 5. Optional execute

If the user wants implementation: run **Act** in order under `dev-core`. After each Change step, re-check that B5–B8 still match reality; if they diverge, update the Bits before writing more code.

## Algorithm / pure-logic variant

When Kind = algo (no runtime bug), remap the slots:

| Slot | Means |
|------|-------|
| Sintomo | Wrong output / too slow / broken edge case |
| Locus | Function / formula / data structure |
| Meccanismo | Why the current approach fails |
| Invariante rotta | Spec property violated |
| Delta | Old approach → new approach (or old → new complexity) |
| Superficie | Functions / types touched |
| Ereditarietà | Call sites / tests that stay valid |
| Residuo | Approximations, limits, unhandled cases |

Act must include **one concrete example**: input → expected → actual-before → after.

## Anti-patterns

- Storytelling without the Bits table.
- Unexplained jargon a non-expert cannot parse.
- Mixing symptom and cause in one bit.
- Act steps that skip evidence ("just change X").
- Listing every file in the repo as Superficie.
- Residuo left empty when rounding, caches, or contracts stay approximate.
- Prose longer than the schema — delete prose, keep slots.

## Progressive disclosure

Worked examples (bugfix, debug, algorithm): [examples.md](examples.md)
