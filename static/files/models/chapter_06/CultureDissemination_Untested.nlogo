globals
[
  a-site-changed?
  time-since-last-change
  ; test-output-on? Moved to switch on Interface
]

patches-own
[
  ; Patches have five "cultural feature" variables
  Var1
  Var2
  Var3
  Var4
  Var5

  mean-similarity  ; The mean similarity over four neighbor patches
]

to setup

  ca
  reset-ticks

  set test-output-on? false

  set time-since-last-change 0

  ask patches
  [
    set Var1 random 10
    set Var2 random 10
    set Var3 random 10
    set Var4 random 10
    set Var5 random 10
  ]

  if test-output-on?
  [
    if file-exists? "similarity-test-output.csv"
    [
      file-delete "similarity-test-output.csv"
      file-open "similarity-test-output.csv"
      file-print "My-var1,My-var2,My-var3,My-var4,My-var5,Their-var1,Their-var2,Their-var3,Their-var4,Their-var5,Similarity"
      file-close
    ]

    if file-exists? "update-test-output.csv"
    [
      file-delete "update-test-output.csv"
      file-open "update-test-output.csv"
      file-print "Neighbor1Similarity,Neighbor2Similarity,Neighbor3Similarity,Neighbor4Similarity,MeanSimilarity"
      file-close
    ]

    if file-exists? "interact-test-output.csv"
    [
      file-delete "update-test-output.csv"
      file-open "update-test-output.csv"
      file-print (word "Prob-interact,The-rand-number,"
        "My-var1,My-var2,My-var3,My-var4,My-var5,Their-var1,Their-var2,Their-var3,Their-var4,Their-var5,"
        "The-rand-var,New-var1,New-var2,New-var3,New-var4,New-var5")
      file-close
    ]
  ] ; if test-output-on?

  ask patches [ update-similarity ]

end


to go

  tick

  ask one-of patches [ interact ]

  ifelse a-site-changed?
  [ set time-since-last-change 0 ]
  [ set time-since-last-change time-since-last-change + 1 ]

  update-outputs

  if time-since-last-change >= 1000 [stop]

end


to interact  ; a patch procedure

  ; Create a string to hold one line of test output
  let a-test-output-string " "

  let the-neighbor one-of neighbors4

  let prob-interact similarity-with the-neighbor
  let the-rand-number random 1.0

  ; Add interaction probability and random number to test output
  if test-output-on?
  [
    set a-test-output-string (word prob-interact "," the-rand-number ",")
  ]

  ; if prob-interact is > 0.8, then you are already identical to neighbor
  ; if prob-interact is < 0.2, then prob-interact is zero and you cannot interact
  if (prob-interact < 0.9) and (prob-interact > 0.1) and (the-rand-number < prob-interact)
  [
    if test-output-on?
    [
      ; Add culture variable values of self and neighbor to output line
      set a-test-output-string (word a-test-output-string Var1 "," Var2 "," Var3 "," Var4 "," Var5 ","
      [Var1] of the-neighbor ","
      [Var2] of the-neighbor ","
      [Var3] of the-neighbor ","
      [Var4] of the-neighbor ","
      [Var5] of the-neighbor ",")
    ]

    ; Create a list containing the position (1-5) of all variables that are
    ; different between this patch and the selected neighbor
    let var-list (list)
    if (Var1 != [Var1] of the-neighbor) [set var-list fput 1 var-list]
    if (Var2 != [Var2] of the-neighbor) [set var-list fput 2 var-list]
    if (Var3 != [Var3] of the-neighbor) [set var-list fput 3 var-list]
    if (Var4 != [Var4] of the-neighbor) [set var-list fput 4 var-list]
    if (Var5 != [Var5] of the-neighbor) [set var-list fput 5 var-list]

    ; Now pick a random member of the list and modify that variable to
    ; match the neighbor's value
    let rand-var one-of var-list
    if (rand-var = 1) [set Var1 [Var1] of the-neighbor]
    if (rand-var = 2) [set Var2 [Var2] of the-neighbor]
    if (rand-var = 3) [set Var3 [Var3] of the-neighbor]
    if (rand-var = 4) [set Var4 [Var4] of the-neighbor]
    if (rand-var = 5) [set Var5 [Var5] of the-neighbor]

    set a-site-changed? true

    ; Add new culture variables to output line
    if test-output-on?
    [
      set a-test-output-string (word a-test-output-string rand-var "," Var1 "," Var2 "," Var3 "," Var4 "," Var5)
    ]

  ]

  update-similarity
  ask neighbors4 [ update-similarity ]

  if test-output-on?
  [
    file-open "interact-test-output.csv"
    file-print a-test-output-string
    file-close
  ]

end


to update-similarity   ; a patch procedure
  ; Set the patch's value of mean similarity with neighbors by summing
  ; similarity over the 4 neighbors, then dividing by 4.

  set mean-similarity 0

  ; Create a string to hold one line of test output
  let test-output-string " "

  ask neighbors4
  [
    let my-similarity similarity-with myself
    ask myself [set mean-similarity (mean-similarity + my-similarity)]
    ; Each neighbor patch adds its similarity to the output line
    set test-output-string (word test-output-string my-similarity ",")
  ]

  set mean-similarity (mean-similarity / 4)

  set pcolor scale-color red mean-similarity 0.0 1.0

  if test-output-on?
  [
    file-open "update-test-output.csv"
    file-print (word test-output-string mean-similarity)
    file-close
  ]

