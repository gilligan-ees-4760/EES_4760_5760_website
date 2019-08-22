globals
[
  ; Patch parameters
  max-resource-mean  ; mean max-resource of patches, used for all distributions
  resource-growth-rate ; growth rate for resource

  ; Harvester parameters
  maintenance-energy  ; harvester parameter for maintenance energy requirement
;  punishment-probability    ; moved to slider; the probability of a harvester being punished when taking more than cooperative harvesters
  dissatisfaction-resettle-prob ; the probability of resettling when harvest is below maintenance
  move-cost           ; the energy given up to move
  repro-param         ; the parameter multiplied by energy to get reproduction probability
  disperse-radius     ; the distance over which new harvesters select a patch

  ; Agentsets and output variables
  cooperative-harvesters ; A convenience agentset of harvesters of type "cooperative"
  selfish-harvesters     ; A convenience agentset of harvesters of type "selfish"
  cumulative-resource-growth ; Total resource growth over space and time
  cumulative-harvest-coop    ; Total harvest by cooperative harvesters over space and time
  cumulative-harvest-selfish ; Total harvest by selfish harvesters over space and time
]

patches-own
[
  resource
  max-resource
  resource-growth  ; a convenience variable for output
]

turtles-own
[
  behavior-type
  greediness
  harvest
  energy

  i-was-greedy?  ; True if harvester harvested more than cooperative rate
  cooperative-harvest ; The harvest for cooperative turtles, used in get-punished
  selfish-harvest     ; The desired harvest for selfish turtles, used in harvest-resources
]

to setup

  ca
  reset-ticks

  ; Set parameter values
  set max-resource-mean 100
  let max-resource-sd (max-resource-mean / 3)
  set resource-growth-rate 0.075 ; growth rate for resource

  set maintenance-energy 0.3 ; harvester parameter for maintenance energy requirement
;  set punishment-probability 0.2   ; moved to interface; the probability of a harvester being punished when taking more than cooperative harvesters
  set dissatisfaction-resettle-prob 0.5 ; the probability of resettling when harvest is below maintenance
  set move-cost 0.6          ; the energy given up to move
  set repro-param 0.0003     ; the parameter multiplied by energy to get reproduction probability
  set disperse-radius 5.0    ; the distance over which new harvesters select a patch

  ; Initialize output variables
  set cumulative-resource-growth 0.0 ; Total resource growth over space and time
  set cumulative-harvest-coop 0.0    ; Total harvest by cooperative harvesters over space and time
  set cumulative-harvest-selfish 0.0 ; Total harvest by selfish harvesters over space and time

  ; Create the landscape and initialize patches
  ifelse landscape-type = "homogeneous"
  [ ask patches [set max-resource max-resource-mean] ]
  [
    ifelse landscape-type = "uniform"
    [ ask patches [set max-resource (0.5 * max-resource-mean) + random max-resource-mean ] ]
    [
      ifelse landscape-type = "normal"
      [ ask patches [set max-resource random-normal max-resource-mean max-resource-sd] ]
      [
        ifelse landscape-type = "exponential"
        [ ask patches [set max-resource random-exponential max-resource-mean] ]
        [ error "Illegal value of landscape-type" ] ; if exponential
      ] ; if normal
    ] ; if uniform
  ] ; if homogeneous

  ask patches
  [
    set pcolor scale-color green resource 0 200
  ]

  ; Create the harvesters
  crt 5000
  [
    move-to one-of patches
    set energy 10
    ifelse random 2 < 1
    [
      set behavior-type "cooperative"
      set color orange
    ]
    [
      set behavior-type "selfish"
      set greediness random-float 1.0
      set color sky
    ]
  ]

  ; Initialize the convenience agentsets
  set cooperative-harvesters turtles with [behavior-type = "cooperative"]
  set selfish-harvesters turtles with [behavior-type = "selfish"]

  ; Initialize the main output file, if it is turned on via the switch on Interface
  ; It must be closed again to allow use of test output files
  ; This file is overwritten each model run!
  if file-output?
  [
    if file-exists? "HarvesterOutput.csv" [file-delete "HarvesterOutput.csv"]
    file-open "HarvesterOutput.csv"
    file-print date-and-time
    file-print "Tick,Num-cooperative,Num-selfish,Total-resource,Total-resource-growth,Coop-harvest,Selfish-harvest,Cumulative-resource-growth,Cumulative-coop-harvest,Cumulative-selfish-harvest"
    file-close
  ]

