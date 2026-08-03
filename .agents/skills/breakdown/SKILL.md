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

Make any problem — and its solution — **trivially understandable to anyone**: same schema every time, no narrative, no unexplained jargon.

A **bit** is one irreducible fact: one sentence, one mechanism, one file, one `prima → dopo`. If it needs an "and", split it.

Works **before** coding (plan), **during** (steer), and **after** (handoff). Companion: `dev-core` says how to code; this skill says how to **see** the problem.

## Comprehension rules (every bit, no exceptions)

1. **No undefined jargon.** Replace terms of art with plain words, or define them inline in ≤5 words: "race condition (due scritture, ordine sbagliato)".
2. **Concrete over abstract.** Numbers, names, paths — never adjectives: "perde 3 decimali", not "perde precisione".
3. **One idea per bit.** Cause, change, and side effect never share a sentence.
4. **≤20 words per bit.** Only the *Dove si mette mano* list may run longer. Description and Act paragraphs are prose, not bits — they follow their own caps (§1, §3).

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

| Field | Question | Cap |
|-------|----------|-----|
| **Goal** | What becomes true when done? | 1 sentence |
| **Kind** | bug / algo / debug / prototype / refactor / decision | 1 word |
| **Description** | The problem in plain words, impossible to misread | 1 paragraph, ≤120 words |

**Description** is prose, not a slot dump. Write it with the discursive rules (§Modalità discorsiva, rules 1–4): answer first, one anchor before the branches, spoken connectives, zero undefined jargon. A reader with no context must finish it knowing what hurts, who feels it, and roughly why — before any bit, path, or table appears. It is the on-ramp to the Bits, not a duplicate of them.

Day gate: if the work doesn't fit one day, stop, split into day-sized scopes, run the skill once per scope. The gate prevents fake "simple" explanations of week-sized work.

### 2. Extract bits (fixed slots)

Fill every slot. Empty slot = write `n/a` + why (one short clause).

Slot names are the plain question the reader would actually ask — a non-developer scanning only the Slot column must understand what each row answers. The technical alias stays for cross-reference (older breakdowns, algo variant); the technical payload (paths, symbols, numbers) lives exact and literal in the Bit column.

| # | Slot | Alias | The bit answers | Must not contain |
|---|------|-------|-----------------|------------------|
| B1 | **Cosa si vede** | sintomo | What does the user/system observe? | The suspected cause |
| B2 | **Dove** | locus | Which file/layer produces it? (`path`) | The full call graph |
| B3 | **Perché succede** | meccanismo | Why does that place produce the symptom? | The fix |
| B4 | **Cosa doveva succedere** | invariante rotta | Expected vs actual: which rule failed? | The implementation plan |
| B5 | **Cosa cambia** | delta | `prima → dopo` — the one change | A file laundry list |
| B6 | **Dove si mette mano** | superficie | Which files/symbols get edited? | Untouched dependents |
| B7 | **Chi ne beneficia gratis** | ereditarietà | Who gets fixed with zero further edits? | Hopeful refactors |
| B8 | **Cosa resta fuori** | residuo | What stays broken/approximate on purpose? | A "should also…" wishlist |

### 3. Order act sequence

Turn bits into ordered **motivated paragraphs** a human or agent can execute — not one-line commands. Read top to bottom, the sequence must frame the whole action perimeter: what gets touched, in what order, why each step fires, and what deliberately stays out (B8). The order is forced by dependency: evidence (B1–B4) → one root change (B5–B6) → inheritance check (B7) → residue + verify (B8).

1. **Evidence before change** — prove B1–B4 before touching B5–B6.
2. **Shared before leaf** — fix the shared util/root (B7) before patching callers.
3. **One lever** — prefer one change that flips many symptoms.
4. **Verify last** — one minimal check that would have failed before the fix.
5. Max **7** steps. More means the frame is too wide: re-split.

