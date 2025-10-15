# ProjectBEC – An Agent-Based Model of Fiscal, Economic and Social Dynamics

**Department of Mathematics and Computer Science (DMI), University of Catania**  
**Author:** Giuseppe Lombardia    
**Platform:** NetLogo 4.0  

---

## 1. Overview

**ProjectBEC** (Behavioral Economic and Fiscal Model) is an **agent-based simulation** designed to explore how citizens, firms and public institutions interact within a macroeconomic system regulated by taxation, welfare, and central bank interventions.

The model provides a dynamic and bottom-up representation of fiscal balance, inequality, and sustainable growth, focusing on the feedback loops between individual behaviour (evasion, productivity) and macro outcomes (GDP, debt, welfare quality).

It extends classical economic frameworks by integrating behavioural dynamics, contagion mechanisms and adaptive fiscal policies — offering a modern laboratory for studying economic resilience and systemic stability.

---

## 2. Theoretical Motivation

Traditional macroeconomic models assume aggregate rationality and equilibrium conditions.  
ProjectBEC adopts a **complex adaptive systems** perspective, where:
- Agents follow heterogeneous behavioural rules (bounded rationality).  
- Policies evolve endogenously in reaction to macro indicators.  
- Crises and recoveries emerge from micro interactions, not from external shocks.

The model captures:
- Fiscal feedback loops between tax evasion, debt, and austerity.  
- Social contagion effects influencing compliance behaviour.  
- Macroeconomic transitions triggered by demographic change and investment shocks.

---

## 3. Model Structure

### Agents
| Type | Description | Key Variables |
|------|--------------|----------------|
| **Citizens** | Individuals characterized by income, skills, age, and fiscal behaviour | `income`, `skill`, `age`, `employed?`, `is-evader?`, `is-deterred?`, `pensioner?` |
| **Companies** | Productive entities generating GDP and employment | `size`, `growth`, `profit`, `is-bankrupt?` |

### Global Variables
`gdp`, `debt`, `pension-debt`, `gini`, `public-quality`, `debt-to-gdp`, `unemployment-rate`,  
`inflation`, `sustainable-growth`, `companies-born`, `companies-bankrupt`,  
`investment-multiplier`, `fiscal-control-rate`, `austerity-mode?`, `bce-interventions`.

---

## 4. Core Mechanisms

**Demography**  
Population evolves through births, deaths, and aging, influencing labour supply and pension obligations.  

**Fiscal System**  
Dual taxation on citizens and firms. Tax evasion spreads through social contagion but can be reduced by fiscal controls.  
Automatic fiscal rules adjust taxation and spending to stabilize debt/GDP.  

**Welfare and Pensions**  
Pension payments and welfare quality depend on fiscal capacity and public investment.  

**Central Bank Interventions**  
The central bank intervenes when debt surpasses critical thresholds, injecting liquidity or lowering interest rates.  
After multiple interventions, an austerity phase is automatically triggered.

---

## 5. Scenarios

| Scenario | Description | Dynamics |
|-----------|--------------|-----------|
| **Economic Expansion** | High investment, low evasion, population growth | Sustainable growth and stable debt |
| **Pension Crisis** | Aging population, fewer workers | Rising pension debt, reduced productivity |
| **Fiscal Austerity** | High taxation, reduced welfare | Temporary debt reduction, long-term inequality |
| **Financial Collapse** | High interest, bankruptcies, massive evasion | Default and intervention cycles |

---

## 6. Output Metrics

| Category | Indicators |
|-----------|-------------|
| **Macro** | GDP, Debt, Debt-to-GDP, Inflation, Sustainable Growth |
| **Inequality** | Gini coefficient, income variance, public quality |
| **Labour** | Employment rate, Unemployment rate |
| **Firms** | Births, Bankruptcies, Cumulative dynamics |
| **Policy** | Fiscal pressure, BCE interventions, Austerity phases |

---

## 7. Running the Model

2. Open `ProjectBEC.nlogo`  
3. Click **Setup** to initialize the population and firms  
4. Click **Go** to start the simulation  
5. Observe the evolution of GDP, Debt, Gini, Welfare Quality, and Fiscal Status  
6. Modify parameters (tax rates, interest rate, welfare budget) to explore different policy outcomes

---

## 8. Repository Structure

ProjectBEC.nlogo          # Main model file
docs/                     # Documentation and screenshots
code/                     # Code
README.md                 # This file
LICENSE                   # MIT License


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
code/                     # Code
README.md                 # Questo file
LICENSE                   # Licenza MIT

---

## 9. Citazione

Giuseppe Lombardia (2025). ProjectBEC – Un modello ad agenti delle dinamiche fiscali, economiche e sociali.
Dipartimento di Matematica e Informatica (DMI), Università di Catania.
GitHub: https://github.com//ProjectBEC

---

## 10. Licenza

Questo progetto è distribuito con **Licenza MIT**.  
Può essere usato, modificato e condiviso liberamente per scopi didattici e di ricerca, citando l’autore.

---

## 11. Parole Chiave

Modellazione ad agenti · NetLogo · Politiche pubbliche · Dinamiche fiscali ·  
Macroeconomia · Disuguaglianza · Sostenibilità del debito · Sistemi complessi

---

## 12. Sviluppi Futuri

Sviluppi previsti:
- Differenziazione settoriale delle imprese  
- Meccanismi di incontro domanda-offerta sul mercato del lavoro  
- Adattamento comportamentale basato su apprendimento  
- Calibrazione con dati reali per analisi comparate
