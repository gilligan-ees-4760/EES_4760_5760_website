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

# Announcements {#announcement-sec data-transition="fade-out" data-state="skip_slide"}

## Announcements {#announcements .center data-transition="fade-in"}

* Analysis of the published model: Due date extended to next Sunday (Feb. 25)

* From here on, no further homework from the book.
  * Focus on working on your team project and individual project.

# Homework {#homework-sec data-transition="fade-out" data-state="skip_slide"}

## Reviewing Homeworks {#homework-review .center data-transition="fade-in"}

* Homework 8.1, 8.2
  * Vary birth rate and carrying capacity in birth-rate models.

## Exercise 8.1

![](assets/images/Ex_8_1_pl.png){width=900}
![](assets/images/Ex_8_1_plb.png){width=900}

## Exercise 8.2

![](assets/images/Ex_8_2_pl.png){height=900}

# Sensing {#sensing-sec data-transition="fade-out" data-state="skip_slide"}

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
