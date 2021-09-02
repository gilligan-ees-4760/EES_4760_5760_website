globals
[
  profit-mean

  ; failure-min
  ; failure-max

  ; num-investors

  time-horizon

  ; sense-radius
  ; use-sense-radius?

  ; max-ticks

  patch-color-mode ; 0 = profit, 1 = p-failure

  file-is-open?

  g-mean-wealth
  g-max-utility

  n-hplr
  n-hphr
  n-lplr
  n-lphr
  n-same
  mv-hplr
  mv-hphr
  mv-lplr
  mv-lphr
  moves
]

turtles-own
[
  wealth ; wealth, in dollars
]

patches-own
[
  profit     ; annual profit (dollars)
  p-failure  ; annual probabilty of failure (0 to 1)
]

to setup
  ca

  initialize-globals
  initialize-patches

  crt num-investors
  [
    initialize-turtle
  ]

  set g-mean-wealth mean [wealth] of turtles
  color-turtles

  reset-ticks
end

to go
  color-patches

  ask turtles
  [
    move
  ]

  ask turtles
  [
    update-wealth
  ]

  set g-mean-wealth mean [wealth] of turtles
  set g-max-utility max [expected-utility nobody] of patches

  color-turtles

  set-current-plot-pen "mean"
  plot mean-wealth
  set-current-plot-pen "sigma"
  plot stdev-wealth

  tick

  if ticks >= max-ticks
  [
    output-print (word "Total wealth: " precision total-wealth 2)
    output-print (word "Mean wealth: " precision mean-wealth 2)
    stop
  ]
end

;
;  INITIALIZATION ROUTINES
;
;

to initialize-globals
  ; set num-investors 100
  set profit-mean 5000
  ; set failure-min 0.01
  ; set failure-max 0.1
  set n-hplr 0
  set n-hphr 0
  set n-lplr 0
  set n-lphr 0
  set n-same 0
  set mv-hplr 0
  set mv-hphr 0
  set mv-lplr 0
  set mv-lphr 0
  set moves 0


  if failure-min > failure-max
  [
    user-message "ERROR: failure-min must be less than or equal to failure-max"
    set failure-max failure-min
  ]

  set time-horizon 5 ; years


  set g-mean-wealth 0
  set g-max-utility (profit-mean * time-horizon) * (1 - failure-min) ^ time-horizon

  ; set sense-radius 1
  ; set use-sense-radius? false

  ; set max-ticks 25

  set-default-shape turtles "circle"
end

to initialize-patches
  ask patches
  [
    set profit random-exponential profit-mean
    set p-failure failure-min + random-float (failure-max - failure-min)
  ]
  set g-max-utility max [expected-utility nobody] of patches
  color-patches
end

to initialize-turtle
  move-to one-of patches with [ not any? turtles-here ]
  set wealth 0
  set size 0.8
  color-turtle 1.0
end

;
;  TURTLE PROCESSING
;
;

to update-wealth ; turtle procedure
  set wealth wealth + profit
  if random-float 1.0 < p-failure [  set wealth 0 ]
end

to move
  let bp find-best-patch
  if [profit] of bp > profit and [p-failure] of bp < p-failure [ set n-hplr n-hplr + 1 ]
  if [profit] of bp > profit and [p-failure] of bp > p-failure [ set n-hphr n-hphr + 1 ]
  if [profit] of bp < profit and [p-failure] of bp < p-failure [ set n-lplr n-lplr + 1 ]
  if [profit] of bp < profit and [p-failure] of bp > p-failure [ set n-lphr n-lphr + 1 ]
  if bp = patch-here [ set n-same n-same + 1 ]
  set moves moves + 1
  move-to bp
end

to-report expected-utility [a-turtle]; patch reporter
  ifelse a-turtle = nobody
  [
    report (g-mean-wealth + time-horizon * profit) * (1.0 - p-failure) ^ time-horizon
  ]
  [
    report ([wealth] of a-turtle + time-horizon * profit) * (1.0 - p-failure) ^ time-horizon
  ]
end


