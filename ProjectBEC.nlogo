globals [

  gdp
  debt
  pension-debt
  gini
  public-quality
  debt-to-gdp
  sustainable-growth
  companies-born
  companies-bankrupt
  cumulative-born
  cumulative-bankrupt
  inflation
  base-birth-rate
  base-death-rate
  fiscal-control-rate
  public-invest-rate
  investment-multiplier
  investment-queue
  bce-interventions
  unemployment-rate
  max-bce-interventions
  austerity-mode?
  fiscal-status
]

breed [citizens citizen]
breed [companies company]

citizens-own [
  income
  is-evader
  age
  pensioner?
  skill
  is-deterred?
  employed?
]

companies-own [
  size
]


to setup
  clear-all

  set cumulative-born 0
  set cumulative-bankrupt 0

  set base-birth-rate 1.0
  set base-death-rate 1.0

  set fiscal-control-rate 15
  set max-bce-interventions 5
  set bce-interventions 0
  set austerity-mode? false
  set fiscal-status "Normal"

  set investment-multiplier 1.5

  set investment-queue []

  apply-scenario
  setup-citizens
  setup-companies
  calculate-gdp
  calculate-debt
  calculate-gini
  calculate-public-quality
  reset-ticks
end

to scenario-pension-crisis
  set birth-rate 0.5
  set immigration-rate 0.5
  set death-rate 0.5
  set welfare-budget 40
  set interest-rate 3
  set citizen-tax-rate 20
  set company-tax-rate 20
  set probability-of-tax-evasion 30
  set pension-tax-rate 15
end

to scenario-economic-expansion
  set birth-rate 2
  set immigration-rate 3
  set death-rate 1
  set welfare-budget 35
  set interest-rate 1
  set citizen-tax-rate 15
  set company-tax-rate 20
  set probability-of-tax-evasion 10
  set pension-tax-rate 10
end

to scenario-fiscal-austerity
  set birth-rate 1
  set immigration-rate 0.5
  set death-rate 1
  set welfare-budget 15
  set interest-rate 2
  set citizen-tax-rate 35
  set company-tax-rate 30
  set probability-of-tax-evasion 25
  set pension-tax-rate 15
end

to scenario-financial-crisis
  set birth-rate 0.8
  set immigration-rate 0.3
  set death-rate 1.5
  set welfare-budget 10
  set interest-rate 6
  set citizen-tax-rate 40
  set company-tax-rate 35
  set probability-of-tax-evasion 40
  set pension-tax-rate 20
  set debt 200000
end

to apply-scenario
  if scenario-choice = "Pension Crisis"       [ scenario-pension-crisis ]
  if scenario-choice = "Economic Expansion"   [ scenario-economic-expansion ]
  if scenario-choice = "Fiscal Austerity"     [ scenario-fiscal-austerity ]
  if scenario-choice = "Financial Crisis"     [ scenario-financial-crisis ]
end

to setup-citizens
  create-citizens population-size [
    setxy random-xcor random-ycor
    set age random 80
    set pensioner? age >= retirement-age
    set skill random-normal 10 3
    set income pareto-income 500 1.1
    set is-evader (random-float 100 < probability-of-tax-evasion)
    set is-deterred? false
    set employed? false
    set shape "person"

    if pensioner? [ set color gray ]
    if not pensioner? [ set color blue ]
  ]
end

to setup-companies
  let largest-company-size 100000
  let rank 1
  create-companies company-count [
    setxy random-xcor random-ycor
    set size (largest-company-size / rank)
    set shape "house"
    set color green
    set rank (rank + 1)
  ]
end



to-report pareto-income [xm alpha]
  report xm / ((random-float 1) ^ (1 / alpha))
end

to go
  if not any? citizens [ stop ]

  distribute-pensions
  economy-step
  unemployment-management
  dynamic-birth-death
  demographics-step
  grow-companies
  calculate-sustainable-growth
  release-investments
  calculate-gdp
  calculate-pension-debt
  calculate-debt
  check-debt-sustainability
  calculate-gini
  calculate-public-quality
  maybe-create-companies
  maybe-bankrupt-companies
  contagion-evasion
  dynamic-checks
  evasion-control
  automatic-fiscal-policy
  central-bank-intervention
  apply-austerity-measures

  if bce-interventions >= max-bce-interventions and debt-to-gdp >= 2 [
    user-message "THE STATE HAS DEFAULTED. THE ECONOMY HAS COLLAPSED."
    stop
  ]

  tick
end


