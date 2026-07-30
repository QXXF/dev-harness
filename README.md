# Dev Harness

Skill per agenti LLM (Cursor, Codex) usate nel workflow di sviluppo. Fonte di verita unica: `.agents/skills/`, versionata nel repo e collegata via symlink alle installazioni globali.

## Skill

| Skill | Attivazione | Cosa fa |
|-------|-------------|---------|
| `dev-core` | sempre attiva | ingegnere generalista senior: soluzioni minimali (YAGNI, stdlib first), risposte dirette, prosa compatta |
| `code-integrity-audit` | on-demand | audit di integrita: stato accoppiato, contratti, sicurezza, concorrenza, operazioni appaiate |
| `design-core` | on-demand | craft UI/frontend: accessibilita, layout, tipografia, colori, polish e design review |
| `breakdown` | on-demand | scompone qualsiasi problema/soluzione in bit atomici + sequenza operativa: spiegazione comprensibile a chiunque, zero gergo |
| `node` | contestuale | esegue npm/node via alias `node;` (fnm) nel terminale agent |

`.legacy/` contiene i vecchi harness monolitici, sostituiti dalle skill.

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