Step format — a short paragraph (2–3 sentences, ≤60 words), opened by one of the verbs Read, Trace, Reproduce, Change, Align, Verify, Document:

```
A{n}. **<Verbo> <target>.** <What you do, concretely.> <Why now: which bit
triggers this step, and what you expect to observe when it's done.>
```

Write the paragraphs with the discursive rules: each step leans on the outcome of the previous one ("confermato il confronto stringa, ora…"), and the motivation lives in the syntax, not in a separate bullet. Litmus test: if the sentences after the bold opener could be deleted without losing anything, it's a command, not a step — rewrite it.

### 4. Emit schema (mandatory output shape)

Use this exact structure, in the user's language:

```markdown
## Frame
- Goal: …
- Kind: …
- Description: <1 paragrafo in prosa semplice>

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
…
An. **Verify …** …

## One-liner
<≤15 words that carry the whole solution>
```

Optional compact ASCII, when the user asks for "schema" or "efficace":

```
[cosa si vede] --perché succede--> [dove]
                                      |
                        cosa cambia: prima → dopo
                                      |
                 dove si mette mano → chi ne beneficia
                                      |
                              cosa resta fuori
```

### 5. Optional execute

If the user wants implementation: run **Act** in order under `dev-core`. After each Change step, re-check that B5–B8 still match reality; if they diverge, update the Bits before writing more code.

## Modalità discorsiva (prosa umana)

Trigger: "discorsivo", "umano", "leggibile", "per il mio manager / per il team", "in un paragrafo", "spiegalo a voce", o quando l'output va incollato in una mail/chat. Sostituisce lo schema del §4: i bit restano il controllo interno di completezza (estraili mentalmente, non emetterli), il testo finale è solo prosa.

Regole, in ordine di impatto:

1. **Prima parola = risposta.** Se la domanda era sì/no, apri con "Sì"/"No" + qualificatore onesto ("in gran parte", "quasi sempre"). Mai aprire con una complicazione ("dipende: …") se puoi affermare e sfumare subito dopo.
2. **Un'àncora prima dei rami.** Dai un punto di partenza unico ("Il punto di partenza è quasi sempre X") prima di elencare i casi: il lettore aggancia tutto lì. Quattro fatti paralleli diventano un albero con una radice.
3. **Rami con connettivi parlati.** "Se… Se invece… invece… Ci sono anche": la biforcazione vive nella sintassi, non in un elenco puntato.
4. **Ogni frase si appoggia alla precedente.** Richiami anaforici ("viene recuperato proprio tramite quel PRG_TIP_DOC") invece di frasi giustapposte: il token introdotto prima viene riusato, non ripresentato.
5. **Evidenza linkata nel tessuto.** Ogni affermazione portante su cui il lettore vorrebbe saltare al codice porta il suo riferimento: path inline nella frase ("nel filtro `security/AuthFilter.java`") e, per il punto esatto dove vive il meccanismo o il fix, un code reference block (formato `startLine:endLine:path`) subito dopo il paragrafo. Linka solo dove il salto serve, non ogni nome citato.
6. **Chiudi la domanda successiva.** Anticipa l'ovvio follow-up in un inciso o parentesi ("ma questi vengono usati in altre aree, non nella nostra"): un inciso ora vale due turni di Q&A dopo.
7. **Chiusura operativa, non constatativa.** Se la domanda implica un "come si fa", chiudi con una mini-lista di passi (unico bullet ammesso: elencare azioni, mai spiegare). Se resta un residuo, trasformalo in raccomandazione per il lettore ("Ricorda: a DB potrebbero esserci dati sporchi, ti consiglio di ricalcolarli"), non in una constatazione passiva ("le differenze sono attese").
8. **Tecnico esatto, resto colloquiale.** Nomi tabella, path, codici restano letterali; il tessuto attorno può rilassarsi ("ecc.", "cmq" se il canale lo consente) e preferisce idiomi corti e diminutivi onesti ("bloccata a monte", "qualcosina da ritoccare", "entrambe minime"). Mai il contrario.
9. **Hedge onesto > elenco eccezioni.** "In gran parte" al posto della lista dei casi limite: il dettaglio arriva solo se richiesto.
10. **Forma:** 1 paragrafo (max 2) + eventuali code reference e lista di passi in coda; nessun bold/tabella/header; ≤120 parole per paragrafo.