end

to go
  tick
  if ticks > 1000 [ stop ]

  ; Test output for grow-resource. To use, un-comment these file- statements and
  ; the file-print statement in grow-resource
;  if ticks = 1 [ if file-exists? "grow-resource-test-out.csv" [ file-delete "grow-resource-test-out.csv" ]]
;  file-open "grow-resource-test-out.csv"  ; Temporary test output for grow-resource
;  if ticks = 1 [file-print "Patch,resource,harvest,max-resource,growth"]  ; Header for test output
  ask patches [ grow-resource ]
;  file-close  ; Temporary test output

  ; Test output for harvest-resource. To use, un-comment these file- statements and
  ; the file-print statement in harvest-resource
;  if ticks = 1 [ if file-exists? "harvest-test-out.csv" [ file-delete "harvest-test-out.csv" ]]
;  file-open "harvest-test-out.csv"  ; Temporary test output for harvest-resource
;  if ticks = 1 [file-print "Who,energy,behavior-type,max-resource,greediness,num-harvesters,cooperative-harvest,selfish-harvest,harvest"]  ; Header for test output
  ask turtles [ harvest-resource ]
;  file-close  ; Temporary test output

  ask selfish-harvesters [ get-punished ]

  ask turtles with [ harvest < maintenance-energy ] [ resettle ]

  ask turtles [ maybe-die ]

  ask turtles [ reproduce ]

  update-outputs

end

to grow-resource ; A patch procedure

  let harvest-here-last-tick sum [harvest] of turtles-here
  let prev-resource resource - harvest-here-last-tick

  set resource-growth (resource-growth-rate * prev-resource * (1 - (prev-resource / max-resource)))

;  file-print (word self "," prev-resource "," harvest-here-last-tick "," max-resource "," resource-growth)

  set resource prev-resource + resource-growth

  ; Some defensive programming: resource should not be negative
  if resource < 0.0
  [
    inspect self
    error "Resource is negative in grow-resource"
  ]

  set pcolor scale-color green resource 0 200

  ; Update total resource production
  set cumulative-resource-growth cumulative-resource-growth + resource-growth

end

to harvest-resource ; A turtle procedure

  let old-energy energy  ; For test output only

  set cooperative-harvest (max-resource * resource-growth-rate) / (8 * count turtles-here)

  ifelse behavior-type = "cooperative"
  [
    set harvest cooperative-harvest
    set cumulative-harvest-coop cumulative-harvest-coop + harvest
  ]
  [
    set selfish-harvest maintenance-energy * (1 + greediness)
    ifelse selfish-harvest > cooperative-harvest
    [
      set harvest selfish-harvest
      set i-was-greedy? true
    ]
    [
      set harvest cooperative-harvest
      set i-was-greedy? false
    ] ; ifelse selfish-harvest > cooperative-harvest
    set cumulative-harvest-selfish cumulative-harvest-coop + harvest
  ] ; ifelse behavior-type

  set energy energy + harvest

  ; Temporary test output
;  file-print (word who "," old-energy "," behavior-type "," max-resource "," greediness ","
;    (count turtles-here) "," cooperative-harvest "," selfish-harvest "," harvest)

end

to get-punished  ; A procedure executed by harvesters of type "selfish"

  if (i-was-greedy?) and (random-float 1.0 < punishment-probability)
  [
    let the-fine 2 * (harvest - cooperative-harvest)
    set energy energy - the-fine
  ]

end

to resettle  ; A procedure executed by harvesters with harvest less than maintenance-energy

  if (random-float 1.0 > dissatisfaction-resettle-prob)
  [
    move-to max-one-of neighbors [ resource ]
    set energy energy - move-cost
  ]

end

to maybe-die  ; A turtle procedure

  set energy energy - maintenance-energy
  if energy <= 0.0 [ die ]

end

to reproduce ; A turtle procedure

  let repro-probability repro-param * energy
  if random-float 1.0 < repro-probability
  [
    set energy (energy / 2) ; Give half my energy to offspring
    hatch 1
    [
      move-to max-one-of patches in-radius disperse-radius [ resource ]
      set energy [energy] of myself
    ] ; hatch
  ] ; if reproduce

end