to grow-companies
  ask companies [
    if sustainable-growth > 0 [
      ;; Crescita proporzionale a sustainable-growth
      set size (size * (1 + sustainable-growth / 10))
    ]
  ]
end


to dynamic-birth-death
  let avg-income mean [income] of citizens

  ifelse (public-quality > 0.5 and avg-income > 1000)
  [
    set birth-rate 2.0
    set death-rate 0.8
  ]
  [
    ifelse (public-quality < 0.2 and avg-income < 500)
    [
      set birth-rate 0.5
      set death-rate 2.0
    ]
    [
      set birth-rate 1.0
      set death-rate 1.0
    ]
  ]
end


to demographics-step
  ask citizens [
    set age (age + 1)


    if age >= retirement-age [
      set pensioner? true
      set color gray
    ]


    let age-threshold (max-age - 10)
    let base-death? (random-float 100 < death-rate)
    let high-death? false

    if age > age-threshold [
      let new-rate (death-rate * 2)
      set high-death? (random-float 100 < new-rate)
    ]

    if (base-death? or high-death? or (age > max-age)) [
      die
    ]
  ]


  create-citizens round(count citizens * birth-rate / 100) [
    setxy random-xcor random-ycor
    set income 0
    set skill random-normal 10 3
    set is-evader (random-float 100 < probability-of-tax-evasion)
    set is-deterred? false
    set age 0
    set pensioner? false
    set shape "person"
    set color white
  ]


  create-citizens round(count citizens * immigration-rate / 100) [
    setxy random-xcor random-ycor
    set skill random-normal 10 3
    set income pareto-income 600 1.3
    set is-evader (random-float 100 < probability-of-tax-evasion)
    set is-deterred? false
    set age random 50
    set pensioner? (age >= retirement-age)
    set shape "person"
    set color yellow
  ]
end




to economy-step
  ask citizens [
  let tax-due (income * citizen-tax-rate / 100)
  if (is-evader and not is-deterred? and random-float 1 < 0.05) [

  ]

]


  ask companies [
    let company-tax (size * company-tax-rate / 100)
  ]
end

to unemployment-management
  let adults citizens with [age >= 18 and age < retirement-age]

  ask adults [

    ifelse (random-float 1 < 0.2) [
      set employed? false
      set income 200
      set color red
    ] [
      set employed? true
      let base-sal pareto-income 500 1.5
      set income (base-sal * (skill / 10))
      set color green
    ]
  ]

  let active (count adults)
  let unemployed (count adults with [not employed?])
  if active > 0 [
    set unemployment-rate (unemployed / active)
  ]
  if active = 0 [
    set unemployment-rate 0
  ]
end

to calculate-gdp
  set gdp (sum [income] of citizens + sum [size] of companies)
end

to calculate-pension-debt
  let pensioners count citizens with [pensioner?]
  let workers count citizens with [age >= 18 and age < 65]
  if workers > 0 [
    let avg-worker-income mean [income] of citizens with [age >= 18 and age < 65]
    let avg-pension (avg-worker-income * 0.6)
    set pension-debt (pensioners * avg-pension)
  ]
  if workers = 0 [
    set pension-debt (pensioners * 500)
  ]
end

to calculate-debt

  let labor-tax (sum [income] of citizens with [not pensioner?]) * (citizen-tax-rate / 100)
  let pension-tax (sum [income] of citizens with [pensioner?]) * (pension-tax-rate / 100)
  let company-tax (sum [size] of companies) * (company-tax-rate / 100)
  let total-tax (labor-tax + pension-tax + company-tax)

  let welfare-expenditure (gdp * welfare-budget / 100)
  let pension-expenditure (sum [income] of citizens with [pensioner?])

  let total-spending (welfare-expenditure + pension-expenditure)

  let deficit (total-spending - total-tax)

  set debt (debt + deficit)

  ifelse (gdp > 0) [
    set debt-to-gdp (debt / gdp)
  ] [
    set debt-to-gdp 0
  ]
end


to distribute-pensions
  let workers citizens with [age >= 18 and age < retirement-age]
  let pensioners citizens with [pensioner?]

  if any? workers [
    let avg-worker-income mean [income] of workers
    let avg-pension (avg-worker-income * pension-replacement-rate)
    ask pensioners [
      set income avg-pension
    ]
  ]
  if not any? workers [
    ask pensioners [
      set income 500
    ]
  ]
end

to check-debt-sustainability
  if (debt-to-gdp >= 0.9) [
    set welfare-budget max list (welfare-budget - 5) 5
  ]
