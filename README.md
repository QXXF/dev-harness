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
for s in dev-core voice-core code-integrity-audit design-core breakdown flow-mirror node; do
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

### `voice-core` — sempre attiva (layer)

Modula la prosa della risposta finale di tutte le altre skill. Non tocca il ragionamento, il codice, i path, i token letterali.

- Nome di tutti i giorni prima del gergo; ogni termine definito al primo uso (zero gatekeeping)
- Italiano a soggetto-verbo-oggetto, niente giri di parole; dove e perché su ogni operazione
- Fino a 3 termini inline, dal quarto un blocco `Termini:` in coda
- Slang dev italiano ammesso nel tessuto (`slang.md`); spento su sicurezza, perdita dati, passi in ordine obbligato

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

### `breakdown` — on-demand

Scompone un problema e la sua soluzione in 8 bit (una riga ciascuno) e una sequenza operativa ≤7 passi. Stesso schema ogni volta: Frame → Bits → Act → one-liner.

Usala su `breakdown`, `scomponi`, `spiegami il fix`, `handoff`, `schema`, o dopo un fix non banale. Modalità discorsiva (stessa sostanza in 1-2 paragrafi, senza tabella) su `discorsivo`, `umano`, `per il mio manager`, `in un paragrafo`. Companion di `dev-core`: questa skill dice come *vedere* il problema, `dev-core` come *codificarlo`.

### `flow-mirror` — on-demand

Specchio UI/UX end-to-end del risultato (di solito TO-BE a fine analisi): rotte, click, schermate, copy, bottoni, tabelle, form (validazioni + prevalorizzazioni), endpoint GET/POST/PUT/DELETE agganciati a ogni interazione.

- Prosa discorsiva e operativa, leggibile a pezzi (titoli = spina dorsale)
- Ancora i pattern UI AS-IS del progetto (tab, accordion, toolbar) invece di inventare shell nuove
- Distingue path **AS-IS** vs **PROPOSTO**; non inventa stati di business assenti dalle fonti
- Template + esempi in `template.md` / `examples.md` (golden sample: CERT EHO `07-flusso-ui-ux-completo.md`)

Usala a fine analisi tecnica su `flusso UI/UX`, `specchio funzionale`, `walkthrough schermate`, `contratto interazioni`, `mappa endpoint`, o quando serve un handoff implementabile FE/BE. Companion: `breakdown` vede il problema, `design-core` valuta il craft UI, `flow-mirror` fissa il contratto di interazione.

### `node` — contestuale

Fa funzionare Node/npm nel terminale agent via alias `node;` (fnm version select).

```bash
node; npm test
node; npx tsc --noEmit
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
Use $breakdown to decompose and explain a problem or solution.
Use $flow-mirror for the complete FE/BE UI/UX flow mirror.
Use $node when running npm or node in the shell.
```

## Hook — user rule Cursor

Le skill in `~/.cursor/skills/` sono visibili all'agente, ma non tutte si caricano da sole: scattano se la `description` della skill combacia col messaggio, o se le invochi con `$nome`. L'**hook** è una user rule (regola globale di Cursor: testo iniettato in ogni chat, in ogni progetto) che dice quali skill sono sempre on e quali scattano a richiesta.

Cursor la tiene nei settings dell'account, non in un file del disco. Per aggiornarla: **Cursor Settings → Rules → User Rules**, sostituisci il blocco intero. Poi apri una chat nuova.

```text
Segui sempre le skill dev-core e voice-core. Usa la skill node per comandi npm/node, code-integrity-audit quando chiedo audit o review, design-core per lavoro UI/frontend (layout, colori, tipografia, accessibilità, animazioni, review di design), breakdown quando chiedo di scomporre o spiegare un problema, e flow-mirror a fine analisi quando serve lo specchio UI/UX completo.
```

Rispetto all'hook precedente: `voice-core` è sempre attiva insieme a `dev-core` (layer sulla prosa della risposta finale, non sul ragionamento). Restano `node`, `code-integrity-audit` e `design-core` con gli stessi trigger. Aggiunti `breakdown` e `flow-mirror`, che prima dipendevano solo dal match della description.

In questo repo la stessa riga vive in `.cursor/rules/skills.mdc` (`alwaysApply: true`), così le chat sul harness la caricano anche senza la user rule. Negli altri progetti serve l'incolla in User Rules.
