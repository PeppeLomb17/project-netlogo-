---

## 10. License

This project is released under the **MIT License**.  
You are free to use, modify, and distribute it for research and educational purposes, provided that appropriate credit is given.

---

## 11. Keywords

Agent-Based Modeling · NetLogo · Public Policy · Fiscal Dynamics ·  
Macroeconomics · Inequality · Debt Sustainability · Complex Systems

---

## 12. Future Developments

Planned extensions include:
- Sectoral differentiation of firms (industry, services, finance)  
- Labour market matching mechanisms  
- Behavioural adaptation through reinforcement learning  
- Integration with external data for calibration and validation  

---

---

# ProjectBEC – Un Modello ad Agenti delle Dinamiche Fiscali, Economiche e Sociali

**Dipartimento di Matematica e Informatica (DMI), Università di Catania**  
**Autore:** Giuseppe Lombardia  
**Anno:** 2025  
**Piattaforma:** NetLogo 6.x  

---

## 1. Panoramica

**ProjectBEC** (Behavioral Economic and Fiscal Model) è una **simulazione ad agenti** progettata per analizzare le interazioni tra cittadini, imprese e istituzioni pubbliche all’interno di un sistema macroeconomico regolato da tassazione, welfare e interventi della banca centrale.

Il modello offre una rappresentazione dinamica e “dal basso” dell’equilibrio fiscale, della disuguaglianza e della crescita sostenibile, mettendo in evidenza i **meccanismi di retroazione** tra comportamento individuale (evasione, produttività) e risultati macroeconomici (PIL, debito, qualità dei servizi pubblici).

Si differenzia dai modelli economici tradizionali integrando **dinamiche comportamentali**, **meccanismi di contagio sociale** e **politiche fiscali adattive**, fornendo un laboratorio moderno per lo studio della **resilienza economica** e della **stabilità sistemica**.

---

## 2. Motivazione Teorica

Mentre i modelli macroeconomici classici assumono razionalità aggregata e condizioni di equilibrio, ProjectBEC adotta la prospettiva dei **sistemi complessi adattivi**, in cui:
- Gli agenti seguono regole eterogenee e razionalità limitata.  
- Le politiche evolvono endogenamente in risposta agli indicatori macro.  
- Le crisi emergono dall’interazione degli attori, non da shock esterni.

Il modello cattura:
- Retroazioni fiscali tra evasione, debito e austerità.  
- Dinamiche sociali di fiducia e contagio nell’adempimento fiscale.  
- Transizioni macroeconomiche legate a demografia e investimenti.

---

## 3. Struttura del Modello

### Agenti
| Tipo | Descrizione | Variabili principali |
|------|--------------|----------------------|
| **Cittadini** | Individui con reddito, età, competenze e comportamento fiscale | `income`, `skill`, `age`, `employed?`, `is-evader?`, `is-deterred?`, `pensioner?` |
| **Imprese** | Unità produttive che generano PIL e occupazione | `size`, `growth`, `profit`, `is-bankrupt?` |

### Variabili Globali
`gdp`, `debt`, `pension-debt`, `gini`, `public-quality`, `debt-to-gdp`, `unemployment-rate`,  
`inflation`, `sustainable-growth`, `companies-born`, `companies-bankrupt`,  
`investment-multiplier`, `fiscal-control-rate`, `austerity-mode?`, `bce-interventions`.

---

## 4. Meccanismi Principali

**Demografia**  
La popolazione evolve con nascite, morti e invecchiamento, influenzando forza lavoro e pensioni.  

**Sistema Fiscale**  
Doppia tassazione (cittadini e imprese). L’evasione si diffonde tramite contagio sociale ma può essere ridotta dai controlli fiscali.  
Le regole automatiche adattano tasse e spesa per stabilizzare il rapporto debito/PIL.  

**Welfare e Pensioni**  
I trasferimenti e la qualità dei servizi pubblici dipendono dalla capacità fiscale dello Stato.  

**Interventi della Banca Centrale**  
Attivati quando il debito supera soglie critiche: riduzione dei tassi o iniezione di liquidità.  
Dopo più interventi, il sistema entra automaticamente in fase di austerità.

---

## 5. Scenari

| Scenario | Descrizione | Dinamica attesa |
|-----------|--------------|----------------|
| **Espansione Economica** | Alta occupazione, evasione contenuta | Crescita sostenibile, debito stabile |
| **Crisi Pensionistica** | Invecchiamento demografico | Debito pensionistico crescente, PIL in calo |
| **Austerità Fiscale** | Aumento tasse, taglio welfare | Riduzione temporanea del debito, maggiore disuguaglianza |
| **Crollo Finanziario** | Alti tassi, fallimenti, evasione diffusa | Default o cicli di intervento monetario |

---

## 6. Indicatori di Output

| Categoria | Indicatori |
|-----------|-------------|
| **Macro** | PIL, Debito, Debito/PIL, Inflazione, Crescita sostenibile |
| **Disuguaglianza** | Coefficiente di Gini, varianza redditi, qualità pubblica |
| **Lavoro** | Tasso di occupazione, disoccupazione |
| **Imprese** | Nascite, fallimenti, dinamiche cumulative |
| **Politiche** | Pressione fiscale, interventi BCE, fasi di austerità |

---

## 7. Esecuzione del Modello

1. Installa **NetLogo 6.x** → https://ccl.northwestern.edu/netlogo/  
2. Apri `ProjectBEC.nlogo`  
3. Clicca **Setup** per inizializzare popolazione e imprese  
4. Clicca **Go** per avviare la simulazione  
5. Osserva l’evoluzione di PIL, debito, Gini e qualità dei servizi  
6. Modifica i parametri (tasse, tassi d’interesse, welfare) per analizzare diversi scenari

---

## 8. Struttura della Repository

ProjectBEC.nlogo          # File principale
docs/                     # Documentazione e immagini
README.md                 # Questo file
LICENSE                   # Licenza MIT
