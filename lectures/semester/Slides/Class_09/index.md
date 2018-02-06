---
title: "Emergence"
class_no: 9
class_date: "Tues. February 6"
qrimage: qrcode.png
qrbottom: '-90%'
pageurl: "ees4760.jgilligan.org/Slides/Class_09"
pdfurl: "ees4760.jgilligan.org/Slides/Class_09/EES_4760_5760_Class_09_Slides.pdf"
course      : "EES 4760/5760"
course_name : "Agent-Based & Individual-Based Computational Modeling"
author      : "Jonathan Gilligan"
semester    : Spring
year        : 2018
output:
  revealjs.jg::revealjs_presentation
---

# Make-up class {#make-up-sec data-transition="fade-out" data-state="skip_slide"}

## Make-up class {#make-up}

Based on doodle poll, the make-up class will be held on 

* Monday Feb. 19 from 6:00--7:15 PM. 
* Place to be announced.


# Team Projects {#team-project-sec data-transition="fade-out" data-state="skip_slide"}

## Team Projects {#team-projects data-transition="fade-in"}

* For next Tuesday: Read Chapter 10 and the ODD of the model you will work on. 
  You will spend significant time in class working with your partner(s) to 
  start turning the ODD into a working NetLogo model.

# Emergence {#emergence-sec data-transition="fade-out" data-state="skip_slide"}

## Emergence {#emergence data-transition="fade-in"}

* Download and open the "modified flocking model" from Brightspace, 
  the Downloads page on the course web site, or from 
  <https://ees4760.jgilligan.org/models/class_09/modified_flocking.nlogo>

* It's easiest if you right-click on the link and choose "Save As" and save the model in a folder on your computer.

## Flocking {.center}

* Play with the model. 
  * Adjust the parameters and see how they change the flocking behavior

## Flocking Model Overview

* Entities:
  * Birds: state-variables `flockmates`, `nearest-neighbor`

* Process:
  * Each bird identifies its `flockmates`
  * Each bird adjusts its direction 
  * Each bird moves forward one patch

## Flocking Model Design Concepts

:::::: {.leftlist}
::: {.leftlist}

* Emergence: Large flocks emerge from each bird acting independently, looking only at nearby birds.

:::
::: {.fragment}

* Adaptation:
  * If the `nearest-neighbor` is too close, the bird `separates` by turning away from it.
  * Otherwise, the bird:
    1. `aligns`: turns toward its `flockmates`
    2. `coheres`: turns slightly toward the direction the rest of its `flockmates` are flying.

:::
::: {.fragment}

* Sensing: The bird can only see a certain distance (`vision`)

:::
::: {.fragment}

* Interaction:
  * Each bird interacts with its `flockmates`

:::
::::::

## Submodels

* `find-flockmates`: 
  * `flockmates` are all birds within `vision` distance
  * Alternate interactions:
    * `flockmates` interacts with 6 nearest birds, regardless of distance.
    * Bird only interacts with nearest member of `flockmates`
* `separate`: Turn away from `nearest-neighbor` by up to `max-separate-turn`
* `align`: Turn toward center of `flockmates` by up to `max-align-turn`
* `cohere`: After aligning, turn toward average direction `flockmates` are flying, by up to `max-cohere-turn`

## Observations:

:::::: {.leftlist}
::: {.leftlist style="text-align:left;"}

* How to measure flock formation?


:::
::: {.fragment style="text-align:left;"}


```
count turtles with [any? flockmates]
mean [count flockmates] of turtles
mean [min [distance myself] of other turtles] of turtles
standard-deviation [heading] of turtles
```


:::
::::::

## Digression: Selecting Turtles {.ninety}

* Selection primitives:
    * Returning agent-sets
        * `n-of`, `min-n-of`, `max-n-of`, `other`, 
        * `turtles-on`, `turtles-at`, `turtles-here`, `at-points`
        * `in-radius`, `in-cone`, 
        * `with`, `with-min`, `with-max`
    * Returning individual turtles
        * `one-of`, `min-one-of`, `max-one-of`
        * (may return `nobody`)
    * Look at `Agentset` category in NetLogo dictionary
* Be careful: 
    * Some primitives expect agent-sets
    * Others expect individual turtles.

## Practice Selecting Turtles {.ninety}

* Turn 5 turtles red:

  ::: {.fragment}
          
  ```
  ask n-of 5 turtles [ set color red ]
  ```
  
  :::

* Now for each of those turtles, select all the turtles within a radius of 5 and turn them green

  ::: {.fragment}
        
  ```
  ask turtles with [color = red] 
  [
    ask other turtles in-radius 5 [ set color green ] 
  ]
  ```

  :::

* Now ask each green turtle to calculate the distance to the closest red turtle

  ::: {.fragment}
        
  ```
  show [
    min [distance myself] of turtles with [color = red]
    ] of turtles with [color = green]
  ```

  :::

* Now get the average over all the green turtles of the distance to the closest red turtle

  ::: {.fragment}
        
  ```
  show mean [
    min [distance myself] of turtles with [color = red]
    ] of turtles with [color = green]          
  ```
  
  :::


# Experiments  {#experiment-sec data-transition="fade-out" data-state="skip_slide"}

## Experiments  {#experiment data-transition="fade-in"}

:::::: {.leftlist}
::: {.leftlist}

* Create a Behaviorspace experiment and call it "Baseline"
  * change one parameter and see how it affects the various measures of flocking.
* Next, duplicate "Baseline" and call it "Flock Type"
  * vary that parameter while also varying the `flock-type`
* Next, duplicate "Baseline" and call it "Multiple"
  * vary more than one parameter (e.g., `vision` and `max-cohere-turn` or `max-align-turn`)

:::
::: {.fragment}

* Use the `analyze_behaviorspace` app at <https://analyze-behaviorspace.jgilligan.org/> to graph the output from your BehaviorSpace experiments.
* Try creating a summary table, saving it to your computer, and opening it in Excel.

:::
::::::