end

to do-public-investment
  let invest-amount ((public-invest-rate / 100) * gdp)
  if (invest-amount > 0) [
    let chunk (invest-amount / 3)
    set investment-queue fput chunk fput chunk fput chunk investment-queue
    set debt (debt + invest-amount)
  ]
end

to release-investments
  if not empty? investment-queue [
    let part first investment-queue
    set investment-queue but-first investment-queue
    let added-gdp (part * investment-multiplier)
    set gdp (gdp + added-gdp)
  ]
end

to calculate-sustainable-growth
  let ideal-investment 25
  let growth-factor (welfare-budget / ideal-investment)
  let real-growth ((growth-factor - 1) * 0.5)

  let nominal-growth ((real-growth / 100) + (inflation / 100))
  if (nominal-growth < -0.3) [ set nominal-growth -0.3 ]
  if (nominal-growth >  0.5) [ set nominal-growth  0.5 ]

  set gdp (gdp * (1 + nominal-growth))
end

to calculate-gini
  let sorted-incomes sort [income] of citizens
  let n length sorted-incomes
  if (n = 0) [
    set gini 0
    stop
  ]
  let total-income sum sorted-incomes
  let cum 0
  let b 0
  let i 0
  foreach sorted-incomes [ val ->
    set cum (cum + val)
    set i (i + 1)
    set b (b + (cum / total-income))
  ]
  set gini (1 + (1 / n) - 2 * (b / n))
end

to calculate-public-quality
  let ideal-budget 30
  set public-quality (
    (welfare-budget / ideal-budget)
    - (max list (debt-to-gdp - 1.2) 0 / 20)
    - ((count citizens with [is-evader] / count citizens) / 15)
  )
  set public-quality max list (min list public-quality 1) 0
end


to maybe-create-companies
  set companies-born 0
  let probability-growth ifelse-value ((count companies < 30) or (sustainable-growth > -1)) [0.4] [0.1]
  if (random-float 1 < probability-growth) [
    create-companies 1 [
      setxy random-xcor random-ycor
      set size random-normal 200 20
      set shape "house"
      set color green
    ]
    set companies-born (companies-born + 1)
    set cumulative-born (cumulative-born + 1)
  ]
end

to maybe-bankrupt-companies
  set companies-bankrupt 0
  ask companies [
    let fail-probability ifelse-value (sustainable-growth < -1) [0.03] [0.005]
    if (random-float 1 < fail-probability) [
      set companies-bankrupt (companies-bankrupt + 1)
      set cumulative-bankrupt (cumulative-bankrupt + 1)
      die
    ]
  ]
end

to contagion-evasion
  let fraction-evaders ((count citizens with [is-evader]) / (count citizens))
  ask citizens with [not is-evader and not is-deterred?] [
    let neighbors-evaders 0
    let north (citizens-at 0 -1) with [is-evader]
    let south (citizens-at 0 1)  with [is-evader]
    let east  (citizens-at 1 0)  with [is-evader]
    let west  (citizens-at -1 0) with [is-evader]
    set neighbors-evaders ((count north) + (count south) + (count east) + (count west))
    if (random-float 100 < (fraction-evaders * 10 + neighbors-evaders * 5)) [
      set is-evader true
      set color red
    ]
  ]
end

to dynamic-checks
  let fraction-evaders ((count citizens with [is-evader]) / (count citizens))
  set fiscal-control-rate (15 + fraction-evaders * 40)
  if (fiscal-control-rate > 100) [ set fiscal-control-rate 100 ]
end

to evasion-control
  ask citizens with [is-evader and not is-deterred?] [
    if (random-float 100 < fiscal-control-rate) [
      set debt (debt + (income * 0.5 + 2000))
      set is-evader false
      set is-deterred? true
      set color blue


      let north (citizens-at 0 -1)
      let south (citizens-at 0 1)
      let east  (citizens-at 1 0)
      let west  (citizens-at -1 0)
      let all-neighbors (turtle-set north south east west)
      ask all-neighbors [
        if is-evader [
          if (random-float 1 < 0.3) [
            set is-evader false
            set color blue
          ]
        ]
      ]
    ]
  ]
end


to central-bank-intervention
  if debt-to-gdp >= 1.2 and bce-interventions < max-bce-interventions [
    let new-rate interest-rate - 0.5
    set interest-rate max list new-rate 0.5
    set debt debt * 0.8
    set bce-interventions bce-interventions + 1
  ]

  if bce-interventions >= max-bce-interventions and debt-to-gdp >= 1.5 and not austerity-mode? [
    set austerity-mode? true
    set fiscal-status "Austerity"
  ]
