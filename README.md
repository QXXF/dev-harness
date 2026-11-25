# Dev Harness

Skill per agenti LLM (Cursor, Codex) nel workflow di sviluppo. Fonte di verità unica: `.agents/skills/`, versionata nel repo e collegata via symlink alle installazioni globali.

## Installazione — Cursor (globale)

Le skill vanno in `~/.cursor/skills/`. Installazione consigliata (symlink al repo):

```bash
chmod +x scripts/install-cursor-global.sh
./scripts/install-cursor-global.sh
```

Lo script collega `.agents/skills/*` in `~/.cursor/skills/` e rimuove skill e subagent obsoleti. Poi riapri la chat o riavvia Cursor.

Installazione manuale:

```bash
mkdir -p ~/.cursor/skills
for s in dev-core voice-core code-integrity-audit design-core breakdown flow-mirror nxd; do
  ln -sfn "$(pwd)/.agents/skills/$s" ~/.cursor/skills/$s
done
```

Non mettere skill personali in `~/.cursor/skills-cursor/`: quella cartella è riservata a Cursor.

## Skill

### `dev-core` — sempre attiva

Modalità operativa quotidiana: ingegnere generalista senior.

- Soluzioni minimali (YAGNI, stdlib first, diff più corto possibile in produzione)
- Risposte dirette (verdetto nella prima frase), prosa compatta
- Ladder di decisione: esiste già? → stdlib → dipendenza installata → minimo codice nuovo
- Bug = causa radice, non sintomo

Usala su ogni task di coding e su ogni domanda tecnica. Le altre skill si appoggiano a questa.

### `voice-core` — sempre attiva (precede sul registro)

Decide come suona la risposta finale e, su questo, prevale sulle altre skill: loro decidono cosa fare e quali fatti devono comparire, lei il registro e il budget cognitivo della pagina. Non tocca il ragionamento, il codice, i path, i token letterali.

- Sintetico, non ermetico: solo le nozioni che spostano decisione o azione; le premesse portanti restano visibili, in una frase loro
- Una idea per paragrafo corto (tetto 3 paragrafi di prosa continua); prima frase = risposta; niente muri di testo
- Paragrafi di default; elenchi solo se chiesti o per vere sequenze di passi
- Italiano con soggetto e verbo chiari; un termine si spiega al volo solo se serve per agire
- Esempi sbagliato/giusto in `SKILL.md` (muro vs ermetico vs giusto); slang in `slang.md`; il perché della revisione in `rationale.md`

Usala su ogni risposta finale. Chi la copia può agganciarla all'hook (user rule di Cursor) o invocarlo con `$voice-core`. Vedi [Hook](#hook--user-rule-cursor).

### `code-integrity-audit` — on-demand

Audit di correttezza prima del release: stato accoppiato, contratti, sicurezza, concorrenza.

- Lenti Feynman (invariante, ordine, assunzioni, fallimento a metà) e State (coppie cache↔source, count↔collection, …)
- Parità operazioni appaiate (create/delete, enable/disable, …)
- Pipeline dual-pass su richiesta esplicita (`audit`, `review`, `nemesis`, `Feynman`, …)

Usala quando il lavoro tocca mutazione di stato, API pubbliche, persistenza, auth, o quando chiedi una review formale.

### `design-core` — on-demand

Craft UI/frontend: costruire e revisionare interfacce.

- Domini: accessibilità, layout, tipografia, colori (OKLCH/contrasto), polish (radius, ombre, motion, icone)
- Rispetta sempre il design system del progetto: nessun secondo approccio per un fix isolato
- Review: fondazioni prima del polish; findings con evidenza `file:riga`; verdetto Block / Needs changes / Approve

Usala quando costruisci componenti, stili pagine, o chiedi una design/UI review.

### `breakdown` — opt-in (`/breakdown`)

Scompone un problema e la sua soluzione in 8 bit (una riga ciascuno) e una sequenza operativa ≤7 passi. Stesso schema ogni volta: Frame → Bits → Act → one-liner.

