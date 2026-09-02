# Examples — Flow Mirror

## Golden sample (real project)

Full discursive mirror after CERT EHO analysis (Angular + Spring):

`FEPN-GestioneFondi2027-WEB/frontend/documentazione-cert/07-flusso-ui-ux-completo.md`

What to copy from that sample:

- Opening says TO-BE + skimmable contract
- Entry via existing tab (not a new app shell)
- Accordion reuse called out explicitly
- Forms include validation + prefill source
- Endpoints appear **at the action** and again in a matrix
- Paths marked as proposed vs existing support APIs
- Happy-path narrative + QA checklist at the end

## Minimal excerpt (shape only)

```markdown
# Specchio UI/UX — Notifiche progetto

Mode: TO-BE. Entry: `#/progetti/:id` → tab **Notifiche**.

## 0. Come ci arrivi
Rotta attiva: `#/progetti/42`
Click: lista progetti → Apri → tab Notifiche (4° step).

## 1. Lista notifiche (accordion aperto)
Cosa vedi: stesso `accordion-card` del tab Documenti.
Cosa leggi: titolo `Notifiche`; empty `Nessuna notifica per questo progetto.`

Bottoni: **Nuova notifica** (header accordion, destra) → apre form.

Tabella: Data | Oggetto | Stato | Azioni(Apri)
Popola: `GET notify/progetti/{id}/items` (PROPOSTO)

## 2. Form notifica (modale)
| Campo | Tipo | Obbl. | Validazione | Prefill |
|-------|------|-------|-------------|---------|
| Oggetto | text | sì | max 120 | vuoto |
| Testo | textarea | sì | max 2000 | vuoto |

Endpoint: `POST notify/progetti/{id}/items` (PROPOSTO) al conferma.
Supporto AS-IS: `GET progetti/{id}` per titolo in header modale.
```

## Bad vs good

| Bad | Good |
|-----|------|
| “Ci sarà un’API per salvare” | `PUT cert/.../rend` al click **Salva REND** |
| Solo user story | Tappa con rotta + bottoni + form + HTTP |
| Nuovo layout inventato | “Stesso accordion del tab Gestione” |
| Stati inventati | “Stati oltre Inviata: da AR (decisione aperta)” |
