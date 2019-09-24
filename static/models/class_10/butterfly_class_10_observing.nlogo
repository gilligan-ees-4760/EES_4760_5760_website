globals [
  ;q
  ]        ; q is the probability that a butterfly moves
                     ; directly to the highest surrounding patch
patches-own [
  elevation
  visited?
  ]
turtles-own [
  initial-patch
  finished?
  chosen?
  ]

to setup

  ca

  set q precision q 2
  set num-butterflies max list num-butterflies 1

  let x0 74
  let y0 74

  ; Assign an elevation to patches and color them by it
  ifelse (real-terrain)
  [
    input-elevation
    set x0 110
    set y0 135
  ]
  [
    build-hills
    set x0 85
    set y0 95
  ]
  ask patches
  [
    set visited? false
  ]    ; end of "ask patches"

  ;  Create just 1 butterfly for now
  crt num-butterflies
   [
     set size 2
     set color red
     ; Set initial location of butterflies
     setxy x0 + random 10 - 5 y0 + random 10 - 5
     set initial-patch patch-here
     set finished? false
     set chosen? false
     pen-down
   ]
   ask one-of turtles [set chosen? true]
   update-display
   reset-ticks
end           ; of setup procedure

to go  ;  This is the master schedule
  ask turtles with [not finished?] [move]
  update-display
  tick
  ; stop when all the butterflies are at the summit, or
  ; 1000 ticks, whichever comes first
  if ticks >= 1000 or all? turtles [finished?] = 0 [stop]
end ; of go

to move  ; The butterfly move procedure, in turtle context
         ; Decide whether to the highest
         ; surrounding patch with probability q
  ifelse random-float 1 < q
    [
      move-to max-one-of neighbors [elevation] ; Move uphill
      set color red

    ]
    [
      move-to one-of neighbors ; Otherwise move randomly
      set color blue
      ]
  set visited? true
  ; ask turtles with [ chosen? ] [ set label precision elevation 0 ]
end ; of move procedure

to build-hills
  ask patches
  [
         ; Patch elevation decreases linearly with distance from the center
       ; of hills. Hills are at (30, 30) and (120, 100). The first hill is
       ; 100 units high. The second hill is 50 units high.

      let elev1 100 - distancexy 30 30
      let elev2 50 - distancexy 120 100

      ifelse elev1 > elev2
         [set elevation elev1]
         [set elevation elev2]
  ]
end

to input-elevation
  file-open "ElevationData.txt"
  while [not file-at-end?]
  [
    let next-x file-read
    let next-y file-read
    let next-elevation file-read
    ask patch next-x next-y [set elevation next-elevation]
  ]
  file-close
end

to color-patches
  ifelse patch-coloring = "elevation"
  [
    let max-elevation max [elevation] of patches
    let min-elevation min [elevation] of patches
    ask patches [ set pcolor scale-color green elevation min-elevation max-elevation]
  ]
  [
    let max-turtles max [count turtles-here] of patches
    let min-turtles 0
    ask patches [ set pcolor scale-color cyan (count turtles-here) min-turtles max-turtles]
  ]

end

to update-display
  color-patches
  ifelse show-butterflies?
  [ ask turtles [show-turtle]]
  [ ask turtles [hide-turtle]]
  if show-labels?
  [ ask turtles with [chosen?] [set label elevation] ]
end

;  Corridor width is the number of patches visited by butterflies
;  divided by the average distance a butterfly is from its initial position
;
;  If a butterfly moves in a straight line, the number of patches visited
;  equals the distance from its initial patch, so corridor-width = 1
;  The more a butterfly wanders off a straight line, the more patches
;  it will visit, so the wider the corridor will be.
;
to-report corridor-width
  let pcount count patches with [visited?]
  let dist mean [distance initial-patch] of turtles
  ifelse dist = 0
  [report 1]
  [report pcount / dist]
end

