---
title: "Scheduling Model Behavior"
class_no: 17
class_date: "Tuesday Mar. 20"
qrimage: qrcode.png
qrbottom: '-90%'
pageurl: "ees4760.jgilligan.org/Slides/Class_17"
pdfurl: "ees4760.jgilligan.org/Slides/Class_17/EES_4760_5760_Class_17_Slides.pdf"
course      : "EES 4760/5760"
course_name : "Agent-Based & Individual-Based Computational Modeling"
author      : "Jonathan Gilligan"
semester    : Spring
year        : 2018
output:
  revealjs.jg::revealjs_presentation
---

# Models to Download {#download-sec .center data-transition="fade" data-state="skip_slide"}

## Models to Download {#model-downloads .center .eightyfive data-transition="fade-in"}

* Download page: [www.ees4760.jgilligan.org/downloads/scheduling_class_17/](/downloads/scheduling_class_17/)
* Zip File with all models: 
  * [www.ees4760.jgilligan.org/models/class_17/class_17_models.zip](/models/class_17/class_17_models.zip)
* Or download individual models:
  * [ees4760.jgilligan.org/models/class_17/Mousetrap_Ch14.nlogo](/models/class_17/Mousetrap_Ch14.nlogo)
  * [ees4760.jgilligan.org/models/class_17/Mousetrap_Ch14_v2.nlogo](/models/class_17/Mousetrap_Ch14_v2.nlogo)
  * [ees4760.jgilligan.org/models/class_23/Ch_23_4_breeding_synchrony.nlogo](/models/class_23/Ch_23_4_breeding_synchrony.nlogo)

# Modeling for Actionable Research {.center}

## Modeling for Actionable Research {.eightyfive .leftslide}

* Using agent-based models of socio-environmental systems to inform planners, public, government decision-makers
  * Disaster planning
  * Conservation and sustainability

. . .

* Grand challenges:
  * Data: Combining different kinds of data, new sources of data, managing big data, ...
  * Challenges of research disciplines: Using models to integrate different kinds of knowledge. 
    Challenge of aligning different ways of thinking.
  * Predictions and Uncertainty: Can models built on today's conditions anticipate very different future conditions?
    How to plan for uncertain future? How to communicate with public about models?
  * Making models useful: What do non-experts want to know? Results of models, or modeling process? 
    Participatory and interactive models. Tools to let non-programmers develop models.
  * Challenges of future technology: Modeling tens or hundreds of millions of people. 
    Integrating people into big models of climate, rivers, cities, etc.

# Scheduling Actions: {#scheduling-sec .center data-transition="fade-out" data-state="skip_slide"}

## Scheduling Actions: {#scheduling .center data-transition="fade-in"}

* Representing time:
    * Discrete (`tick`)
    * Continuous (`tick-advance`)
* Execution order
    * Synchronous
    * Asynchronous
        * Random order
        * Determined order

## Repeating actions

* `repeat` repeats a certain number of times

  ```
  repeat 5 [ wander ]
  ```
  or
  ```
  repeat random count turtles [ wander ]
  ```
  
* `while` repeats as long as a condition is true

  ```
  while not any? turtles-here [ wander ]
  ```
  
* `loop` repeats forever (until `stop` or `report`)

  ```
  loop [
    wander
    if any? turtles-here [ stop ]
  ]
  ```

## Discrete vs. continuous time

* Almost all models use discrete time:
  * `tick` advances tick counter by 1.
  * `ticks` is always an integer.
* Continuous time
  * `tick-advance 2.3`
  * `ticks` can have fractional values.
* Things to think about:
  * When to tick?

:::::: {.columns}
::: {.column style="width:50%"}

```
to go
  ask patches [ do-patch-stuff ]
  ask turtles [ do-turtle-stuff ]

  tick
  if ticks > run-duration [stop]
end
```

:::
::: {.column style="width:50%"}

