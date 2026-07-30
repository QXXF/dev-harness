# Breakdown — worked examples

## Example A — currency precision (day bugfix)

### Frame
- Goal: Totale raggiunto keeps 5 decimal places like input/display
- Kind: bug
- Budget: yes
- Invariant: integer scaled arithmetic (no raw float sums)

### Bits

| Slot | Bit |
|------|-----|
| Sintomo | Totale raggiunto drops last 3 decimals |
| Locus | `currency-amount.util.ts` (`toCurrencyCents` ×100) |
| Meccanismo | UI scale 10⁵, math scale 10² → early round |
| Invariante rotta | Expected: match `EURO_FRACTION_DIGITS`; Actual: 2 dp |
| Delta | scala `100` → `10 ** EURO_FRACTION_DIGITS` |
| Superficie | `currency-amount.util.ts` only |
| Ereditarietà | programmazione-offerta + gestione-progetto via util |
| Residuo | Commercial round still at 5th decimal (intentional) |

### Act
1. Read util + euro-amount — prove scale mismatch
2. Trace callers — confirm only convenzioni enti house
3. Change `CURRENCY_SCALE` to `10 ** EURO_FRACTION_DIGITS`
4. Verify: `1.12345 + 2.12345` → `3.24690` (not `3.25`)

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
- Budget: yes
- Invariant: stable sort; null dates last

### Bits

| Slot | Bit |
|------|-----|
| Sintomo | Old items appear above new ones |
| Locus | `lista.component.ts` comparator |
| Meccanismo | Compares display string, not timestamp |
| Invariante rotta | Expected: `datOra` desc; Actual: locale string asc |
| Delta | `localeCompare(label)` → `b.datOra - a.datOra` |
| Superficie | comparator in lista component |
| Ereditarietà | n/a (local sort) |
| Residuo | Ties keep insertion order |

### Act
1. Reproduce with two known dates
2. Read comparator — confirm string compare
3. Change to timestamp compare + nulls last
4. Verify: same two rows flip order

### One-liner
Sort by the timestamp field, not by the formatted label.

---

## Example C — prototype algorithm (sliding window)

### Frame
- Goal: max sum of any contiguous subarray of length k
- Kind: algo
- Budget: yes
- Invariant: window size always k; O(n) time

### Bits

| Slot | Bit |
|------|-----|
| Sintomo | Nested loops too slow / wrong on negatives |
| Locus | `maxSumWindow(arr, k)` |
| Meccanismo | Re-sums window each step O(nk); or drops negatives badly |
| Invariante rotta | Spec: contiguous length k; naive skips constraint |
| Delta | O(nk) rescan → O(n) sliding: add right, remove left |
| Superficie | one function + 3 assert cases |
| Ereditarietà | callers unchanged if signature stable |
| Residuo | k≤0 / k>n → define empty/error explicitly |

### Act
1. Write failing example: `[2,1,5,1,3,2], k=3` → `9`
2. Change to sliding window
3. Verify example + edge `k=1`, `k=n`

### One-liner
Keep a running window sum: enter right, leave left, track max.