to update-outputs

  ; Update plots
  set-current-plot "Harvesters"
  set-current-plot-pen "Cooperative"
  plot count cooperative-harvesters
  set-current-plot-pen "Selfish"
  plot count selfish-harvesters
  if any? selfish-harvesters
  [
    set-current-plot "Greediness of selfish harvesters"
    plot mean [greediness] of selfish-harvesters
  ]

  set-current-plot "Cooperative"
  histogram [energy] of cooperative-harvesters

  set-current-plot "Selfish"
  histogram [energy] of selfish-harvesters

  ; Update main output file, in .csv format
  if file-output?
  [
    file-open "HarvesterOutput.csv"
    file-print (word ticks "," count cooperative-harvesters "," count selfish-harvesters ","
      sum [resource] of patches "," sum [resource-growth] of patches ","
      sum [harvest] of cooperative-harvesters "," sum [harvest] of selfish-harvesters ","
      cumulative-resource-growth "," cumulative-harvest-coop "," cumulative-harvest-selfish )
    file-close
  ]

end
@#$#@#$#@
GRAPHICS-WINDOW
264
10
672
419
-1
-1
8.0
1
10
1
1
1
0
1
1
1
0
49
0
49
1
1
1
ticks
50.0

BUTTON
16
14
79
47
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
85
14
148
47
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
153
13
216
46
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

CHOOSER
18
64
156
109
landscape-type
landscape-type
"homogeneous" "uniform" "normal" "exponential"
1

PLOT
8
206
255
390
Harvesters
Tick
Number of harvesters
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Cooperative" 1.0 0 -955883 true "" ""
"Selfish" 1.0 0 -13791810 true "" ""

PLOT
7
429
246
612
Cooperative
Energy
Number of harvesters
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"default" 10.0 1 -16777216 false "" ""

PLOT
281
428
533
615
Selfish
Energy
Number of harvesters
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"default" 10.0 1 -16777216 false "" ""

SLIDER
17
118
197
151
punishment-probability
punishment-probability
0
1
0.2
.01
1
NIL
HORIZONTAL

SWITCH
17
159
136
192
file-output?
file-output?
0
1
-1000

PLOT
539
428
739
578
Greediness of selfish harvesters
Ticks
Mean greediness
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

@#$#@#$#@
# HARVESTER MODEL
Model formulated and implemented by S. F. Railsback and V. Grimm

This model is loosely based on the model of:
Pérez, I., & Janssen, M. A. 2015. The effect of spatial heterogeneity and mobility on the performance of social–ecological systems. Ecological Modelling, 296, 1–11.

However, this model is different from the model of Pérez & Janssen in important ways and should not be compared to, or treated as equivalent to, their model.

This NetLogo implementation intentionally includes programming errors as a software testing exercise!! This program is completely independent of the software used by Pérez & Janssen.

Copyright 2019 by Steven F. Railsback and Volker Grimm.

# MODEL DESCRIPTION (ODD FORMAT)
## PURPOSE
This model is derived from the model of Pérez and Janssen (2015), but is simplified and focused on a different purpose. The model addresses the general issue of cooperative vs. selfish behavior in social systems. Natural selection is believed to be driven mainly by selfishness (“survival of the fittest”), yet cooperative societies often offer higher overall success to their members. Selfish individuals are likely to be even more successful when competing in a society of mostly unselfish individuals, compared to competing with other selfish individuals. How can cooperative behavior persist in competition with selfishness? One answer is via punishment: if selfish individuals are sometimes caught and fined for using more resources than cooperative individuals, they may lose enough of their advantage to allow the cooperative individuals to persist. This model is designed to explore how punishment affects co-existence of cooperative and selfish individuals, in a very simple system that loosely resembles an agricultural society. It also explores the interacting effect of landscape structure—how the resources harvested by the individuals are distributed over space. Example analyses the model can address are: (a) How does the risk of punishment affect overall abundance and harvest by cooperative and selfish harvesters? (b) How does the risk of punishment affect the average level of “greediness” in selfish harvesters? (c) How do the answers to (a) and (b) depend on the level of spatial variability in resource availability?

## ENTITIES, STATE VARIABLES, AND SCALES
The model represents space as a two-dimensional landscape made up of square patches. These patches can be thought of as small regions or villages within which resources are produced and shared by the harvesters that occupy the patch. The landscape is made up of 50 × 50 patches; distance units and patch size are arbitrary. 

