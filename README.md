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
