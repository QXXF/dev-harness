# Perché `voice-core` ha un budget cognitivo

Questa nota è per chi tocca la skill, non per chi la applica a una risposta.

## Cosa si è rotto

La voce era già quella giusta: un collega a tavolo, prosa, nomi esatti, niente elenchi da slide. Il buco era la lunghezza e la densità. "Uno o due paragrafi brevi" e, per i casi intricati, "qualche paragrafo" venivano letti come permesso a scrivere un saggio. "Spiega ogni termine al volo" e "se tre punti stanno in una frase, scrivi la frase" impilavano definizioni, cause, eccezioni e fix nello stesso fiato.

Il risultato, a fine giornata, era un muro di testo. Impilare concetti eterogenei è cheap per un modello e caro per una mente che ha già sviluppato per 16 ore. Chi voleva shippare una feature si trovava a leggere il manuale più duro della giornata.

Gli esempi "giusti" della skill precedente erano parte del bug: quattro o cinque frasi dense, copiate come gold standard.

## Cosa non è la cura

Tagliare fino all'oracolo. "N+1 in `OrderService.java:48`. Fai join fetch." è corto e illeggibile in un altro modo: manca la premessa (lazy `getCustomer()` nel ciclo, 201 query, join solo su quella schermata). Chi legge deve ricostruire il ragionamento che la macchina ha già fatto. Quello è ermetico, e resta vietato.

Vietato anche nascondere un'alternativa scartata se il lettore la proverebbe. La completezza è "ogni premessa portante compare", non "ogni pensiero del modello compare". Un fatto che non cambia né la fiducia né l'azione resta fuori. Un fatto su cui poggia la conclusione entra, in una frase sua.

## Il contratto nuovo

Sintetico: solo le nozioni che spostano la decisione o l'azione. Univoco: la frase è vera su questo file, questo bug, questo repo, non un consiglio generico. Comprensibile: una idea per paragrafo, una apposizione per termine, spazio bianco tra i concetti.

Tetto a 3 paragrafi di prosa continua, 2–4 frasi l'uno, prima frase = risposta. I formati espliciti (audit, `flow-mirror`, `/breakdown`, un documento chiesto) tengono lo scheletro; il budget vale dentro ogni sezione.

`dev-core` e le altre skill restano padroni del contenuto e dell'ordine. `voice-core` resta padrone del registro e, da questa revisione, del budget della pagina. Completezza e lunghezza non sono la stessa cosa.
