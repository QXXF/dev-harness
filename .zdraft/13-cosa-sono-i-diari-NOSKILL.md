# Cosa sono i «diari» in quest’app

Nel codice e nella documentazione di quest’app, **«diari»** (al plurale) sono quasi sempre i **diari degli operatori** delle **convenzioni Enti in House** (EHO / FEFH), non un diario generico dell’applicazione.

## Cosa sono

Un diario è il **rendiconto mensile del lavoro** di una persona inserita in un **gruppo di lavoro** su una **micro-attività** di un progetto EHO.

Catena: progetto → macro → micro → figura professionale → gruppo di lavoro → partecipante → **un diario per ogni mese solare** coperto dal periodo di impegno.

In tabella: `TFE1503_DIARIOPERATORE` (`Tfe1503DiarioOperatore`). In UI: tab **Diari** su `#/convenzioni`, dettaglio `#/convenzioni/diari/:idDiario`.

Ogni diario porta, in sintesi:

- **chi / dove**: operatore, micro, progetto, anno, mese
- **cosa ha fatto**: giornate con ore e descrizione; da lì escono periodo, ore totali e giornate (7,20 h/gg interni, 6 h/gg esterni)
- **documento PDF** (oggi generato dal sistema, non caricato a mano)
- **stato di validazione**

Stati: **Da inserire** → **In attesa di validazione** → **Validato** oppure **Rigettato**. C’è anche **Non previsto** (mese senza produzione diario).

## Chi li usa

| Ruolo | Cosa fa |
|--------|---------|
| **Operatore Diari** | Partecipante del gruppo: compilazione dei propri diari |
| **Operatore inserimento dati** | Supporto alla compilazione |
| **Responsabile del progetto** | Valida o rigetta |
| **Gestore Ente in House** | Super-user su tutte queste funzioni |

INVALSI li gestisce in piattaforma; per INDIRE è prevista (P2) l’acquisizione dei diari già validati via web service.

## Perché esistono

Servono a **documentare e far validare il lavoro mensile** degli operatori sulle micro-attività. Un diario **In attesa** o **Validato** **blocca** eliminazioni/modifiche pesanti su micro, figura o partecipante.

Insieme agli **Output** (Piano di progetto, Output realizzati, Relazione periodica) formano il blocco funzionale «Diari ed Output» dell’AR FEFH.

## Cosa non sono

- **Non** è la **diaria FSE** (`Tfe1435`): altro dominio, altro significato (indennità).
- **Non** è il **diario dell’attività** dei moduli FSE/FESR in Realizzazione progetti (`desDia` / «diario dell’attività» per le presenze): lì è una nota testuale sull’attività del modulo, non il flusso EHO.

Nel repo, la cartella `frontend/documentazione-diari/` parla **solo** dei diari EHO.
