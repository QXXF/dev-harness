# Skills Harness

Raccolta di harness per agenti LLM usati nel workflow di sviluppo.

## File

- `agent-generalist.md` - agente senior generalista per sviluppo frontend, backend, mobile nativo e automazione.
- `style-caveman.md` - stile di comunicazione compatto, configurabile per intensita.
- `audit-code-integrity.md` - lente di audit per correttezza, invarianti, stato e regressioni.
- `.agents/skills/generalist-engineer/SKILL.md` - skill Codex portabile per agente generalista.
- `.agents/skills/compact-communication/SKILL.md` - skill Codex portabile per comunicazione compatta.
- `.agents/skills/code-integrity-audit/SKILL.md` - skill Codex portabile per audit di integrita del codice.

## Uso consigliato

Usa `agent-generalist.md` come base. Aggiungi `style-caveman.md` quando vuoi output piu asciutto. Aggiungi `audit-code-integrity.md` quando il lavoro tocca stato, contratti, sicurezza, concorrenza, dati o logica critica.

## Skill Codex

Le skill sono installate globalmente in:

```text
C:\Users\giuliano.gangemi\.codex\skills
```

Invocazione esplicita:

```text
Use $generalist-engineer to implement this task.
Use $compact-communication to keep the answer terse.
Use $code-integrity-audit to review this change.
```

La copia sotto `.agents/skills` e versionata nel repo, cosi puo essere copiata o sincronizzata in altri ambienti Codex.

## Cursor (globale)

In Cursor ci sono due modi per usare questo harness in tutti i progetti:

| Tipo | Percorso globale | Cosa fa |
|---|---|---|
| Skill | `~/.cursor/skills/` | Invocabili con `$nome-skill` in chat |
| Subagent | `~/.cursor/agents/` | Agenti specializzati delegabili dal Task tool |

Installazione consigliata (symlink al repo, una sola fonte di verita):

```bash
chmod +x scripts/install-cursor-global.sh
./scripts/install-cursor-global.sh
```

Lo script:

- collega `.agents/skills/*` in `~/.cursor/skills/`
- genera i subagent in `~/.cursor/agents/` a partire da `agent-generalist.md`, `style-caveman.md` e `audit-code-integrity.md`

Dopo l'installazione, riapri la chat o riavvia Cursor.

Invocazione esplicita in chat:

```text
Use $generalist-engineer to implement this task.
Use $compact-communication to keep the answer terse.
Use $code-integrity-audit to review this change.
```

Invocazione subagent:

```text
Use the generalist-engineer subagent to implement this feature.
Use the code-integrity-audit subagent to review this diff.
```

Installazione manuale alternativa:

```bash
mkdir -p ~/.cursor/skills
ln -sfn "$(pwd)/.agents/skills/generalist-engineer" ~/.cursor/skills/generalist-engineer
ln -sfn "$(pwd)/.agents/skills/compact-communication" ~/.cursor/skills/compact-communication
ln -sfn "$(pwd)/.agents/skills/code-integrity-audit" ~/.cursor/skills/code-integrity-audit
```

Nota: non mettere skill personali in `~/.cursor/skills-cursor/`; quella cartella e riservata a Cursor.