end

to apply-austerity-measures

  if austerity-mode? and debt-to-gdp < 0.5 [
    set austerity-mode? false
    set fiscal-status "Recovery"
    ask patches [ set pcolor black ]
  ]


  if austerity-mode? [
    set welfare-budget 0
    set citizen-tax-rate min list (citizen-tax-rate + 5) 80
    set company-tax-rate min list (company-tax-rate + 5) 80
    set pension-tax-rate min list (pension-tax-rate + 5) 50
    set pension-replacement-rate max list (pension-replacement-rate - 0.1) 0.3
    set public-invest-rate 0

    ask patches [ set pcolor red ]
  ]
end

to automatic-fiscal-policy
  if not austerity-mode? [
    if debt-to-gdp >= 1.0 and debt-to-gdp < 1.5 [
      set fiscal-status "Correction"
      set citizen-tax-rate min list (citizen-tax-rate + 1) 60
      set company-tax-rate min list (company-tax-rate + 1) 60
      set pension-tax-rate min list (pension-tax-rate + 1) 40
      set welfare-budget max list (welfare-budget - 1) 10
      set pension-replacement-rate max list (pension-replacement-rate - 0.05) 0.4
    ]
    if debt-to-gdp < 1.0 [
      set fiscal-status "Normal"
      if welfare-budget < 35 [ set welfare-budget (welfare-budget + 0.5) ]
      set citizen-tax-rate max list (citizen-tax-rate - 1) 10
      set company-tax-rate max list (company-tax-rate - 1) 10
      set pension-tax-rate max list (pension-tax-rate - 1) 5
      if pension-replacement-rate < 0.7 [ set pension-replacement-rate (pension-replacement-rate + 0.05) ]
      set public-invest-rate min list (public-invest-rate + 0.5) 5
    ]
    if debt-to-gdp < 0.6 [
      if welfare-budget < 40 [ set welfare-budget (welfare-budget + 0.5) ]
      if pension-replacement-rate < 0.8 [ set pension-replacement-rate (pension-replacement-rate + 0.05) ]
    ]
  ]
end




to set-optimal-values
  set population-size 1000
  set company-count 150
  set citizen-tax-rate 20
  set company-tax-rate 20
  set probability-of-tax-evasion 15
  set birth-rate 1.0
  set death-rate 1.0
  set immigration-rate 2.0
  set interest-rate 2.0
  set welfare-budget 30
  set fiscal-control-rate 25
  set pension-tax-rate 10
  set public-invest-rate 3
  set investment-multiplier 1.5
  set pension-replacement-rate 0.6
  set retirement-age 67
  set max-age 85
  set scenario-choice "None"
end

to debug-iniziale
  let labor-tax (sum [income] of citizens with [not pensioner?]) * (citizen-tax-rate / 100)
  let pension-tax (sum [income] of citizens with [pensioner?]) * (pension-tax-rate / 100)
  let company-tax (sum [size] of companies) * (company-tax-rate / 100)
  let total-tax (labor-tax + pension-tax + company-tax)

  let welfare-expenditure (gdp * welfare-budget / 100)
  let pension-expenditure sum [income] of citizens with [pensioner?]
  let total-spending (welfare-expenditure + pension-expenditure)

  let initial-debt debt
  let deficit (total-spending - total-tax)

  print "--- DEBUG INIZIALE ---"
  print (word "Citizen tax revenue: " round labor-tax)
  print (word "Pension tax revenue: " round pension-tax)
  print (word "Company tax revenue: " round company-tax)
  print (word "TOTAL tax revenue: " round total-tax)
  print (word "Welfare spending: " round welfare-expenditure)
  print (word "Pension spending: " round pension-expenditure)
  print (word "TOTAL spending: " round total-spending)
  print (word "DEFICIT: " round deficit)
  print (word "Debt before: " round initial-debt)
  print (word "Expected debt after tick: " round (initial-debt + deficit))
  print (word "GDP: " round gdp)
  print (word "Debt-to-GDP: " precision (debt / gdp) 2)
  print "------------------------"
end