Time is represented as steps that represent the time within which resources are produced and consumed; one time step can be thought of as a year with its resource growth and harvest cycle and one cycle of harvester reproduction. Simulations have a standard duration of 1000 time steps.

### Patches
Patches have two state variables. _Resource_ is a dynamic variable representing the amount of resource currently available for harvest, in arbitrary energy units. _Max-resource_ is a static variable that varies among patches and is the maximum value that resource approaches if there is no harvest for many time steps. The resource growth submodel uses _max-resource_ in updating the value of _resource_.

### Harvesters
Harvesters are the agents that consume resources and potentially move among patches. Their state variables describe their location, their behavior, and their energy state. Location is tracked as the patch occupied by a harvester. The variable _behavior-type_ has a value of either “cooperative” or “selfish”, distinguishing these two types of harvesters. Harvesters of type “selfish” have a static state variable _greediness_ that represents how much resource they attempt to harvest and need to be satisfied. The value of _greediness_ is between zero and one. The dynamic variable _energy_ is the harvester’s current energy state, in the same energy units as _resource_. _Harvest_ is a variable used only to record how much resource was harvested in the current time step.


## PROCESS OVERVIEW AND SCHEDULING
The following actions are executed on each time step. The order in which harvesters execute each action is randomized each time step, to represent the lack of a hierarchy.
  1.	Patches grow resource, regenerating the material that harvesters consume (the resource growth submodel, detailed below). The rate at which patches grow more resource varies nonlinearly with amount that resource has been depleted below its maximum level, so that the maximum rate of resource growth (and, therefore, harvest) is at an intermediate level of harvest (explained in the harvest submodel).
  2.	Harvesters harvest resource (the harvest submodel). There are usually many more harvesters than patches, so harvesters can either share or compete with the other harvesters on their patch. The cooperative harvesters share: each consumes an amount that would maximize long-term harvest if all harvesters on the patch took that same amount. The selfish harvesters compete: each tries to consume an amount greater than cooperative harvesters do, with that amount depending on their selfishness variable.
  3.	Selfish harvesters are subjected to potential punishment, a “fine” that takes away some of their energy (the punishment submodel).
  4.	Harvesters move to a new patch if they are dissatisfied with their harvest (the resettlement submodel). 
  5.	Harvesters die if their energy is completely consumed (the death submodel).
  6.	Harvesters reproduce, producing at most one new harvester of the same type (the reproduction submodel). The probability of reproducing increases with the harvester’s value of energy.
  7.	Model outputs (the “Observation” design concept) are updated.


## DESIGN CONCEPTS
_Basic principles_: This model addresses two important concepts of social science: the evolution of cooperation and management of shared (“common-pool”) resources. How cooperative behavior can arise and persist in a society of selfish individuals has been the subject of numerous models, many using the “prisoner’s dilemma” game as a framework (e.g., Axelrod, R. 1984. The evolution of cooperation. Basic Books, New York NY). This model addresses this question in the framework of shared harvest or shared use of common resources. How social groups can share common resources to their mutual benefit and avoid the “tragedy of the commons” (Lloyd, W. F. 1833. Two lectures on the checks to population. Oxford University Press, Oxford, England, 1833, reprinted in part in Population, evolution, and birth control, G. Hardin, Ed., Freeman, San Francisco, 1964) has also been extensively studied and modeled, prominently in the work of Elinor Ostrom. In this model, “cooperative” harvesters consume a resource at its maximum sustainable rate, so the system is expected to be most productive when all harvesters are cooperative. However, the system also has “selfish” harvesters that can consume more than the sustainable rate, raising questions about how selfish behavior—and punishment to deter it—affect the system’s productivity.

_Emergence_: Key outcomes of this model are the total number of cooperative and selfish harvesters, their spatial arrangement (are they mixed together or isolated?), and the total harvest, which can be considered a measure of the whole system’s productivity. These outcomes emerge from the rate of resource production and the methods by which the two kinds of harvesters decide how much resource to harvest. Because harvesters can move, these results also emerge in part from the spatial distribution of resources and how harvesters decide when and where to resettle. The degree of greediness among selfish harvesters also emerges from model mechanisms. When selfish harvesters reproduce they produce new selfish harvesters that inherit the parent’s value of _greediness_. More successful harvesters are more likely to reproduce, so _greediness_ is actually subject to “evolution” in the population.


