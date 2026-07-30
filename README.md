# Dev Harness

Skill per agenti LLM (Cursor, Codex) usate nel workflow di sviluppo. Fonte di verita unica: `.agents/skills/`, versionata nel repo e collegata via symlink alle installazioni globali.

## Installazione — Cursor (globale)

Le skill vanno in `~/.cursor/skills/`. Installazione consigliata (symlink al repo):

```bash
chmod +x scripts/install-cursor-global.sh
./scripts/install-cursor-global.sh
```

Lo script collega `.agents/skills/*` in `~/.cursor/skills/` e rimuove skill e subagent obsoleti delle versioni precedenti. Dopo l'installazione, riapri la chat o riavvia Cursor.

Installazione manuale alternativa:

```bash
mkdir -p ~/.cursor/skills
for s in dev-core code-integrity-audit design-core breakdown node; do
  ln -sfn "$(pwd)/.agents/skills/$s" ~/.cursor/skills/$s
done
```

Nota: non mettere skill personali in `~/.cursor/skills-cursor/`; quella cartella e riservata a Cursor.  


## Skill

### `dev-core` — sempre attiva

Modalita operativa quotidiana: ingegnere generalista senior.

- Soluzioni minimali (YAGNI, stdlib first, diff piu corto possibile in produzione)
- Risposte dirette (verdetto nella prima frase), prosa compatta
- Ladder di decisione: esiste gia? → stdlib → dipendenza installata → minimo codice nuovo
- Bug = causa radice, non sintomo

Usa su ogni task di coding e su ogni domanda tecnica. Le altre skill si appoggiano a questa.

### `code-integrity-audit` — on-demand

Audit di correttezza prima del release: stato accoppiato, contratti, sicurezza, concorrenza.

- Lenti Feynman (invariante, ordine, assunzioni, fallimento a meta) e State (coppie cache↔source, count↔collection, …)
- Parita operazioni appaiate (create/delete, enable/disable, …)
- Pipeline dual-pass su richiesta esplicita (`audit`, `review`, `nemesis`, `Feynman`, …)

Scatta quando il lavoro tocca mutazione di stato, API pubbliche, persistenza, auth o quando chiedi una review formale.

### `design-core` — on-demand

Craft UI/frontend: costruire e revisionare interfacce con disciplina da generalista.

- Domini: accessibilita, layout, tipografia, colori (OKLCH/contrasto), polish (radius, ombre, motion, icone)
- Rispetta sempre il design system del progetto: nessun secondo approccio per un fix isolato
- Review: fondazioni prima del polish; findings con evidenza `file:riga`; verdetto Block / Needs changes / Approve

Usa quando costruisci componenti, stili pagine, o chiedi una design/UI review.

### `breakdown` — on-demand

Scompone qualsiasi problema e la sua soluzione in bit atomici e una sequenza operativa ordinata.

- Schema fisso: Frame → 8 bit (sintomo, locus, meccanismo, invariante, delta, …) → Act ≤7 passi → one-liner
- Zero gergo non definito; un'idea per bit; comprensibile a chiunque
- Funziona prima (piano), durante (sterzo) e dopo (handoff / PR summary)

Usa su `breakdown`, `scomponi`, `spiegami il fix`, `handoff`, `schema`, o dopo un fix non banale. Companion di `dev-core`: questa skill dice come *vedere* il problema, `dev-core` come *codificarlo*.

### `node` — contestuale

Fa funzionare Node/npm nel terminale agent via alias `node;` (fnm version select).

```bash
node; npm test
node; npx tsc --noEmit
```

Scatta da sola quando serve `npm`/`node`/`npx` o quando `node` non e in PATH.

---

`.legacy/` contiene i vecchi harness monolitici, sostituiti dalle skill.  


## Installazione — Codex

Le skill vanno in `C:\Users\giuliano.gangemi\.codex\skills`: copia o sincronizza le directory da `.agents/skills/`. Ogni skill include `agents/openai.yaml` con display name e prompt di default per l'interfaccia Codex.

## Invocazione esplicita

```text
Use $dev-core as the default engineering and communication mode.
Use $code-integrity-audit to review this change.
Use $design-core for UI/frontend work or design reviews.
Use $breakdown to decompose and explain a problem or solution.
Use $node when running npm or node in the shell.
```



## User rule consigliata (Cursor, una riga)

```text
Segui sempre la skill dev-core. Usa node per comandi npm/node, code-integrity-audit quando chiedo audit o review, design-core per lavoro UI/frontend e breakdown quando chiedo di scomporre o spiegare un problema.
```