to-report find-best-patch ; turtle reporter
  let candidates neighbors with [ not any? turtles-here ]

  let alt-hi-profit-lo-risk candidates with [
    (profit > [profit] of myself) and (p-failure < [p-failure] of myself) ]
  let alt-hi-profit-hi-risk candidates with [
    (profit > [profit] of myself) and (p-failure > [p-failure] of myself) ]
  let alt-lo-profit-lo-risk candidates with [
    (profit < [profit] of myself) and (p-failure < [p-failure] of myself) ]
  let alt-lo-profit-hi-risk candidates with [
    (profit < [profit] of myself) and (p-failure > [p-failure] of myself) ]


    let best-candidate patch-here

    let all-candidates (patch-set candidates patch-here)

    if any? alt-hi-profit-lo-risk [ set mv-hplr mv-hplr + 1]
    if any? alt-hi-profit-hi-risk [ set mv-hphr mv-hphr + 1]
    if any? alt-lo-profit-lo-risk [ set mv-lplr mv-lplr + 1]
    if any? alt-lo-profit-hi-risk [ set mv-lphr mv-lphr + 1]

    ifelse stochastic?
    [
      ifelse any? alt-hi-profit-lo-risk  and (random-bernoulli (p-high-profit-low-risk / 100))
        [ set best-candidate one-of alt-hi-profit-lo-risk ]
        [
          ifelse any? alt-hi-profit-hi-risk and (random-bernoulli (p-high-profit-high-risk / 100))
          [ set best-candidate one-of alt-hi-profit-hi-risk ]
          [
            ifelse any? alt-lo-profit-lo-risk and (random-bernoulli (p-low-profit-low-risk / 100))
            [ set best-candidate one-of alt-lo-profit-lo-risk ]
            [
              if any? alt-lo-profit-hi-risk and (random-bernoulli (p-low-profit-high-risk / 100))
              [ set best-candidate one-of alt-lo-profit-hi-risk ]
            ]
          ]
        ]
    ]
    [
      set best-candidate max-one-of all-candidates [expected-utility myself]
    ]

    report best-candidate
end

;
;  OBSERVER REPORTERS
;
;

to-report total-wealth ; observer reporter
  report sum [wealth] of turtles
end

to-report mean-wealth ; observer reporter
  report mean [wealth] of turtles
end

to-report stdev-wealth ; observer reporter
  report standard-deviation [wealth] of turtles
end

;
;
;  COLORING ROUTINES
;
;

to color-patches
  ;ifelse patch-color-mode = 1
  ifelse color-patches-by = "profit"
  [
    let min-profit 0
    let max-profit max [profit] of patches
    ask patches
    [
      set pcolor scale-color blue profit min-profit max-profit
    ]
  ]
  [
    ifelse color-patches-by = "p-failure"
    [
      ask patches
      [
        ifelse (failure-min < failure-max) and (failure-min > 0)
        [
          set pcolor scale-color red (ln p-failure) (ln failure-max) (ln failure-min)
        ]
        [
          set pcolor scale-color red (p-failure) 1 0
        ]
      ]
    ]
    [
      ask patches
      [
        set pcolor scale-color magenta (expected-utility nobody) 0 g-max-utility
      ]
    ]
  ]
end

to color-turtle [max-wealth]
  ifelse turtle-coloring-mode = "wealth"
  [
    ifelse max-wealth > 0
    [
      set color scale-color green wealth 0 max-wealth
    ]
    [
      set color black
    ]
  ]
  [
    set color red
  ]
end

to color-turtles
  let max-wealth max [wealth] of turtles
  ask turtles
    [
      color-turtle max-wealth
    ]
end

to-report random-bernoulli [p]
  if p < 0 or p > 1 [
    user-message (word
      "Warning in random-bernoulli: p = " p)
  ]
  report random-float 1.0 < p
end

to-report p-hplr
  report n-hplr / mv-hplr
end

to-report p-lplr
  report n-lplr / mv-lplr
end

to-report p-hphr
  report n-hphr / mv-hphr
end

to-report p-lphr
  report n-lphr / mv-lphr
end

to-report p-same
    report n-same / moves
end

to-report pct-format [x n-places]
  report word (precision (100 * x) n-places) "%"
end