Anti-pattern specifici: aprire negando la premessa della domanda quando la sostanza è un sì; prosa che è una lista travestita (frasi parallele senza connettivi); bullet usati per spiegare invece che per elencare passi; registro colloquiale sui token tecnici; claim portante senza riferimento al file quando il lettore vorrebbe saltarci; lasciare scoperto il follow-up ovvio; chiudere con una constatazione dove serviva un'azione.

Esempio calibrato (domanda: "i template dei documenti sono censiti su una tabella?"):

> Sì, i template dei documenti che usiamo sono in gran parte censiti a database, in diverse tabelle. Il punto di partenza è quasi sempre la tabella delle tipologie documento, dove definiamo ogni tipo con il suo identificativo. Se il template è un file scaricabile (Excel, Word, ecc.), il file vero e proprio è registrato nell'anagrafica documenti e viene recuperato proprio tramite quell'identificativo (il retrieve sta in `service/DocumentService.java`). Se invece si tratta di lettere generate dall'applicazione, il contenuto sta nella tabella dei template lettera (con i parametri in una tabella collegata). I template email invece passano da un'altra coppia di tabelle dedicate. Ci sono anche dei template HTML/PDF sotto `resources/templates` che non sono a DB (ma vengono usati in altre aree, non nella nostra).

Esempio con fragment e chiusura operativa (domanda: "perché il totale ordine sbagliava di pochi centesimi?"):

> Il problema è che stiamo arrotondando nel momento sbagliato. Il totale viene calcolato sommando le righe d'ordine in `service/OrderTotals.java`: ogni riga veniva arrotondata a 2 decimali prima della somma invece che dopo \[code reference block del punto incriminato\]. Su ordini con tante righe da importi "scomodi" (es. sconti percentuali), i centesimi persi si accumulavano. Il fix sposta l'arrotondamento a fine calcolo, un punto solo, e le righe viaggiano a precisione piena \[code reference block del fix\]. Ricorda: a DB potrebbero esserci dati sporchi, ti consiglio di controllarli e/o ricalcolarli.

## Algorithm / pure-logic variant

When Kind = algo (no runtime bug), remap the slots:

| Slot | Means |
|------|-------|
| Cosa si vede | Wrong output / too slow / broken edge case |
| Dove | Function / formula / data structure |
| Perché succede | Why the current approach fails |
| Cosa doveva succedere | Spec property violated |
| Cosa cambia | Old approach → new approach (or old → new complexity) |
| Dove si mette mano | Functions / types touched |
| Chi ne beneficia gratis | Call sites / tests that stay valid |
| Cosa resta fuori | Approximations, limits, unhandled cases |

Act must include **one concrete example**: input → expected → actual-before → after.

## Anti-patterns (schema mode — la modalità discorsiva ha i suoi, vedi sopra)

- Storytelling without the Bits table.
- Unexplained jargon a non-expert cannot parse.
- Mixing symptom and cause in one bit.
- Act steps that skip evidence ("just change X").
- Act steps without motivation — a bare command with no trigger and no expected outcome.
- Description that duplicates the Bits table instead of introducing the problem in plain words.
- Listing every file in the repo as *Dove si mette mano*.
- *Cosa resta fuori* left empty when rounding, caches, or contracts stay approximate.
- Bits written as prose — atomic facts stay in the table; prose belongs to Description and Act.

## Progressive disclosure

Worked examples (bugfix, debug, algorithm): [examples.md](examples.md)
