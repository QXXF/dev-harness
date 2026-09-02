# Template — Flow Mirror document

Copy and fill. Delete unused sections. Keep Endpoint blocks next to the UI moment.

```markdown
# Specchio UI/UX — <Nome feature>

Questo documento descrive **il risultato <TO-BE | AS-IS>**: cosa l’utente deve
poter fare, schermata per schermata. Leggibile a pezzi: titoli = spina dorsale;
sotto, dettagli; scatole **Endpoint** = contratto HTTP.

**Mode:** TO-BE | AS-IS | DELTA
**Entry:** <route> + <controllo UI>
**Assunzioni:** …
**Fuori scope:** …

---

## 0. Come ci arrivi

### Rotta attiva
`<route esatta>`

### Percorso click-by-click
1. …
2. …
3. … ← controllo che apre la feature

---

## 1. <Nome vista / tab / accordion>

### Cosa vedi
Layout (accordion / tabs / master-detail / modal). Allineamento AS-IS: …

### Cosa leggi
- Titolo: `…`
- Help (copy proposto): `…`
- Empty state: `…`

### Bottoni

| Bottone | Posizione | Visibile quando | Azione |
|---------|-----------|-----------------|--------|
| | | | |

### Tabelle

| Colonna (label) | Contenuto | Chi popola |
|-----------------|-----------|------------|
| | | |

### Form / input

| Campo | Tipo | Obbl. | Validazione | Prevalorizzato da |
|-------|------|-------|-------------|-------------------|
| | | | | |

### Endpoint

| Quando | Method | Path | AS-IS / PROPOSTO |
|--------|--------|------|------------------|
| load vista | GET | | |
| salva | POST/PUT | | |
| elimina | DELETE | | |
| download | GET | | |

### Stati UI
loading / empty / readonly / error / …

---

## 2. <Prossima tappa>
… ripeti lo stesso scheletro …

---

## N. Percorso utente felice (narrativo)
<≤12 frasi, attore primario>

## Matrice endpoint (indice)

### Lettura (GET)
| Quando in UI | Path | Note |

### Scrittura (POST / PUT / DELETE)
| Azione UI | Path | Note |

### Endpoint AS-IS di supporto
| Uso | Path |

## Checklist QA / demo
- [ ] …
```