to get-percentages
  let runs 0
  let n  [ 0 0 0 0 0 ]
  let mv [ 0 0 0 0 0 ]
  let p  [ 0 0 0 0 0 ]
  let total-w (list)
  let mean-w (list)
  repeat 1000 [
    setup
    set runs runs + 1
    while [ticks < max-ticks] [ go ]
    set total-w lput (sum [wealth] of turtles) total-w
    set mean-w lput (mean [wealth] of turtles) mean-w
    set n  (map + n   (list  n-hplr  n-hphr  n-lplr  n-lphr n-same))
    set mv (map + mv  (list mv-hplr mv-hphr mv-lplr mv-lphr  moves))
    type word runs " "
    if (runs mod 50) = 0 [print ""]
  ]
  set n-hplr item 0 n
  set n-hphr item 1 n
  set n-lplr item 2 n
  set n-lphr item 3 n
  set n-same item 4 n

  set mv-hplr item 0 mv
  set mv-hphr item 1 mv
  set mv-lplr item 2 mv
  set mv-lphr item 3 mv
  set moves   item 4 mv

  set p (map / n mv)
  set p (map [x -> precision (100 * x) 2] p)
  show n
  show mv
  show p
  output-print (word "Total wealth = " precision mean(total-w) 2)
  output-print (word "Mean wealth = " precision mean(mean-w) 2)
  set p-high-profit-low-risk  precision (item 0 p) 1
  set p-high-profit-high-risk precision (item 1 p) 1
  set p-low-profit-low-risk   precision (item 2 p) 1
  set p-low-profit-high-risk  precision (item 3 p) 1
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
788
589
-1
-1
30.0
1
10
1
1
1
0
0
0
1
0
18
0
18
1
1
1
ticks
30.0

BUTTON
13
27
77
60
Setup
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
14
68
77
101
Go
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

PLOT
798
10
1485
488
Mean  wealth
ticks
wealth (dollars)
0.0
25.0
0.0
10.0
true
true
"" ""
PENS
"mean" 1.0 0 -16777216 true "" ""
"sigma" 1.0 0 -13791810 true "" ""

OUTPUT
797
491
1098
610
12

CHOOSER
15
453
153
498
color-patches-by
color-patches-by
"profit" "p-failure" "exp utility"
2

SLIDER
14
303
186
336
max-ticks
max-ticks
0
500
25.0
1
1
NIL
HORIZONTAL

SLIDER
14
339
186
372
num-investors
num-investors
0
381
25.0
1
1
NIL
HORIZONTAL

SLIDER
14
375
186
408
failure-min
failure-min
0
1
0.01
0.01
1
NIL
HORIZONTAL

SLIDER
14
411
186
444
failure-max
failure-max
0
1
0.1
0.01
1
NIL
HORIZONTAL

BUTTON
99
69
162
102
Step
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

CHOOSER
15
507
153
552
turtle-coloring-mode
turtle-coloring-mode
"wealth" "red"
0

BUTTON
15
568
121
601
Redraw
color-patches\ncolor-turtles
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
15
116
132
149
stochastic?
stochastic?
0
1
-1000

SLIDER
13
154
199
187
p-high-profit-low-risk
p-high-profit-low-risk
0
100
78.0
0.1
1
%
HORIZONTAL

SLIDER
12
190
199
223
p-high-profit-high-risk
p-high-profit-high-risk
0
100
9.3
0.1
1
%
HORIZONTAL

SLIDER
12
227
198
260
p-low-profit-low-risk
p-low-profit-low-risk
0
100
3.4
0.2
1
%
HORIZONTAL

SLIDER
13
264
199
297
p-low-profit-high-risk
p-low-profit-high-risk
0
100
0.0
1
1
%
HORIZONTAL

BUTTON
92
27
203
60
Default values
set p-high-profit-low-risk 83.4\nset p-high-profit-high-risk 5.4\nset p-low-profit-low-risk 4.9\nset p-low-profit-high-risk 0
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1169
497
1226
542
P hp lr
pct-format p-hplr 1
1
1
11

MONITOR
1232
496
1289
541
P hp hr
pct-format p-hphr 1
1
1
11

MONITOR
1296
495
1353
540
P lp lr
pct-format p-lplr 1
1
1
11

MONITOR
1362
495
1419
540
P lp hr
pct-format p-lphr 1
1
1
11

MONITOR
1427
495
1484
540
P same
pct-format p-same 1
1
1
11

@#$#@#$#@
# Business Investor Model


# A Business Investor Model

We demonstrate the sensing concept via a simple business model. In fields dealing with people and organizations, other terms such as "information acquisition" might be more intuitive than "sensing," but the concept is the same: when building an ABM we need to decide, and then program, exactly what information our agents have and where they get it.