end

to-report similarity-with [a-patch]  ; a patch procedure

  let similarity 0.0
  if Var1 = [Var1] of a-patch [ set similarity similarity + 0.2 ]
  if Var2 = [Var2] of a-patch [ set similarity similarity + 0.2 ]
  if Var3 = [Var3] of a-patch [ set similarity similarity + 0.2 ]
  if Var4 = [Var4] of a-patch [ set similarity similarity + 0.2 ]
  if Var5 = [Var5] of a-patch [ set similarity similarity + 0.2 ]

  if test-output-on?
  [
    file-open "similarity-test-output.csv"
    file-print (word Var1 "," Var2 "," Var3 "," Var4 "," Var5 ","
      [Var1] of a-patch ","
      [Var2] of a-patch ","
      [Var3] of a-patch ","
      [Var4] of a-patch ","
      [Var5] of a-patch "," similarity)
    file-close
  ]

  report similarity

end

to update-outputs

  ; First update the line graph of mean similarity
  set-current-plot "Mean similarity of sites"
  plot mean [mean-similarity] of patches

  ; Histogram of the similarity of each patch with each of its neighbors
  ; This requires a list of all the similarity values
  ; ("histogram [([similarity-with myself] of neighbors4] of patches" does not
  ; work because it creates a list of lists instead of a big list of similarity values.)
  let a-similarity-list (list)
  ask patches
  [
    set a-similarity-list sentence a-similarity-list ([similarity-with myself] of neighbors4)
  ]
  set-current-plot "Similarity histogram"
  histogram a-similarity-list

end

to show-similarities
  ; A patch test procedure that can be executed from an Agent Monitor

  let output-string "North: "

  ifelse patch-at 0 1 = nobody
  [ set output-string (word output-string "nobody") ]
  [ set output-string (word output-string (similarity-with patch-at 0 1)) ]

  set output-string (word output-string " East: ")
  ifelse patch-at 1 0 = nobody
  [ set output-string (word output-string "nobody") ]
  [ set output-string (word output-string (similarity-with patch-at 1 0)) ]

  set output-string (word output-string " South: ")
  ifelse patch-at 0 -1 = nobody
  [ set output-string (word output-string "nobody") ]
  [ set output-string (word output-string (similarity-with patch-at 0 -1)) ]

  set output-string (word output-string " West: ")
  ifelse patch-at -1 0 = nobody
  [ set output-string (word output-string "nobody") ]
  [ set output-string (word output-string (similarity-with patch-at -1 0)) ]

  show output-string

end
@#$#@#$#@
GRAPHICS-WINDOW
242
10
550
319
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
9
0
9
0
0
1
ticks
30.0

BUTTON
11
20
78
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
11
61
74
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

PLOT
7
135
207
285
Mean similarity of sites
Tick
Mean similarity
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles"

PLOT
576
74
806
269
Similarity histogram
Similarity with neighbor
Number of site borders
0.0
1.0
0.0
10.0
true
false
"" ""
PENS
"default" 0.2 1 -16777216 true "" "plot count turtles"

SWITCH
92
22
235
55
test-output-on?
test-output-on?
1
1
-1000

@#$#@#$#@
# Axelrod's 1997 Model of Dissemination of Culture
This is an implementation of the culture dissemination model described by: Axelrod R. 1997. The dissemination of culture: a model with local convergence and global polarization. Journal of Conflict Research 41: 203-226.

This version has not been tested for software errors.

Following is an ODD description developed from Axelrod (1997).

This ODD description and the NetLogo program were prepared by S. Railsback, 2017, and are copyrighted 2017 by Steven Railsback and Volker Grimm as part of the instructional materials for _Agent-Based and Individual-Based Modeling_; see http://www.railsback-grimm-abm-book.com.

## 1. Purpose and patterns

The model’s purpose is stated as being “to show the consequences of a few simple assumptions about how people (or groups) are influenced by those around them.” These assumptions are about how people learn culture from each other and, therefore, how culture spreads and how societies influence each others’ culture. In particular, the model assumes that people or societies share culture locally, and share more with others that are more similar to themselves.

The model is abstract and not designed to explain any specific patterns observed in particular real systems, but its author states one general pattern that the model is intended to explore: that, even if peole tend to become more alike when they interact, differences in culture persist over time.

## 2. Entities, state variables, and scales

The entities in this model are agents that “can be thought of as homogeneous villages”. The villages are represented by sites (patches) on a grid.

The sites have state variables for each of five cultural “features” (characteristics). Each of these five feature variables has a value that is an integer between 0 and 9. A site’s culture is defined as its set of values for the five feature variables, concatenated together as a five-digit string, e.g., 93209. 