to debug-lavoratori
  let tot-lavoratori count citizens with [age >= 18 and age < retirement-age]
  let impiegati count citizens with [employed? and age >= 18 and age < retirement-age]
  let disoccupati (tot-lavoratori - impiegati)

  let deterred-lavoratori count citizens with [is-deterred? and employed? and age >= 18 and age < retirement-age]
  let evaders-lavoratori count citizens with [is-evader and employed? and age >= 18 and age < retirement-age]

  print (word "Tot. lavoratori (18+): " tot-lavoratori)
  print (word "Impiegati: " impiegati)
  print (word "Disoccupati: " disoccupati)
  print (word "Lavoratori beccati (deterred): " deterred-lavoratori)
  print (word "Lavoratori evasori: " evaders-lavoratori)
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
547
49
610
82
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
483
48
546
81
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
415
48
481
81
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
460
81
609
114
NIL
set-optimal-values\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
0
86
172
119
birth-rate
birth-rate
0
10
1.0
0.5
1
%
HORIZONTAL

SLIDER
0
120
172
153
immigration-rate
immigration-rate
0
10
2.0
0.5
1
%
HORIZONTAL

SLIDER
0
153
172
186
death-rate
death-rate
0
10
1.0
0.5
1
%
HORIZONTAL

SLIDER
0
307
172
340
welfare-budget
welfare-budget
0
50
30.0
1
1
%
HORIZONTAL

SLIDER
0
340
172
373
interest-rate
interest-rate
0
10
2.0
0.5
1
%
HORIZONTAL

SLIDER
0
373
172
406
citizen-tax-rate
citizen-tax-rate
0
60
20.0
1
1
%
HORIZONTAL

SLIDER
0
405
179
438
company-tax-rate
company-tax-rate
0
60
20.0
1
1
%
HORIZONTAL

SLIDER
0
436
232
469
probability-of-tax-evasion
probability-of-tax-evasion
0
100
15.0
1
1
%
HORIZONTAL

SLIDER
0
470
172
503
pension-tax-rate
pension-tax-rate
0
50
10.0
1
1
%
HORIZONTAL

CHOOSER
420
120
597
165
scenario-choice
scenario-choice
"None" "Pension Crisis" "Economic Expansion" "Fiscal Austerity" "Financial Crisis"
0

SLIDER
0
55
172
88
population-size
population-size
100
2000
1000.0
100
1
NIL
HORIZONTAL

SLIDER
0
186
172
219
company-count
company-count
0
300
150.0
10
1
NIL
HORIZONTAL

MONITOR
496
587
678
632
Gross Domestic Production
gdp
0
1
11

MONITOR
496
632
573
677
Total Debt
debt
0
1
11

MONITOR
496
678
645
723
Debt-to-GDP Ratio (%)
debt-to-gdp * 100
0
1
11

MONITOR
682
587
776
632
Pension Debt
pension-debt
0
1
11

MONITOR
705
634
762
679
Gini
gini
2
1
11

MONITOR
764
633
906
678
Public Service quality
public-quality
2
1
11

MONITOR
760
680
887
725
Citizen tax rate (%)
citizen-tax-rate
2
1
11

MONITOR
646
678
758
723
Inflation rate (%)
inflation
2
1
11

MONITOR
777
587
920
632
Company tax rate (%)
company-tax-rate
2
1
11

MONITOR
572
633
705
678
Pension tax rate (%)
pension-tax-rate
0
1
11

PLOT
1195
36
1395
186
Debt-to-GDP (%)
ticks
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot (debt-to-gdp * 100)"

PLOT
1396
37
1596
187
GDP Real
ticks
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot gdp"

PLOT
1398
188
1598
338
Gini Index
ticks
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot gini "

PLOT
1195
189
1395
339
Companies Creation/Fall
ticks
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Born" 1.0 0 -987046 true "" "plot cumulative-born"
"Bankrupt" 1.0 0 -16777216 true "" "plot cumulative-bankrupt"

PLOT
1195
341
1395
491
Public Service Quality
ticks
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot public-quality"

PLOT
1398
340
1598
490
Population Age Distribution (histogram)
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 11.0 1 -16777216 true "" "clear-plot\nset-plot-x-range 0 100\nset-histogram-num-bars 20\nhistogram [age] of citizens\n"

MONITOR
73
616
153
661
population
count citizens
0
1
11

MONITOR
154
616
237
661
Immigrants
count citizens with [color = yellow]
0
1
11

MONITOR
74
663
148
708
Pensioner
count citizens with [pensioner?]
0
1
11

MONITOR
150
662
214
707
Workers
count citizens with [age >= 18 and age < 65 and income > 200]
0
1
11

MONITOR
74
708
164
753
Unemployed
count citizens with [age >= 18 and age < 65 and income = 200]
0
1
11