Si carica **solo** se la invochi con `/breakdown` o `$breakdown` (`disable-model-invocation: true`). Spiegare un problema senza quell'invoke è `voice-core`, non questo schema. Aggiungi `discorsivo` per 1-2 paragrafi senza tabella, ma solo dopo l'invoke.

### `flow-mirror` — on-demand

Specchio UI/UX end-to-end del risultato (di solito TO-BE a fine analisi): rotte, click, schermate, copy, bottoni, tabelle, form (validazioni + prevalorizzazioni), endpoint GET/POST/PUT/DELETE agganciati a ogni interazione.

- Prosa discorsiva e operativa, leggibile a pezzi (titoli = spina dorsale)
- Ancora i pattern UI AS-IS del progetto (tab, accordion, toolbar) invece di inventare shell nuove
- Distingue path **AS-IS** vs **PROPOSTO**; non inventa stati di business assenti dalle fonti
- Template + esempi in `template.md` / `examples.md` (golden sample: CERT EHO `07-flusso-ui-ux-completo.md`)

Usala a fine analisi tecnica su `flusso UI/UX`, `specchio funzionale`, `walkthrough schermate`, `contratto interazioni`, `mappa endpoint`, o quando serve un handoff implementabile FE/BE. Companion: `breakdown` vede il problema, `design-core` valuta il craft UI, `flow-mirror` fissa il contratto di interazione.

### `nxd` — contestuale

Fa funzionare Node/npm nel terminale agent via la function PowerShell `nxd`: inietta fnm (`fnm env --use-on-cd --shell powershell`) e pinna `v22.12` (`fnm use v22.12`).

```bash
nxd; npm test
nxd; npx tsc --noEmit
```

Scatta da sola quando serve `npm`/`node`/`npx` o quando `node` non è in PATH.

---

`.legacy/` contiene i vecchi harness monolitici, sostituiti dalle skill.

## Installazione — Codex

Le skill vanno in `~/.codex/skills`: copia o sincronizza le directory da `.agents/skills/`. Ogni skill include `agents/openai.yaml` con display name e prompt di default per l’interfaccia Codex.

## Invocazione esplicita

```text
Use $dev-core as the default engineering and communication mode.
Use $voice-core to shape the prose of the final answer.
Use $code-integrity-audit to review this change.
Use $design-core for UI/frontend work or design reviews.
Use $breakdown only when explicitly invoked (/breakdown or $breakdown).
Use $flow-mirror for the complete FE/BE UI/UX flow mirror.
Use $nxd when running npm or node in the shell.
```

## Hook — user rule Cursor

Le skill in `~/.cursor/skills/` sono visibili all'agente, ma non tutte si caricano da sole: scattano se la `description` della skill combacia col messaggio, o se le invochi con `$nome`. L'**hook** è una user rule (regola globale di Cursor: testo iniettato in ogni chat, in ogni progetto) che dice quali skill sono sempre on e quali scattano a richiesta.

Cursor la tiene nei settings dell'account, non in un file del disco. Per aggiornarla: **Cursor Settings → Rules → User Rules**, sostituisci il blocco intero. Poi apri una chat nuova.

```text
Segui sempre le skill dev-core e voice-core: le altre skill decidono cosa fare, voice-core decide come me lo racconti e prevale sul loro registro. Usa la skill nxd per comandi npm/node, code-integrity-audit quando chiedo audit o review, design-core per lavoro UI/frontend (layout, colori, tipografia, accessibilità, animazioni, review di design), e flow-mirror a fine analisi quando serve lo specchio UI/UX completo. Non usare breakdown a meno che la invoco con /breakdown o $breakdown.
```

Rispetto all'hook precedente: `voice-core` è sempre attiva insieme a `dev-core`. Restano `nxd`, `code-integrity-audit`, `design-core` e `flow-mirror` con gli stessi trigger. `breakdown` è opt-in: solo `/breakdown` o `$breakdown`, così non cozza con `voice-core` sulle spiegazioni.

In questo repo la stessa riga vive in `.cursor/rules/skills.mdc` (`alwaysApply: true`), così le chat sul harness la caricano anche senza la user rule. Negli altri progetti serve l'incolla in User Rules.