_Adaptation_: The model includes two kinds of adaptive behavior by harvesters, although the first is not represented explicitly as a decision. This first adaptation is adjusting harvest to the amount of resource available in the patch (the harvest submodel): cooperative harvesters adjust their harvest so that, if only cooperative harvesters occupied the patch, maximum sustained yield would be obtained. Selfish harvesters adapt to resource availability by using the harvest rule that provides highest harvest.
The second adaptive behavior is deciding to resettle in a new patch if harvest is unsatisfactory (the resettlement submodel). The decision of whether to resettle is stochastic, but the choice of a new patch is made to maximize a specific objective. 

_Objectives_: When harvesters resettle, they select the patch, among the available alternatives, with highest current value of _resource_. It is important to understand this objective does not clearly maximize the harvester’s future harvest, energy level, reproductive output, etc. For example, a patch may have highest resource availability because it has a low resource production rate and is therefore occupied by few or no harvesters, while the most productive patches are already occupied by harvesters that consume all their resources. A productive patch could also not provide high future harvest if multiple harvesters move into it.

_Learning_: The model includes no learning.

_Prediction_: Harvesters do not use explicit prediction in their adaptive behaviors. However, the objective used in the resettlement behaviors is based on the implicit prediction that the patch with currently high resource will provide high harvest in the future. As discussed above, this prediction could often be wrong.

_Sensing_: The harvest obtained by each harvester depends on how many others are in the patch (the harvest submodel), so harvesters are assumed to sense how many harvesters are in their patch. The resettlement submodel assumes harvesters know which surrounding patch has the highest value of _resource_.

_Interaction_: The harvesters interact with each other indirectly via competition for their patch’s resource. Punishment is often a type of interaction, in that a society imposes the punishment on an individual. However, in this model punishment is not clearly represented as an interaction; e.g., fines imposed on selfish harvesters are not made available to others.

_Stochasticity_: The model landscape is created by drawing each patch’s value of _max-resource_ from a random distribution. This approach is used because variability among patches in resource production is considered important, but the amount and characteristics of this variability need to be controlled. Alternative distributions (uniform, normal, and exponential) are used to represent different types of variability among patches. There is no spatial correlation in _max-resource_: each patch’s value is independent of the value of adjacent patches. The punishment, resettlement, and reproduction submodels are each partially stochastic, as a way of inducing variability and controlling the rate of punishment, movement, and reproduction. 

_Collectives_: The harvesters on a patch could be thought of as a simple collective because they intentionally share its resources. However, the model does not treat patches explicitly as collectives. 

_Observation_: Key results are the total number of cooperative and selfish harvesters, their spatial arrangement, and the total harvest. The total numbers of cooperative and selfish harvesters are plotted over time. Their spatial arrangement is displayed visually via the NetLogo View, with patches shaded by _max-resource_ and harvesters colored by behavior type. The production of resource (increase in _resource_, in the resource growth submodel) is observed via file output of the total production over all patches, on each time step. Harvest of resource is observed by file output of the total harvest, summed over all harvesters, at the end of each time step.  

## INITIALIZATION
### Landscape and patches
Initialization begins by setting the value of _max-resource_ of each patch. The user selects one of four optional distributions of this variable, with the distribution treated as a model parameter. Upon initialization, the value of _max-resource_ for each patch is drawn randomly from the selected distribution. For all four distributions, the mean of _max-resource_ is a model parameter _max-resource-mean_, which has a standard value of 100 energy units. The four alternative distributions are:

  * Homogeneous landscape: all patches have _max-resource_ equal to _max-resource-mean_.
  * Uniform: _max-resource_ is drawn from a uniform distribution with minimum of 0.5 _max-resource-mean_ and maximum of 1.5 _max-resource-mean_.
  * Normal: _max-resource_ is drawn from a normal distribution with mean of _max-resource-mean_ and standard deviation of 1/3 _max-resource-mean_.
  * Exponential: _max-resource_ is drawn from an exponential distribution with mean of _max-resource-mean_. (Exponential distributions have few high values and many low values.)

Next, the patches’ value of _resource_ must be initialized; it is arbitrarily set to half of _max-resource_.

### Harvesters
Simulations start with 5000 initial harvesters, which have their state variables initialized in these ways:

  * Location is set by moving the harvester to a randomly selected patch.
  * Behavior-type is assigned randomly to either “cooperative” or “selfish”, with equal probability of each type.
  * For selfish harvesters, the value of greediness is drawn randomly from a uniform distribution between 0.0 and 1.0.
  * Energy is set to 10 energy units.

