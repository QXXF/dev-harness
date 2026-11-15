# Cosa sono i diari in quest'app

I **diari** sono i fogli mensili di lavoro degli operatori sui progetti delle convenzioni Enti in House (enti pubblici che lavorano “in house” per il Ministero, senza gara: INVALSI, INDIRE e simili). Un diario dice, per un mese, chi ha fatto cosa su quale micro-attività (il pezzo più piccolo del progetto), quante ore, e allega il documento da far validare.

Non sono un diario di bordo generico, e non sono la **diaria FSE** (`Tfe1435`: indennità giornaliera dei fondi FSE). Qui il nome è quello dell’AR *Diari ed Output EHO*.

**Una riga = un mese.** Chiave: operatore (partecipante al gruppo di lavoro) × micro-attività × anno-mese. Tabella `TFE1503_DIARIOPERATORE`. Dentro: periodo di attività, ore/giorni, descrizione, giornate (ore e testo giorno per giorno), PDF generato, stato.

**Ciclo.** L’operatore compila (o marca “non previsto”), chiede validazione, il Responsabile di progetto valida o rigetta. Stati: `DA_INSERIRE` → `IN_ATTESA` → `VALIDATO` o `RIGETTATO` (e `NON_PREVISTO`). Finché un diario è in attesa, validato o rigettato, quella micro non si elimina.

**Dove lo vedi.** Scheda Diari sulle convenzioni (`#/convenzioni`), dettaglio `#/convenzioni/diari/:idDiario`. Backend: `DiariEntiHouseController`. Documentazione in `frontend/documentazione-diari/` (indice: `README.md`).