MONITOR
493
726
667
771
Average Salary (Workers)  
mean [income] of citizens with [age >= 18 and age < 65 and income > 200]
0
1
11

MONITOR
668
726
791
771
Average Pension  
mean [income] of citizens with [pensioner?]
0
1
11

MONITOR
165
708
303
753
Number of Evaders  
count citizens with [is-evader]
0
1
11

MONITOR
792
726
901
771
Evasion rate (%)
(count citizens with [is-evader] / count citizens) * 100
2
1
11

MONITOR
217
661
334
706
Deterret Citizens
count citizens with [is-deterred?]
0
1
11

MONITOR
493
771
614
816
Companies count
count companies
0
1
11

MONITOR
614
771
741
816
Avg Company Size
mean [size] of companies
0
1
11

SLIDER
0
216
172
249
retirement-age
retirement-age
65
80
67.0
1
1
NIL
HORIZONTAL

SLIDER
173
55
345
88
max-age
max-age
80
100
85.0
1
1
NIL
HORIZONTAL

MONITOR
923
586
1062
631
Total Tax
((sum [income] of citizens with [not pensioner?]) * citizen-tax-rate / 100) + \n((sum [income] of citizens with [pensioner?]) * pension-tax-rate / 100) + \n((sum [size] of companies) * company-tax-rate / 100)
0
1
11

MONITOR
924
632
1075
677
Total Pension Revenue
sum [income] of citizens with [age >= 18 and age < 65] * (pension-tax-rate / 100)
0
1
11

MONITOR
924
677
1086
722
Spending on Investment
(public-invest-rate / 100) * gdp
0
1
11

MONITOR
241
615
301
660
Youngs
count citizens with [age < 18]
0
1
11

PLOT
1396
491
1596
641
Age Groups                                                   
ticks
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Young (<18)" 1.0 0 -16777216 true "" "plot count citizens with [age < 18]"
"Adults (18-64)" 1.0 0 -987046 true "" "plot count citizens with [age >= 18 and age < 65]"
"Pensioners (>=65)" 1.0 0 -2674135 true "" "plot count citizens with [pensioner?]"

PLOT
1195
492
1395
642
Evasion Rate Over Time 
ticks
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Evasion Rate " 1.0 0 -16777216 true "" "plot ((count citizens with [is-evader]) / count citizens * 100)"

