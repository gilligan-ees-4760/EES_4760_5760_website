;--------------------------------------------------------------------------------------
; This program was developed using NetLogo 3.1.4 (http://ccl.northwestern.edu/netlogo)
; by Roger Jovani and Volker Grimm in Leipzig (Germany) and Sevilla (Spain), 2007
;
; It implements the model described in:
;
;   Jovani, R. and Grimm, V. 200X. Breeding synchrony in colonial birds: from local stress
;   to global harmony
;
; This is the BASIC MODEL discussed in that paper.
;
; The program is free of use for research and education. If you use this program or model
; for your own research, please refer to our paper as described above.
;
; Copyright: Roger Jovani and Volker Grimm, Leipzig and Sevilla, 2007
;--------------------------------------------------------------------------------------

globals
[
  days               ; One time step of the model corresponds to one day
  number_incubating  ; Number of incubating females
  maxpatch           ; Female with the highest initial OSL at the beginning of the simulation
  minpatch           ; Female with the lowest initial OSL at the beginning of the simulation
  SD                 ; Stress Decay each day owed to the enlargment of the day
]

patches-own          ; Patches represent female birds occupying a certain nest site
[
  STATE_old          ; STATE can be either 0 (pre-laying) or 1 (incubating)
  STATE_new
  OSL_new            ; The bird's Own Stess Level
  OSL_old
  LD                 ; Laying date: the day when the female lay its egg
]

to setup
  clear-all
  reset-ticks
  set number_incubating 0
  set SD 10
  set days 1

  ask patches
  [
    set STATE_old 0                  ; All females start as pre-laying
    set OSL_old 100 + random 201     ; Females start with a random OSL between 100 and 300
    ;set LD -1
    set pcolor white
  ]

  ; Select a subsample of females for plotting contrasting examples of OSL dynamics:
  set minpatch min-one-of patches [OSL_old]
  set maxpatch max-one-of patches [OSL_old]

  do-plots
end

to go
  step
  ; Stop simulation after 200 days of if all females are breeding:
  if ((days = 200) or (number_incubating = world-width * world-height )) [stop]
end

to step
  ask patches with [STATE_old = 0]
  [
    stress-level-dynamics
  ]
  ask patches with [STATE_old = 0]
  [
    ; Synchronous updating of states:
    set STATE_old STATE_new
    set OSL_old OSL_new

    ; Display laying dates (LD) in a green scale
    if STATE_old = 1
    [ set pcolor scale-color green LD 0 50 ]
  ]
  set days days + 1
  do-plots
end

to stress-level-dynamics
  ; Calculate the mean OSL of the eight neighbor birds:
  let meanNSL mean [OSL_old] of neighbors

  ; See [Eq 1] in the accompanying paper by Jovani & Grimm
  set OSL_new (1 - NR) * OSL_old + (NR * meanNSL) - SD

  ; If stress is below or equal to 10 the female lay its egg and the current day becomes its laying date (LD)
  ifelse OSL_new <= 10
  [
    set STATE_new  1  ; State changes to "breeding"
    set OSL_new 0     ; Breeding birds have OSL of zero
    set LD days       ; Set the laying date to the current day number
    set number_incubating number_incubating + 1
  ]
  [ set STATE_new 0 ]
end

to do-plots
  ; Plot stress dynamics for females with the highest and lowest initial OSL and 10 other females:
  set-current-plot "Stress examples"
  set-current-plot-pen "minOSL"
  set-plot-pen-color red
  plot [OSL_old] of minpatch
  set-current-plot-pen "patch1"
  plot [OSL_old] of patch 0 0
  set-current-plot-pen "patch2"
  plot [OSL_old] of patch 5 5
  set-current-plot-pen "patch3"
  plot [OSL_old] of patch 10 10
  set-current-plot-pen "patch4"
  plot [OSL_old] of patch 15 15
  set-current-plot-pen "patch5"
  plot [OSL_old] of patch 20 20
  set-current-plot-pen "patch6"
  plot [OSL_old] of patch 25 25
  set-current-plot-pen "patch7"
  plot [OSL_old] of patch 30 30
  set-current-plot-pen "patch8"
  plot [OSL_old] of patch 35 35
  set-current-plot-pen "patch9"
  plot [OSL_old] of patch 40 40
  set-current-plot-pen "patch10"
  plot [OSL_old] of patch 45 45
  set-current-plot-pen "maxOSL"
  set-plot-pen-color red
  plot [OSL_old] of maxpatch

  ; Plot the histogram of laying dates:
  set-current-plot "Laying dates histogram"
  set-current-plot-pen "LD"
  histogram [LD] of patches
end
@#$#@#$#@
GRAPHICS-WINDOW
597
26
1054
484
-1
-1
4.49
1
5
1
1
1
0
1
1
1
0
99
0
99
0
0
1
ticks
30.0

BUTTON
11
10
77
43
NIL
SETUP
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
11
57
78
91
NIL
GO
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
12
152
142
185
NR
NR
0
1
0.2
0.01
1
NIL
HORIZONTAL

TEXTBOX
158
153
465
185
Relevance given to the stress of neighbours\nShift the slider with the mouse to change NR\n
11
0.0
0

MONITOR
123
207
181
252
NIL
days
3
1
11

BUTTON
11
101
77
138
STEP
step
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
11
207
219
252
incubating females (green patches)
number_incubating\n;count patches with [STATE_new = 1]\n
3
1
11

PLOT
309
270
589
504
Laying dates histogram
laying date
# females
1.0
50.0
0.0
10.0
true
false
"" ""
PENS
"LD" 1.0 1 -16777216 true "" ""

PLOT
10
270
302
504
Stress examples
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
"patch1" 1.0 0 -16777216 true "" ""
"patch2" 1.0 0 -16777216 true "" ""
"patch3" 1.0 0 -16777216 true "" ""
"patch4" 1.0 0 -16777216 true "" ""
"minOSL" 1.0 0 -2064490 true "" ""
"maxOSL" 1.0 0 -1184463 true "" ""
"patch5" 1.0 0 -16777216 true "" ""
"patch6" 1.0 0 -16777216 true "" ""
"patch7" 1.0 0 -16777216 true "" ""
"patch8" 1.0 0 -16777216 true "" ""
"patch9" 1.0 0 -16777216 true "" ""
"patch10" 1.0 0 -16777216 true "" ""

TEXTBOX
96
21
246
39
Initialize the simulation
11
0.0
1

TEXTBOX
95
68
280
96
Run the simulation continuously
11
0.0
1

TEXTBOX
95
113
288
141
Run only one day of the simulation
11
0.0
1

TEXTBOX
580
10
1087
66
Map (aerial view) of the colony. Each small square is a female. Darker greens show earlier laying dates.
11
0.0
1

@#$#@#$#@
#Breeding Synchrony Model
This program was developed using NetLogo 3.1.4 (http://ccl.northwestern.edu/netlogo)
by Roger Jovani and Volker Grimm in Leipzig (Germany) and Sevilla (Spain), 2007
 
It implements the model described in: 

> Jovani, R. and Grimm, V. 2008. Breeding synchrony in colonial birds: 
> from local stress to global harmony.
> _Proceedings of the Royal Society of London B_, 275, 1557-1563.
 
This is the BASIC MODEL discussed in that paper.

The program is free of use for research and education. If you use this program or model
for your own research, please refer to our paper as described above.

Copyright: Roger Jovani and Volker Grimm, Leipzig and Sevilla, 2007

A full ODD description of this model is in Section 23.4.1 of _Agent-based and Individual-based Modeling: A Practical Introduction_ by Railsback and Grimm.
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

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 30 225
Line -7500403 true 150 150 270 225

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
NetLogo 6.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment1" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <exitCondition>count patches with [STATE_old = 1] = 1225</exitCondition>
    <metric>count patches with [STATE_old = 1]</metric>
    <metric>mean [LD] of patches</metric>
    <metric>max [LD] of patches</metric>
    <metric>min [LD] of patches</metric>
    <enumeratedValueSet variable="RNSL">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OTSL">
      <value value="10"/>
    </enumeratedValueSet>
    <steppedValueSet variable="NR" first="0" step="0.1" last="1"/>
    <steppedValueSet variable="STOCHASTICITY" first="0" step="0.2" last="0.8"/>
    <enumeratedValueSet variable="SD">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment2" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <exitCondition>count patches with [STATE_old = 1] = 1225</exitCondition>
    <metric>count patches with [STATE_old = 1]</metric>
    <metric>mean [LD] of patches</metric>
    <metric>max [LD] of patches</metric>
    <metric>min [LD] of patches</metric>
    <steppedValueSet variable="RNSL" first="50" step="1" last="55"/>
    <enumeratedValueSet variable="OTSL">
      <value value="10"/>
    </enumeratedValueSet>
    <steppedValueSet variable="NR" first="0" step="0.01" last="1"/>
    <enumeratedValueSet variable="SD">
      <value value="20"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="with MEANS" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <exitCondition>count patches with [STATE_old = 1] = 100</exitCondition>
    <metric>count patches with [STATE_old = 1]</metric>
    <metric>mean [LD] of patches</metric>
    <metric>max [LD] of patches</metric>
    <metric>min [LD] of patches</metric>
    <metric>ask patches[</metric>
    <metric>print [pxcor]</metric>
    <metric>print [pycor]</metric>
    <metric>print [LD]</metric>
    <metric>]</metric>
    <enumeratedValueSet variable="NR">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STOCHASTICITY">
      <value value="0.05"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="lineal decay" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <exitCondition>count patches with [STATE_old = 1] = 10000</exitCondition>
    <metric>count patches with [STATE_old = 1]</metric>
    <metric>median [LD] of patches</metric>
    <metric>max [LD] of patches</metric>
    <metric>min [LD] of patches</metric>
    <metric>standard-deviation [LD] of patches</metric>
    <steppedValueSet variable="NR" first="0.5" step="0.1" last="1.1"/>
    <enumeratedValueSet variable="SD">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STOCHASTICITY">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="SD">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STOCHASTICITY">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NR">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <exitCondition>number_incubating = 10000</exitCondition>
    <enumeratedValueSet variable="arrival-rate">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="STOCHASTICITY">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="NR" first="0" step="0.04" last="1.04"/>
    <enumeratedValueSet variable="always-empty">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="empty">
      <value value="0"/>
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
