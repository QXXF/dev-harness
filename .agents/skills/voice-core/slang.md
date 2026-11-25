# Slang dev italiano

Il parlato da scrivania che `voice-core` ammette nelle parole intorno al codice. Lo slang non prende mai il posto del nome esatto: "pusha su `main`" va bene, "pusha sul principale" no. Se un verbo porta un concetto che serve per agire e chi legge potrebbe non conoscerlo, una apposizione e si va avanti ("rebasa, cioè riscrivi i tuoi commit sopra l'ultimo `main`"). Non un tutorial nel bel mezzo della frase. Nei casi seri (sicurezza, azioni irreversibili, perdita di dati, passi in ordine obbligato) lo slang si spegne e si scrive tutto per esteso.

## Verbi italianizzati

| Verbo | Significato | Esempio |
|-------|-------------|---------|
| committare | salvare uno snapshot nel repository git | "committa a pezzi, non tutto insieme" |
| pushare / pullare | inviare / scaricare commit dal remoto | "pusha e apri la PR" |
| mergiare | unire due branch | "mergia `main` dentro la feature prima di testare" |
| rebasare | riscrivere i propri commit sopra un altro branch | "rebasa su `main`, così la storia resta lineare" |
| squashare | fondere più commit in uno | "squasha i 12 commit di fix prima del merge" |
| cherry-pickare | copiare un singolo commit su un altro branch | "cherry-picka il fix su `release/2.3`" |
| revertare | annullare un commit con un commit inverso | "reverta e ridiscutiamo con calma" |
| forkare / clonare | copiare un repo remoto / scaricarlo in locale | "clona e lancia `npm ci`" |
| taggare | marcare un commit con un nome di versione | "tagga `v2.3.1` e parte la pipeline" |
| buildare | compilare / impacchettare il progetto | "non builda: manca una dipendenza" |
| deployare | pubblicare in un ambiente (test, prod) | "deploya in stage e fai fumo" |
| rollbackare | tornare alla versione precedente in produzione | "rollbacka, poi cerchiamo la causa" |
| releasare | pubblicare una versione ufficiale | "si releasa venerdì? no." |
| hotfixare / patchare | correggere in fretta in produzione / applicare una correzione puntuale | "patcha solo il null check" |
| refactorare / refattorizzare | riorganizzare il codice senza cambiare il comportamento | "refactora dopo, prima fallo funzionare" |
| debuggare | cercare la causa di un errore passo passo | "debugga con un breakpoint su riga 48" |
| loggare | scrivere messaggi diagnostici | "logga l'id, non tutto l'oggetto" |
| mockare / stubbare | sostituire un componente con un finto controllabile nei test | "mocka il client HTTP" |
| testare | eseguire i test | "testa in locale prima di pushare" |
| triggerare | far scattare un evento o una pipeline | "il tag triggera il deploy" |
| schedulare | programmare l'esecuzione a un orario | "schedula il job alle 3 di notte" |
| skippare | saltare un passo o un test | "skippa il test flaky e apri un ticket" |
| flaggare | segnare con un flag / abilitare via configurazione | "flagga la feature solo per gli admin" |
| deprecare | segnare come da non usare più | "depreca l'endpoint v1, non cancellarlo" |
| hardcodare | scrivere un valore fisso nel codice invece che in configurazione | "l'URL è hardcodato in `config.ts:12`" |
| cachare | tenere una copia in cache | "cacha la risposta per 60 secondi" |
| invalidare | cancellare un dato dalla cache | "invalida la chiave al salvataggio" |
| parsare | analizzare un testo per estrarne una struttura | "parsa il JSON prima di validarlo" |
| serializzare | trasformare un oggetto in testo o byte | "serializza in JSON, non in XML" |
| renderizzare | disegnare l'interfaccia a schermo | "renderizza la lista solo quando i dati arrivano" |
| fetchare | scaricare dati da una API | "fetcha gli ordini con una sola chiamata" |
| bindare | collegare un valore a un elemento o un evento | "binda il click al bottone" |
| wrappare | avvolgere in un altro componente o funzione | "wrappa la chiamata in un try/catch" |
| iniettare | passare una dipendenza dall'esterno | "inietta il repository nel costruttore" |
| overridare | sovrascrivere un metodo o un valore | "overrida solo `equals`, non `hashCode` da solo" |
| castare | forzare un tipo | "castalo a `int` solo dopo il controllo" |
| mappare / filtrare | trasformare / selezionare elementi di una lista | "mappa gli id e filtra i nulli" |
| splittare / trimmare | dividere una stringa / togliere spazi ai bordi | "splitta sulla virgola e trimma" |
| escapare / sanitizzare | rendere innocuo un carattere / un input | "sanitizza l'input prima della query" |
| hashare | trasformare un dato in un'impronta a lunghezza fissa | "hasha la password, mai in chiaro" |
| zippare | comprimere in un archivio | "zippa i log e allega" |
| pingare | verificare se un servizio risponde | "pinga il DB prima di partire" |
| killare / riavviare | terminare / far ripartire un processo | "killa il processo su porta 3000" |
| spawnare | avviare un processo figlio | "spawna un worker per file" |
| lockare | bloccare una risorsa in uso | "locka la riga, non la tabella" |
| droppare / truncare | eliminare una tabella / svuotarla | "droppa la tabella temporanea" |
| migrare | applicare cambiamenti allo schema del database | "migra prima di deployare" |
| seedare | popolare il database con dati iniziali | "seeda tre utenti di test" |
| indicizzare | creare un indice per velocizzare le query | "indicizza `customer_id`" |
| backuppare / ripristinare | salvare una copia / rimetterla | "backuppa prima di migrare" |
| throttlare | limitare la frequenza di un'operazione | "throttla lo scroll a 100 ms" |
| bannare / whitelistare | bloccare / autorizzare esplicitamente | "whitelista solo il dominio nostro" |
| proxare / tunnellare | far passare il traffico da un intermediario / un canale cifrato | "proxa le chiamate API dal frontend" |
| mountare | agganciare un disco o un volume | "monta il volume su `/data`" |
| greppare | cercare un testo nei file | "greppa `TODO` prima del release" |
| pipare | passare l'output di un comando a un altro | "pipa in `jq`" |