to-report fraction-crowded
  let crowd-count sum [count turtles-here] of patches with [count turtles-here >= 4]
  report crowd-count / num-butterflies
end
@#$#@#$#@
GRAPHICS-WINDOW
295
10
753
469
-1
-1
3.0
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
149
0
149
1
1
1
ticks
30.0

BUTTON
15
20
86
53
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
15
60
79
94
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

SLIDER
20
105
192
138
q
q
0
1
0.6
0.01
1
NIL
HORIZONTAL

MONITOR
20
350
114
395
Corridor Width
corridor-width
2
1
11

SWITCH
95
20
205
53
real-terrain
real-terrain
0
1
-1000

BUTTON
95
60
158
93
step
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

SLIDER
20
145
192
178
num-butterflies
num-butterflies
0
50
50.0
5
1
NIL
HORIZONTAL

CHOOSER
20
185
158
230
patch-coloring
patch-coloring
"elevation" "turtles"
0

BUTTON
135
290
232
323
Erase paths
clear-drawing
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
20
235
167
268
show-butterflies?
show-butterflies?
0
1
-1000

MONITOR
120
350
217
395
mean elevation
mean [elevation] of turtles
2
1
11

BUTTON
20
290
132
323
Update Display
update-display
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
155
235
277
268
show-labels?
show-labels?
1
1
-1000

MONITOR
20
410
112
455
Mean turtles
mean [count turtles-here] of patches with [any? turtles-here]
2
1
11

MONITOR
125
410
232
455
Fraction crowded
fraction-crowded
2
1
11

PLOT
775
35
975
185
Patch density
Turtles per patch
count
1.0
20.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram [count turtles-here] of patches"

PLOT
775
200
975
350
Fraction crowded
Tick
Percent
0.0
10.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot 100 * fraction-crowded"

PLOT
775
355
975
505
Mean elevation
tick
Elevation
0.0
10.0
500.0
500.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [elevation] of turtles"

@#$#@#$#@
# Butterfly Model ODD Description

This file describes the model of Pe'er et al. (2005). The description is taken from Section 3.4 of Railsback and Grimm (2019). The file uses the markup language used by NetLogo's Info tab starting with NetLogo version 5.0.

## 1. Purpose and patterns

The model was designed to explore questions about virtual corridors. Under what conditions do the interactions of butterfly hilltopping behavior and landscape topography lead to the emergence of virtual corridors, that is, relatively narrow paths along which many butterflies move? How does variability in the butterflies' tendency to move uphill affect the emergence of virtual corridors? This model does not represent a specific place or species of butterfly, so only general patterns are used as criteria for its usefulness for answering these questions: that butterflies can reach hilltops, and that their movement has a strong stochastic element representing the effects of factors other than elevation.

## 2. Entities, State Variables, and Scales

The model has two kinds of entities: butterflies and square patches of land. The patches make up a square grid landscape of 150 &times; 150 patches, and each patch has one state variable: its elevation. Butterflies are characterized only by their location, described as the patch they are on. Therefore, butterfly locations are in discrete units, the x- and y- coordinates of the center of their patch. Patch size and the length of one time step in the simulation are not specified because the model is generic, but when real landscapes are used, a patch corresponds to 25 &times; 25 m<sup>2</sup>. Simulations last for 1000 time steps; the length of one time step is not specified but should be about the time it takes a butterfly to move 25--35 m (the distance from one cell to one of its neighbor cells).

## 3. Process Overview and Scheduling

There is only one process in the model: movement of the butterflies. On each time step, each butterfly moves once. The order in which the butterflies execute this action is unimportant because there are no interactions among the butterflies.

## 4. Design Concepts