This model simulates how people decide which business to invest in, when the alternative businesses they choose from differ in their annual profit and in their risk of failing such that the investors lose all their wealth. These business alternatives are modeled as NetLogo patches, a use of patches to represent something other than geographic space. In the first version, investors (modeled as turtles) are assumed to sense financial information only from neighbor patches; in a second version we will add links among turtles and simulate sensing through a network. As exercises, we will explore how different assumptions about sensing affect the results of this model. (In later chapters we will explore the effects of other assumptions, especially the way investors make trade-offs between profit and risk.)

## Purpose

The primary purpose of this model is to explore effects of "sensing"---what information agents have and how they obtain it---on emergent outcomes of a model in which agents make adaptive decisions using sensed information. The model uses investment decisions as an example, but is not intended to represent any real investment approach or business sector. (In fact, you will see by the end of Chapter 12 that models like this one that are designed mainly to explore the system-level effects of sensing and other concepts can produce very different results depending on exactly how those concepts are implemented. What can we learn from such models if their results depend on what seem like details? In part III of this course we will learn to solve this problem by tying models more closely to real systems.)

This model could be thought of as approximately representing people who buy and operate local businesses: it assumes investors are familiar with investment opportunities within a limited range of their own experience, and that there is no cost of entering or switching investments (e.g., as if capital to buy a business is borrowed and the repayment is included in the annual profit calculation).

## Entities, state variables and scales

The entities in this model are investor agents (turtles) and business alternatives (patches) that vary in profit and risk. The investors have state variables for their location in the space and for their current wealth (*W*, in money units).

The landscape is a grid of business patches, which each have two static variables: the annual net profit the business there provides (*P*, in money units such as dollars per year), and the annual risk of the business there failing and its investor losing all its wealth (*F*, as probability per year). This landscape is *19 &times; 19* patches in size with no wrapping at its edges.

The model time step is one year, and simulations run for 25 years.

## Process overview and scheduling

The model includes the following actions that are executed in this order each time step.

* *Investor repositioning.* The investors decide whether any similar business (adjacent patch) offers a better trade-off of profit and risk; if so, they "reposition" and transfer their investment to that patch, by moving there. Only one investor can occupy a patch at a time. The agents execute this repositioning action in randomized order.

* *Accounting.* The investors update their wealth state variable. *W* is set equal to the previous wealth plus the profit of the agent's current patch. However, unexpected failure of the business is also included in the accounting action. This event is a stochastic function of F at the investor's patch. If a uniform random number between zero and one is less than *F*, then the business fails: the investor's *W* is set to zero, but the investor stays in the model and nothing else about it changes.

* *Output.* The World display, plots, and an output file are updated.

## Design concepts

### Basic principles

The basic topic of this model is how agents make decisions involving trade-offs between several objectives—here, increasing profit and decreasing risk.

### Emergence

The model's primary output is mean investor wealth, over time. Important secondary outputs are the mean profit and risk chosen by investors over time, and the number of investors who have suffered a failure. These outputs emerge from how individual investors make their trade-offs between profit and risk, but also from the "business climate": the ranges of *P* and *F* values among patches and the number of investors competing for locations on the landscape.

### Adaptation

The adaptive behavior of investor agents is their decision of which neighboring business to move to (or whether to stay put), considering the profit and risk of these alternatives. Each time step, investors can reposition to any unoccupied one of their adjacent patches, or retain their current position. In this version of the model, investors use a simplified microeconomic analysis to make their decision, moving to the patch providing highest value of an objective function.

### Objectives

In economics, the term "utility" is used for the objective that agents seek. Investors rate business alternatives by a utility measure that represents their expected future wealth at the end of a time horizon (*T*, a number of future years; we use 5). This expected future wealth is a function of their current wealth and the profit and failure risk offered by the patch:

U = (W + T P) (1 - F)<sup>T</sup>

where *U* is expected utility for the patch, *W* is the investor's current wealth, and *P* and *F* are defined above. The term *(W + T P)* estimates investor wealth at the end of the time horizon if no failures occur. The term *(1 - F)<sup>T</sup>* is the probability of not having a failure over the time horizon; it reduces utility more as failure risk increases. (Economists might expect to use a utility measure such as present value that includes a discount rate to reduce the value of future profit. We ignore discounting to keep this model simple.)