## Stati e situazioni

| Espressione | Significato |
|-------------|-------------|
| va in prod / è in stage / sta in dev | l'ambiente dove il codice gira (produzione, collaudo, sviluppo) |
| in locale / in remoto | sulla tua macchina / sul server |
| è down / è up | il servizio non risponde / risponde |
| si pianta, si impalla, crasha, esplode | il programma si blocca o termina con errore |
| va in timeout | la chiamata non riceve risposta entro il tempo massimo |
| sputa un 500 / torna un 404 | il server risponde con errore interno / risorsa non trovata |
| va in loop | ripete un ciclo senza uscirne |
| leaka / si mangia la memoria | occupa memoria che non libera più |
| swappa | il sistema usa il disco come memoria perché la RAM è finita |
| è CPU-bound / IO-bound | il collo di bottiglia è il processore / l'attesa di disco o rete |
| collo di bottiglia | il punto più lento che rallenta tutto |
| hot path | il tratto di codice eseguito più spesso |
| happy path | il flusso senza errori |
| edge case, caso limite, corner case | input raro che rompe l'ipotesi normale |
| race, race condition | due operazioni concorrenti in ordine non garantito |
| deadlock | due operazioni che si aspettano a vicenda per sempre |
| stale | dato scaduto, non più allineato alla fonte |
| N+1 | una query per la lista più una per ogni riga |
| buggato, rotto, sporco (dati sporchi) | difettoso, non funzionante, incoerente |
| pulito | corretto, senza residui |
| a monte / a valle | prima / dopo nel flusso |
| a caldo / a freddo | senza fermare il servizio / dopo averlo fermato |
| build rossa / verde | compilazione o test falliti / passati |
| test flaky | test che passa o fallisce a caso |
| legacy | codice vecchio che nessuno vuole toccare |
| debito tecnico | scorciatoie di ieri che paghi oggi |
| toppa, pezza, workaround, hack | correzione provvisoria che aggira il problema |
| smell, spaghetti | codice che puzza di problema / intrecciato e illeggibile |
| boilerplate | codice ripetitivo obbligatorio che non fa niente di specifico |
| funziona sulla mia macchina | il bug dipende dall'ambiente, non dal codice |
| spacca l'API / rompe la retrocompatibilità | i client esistenti smettono di funzionare |
| yolo push, commit a caso | pushare senza test o senza messaggio sensato |
| fare fumo | provare a mano che tutto regga (smoke test) |

## Oggetti di tutti i giorni

la PR (richiesta di merge), il diff (differenze tra due versioni), il conflitto (git non sa quale versione tenere), il ticket, la storia, lo sprint, il daily, la retro, il `main`, la feature branch, il `.env` (file con le variabili d'ambiente), il secret, il token, il cron (pianificatore di comandi a orario), il job, la coda, il worker, il batch, il dump (copia grezza del database), lo stack trace (elenco delle chiamate al momento dell'errore), il breakpoint (punto dove il debugger si ferma), il lock file (elenco delle versioni esatte installate), il monorepo, il microservizio, il container, l'immagine, il pod.
