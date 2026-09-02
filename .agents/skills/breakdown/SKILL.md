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
  structure the resolution. Includes a discursive mode (prose, no schema) for
  human-readable answers: triggers on discorsivo, umano, leggibile, per il
  manager, in un paragrafo, spiegalo a voce, per una mail/chat.
---

# Breakdown

Same schema every time. A **bit** is one fact: one sentence, one file, one `prima → dopo`. If it needs "and", split it.

Companion: `dev-core` how to code; this skill how to **see** the problem; `voice-core` how the explanation sounds. Skip one-line trivia.

## 1. Frame

| Field | Cap |
|-------|-----|
| **Goal** | 1 sentence: what becomes true |
| **Kind** | bug / algo / debug / prototype / refactor / decision |
| **Description** | 1 paragraph ≤120 words: what hurts, who feels it, roughly why. On-ramp, not a dump of the bits. |

If it doesn't fit one day, split and run once per scope.

## 2. Bits

Fill every slot. Empty = `n/a` + why (one clause). One idea, ≤20 words. Path/symbol/number stay literal.

| Slot | Answers | Must not contain |
|------|---------|------------------|
| Cosa si vede | What the user/system observes | The cause |
| Dove | File/layer (`path`) | Full call graph |
| Perché succede | Why that place produces the symptom | The fix |
| Cosa doveva succedere | Expected vs actual | The plan |
| Cosa cambia | `prima → dopo` — the one change | File laundry list |
| Dove si mette mano | Files/symbols edited | Untouched dependents |
| Chi ne beneficia gratis | Who is fixed with zero further edits | Hopeful refactors |
| Cosa resta fuori | What stays broken/approximate on purpose | Wishlist |

Kind = algo: Dove → function/formula; Cosa cambia → old approach → new. Act includes one concrete example: input → expected → actual-before → after.

## 3. Act

Bits → ≤7 motivated paragraphs, this order: evidence (B1–B4) → one root change (B5–B6) → who inherits (B7) → residue + verify (B8). Shared util before callers. Verify last.

Format (2–3 sentences, ≤60 words), verb first: Read, Trace, Reproduce, Change, Align, Verify, Document.

```
A{n}. **<Verbo> <target>.** <What you do.> <Why now: which bit, what you expect to see.>
```

If the sentences after the bold opener can be deleted, it's a command — rewrite.

## 4. Emit

```markdown
## Frame
- Goal: …
- Kind: …
- Description: <1 paragrafo>

## Bits
| Slot | Bit |
|------|-----|
| Cosa si vede | … |
| Dove | … |
| Perché succede | … |
| Cosa doveva succedere | … |
| Cosa cambia | … |
| Dove si mette mano | … |
| Chi ne beneficia gratis | … |
| Cosa resta fuori | … |

## Act
A1. **…** …
An. **Verify …** …

## One-liner
<≤15 words>
```

Compact ASCII only if asked ("schema" / "efficace"):

```
[cosa si vede] --perché succede--> [dove]
                                      |
                        cosa cambia: prima → dopo
                                      |
                 dove si mette mano → chi ne beneficia
                                      |
                              cosa resta fuori
```

If the user wants implementation: run Act under `dev-core`. After each Change, re-check B5–B8; if they diverge, update Bits before more code.

## Discorsivo

Trigger: discorsivo, umano, leggibile, per il manager/team, in un paragrafo, spiegamelo a voce, testo da incollare in mail/chat.

Replace the schema: bits stay an internal completeness check (extract, don't emit). Wording: `voice-core`. Shape:

- 1 paragrafo (max 2), ≤120 parole, nessun bold/tabella/header
- Un'àncora prima dei rami; biforcazioni nei connettivi (Se… se invece… ci sono anche…)
- Path inline dove il lettore vorrebbe saltare; code reference (`startLine:endLine:path`) solo sul meccanismo o sul fix
- Se la domanda è "come si fa": chiudi con una mini-lista di passi (unico bullet ammesso)

Esempi: [examples.md](examples.md)