```
to go
  tick
  if ticks > run-duration [stop]

  ask patches [ do-patch-stuff ]
  ask turtles [ do-turtle-stuff ]
end
```

:::
::::::

## Order of execution

> * `ask`: Asks turtles in a random order.
>   ```
>   ask turtles [do-sales]
>   ```
> * Suppose we wanted bigger turtles to act before the smaller ones?
>   ```
>   foreach sort-on [(- size)] turtles 
>   [ 
>     next-turtle -> ask next-turtle [do-sales] 
>   ]
>   ```


## Concurrent execution

* `ask-concurrent` (<span style="color:darkred;">**not recommended**</span>)

This is a relic from older versions and can create problems if you use it.

## Synchronous vs. asynchronous updating {.eightyfive}

> * What is the difference?
> * When would you want to use one or the other?
>   * Business investor model?
>   * Telemarketer model?
> * How would you do *asynchronous* updating?
> * How would you do *synchronous* updating?
>   * Hidden state-variables (turtle can't see other turtle's hidden variables)
>   * Two ways:
>     1. Break submodel into two parts:
>        1. Turtles have sense and update hidden state-variables that others can't sense
>        2. Update environment (including state-variables that others can sense)
>     2. Make shadow copy of all state variables:
>        1. Sensing sees originals, updates change shadow-copies
>        2. Update the original (`set original shadow-copy`)
> * What advantages or disadvantages does *synchronous updating* have versys *asynchronous*?

# Mousetrap model {#mousetrap-sec .center }

## Mousetrap model {#mousetrap-video .center}


[https://youtu.be/XIvHd76EdQ4](https://youtu.be/XIvHd76EdQ4?t=1m25s){target="_blank"}


## Mousetrap model {#mousetrap-netlogo .center}

<https://ees4760.jgilligan.org/models/class_17/Mousetrap_Ch14.nlogo>

<https://ees4760.jgilligan.org/models/class_17/Mousetrap_Ch14_v2.nlogo>

* Play with models
* Compare continuous updating with updating on ticks

# Breeding Synchrony Model {#breeding-sec .center}

## Breeding Synchrony Model {#breeding-synchrony}

<https://ees4760.jgilligan.org/models/class_23/Ch_23_4_breeding_synchrony.nlogo>

* Colonies of sea birds (up to several thousand) often exhibit synchronized breeding:
  * Birds with very different characteristics & histories lay eggs at the same time
    * Different stored energy, different arrival times, ...
* Different colonies in nearby areas lay eggs at different times
  * So environemntal factors (e.g., phase of moon) aren't explanation
* Why?

## Breeding Synchrony Model {#breeding-synchrony-2}

* Is stress the answer?
  * "Stressful neighborhoods":
    * If other birds are still competing for mates, nesting material, it's dangerous
      to lay eggs.
    * Hypothesis: Birds wait until neighborhood is fairly calm to lay eggs.

## Breeding Synchrony Model {#breeding-synchrony-equation .eightyfive .leftslide}

* Model:
  * Birds' activities cause stress in neighbors
  * Key variables: 
    * **OSL**: a bird's own stress level, 
    * **mean NSL**: average of neighbors' stress levels,
    * **NR** (0--1): neighborhood relevance: how much a bird's stress is influenced by its neighbors,
    * **SD** = 10: stress decay rate: How quickly a bird loses stress without external stimulus.
    $$
    \text{OSL}_t = (1 - \text{NR}) \text{OSL}_{t-1} + (\text{NR} \times \text{mean NSL}_{t - 1}) - \text{SD}
    $$

. . .

* Birds start out with random $\text{OSL}$ between 100 and 300.
* Birds lay eggs when $\text{OSL} \le 10$.
* Synchronous updating:
  * All birds compute $\text{OSL}_t$ using stress levels at $t-1$, then they all update together
* How does breeding synchrony depend on $\text{NR}$?