The grid of sites is 10 × 10 patches in extent, with the space not wrapped. The distance between sites is not stated, and in fact it is not clear that the grid represents geographic space. Time is represented only by the number of “ticks” (times that the schedule is executed); each tick does not represent a specific amount of time. Model runs continue until the system is stable, defined as executing 1000 consecutive ticks with no change in site state variables. Reaching this stable end can take more than 80,000 ticks.

## 3. Process overview and scheduling

The schedule has only two actions per tick. First is a single cultural interaction of one site. On each tick, one of the 100 sites is chosen randomly, and that site then executes the cultural interaction trait described below at “Submodels”. 

The second action is to update the outputs described below at the "Observation" design concept.

## 4. Design concepts

**Basic principles:** The author states that the study is based on three principles. One is agent-based modeling, so that consequences of simple mechanisms emerge. Second is the lack of central authority, so that changes in culture arise from local interactions instead of being imposed by central authority. Third is adaptive rather than rational agents, with agents making decisions simply in response to their neighbors instead of by attempting to calculate the best choice.

**Emergence:** The key results of the model are the presence or absence of regions of different, but stable, culture. These results emerge from the adaptive trait of the village sites.

**Adaptation:** The sites adapt their culture state variables to be more similar to neighbors, using the cultural interaction submodel described below. This trait does not explicitly seek to increase a measure of site success; instead, the trait seems to implicitly assume that being more like a neighbor in culture is better. 

**Objectives:** This concept is not relevant because the adaptive trait for cultural interaction does not seek a specific objective.

**Learning, prediction:** These concepts are not used.

**Sensing:** Village sites are assumed able to sense the culture variables of the neighbor sites that they interact with. Sites are assumed to simply know their neighbor’s variable values.

**Interaction:** The model represents one kind of interaction: spreading of culture. These are direct interactions, with the culture of one site directly affecting the culture of another.

**Stochasticity:** Random processes are used to initialize the model (see “Initialization” below), presumably so that simulations start with no pattern of cultural similarity among neighbors. The cultural interaction trait is highly stochastic, with random choice of which site acts each tick, which neighbor it interacts with, and which cultural variable it changes. The reason why these processes were made stochastic was not provided, but presumably it was to minimize the level of mechanistic detail in the model.

**Collectives:** This model does not include collectives. Regions of culturally similar sites do emerge, but these regions do not affect the individual sites (because sites are affected only by neighbor sites).

**Observation:** Because this model is about the spread and similarity of culture, the key results from the model are not the values of the sites’ culture variables but how similar these variables are over the grid of sites. In Axelrod's original implementation, these results were observed via a “map of cultural similarities” that displayed the borders among sites, shaded from black between highly dissimilar sites to white between sites with identical culture variables. (Calculation of cultural similarity is explained below at “Submodels”.)  This map therefore displayed the boundaries between regions within which culture is similar or identical. 

In this NetLogo implementation, cultural similarity is observed via three outputs. First is by shading each site (patch) by the mean similarity of the site it represents with its neighboring sites. This mean similarity for a patch is the mean of the patch's cultural similarity with all the neighbors it can potentially interact with (see the cultural interaction submodel below). Patch color is shaded from black to white as mean cultural similarity ranges from 0.0 to 1.0. It is critical to understand that mean similarity values greater than zero and less than 1.0 often result from similarity values of 0.0 with some neighbors and values of 1.0 with the other neighbors, while no neighbors have intermediate similarity.

The second similarity output is a plot of mean similarity over all patches: the mean, over all patches, of the mean similarity with all neighbors. This value ranges from 0.0 to 1.0 and approaches 1.0 as the variability among sites in culture disappears.

The third similarity output is a histogram of the similarity values of all borders among sites. The histogram includes one value for each border of each patch, that value being the cultural similarity between the patch and the patch adjacent at the border.

## 5. Initialization

The model is initialized by setting the five culture variables of each site to a random digit between 0 and 9. (This method was implied but not stated explicitly by Axelrod 1997.)

## 6. Input data

The model uses no input data.

## 7. Submodels

The single submodel is the trait a site uses to interact culturally with a neighbor site. It has these steps (“the site” refers to the patch executing this trait):

1.	Randomly select one neighbor site to interact with. These “neighbors” are the four (or fewer, for sites on the edge of the grid) sites to the north, east, south, and west. 

2.	Calculate the “cultural similarity” between the site and the selected neighbor. Cultural similarity is the fraction of the five culture variables for which both sites have the same value. For example, if the cultures of the site and its neighbor are 64892 and 16852 then their similarity is 0.4 (two of the five digits are the same). 

3.	Decide whether to interact with the neighbor. This decision is made randomly with the probability of interacting equal to the cultural similarity calculated in step 2. Hence, if culture similarity is zero, the sites never interact. If the sites are already similar (cultural similarity of 0.6 to 1.0), they are likely to interact.

4.	If there is an interaction with the neighbor, randomly select one of the culture variables for which the site and its neighbor differ, and set the site’s value to that of its neighbor. For example, a site and its neighbor could have cultures of 64892 and 16852 before the interaction and 66892 and 16852 after it.
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
NetLogo 6.0.4
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