## INPUT DATA
No time-series input data are used.

## SUBMODELS

### Resource growth
Resource growth is modeled using a simple logistic model, which assumes the amount of resource produced in a time step increases and then decreases as resource increases. The equation for updating _resource_ is:
_resource_ = _prev-resource_ + ( _growth-rate_ × _prev-resource_ × (1 – ( _prev-resource_ / _max-resource_ )))
where _resource_ is the value of _resource_ in the current time step, _prev-resource_ is the value of _resource_ after being updated in this submodel the previous time step minus the total harvest by all harvesters in patch during the previous time step, and _growth-rate_ is a parameter with value of 0.075.
   
### Harvest
The harvest submodel updates a harvester’s value of the state variables harvest and energy. 

Cooperative harvesters (with _behavior-type_ = “cooperative”) are assumed to harvest the amount that each occupant of a patch would get if each got an equal share of the “maximum sustainable yield” (MSY) of the resource. MSY is the harvest rate that maximizes long-term resource production and harvest, and can be shown mathematically to equal ( _max-resource_ × _growth-rate_ ) / 8 for the logistic model of resource growth. Therefore, the harvest of a cooperative harvester is equal to a variable _cooperative-harvest_ = MSY / _num-harvesters_ where _num-harvesters_ is the number of all harvesters on the patch. The value of _harvest_ for cooperative harvesters is set to _cooperative-harvest_.

Selfish harvesters are assumed to desire a higher harvest, the variable _selfish-harvest_, which is equal to _maintenance-energy_ × (1 + _greediness_). _Maintenance-energy_ is a harvester parameter representing a harvester’s energy requirement per time step, with value of 0.3 energy units. However, _selfish-harvest_ may sometimes be less than _cooperative-harvest_, so for selfish harvesters, _harvest_ is set to the highest of _selfish-harvest_ and _cooperative-harvest_.
 
For all harvesters, the value of _energy_ is updated by adding _harvest_ to it.

### Punishment
This harvester submodel determines whether energy is lost due to punishment for selfish harvesting. A variable _fine_ represents the energy lost this way. The parameter _punishment-probability_ is the risk of being punished for harvesting more than cooperative harvesters do. If the value of _harvest_ was higher than the value of _cooperative-harvest_ in the harvest submodel, punishment is simulated as a stochastic event with probability _punishment-probability_ of occurring. _Punishment-probability_ is a key model parameter because examining the effect of punishment is a main purpose of the model; the parameter’s standard value is 0.2. If punishment occurs, then the value of _fine_ is two times the amount by which harvest exceeded _cooperative-harvest_.

The value of _fine_ is subtracted from the harvester’s value of _energy_.

### Resettlement
This submodel is executed by each “dissatisfied” harvester: those whose value of _harvest_, for the current time step, was less than desired. For cooperative harvesters, the desired harvest is the minimum energy need, equal to the parameter _maintenance-energy_. For selfish harvesters, the desired harvest is the value of _selfish-harvest_ calculated in the harvest submodel.

Each dissatisfied harvester has a probability of 0.5 of moving to the neighboring patch (one of the eight surrounding patches) with highest current value of _resource_. When a harvester moves, none of its state variables change except its location and energy; _energy_ is reduced by the cost moving. This cost is the parameter _move-cost_, with a value of 0.6 energy units.

### Death
This submodel represents the maintenance energy costs of harvesters and their death due to lack of energy. Maintenance costs are represented by the parameter _maintenance-energy_. The value of _energy_ is updated by subtracting _maintenance-energy_. If the result is less than or equal to zero, the harvester immediately dies and is removed from the simulation.

### Reproduction
This submodel determines whether a harvester creates an offspring and, if so, creates the new harvester. Reproducing is a stochastic event with probability increasing with the harvester’s energy. The probability of reproducing is equal to 0.0003 × _energy_.

When a harvester produces an offspring, its value of _energy_ is reduced by half. The offspring is a new harvester created immediately, with state variables set as follows:

  * Location is set by moving the new harvester to the patch with highest value of _resource_, within a radius of 5 patches.
  * _Energy_ is set to its parent’s value (which is half the parent’s pre-reproduction energy).
  * All other state variables, including _greediness_, are set to the parent’s value. 
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
