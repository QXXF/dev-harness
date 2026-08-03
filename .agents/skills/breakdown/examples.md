# Breakdown — worked examples

## Example A — currency precision (day bugfix)

### Frame
- Goal: Totale raggiunto keeps 5 decimal places like input/display
- Kind: bug
- Description: Il totale raggiunto perde le ultime 3 cifre decimali: l'utente inserisce importi a 5 decimali e la somma torna arrotondata a 2. Il punto di partenza è l'utility condivisa che converte gli importi in centesimi prima di sommarli: moltiplica per 100 invece che per 10⁵, quindi tronca ogni importo prima ancora che la somma inizi. Il resto della UI lavora già a 5 decimali, per questo l'errore si vede solo sul totale.

### Bits

| Slot | Bit |
|------|-----|
| Cosa si vede | Totale raggiunto drops last 3 decimals |
| Dove | `currency-amount.util.ts` (`toCurrencyCents` ×100) |
| Perché succede | UI scale 10⁵, math scale 10² → early round |
| Cosa doveva succedere | Expected: match `EURO_FRACTION_DIGITS`; Actual: 2 dp |
| Cosa cambia | scala `100` → `10 ** EURO_FRACTION_DIGITS` |
| Dove si mette mano | `currency-amount.util.ts` only |
| Chi ne beneficia gratis | programmazione-offerta + gestione-progetto via util |
| Cosa resta fuori | Commercial round still at 5th decimal (intentional) |

### Act

A1. **Read `currency-amount.util.ts` + euro-amount config.** Confronta la scala usata nella conversione (×100) con `EURO_FRACTION_DIGITS` (5). Serve la prova del mismatch (B3) prima di toccare qualsiasi cosa: se le scale coincidessero, il sospetto sarebbe sbagliato.

A2. **Trace i chiamanti dell'util.** Elenca chi usa `toCurrencyCents`. Conferma che il perimetro è solo convenzioni enti house (B6) e che chi eredita la util vuole la stessa precisione (B7): così la modifica alla radice è sicura.

A3. **Change `CURRENCY_SCALE` a `10 ** EURO_FRACTION_DIGITS`.** Un solo punto (B5): verificato al passo 2 che tutti i chiamanti vogliono 5 decimali, la correzione alla radice li sistema tutti senza altri edit.

A4. **Verify `1.12345 + 2.12345` → `3.24690`.** È il caso che prima tornava `3.25`: se passa, la regola di B4 è ripristinata. Il round commerciale al 5° decimale resta voluto (B8), non va "corretto".

### One-liner
Align money math scale to the same 5 decimals the UI already uses.

### Compact schema
```
[totale perde 3 cifre] --×100 troppo presto--> [currency-amount.util]
                                                      |
                                              100 → 10^5
                                                      |
                                         1 file → 2 componenti
                                                      |
                                         round resta al 5° decimale
```

---

## Example B — wrong sort key (debug)

### Frame
- Goal: list order matches business rule "newest first"
- Kind: debug
- Description: La lista dovrebbe mostrare gli elementi più recenti in cima, ma alcuni vecchi compaiono sopra i nuovi. L'ordinamento non usa la data vera: confronta la stringa formattata mostrata a schermo, e l'ordine alfabetico di una data formattata non coincide con l'ordine cronologico. Basta correggere il criterio di confronto nel componente lista.

### Bits

| Slot | Bit |
|------|-----|
| Cosa si vede | Old items appear above new ones |
| Dove | `lista.component.ts` comparator |
| Perché succede | Compares display string, not timestamp |
| Cosa doveva succedere | Expected: `datOra` desc; Actual: locale string asc |
| Cosa cambia | `localeCompare(label)` → `b.datOra - a.datOra` |
| Dove si mette mano | comparator in lista component |
| Chi ne beneficia gratis | n/a (local sort) |
| Cosa resta fuori | Ties keep insertion order |

### Act

A1. **Reproduce con due date note.** Inserisci due righe con date che l'ordine alfabetico e quello cronologico ordinano diversamente. Serve un caso che fallisce sotto gli occhi (B1) prima di guardare il codice.

A2. **Read il comparator.** Con la riproduzione in mano, conferma che confronta la label formattata e non `datOra` (B3): è la prova che il criterio è sbagliato, non i dati.

A3. **Change a confronto su timestamp, null in coda.** Sostituisci `localeCompare(label)` con `b.datOra - a.datOra` (B5). Il sort è locale al componente (B7 n/a), quindi nessun altro punto va toccato.

A4. **Verify: le due righe del passo 1 si invertono.** Lo stesso caso che falliva ora passa (B4). I pareggi mantengono l'ordine di inserimento: è accettato, non un bug (B8).

### One-liner
Sort by the timestamp field, not by the formatted label.

---

## Example C — prototype algorithm (sliding window)

### Frame
- Goal: max sum of any contiguous subarray of length k
- Kind: algo
- Description: Serve la somma massima tra tutte le finestre contigue di lunghezza k in un array. La versione ingenua ricalcola la somma di ogni finestra da zero (due cicli annidati): lenta sugli array grandi e fragile con i numeri negativi. L'idea giusta è far "scorrere" la finestra: quando avanza, aggiungi l'elemento che entra e togli quello che esce, senza mai risommare tutto.

### Bits

| Slot | Bit |
|------|-----|
| Cosa si vede | Nested loops too slow / wrong on negatives |
| Dove | `maxSumWindow(arr, k)` |
| Perché succede | Re-sums window each step O(nk); or drops negatives badly |
| Cosa doveva succedere | Spec: contiguous length k; naive skips constraint |
| Cosa cambia | O(nk) rescan → O(n) sliding: add right, remove left |
| Dove si mette mano | one function + 3 assert cases |
| Chi ne beneficia gratis | callers unchanged if signature stable |
| Cosa resta fuori | k≤0 / k>n → define empty/error explicitly |

### Act

A1. **Reproduce un esempio che fallisce.** `[2,1,5,1,3,2], k=3` deve dare `9`. Fissa input → atteso prima di scrivere l'algoritmo (B1/B4): senza un caso concreto non c'è modo di sapere quando hai finito.

A2. **Change a sliding window.** Somma iniziale sulle prime k posizioni, poi a ogni passo aggiungi l'elemento che entra e sottrai quello che esce, tracciando il massimo (B5). La firma resta identica, quindi i chiamanti non cambiano (B7).

A3. **Verify esempio + edge `k=1`, `k=n`.** Il caso del passo 1 più i due estremi della finestra. `k≤0` e `k>n` restano da definire esplicitamente (errore o vuoto): è il residuo dichiarato (B8), non una svista.

### One-liner
Keep a running window sum: enter right, leave left, track max.