The _basic principle_ addressed by this model is the concept of virtual corridors---pathways used by many individuals when there is nothing particularly beneficial about the habitat in them. This concept is addressed by seeing when corridors _emerge_ from two parts of the model: the adaptive movement behavior of butterflies and the landscape they move through. This _adaptive behavior_ is modeled via a simple empirical rule that reproduces the behavior observed in real butterflies: moving uphill. This behavior is based on the understanding (not included in the model) that moving uphill leads to mating, which conveys fitness (success at passing on genes, the presumed ultimate objective of organisms). Because the hilltopping behavior is assumed a priori to be the objective of the butterflies, the concepts of _Objectives_ and _Prediction_ are not explicitly considered. There is no _learning_ in the model.

_Sensing_ is important in this model: butterflies are assumed able to identify which of the surrounding patches has the highest elevation, but to use no information about elevation at further distances. (The field studies of Pe'er 2003 addressed this question of how far butterflies sense elevation differences.)

The model does not include _interaction_ among butterflies; in field studies, Pe'er (2003) found that real butterflies do interact (they sometimes stop to visit each other on the way uphill) but decided it is not important to include interaction in a model of virtual corridors.

_Stochasticity_ is used to represent two sources of variability in movement that are too complex to represent mechanistically. Real butterflies do not always move directly uphill, likely because of (1) limits in the ability of the butterflies to sense the highest area in their neighborhood, and (2) factors other than topography (e.g., flowers that need investigation along the way) that influence movement direction. This variability is represented by assuming butterflies do not move uphill every time step; sometimes they move randomly instead. Whether a butterfly moves directly uphill or randomly at any time step is modeled stochastically, using a parameter _q_ that is the probability of an individual moving directly uphillinstead of randomly.

_Collectives_ are not represented in this model.

To allow _observation_ of the two patterns used to define the model's usefulness, we use graphical display of topography and butterfly locations. Observing virtual corridors requires a specific "corridor width" measure that characterizes the width of butterfly paths from their starting patches to hilltops.

## 5. Initialization
The topography of the landscape (the elevation of each patch) is initialized when the model starts. Two kinds of landscapes are used in different versions of the model: (1) a simple artificial topography, and (2) the topography of a real study site, imported from a file containing elevation values for each patch. The butterflies are initialized by creating five hundred of them and dispersing them throughout the landscape: each butterfly's initial location is set to a patch selected randomly from among all patches.

## 6. Input Data
The environment is assumed to be constant, so the model has no input data.

## 7. Submodels
The movement submodel defines exactly how butterflies decide whether to move uphill or randomly. First, to "move uphill" is defined specifically as moving to the neighbor patch that has the highest elevation; if two patches have the same elevation, one is chosen randomly. "Move randomly" is defined as moving to one of the neighboring patches, with equal probability of choosing any patch. "Neighbor patches" are the eight patches surrounding the butterfly's current patch. The decision of whether to move uphill or randomly is controlled by the parameter _q_, which ranges from 0.0 to 1.0 (_q_ is a global variable: all butterflies use the same value). On each time step, each butterfly draws a random number from a uniform distribution between 0.0 and 1.0. If this random number is less than _q_, the butterfly moves uphill; otherwise, the butterfly moves randomly.

## CREDITS AND REFERENCES

Pe'er, G., Saltz, D. & Frank, K. 2005. Virtual corridors for conservation management. _Conservation Biology_, 19, 1997--2003.

Pe'er, G. 2003. Spatial and behavioral determinants of butterfly movement patterns in topographically complex landscapes. Ph.D. thesis, Ben-Gurion University of the Negev.

Railsback, S. & Grimm, V. 2018. _Agent-based and individual-based modeling: A practical introduction, Second edition_. Princeton University Press, Princeton, NJ.
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
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

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
  <experiment name="vary-q-all-steps" repetitions="20" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>corridor-width</metric>
    <steppedValueSet variable="q" first="0" step="0.1" last="1"/>
  </experiment>
  <experiment name="vary-q-final-only" repetitions="20" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>corridor-width</metric>
    <steppedValueSet variable="q" first="0" step="0.1" last="1"/>
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
1
@#$#@#$#@