### Learning

There is no learning.

### Prediction

The utility measure estimates utility over a time horizon by using the explicit prediction that *P* and *F* will remain constant over the time horizon. This assumption is accurate here because the patches’ *P* and *F* values are static.

### Sensing

The investor agents are assumed to know the profit and risk at their own patch and the adjacent neighbor patches, without error.

### Interaction

The investors interact with each other only indirectly via competition for patches; an investor cannot take over a business (move into a patch) that is already occupied by another investor. Investors execute their repositioning action in randomized order, so there is no hierarchy in this competition: investors with higher wealth have no advantage over others in competing for locations.

### Stochasticity

The initial state of the model is stochastic: the values of *P* and *F* of each patch, and initial investor locations, are set randomly. Stochasticity is thus used to simulate an investment environment where alternatives are highly variable and risk is not correlated with profit. Whether each investor fails each year is also stochastic, a simple way to represent risk. The investor reposition action uses stochasticity only in the very unlikely event that more than one potential destination patch offers the same highest utility; when there is such a tie the agent randomly chooses one of the tied patches to move to.

### Collectives

There are no collectives.

### Observation

The World display shows the location of each agent on the investment landscape. Graphs show the mean profit and risk experienced by investors, and mean investor wealth over time. An output file reports the state of each investor at each time step.

## Initialization

Four model parameters are used to initialize the investment landscape. These define the minimum and maximum values of *P* (1000 and 10,000) and *F* (0.01 and 0.1). The values of *P* and *F* for each patch are drawn randomly from uniform real number distributions with these minimum and maximum values.

One hundred investor agents are initialized and put in random patches, but investors cannot be placed in a patch already occupied by another investor. Their wealth state variable *W* is initialized to zero.

## Input data

No time-series inputs are used.

## Submodels

* *Investor repositioning.* An agent identifies all the businesses that it could invest in; the neighboring (eight, or fewer if on the edge of the space) patches that are unoccupied, plus its current patch. The agent then determines which of these alternatives provides the highest value of the utility function, and moves (or stays) there.

* *Accounting.* This action is fully described above ("Process overview and scheduling").
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
NetLogo 6.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="vary-stochasticity" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>mean [wealth] of turtles</metric>
    <metric>standard-deviation [wealth] of turtles</metric>
    <enumeratedValueSet variable="stochastic?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="failure-max">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-low-profit-low-risk">
      <value value="3.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="turtle-coloring-mode">
      <value value="&quot;wealth&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-high-profit-high-risk">
      <value value="9.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="failure-min">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-low-profit-high-risk">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-high-profit-low-risk">
      <value value="78"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="color-patches-by">
      <value value="&quot;exp utility&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-investors">
      <value value="25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="vary-probabilities" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>mean [wealth] of turtles</metric>
    <metric>standard-deviation [wealth] of turtles</metric>
    <enumeratedValueSet variable="stochastic?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="failure-max">
      <value value="0.1"/>
    </enumeratedValueSet>
    <steppedValueSet variable="p-low-profit-low-risk" first="0" step="2" last="10"/>
    <enumeratedValueSet variable="turtle-coloring-mode">
      <value value="&quot;wealth&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="p-high-profit-high-risk" first="0" step="10" last="50"/>
    <enumeratedValueSet variable="failure-min">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-low-profit-high-risk">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="25"/>
    </enumeratedValueSet>
    <steppedValueSet variable="p-high-profit-low-risk" first="70" step="10" last="100"/>
    <enumeratedValueSet variable="color-patches-by">
      <value value="&quot;exp utility&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-investors">
      <value value="25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="get-probabilities" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>p-hplr</metric>
    <metric>p-hphr</metric>
    <metric>p-lplr</metric>
    <metric>p-lphr</metric>
    <metric>p-same</metric>
    <enumeratedValueSet variable="stochastic?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="failure-max">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-high-profit-high-risk">
      <value value="4.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="turtle-coloring-mode">
      <value value="&quot;wealth&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-low-profit-low-risk">
      <value value="3.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="failure-min">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-low-profit-high-risk">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-high-profit-low-risk">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="color-patches-by">
      <value value="&quot;exp utility&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-investors">
      <value value="25"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
