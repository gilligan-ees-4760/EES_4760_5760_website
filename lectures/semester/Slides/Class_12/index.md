---
title: "Adaptive Behavior<br/>and Objectives"
class_no: 12
class_date: "Monday, Feb. 19"
qrimage: qrcode.png
qrbottom: '-70%'
pageurl: "ees4760.jgilligan.org/Slides/Class_12"
pdfurl: "ees4760.jgilligan.org/Slides/Class_12/EES_4760_5760_Class_12_Slides.pdf"
course      : "EES 4760/5760"
course_name : "Agent-Based & Individual-Based Computational Modeling"
author      : "Jonathan Gilligan"
semester    : Spring
year        : 2018
output:
  revealjs.jg::revealjs_presentation
---

# Getting Started {#announcement-sec data-transition="fade-out" data-state="skip_slide"}

## Getting Started {.center}

* Sit with your team partners
* Download models:
    * <https://ees4760.jonathangilligan.org/models/class_12/jg-tif.nls>
    * <https://ees4760.jonathangilligan.org/models/class_12/class_12.nlogo>
  
## Announcements {#announcements .center data-transition="fade-in"}

* Analysis of the published model: Due date extended to next Sunday (Feb. 25)

* From here on, no further homework from the book.
  * Focus on working on your team project and individual project.

## Sensing {#sensing .leftslide data-transition="fade-in"}

> * Options for sensing:
>   * Omnisicence: `max-one-of [ expected-utility ] patches`
>   * Neighbors: `max-one-of [ expected-utility ] neighbors`
>   * Limited radius: `max-one-of [expected-utility ] patches in-radius 5`
>   * Social network: `max-one-of [ expected-utility ] my-social-network`

. . .

* Context:
  * NetLogo has __four__ types of entities:
    1. Patches
    1. Turtles
    1. Links
    1. The Observer


## Social Networks and Links {#networks .ninety}

> * Links
>   * Connect turtles
>   * Directed (`create-link-from`, `create-link-to`) or undirected (`create-link-with`)
>   * Can have properties (color, size, etc.)
> * Using links:
>   * `my-links`, `my-in-links`, `my-out-links` 
>     * report agent-sets of __links__ connected to a turtle
>   * `link-neighbors`, `out-link-neighbors`, `in-link-neighbors` 
>     * report agent-sets of __turtles__ connected to a turtle.
>   * __Lots__ more you can do with links (read NetLogo dictionary)
> * **But** links can be slow if you have a big model with lots of links.
>   * Sometimes it's better to use turtles-own variables to keep track of connections


# Subsetting {#subset-sec data-transition="fade-out" data-state="skip_slide"}

## Subsetting {#subset-exercises .eighty data-transition="fade-in"}

* Open the `Class_12` model in NetLogo
* Click `setup` and `set up turtle 5`
* Turn all the turtles red
* Turn turtle 5 green
* Ask turtle 5 to identify all the patches that are exactly 2 patches away from the turtle's patch (not a 2-patch radius from turtle-2)

  ![illustration](assets/images/selection.png){height=400}


## Hints: {.seventy}

* There are many ways to do this. Let's look at a way to do this with the `neighbors` primitive.
* Hints: 
    * Use `member?` primitive (`member <agent> <agent-set>`)
    * Use `patch-set` primitive to turn an list of many patch-sets into a single patch-set
* Suggestion: 
    #. Start by turning all neighbor patches (patches exactly 1 patch away) blue
    #. Next turn all patches within 2 patches blue
    #. Now turn all patches black again
    #. Now turn all patches within a 2-patch distance blue _except_ the turtle's patch
    #. Now turn all patches black again
    #. Now turn all patches within a 2-patch distance blue _except_ the turtle's patch and the patches 1 patch away.

## A solution

```
ask turtle 5 [ 
  ask (patch-set [neighbors] of [neighbors] of self) with                      
    [not member? self [(patch-set neighbors patch-here)] of myself] 
  [ 
  set pcolor blue
  ]
]
```

* What does `self` refer to in `patch-set [neighbors] of [neighbors] of self`?
* What does `self` refer to in `not member? self [(patch-set neighbors patch-here)] of myself`?

## Links

* Put a slider on the interface and call it `number-of-links`

* Edit the chooser for `vision-mode` to add `links` as an option.

* Edit `to initialize-turtle`:

    ```
    to initialize-turtle
      move-to one-of patches with [ not any? turtles-here ]
      set wealth 0
      set size 0.8
      color-turtle 1.0
      create-links-to n-of number-of-links other turtles
    end
    ```

## Links {.eighty}

* Edit `to-report find-best-patch`:
  ```
  ifelse vision-mode = "radius" 
  [
    set candidates (patches in-radius sense-radius) with [ not any? turtles-here ]
    set candidates (patch-set candidates patch-here)
  ] 
  [
    ifelse vision-mode = "neighbors" 
    [
      set candidates neighbors with [ not any? turtles-here ]
      set candidates (patch-set candidates patch-here)
    ] 
    [ 
      ifelse vision-mode = "links" 
      [
        set candidates neighbors with [ not any? turtles-here ]
        set candidates (patch-set candidates patch-here)
        set candidates (patch-set candidates ([neighbors with [not any? turtles-here]] of out-link-neighbors) )             
      ] 
      [
        error "Unknown vision-mode"
      ]
   ]
  ]
  ```
  
# Sensing {#sensing-sec data-transition="fade-out" data-state="skip_slide"}


## Expected Utility Function {.ninety}

* Function: 
  $$U = (W + PT) \times (1 - F)^T$$

    W = wealth, P = profit, F = risk of failure, T = time horizon

* How does this change as investors gain more wealth?

* Interactive app <https://alo.ees.vanderbilt.edu/shiny/ees4760/contour/>



<div  style="padding-top:50px;">
<iframe height=450 width=1800 src="https://alo.ees.vanderbilt.edu/shiny/ees4760/contour/">
Open app at <https://alo.ees.vanderbilt.edu/shiny/ees4760/contour/>
</iframe>
</div>

<!--
# Work on team projects with partners {.center}
-->

# Adaptation {#adapt-sec data-transition="fade-out" data-state="skip_slide"}

## Adaptation and Objectives {#adaptation data-transition="fade-in"}

> * Making decisions:
>   * Perfect rationality:
>     * Pick a goal (objective function)
>     * List possible actions
>     * Calculate how well each will satisfy goal
>     * Choose action that will best accomplish goal
>   * Imperfect rationality:
>     * Goal may be unclear or inconsistent
>     * May not list all possible actions
>     * May not calculate results of actions
>     * May not act on best option
> * Real-life agents may not act rationally

## Bounded Rationality

> * Perfect rationality and chess ...
>   * Evaluating all possible moves may not be possible
>     * Limited time, memory, computing power
>   * Cost of rationality
>     * Getting, processing information
>     * It may be more rational to be slightly irrational

## Satisficing

> * Define goal (objective function)
> * Define criteria for _good enough_ result
> * Evaluate possible actions until the first one that is _good enough_.
>   * Do that action.


## Satisficing

* Make a new slider and call it `wealth-increase-threshold`
* Make a satisfice function:
  ```
  to satisfice
    ; Move if expected wealth increase rate is below the threshold
    ; Potential destinations do NOT include the current patch
    if utility self < wealth * (1 + wealth-increase-threshold)
    [
      let potential-destinations neighbors with [not any? turtles-here]
      if any? potential-destinations [ move-to one-of potential-destinations]
    ]
  end
  ```
