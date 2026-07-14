# Skills Harness

Raccolta di harness per agenti LLM usati nel workflow di sviluppo.

## File

- `.agents/skills/dev-core/SKILL.md` - skill principale, sempre attiva: ingegnere generalista senior, soluzioni minimali (YAGNI, stdlib first), risposte dirette e prosa compatta. Fonde le ex skill generalist-engineer, ponytail, direct-answers e compact-communication.
- `.agents/skills/code-integrity-audit/SKILL.md` - skill on-demand per audit di integrita del codice.
- `.agents/skills/node/SKILL.md` - skill contestuale: esegue npm/node via alias `node;` (fnm) nel terminale agent.
- `.legacy/` - vecchi harness monolitici, sostituiti dalle skill.

## Uso consigliato

`dev-core` copre il lavoro quotidiano. `code-integrity-audit` si lancia su richiesta quando il lavoro tocca stato, contratti, sicurezza, concorrenza, dati o logica critica. `node` scatta da sola quando serve npm/node nel terminale.

## Skill Codex

Le skill sono installate globalmente in:

```text
C:\Users\giuliano.gangemi\.codex\skills
```

Invocazione esplicita:

```text
Use $dev-core as the default engineering and communication mode.
Use $code-integrity-audit to review this change.
Use $node when running npm or node in the shell.
```

La copia sotto `.agents/skills` e versionata nel repo, cosi puo essere copiata o sincronizzata in altri ambienti Codex.

## Cursor (globale)

Le skill vanno in `~/.cursor/skills/` e sono invocabili con `$nome-skill` in chat.

Installazione consigliata (symlink al repo, una sola fonte di verita):

```bash
chmod +x scripts/install-cursor-global.sh
./scripts/install-cursor-global.sh
```

Lo script collega `.agents/skills/*` in `~/.cursor/skills/` e rimuove skill e subagent obsoleti delle versioni precedenti.

Dopo l'installazione, riapri la chat o riavvia Cursor.

Invocazione esplicita in chat:

```text
Use $dev-core as the default engineering and communication mode.
Use $code-integrity-audit to review this change.
Use $node when running npm or node in the shell.
```

Rule Cursor consigliata (User Rules, una riga):

```text
Segui sempre la skill dev-core. Usa node per comandi npm/node e code-integrity-audit quando chiedo audit o review.
```

Installazione manuale alternativa:

```bash
mkdir -p ~/.cursor/skills
ln -sfn "$(pwd)/.agents/skills/dev-core" ~/.cursor/skills/dev-core
ln -sfn "$(pwd)/.agents/skills/code-integrity-audit" ~/.cursor/skills/code-integrity-audit
ln -sfn "$(pwd)/.agents/skills/node" ~/.cursor/skills/node
```

Nota: non mettere skill personali in `~/.cursor/skills-cursor/`; quella cartella e riservata a Cursor.