MONITOR
906
726
1015
771
BCE Status         
ifelse-value (debt-to-gdp >= 1.2)\n[\"Active Intervention!\"]\n[\"No Intervention\"]
17
1
11

BUTTON
461
303
599
336
NIL
debug-lavoratori\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
469
268
589
301
NIL
debug-iniziale
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
0
502
228
535
pension-replacement-rate
pension-replacement-rate
0
1
0.6
0.01
1
NIL
HORIZONTAL

MONITOR
905
770
1015
815
Austerity Mode	
austerity-mode?
17
1
11

MONITOR
1016
725
1105
770
Fiscal status
fiscal-status
17
1
11

MONITOR
768
771
902
816
Unemployment rate
unemployment-rate * 100
2
1
11

PLOT
1194
642
1394
792
Welfare & Tax Pressure
ticks
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot welfare-budget"
"pen-1" 1.0 0 -7500403 true "" "plot citizen-tax-rate"
"pen-2" 1.0 0 -2674135 true "" "plot company-tax-rate"
"pen-3" 1.0 0 -955883 true "" "plot pension-tax-rate"

@#$#@#$#@
## WHAT IS IT?

This model simulates the macroeconomic dynamics of a state under various fiscal, demographic, and economic conditions. It is designed to explore how public debt, GDP, tax policy, welfare expenditure, pension systems, and company behavior interact over time within a stylized economic environment.
The primary goal of the model is to analyze how governments manage fiscal sustainability while preserving social welfare. 
The model features:
- Automatic fiscal policy that reacts to debt levels by adjusting taxes and spending.
- Pension distribution and replacement rate mechanics based on workforce income.
- Company birth and bankruptcy processes, influenced by sustainable growth.
- Tax evasion and enforcement dynamics, with contagion and deterrence effects.
- Monetary policy interventions by a simulated central bank (e.g., BCE), which reduce 		  debt and interest rates during crises.
- Austerity mode, triggered when debt-to-GDP exceeds 150% and the central bank can no       longer intervene. This phase imposes strict tax increases and cuts to welfare and         pensions until the debt stabilizes below 50%.

By modeling these interrelated components, the simulation helps users understand the complex trade-offs involved in maintaining public finances, managing economic crises, and balancing social equity through taxation and welfare policies.

## HOW IT WORKS

The model consists of two main types of agents: citizens and companies, interacting within a simulated economy driven by macroeconomic indicators and government rules.

# Citizens

Citizens are born, age, may become pensioners at retirement age, and die based on        probabilistic life-cycle rules. Each citizen has a skill level that affects income if employed. Employment status is determined probabilistically, influenced by economic conditions.
Pensioners receive income based on a replacement rate of the average worker’s income.
Citizens may evade taxes depending on a global probability, but can be deterred through fiscal control. Evasion can also spread through social contagion.

# Companies

Companies vary in size, can grow with economic conditions, and may go bankrupt if sustainable growth is negative.
New companies may be created based on the economic climate.

# Government & Economy

The government collects taxes from citizens and companies and uses them to fund welfare and pensions.
The automatic fiscal policy adjusts taxes and public spending according to the debt-to-GDP ratio:
If debt is high, taxes rise and spending is reduced.
If debt is low, spending and welfare are increased moderately.
The central bank (BCE) may intervene by reducing interest rates and public debt when debt-to-GDP exceeds 120%, up to a maximum number of interventions.

# Austerity Mode

If the debt-to-GDP ratio exceeds 150% and BCE interventions are exhausted, the state enters austerity mode:
Welfare is cut to zero.
Pension replacement rates are drastically reduced.
Taxes are sharply increased.
Austerity lasts until the debt-to-GDP ratio drops below 50%.
All agents’ actions collectively influence GDP, debt, income inequality (Gini), unemployment, and overall social health.

## HOW TO USE IT

This model can be controlled through the buttons, sliders, switches, and monitors found in the Interface tab. Here's how to use it:

# Buttons

setup: Initializes the model based on slider values and the selected scenario.
go: Runs the simulation continuously.
go (step): Runs one tick at a time.
set-optimal-values: Loads a balanced starting configuration for the sliders.
scenario-choice: Dropdown menu to load predefined economic scenarios (e.g., Financial Crisis, Pension Crisis).
debug-iniziale / debug-lavoratori: Print initial budget or employment-related debug info to the Command Center.

# Sliders

Control key model parameters:
population-size, birth-rate, death-rate, immigration-rate: control demographic dynamics.
welfare-budget, interest-rate, citizen-tax-rate, company-tax-rate, pension-tax-rate: control economic policy.
probability-of-tax-evasion: likelihood of citizens becoming tax evaders.
pension-replacement-rate: determines pension size relative to worker income.
max-age, retirement-age: define age structure and retirement thresholds.

# Plots

Real-time monitoring of key indicators:
Debt-to-GDP, GDP, Public Service Quality, Gini Index
Evasion Rate, Companies Created/Bankrupted, Age Distribution
Welfare & Tax Pressure shows the cost of welfare plus total tax rate over time.

# Monitors

Track current values of important variables such as:
GDP, Debt, Taxes, Unemployment, Pension Spending, Evaders, Inflation
Fiscal status (Normal, Correction, Austerity, Recovery)
BCE Status, Evasion %, Gini index, Average salaries and pensions

# How to explore:

Press setup to initialize the model.
Select a scenario from the dropdown (optional).
Press go to run continuously, or go (step) to advance tick-by-tick.
Adjust sliders to experiment with different policies and conditions.
Monitor the plots and values to observe system behavior and trigger events (e.g., austerity, default).


## THINGS TO NOTICE

- Observe how the debt-to-GDP ratio evolves over time and how it triggers changes in fiscal policy.
- Pay attention to the transition between different fiscal statuses: "Normal", "Correction", "Austerity", and "Recovery".
- Watch how tax rates and welfare budget shift dynamically as debt levels increase or decrease.
- Notice how the BCE interventions reduce debt temporarily but are limited in number.
- Monitor how austerity mode drastically alters economic behavior—welfare disappears, taxes spike, and pensions drop.
- Track the evolution of income inequality (Gini index) and the impact of tax evasion and fiscal control.
- Look at how company creation and bankruptcy correlate with economic conditions and sustainable growth.
- Notice how public service quality responds to changes in welfare spending and tax compliance.


## THINGS TO TRY

Start with set-optimal-values, run the model, and see how the system stabilizes or deteriorates under different scenarios.
Select a crisis scenario (e.g., Pension Crisis, Financial Crisis) and observe how the economy reacts.
Try increasing the welfare budget manually and observe the consequences on debt and inflation.
Raise or lower the tax rates to see how much revenue is collected and how it affects public services.
Increase the probability of tax evasion and see how contagion and deterrence play out.
Adjust the pension-replacement-rate to make pensions more or less generous, and see how this impacts sustainability.
Let the model run long enough to trigger austerity mode and then watch how the system recovers once debt drops.
Experiment with immigration and birth rate to simulate demographic shifts.

## EXTENDING THE MODEL

Introduce consumer behavior and household spending to model aggregate demand more realistically.
Add sector-specific companies (e.g., tech, agriculture, services) with different productivity and growth dynamics.
Implement a housing market to study real estate bubbles, rents, and wealth accumulation.
Include political choices (e.g., left/right governments) that influence fiscal priorities and tax policies.
Add external shocks such as pandemics, wars, or climate disasters, which affect public debt and citizen behavior.
Include labor market dynamics like wages, contracts, and underemployment.
Create a healthcare system with its own spending, public impact, and relation to public service quality.
Implement regional or federal structures to simulate local vs. national fiscal balances.
Use a real population dataset or real economic data for calibration and validation.
Add behavioral models of tax compliance, including trust in institutions or perception of fairness.


## NETLOGO FEATURES

The model uses turtles-own and patches-own to manage complex attributes of citizens and companies.
Dynamic tax policy and behavior switching are implemented through global thresholds and rule-based logic.
Agent-to-agent contagion is modeled via directional neighborhood checks (north/south/east/west).
Investment queuing simulates delayed public investment impacts using NetLogo's list management.
The model uses sliders, monitors, plots, and dropdowns extensively for live interaction and experimentation.
To simulate fiscal state transitions, custom variables like fiscal-status and austerity-mode? are used to track systemic behavior.
Color-coded patches (red during austerity) visually reflect macroeconomic conditions.
Uses user-message for hard-stops like full economic default.

## KEY ATTRIBUTES AND VARIABLE

# CITIZENS

Probability to Evade Taxes: Defines the individual likelihood of a citizen to become a tax evader.
Skill Level: Influences a citizen’s productivity and income if employed.
Age and Pension Status: Determines whether a citizen is part of the active labor force or receives a pension.
Employment Status: Citizens can be employed or unemployed based on probabilistic rules and economic conditions.
Is Evader / Is Deterred?: Indicates whether the citizen is currently evading taxes and whether they have been previously sanctioned.

# COMPANIES

Size: Determines the company's contribution to GDP and the number of workers needed.
Probability of Bankruptcy: Affected by negative sustainable growth.
Birth and Failure Logic: New companies can form, and existing ones may close based on economic cycles.

# GLOBAL VARIABLE

Debt-to-GDP Ratio: Central indicator for macroeconomic sustainability and policy shifts.
Welfare Budget: Percentage of GDP allocated to welfare spending.
Total Tax Revenue: Combined taxes from citizens, pensioners, and companies.
Public Service Quality: Dynamic indicator based on debt, welfare, and tax compliance.
Gini Index: Measures income inequality across the population.
Pension Debt and Spending: Tracks the amount spent on pensions.
Unemployment Rate: Updated dynamically based on job assignment.


# PROCEDURAL ATTRIBUTES

Automatic Fiscal Policy Procedure: Adjusts tax rates and welfare in response to rising or falling debt.
Austerity Procedure: Enforces severe cuts and tax hikes when debt-to-GDP exceeds 150%.
Pension Distribution Procedure: Allocates pension income based on the average worker salary and replacement rate.
Tax Evasion Control Procedure: Increases enforcement efforts and updates evader status through detection and contagion.
Contagion Mechanism: Tax evasion spreads through neighbors; also includes reverse contagion after enforcement.
Company Growth and Death Procedures: Companies grow under positive economic conditions and may collapse during recessions.
Central Bank Intervention Procedure: Simulates monetary policy to reduce debt and interest rates during crises.

## CONCLUSION

This model offers a robust agent-based simulation of a modern economy, combining fiscal policy, taxation, public spending, and demographic dynamics. Citizens interact with a dynamic market where employment, income, and tax behavior drive aggregate variables such as GDP and public debt.
Users can observe how automatic fiscal responses, austerity, and central bank interventions influence systemic stability. By adjusting parameters such as tax rates, welfare spending, or pension policies, users can explore different macroeconomic paths and evaluate the trade-offs between growth, equity, and fiscal sustainability.
The model is extensible to include consumer behavior, imitation, and behavioral economics mechanisms, offering a foundation for more complex simulations involving micro-to-macro feedbacks.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
