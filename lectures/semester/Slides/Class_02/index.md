---
title: "A Model Is A Model Is A Model"
class_no: 2
class_date: "Thurs. January 11"
qrimage: qrcode.png
qrbottom: '-90%'
pageurl: "ees4760.jgilligan.org/Slides/Class_02"
pdfurl: "ees4760.jgilligan.org/Slides/Class_02/EES_4760_5760_Class_02_Slides.pdf"
course      : "EES 4760/5760"
course_name : "Agent-Based & Individual-Based Computational Modeling"
author      : "Jonathan Gilligan"
semester    : Spring
year        : 2018
output:
  revealjs.jg::revealjs_presentation
---

# A Model Is A  Model Is A Model {#model-model-model data-transition="fade-out" data-state="skip_slide"}

## Modeling {#modeling data-transition="fade-in"}

<div class="noborder">

<table><tbody>
<tr>
<td style="vertical-align:top;padding-top:50px;">

* There are many "modelings":
    * Agent-Based Models
    * Mathematical Models
    * Statistical Models
    * System-Dynamics Models
    * Discrete-Event Models
    * Stochastic Dynamic Models
    * Physical Models
    * ...

</td><td style="vertical-align:top;">
![Physical Model of the Economy](assets/images/moniac.jpg){height=800}

<span style="font-size:80%;">
MONIAC: A physical model of the British national economy
</span>

<span style="font-size:60%;color:#c0c0c0;">(Photo: Wm. Vandivere, Fortune, March 1952, p. 100)</span>

</td></tr>
</tbody></table>

## Agent-Based Modeling (ABM) {#abm}

<div style="text-align:left;">

* Two elements:
    1. Agent-based
    2. Modeling

<div style="height:50px;"></div>

> * Certain principles apply to all kinds of modeling
> * First, consider modeling
> * Then consider what distinguishes agent-based modeling from other kinds.

</div>

## What Is A Model? {#what-is-a-model}

> * Definition (first try):
>      * A model is a simplified representation of reality
> * Why do we simplify?

## Modeling {#modeling-2}

* Developing a model:
    * Problem solving under constraints
* Most important constraints:
    * Incomplete information
    * Lack of time
    * Lack of resources (people, money, computing power, etc.)

## Example {#example-1}

> * You bought a six-pack of a tasty beverage last night,
>   * but when you get home this evening, you realize that 
>     you forgot to put it in the refrigerator.
> * So you put it in the fridge, and now you want to know,
>   without trial and error, when it will be cool enough to drink.
> * How do you approach the problem?

# Heuristics {#heuristics-sec data-transition="fade-in" data-state="skip_slide"}

## Heuristics {#heuristics data-transition="fade-in"}

* Mental shortcuts
* Rules of thumb that experience has shown to be useful.
* When solving problems under constraints, 
  apply heuristics in modeling:
  * Simplified representations

## Typical Heuristics {#typical-heuristics}

* Rephrase the problem
* Draw a simple diagram of the system
* Imagine that you are inside the system
* Identify essential variables
* Identify simplifying assumptions
* Use "salami tactics": slice space and time

## What Is A Model {#what-is-a-model-2}

* Definition (second try):
    * A model is a purposeful (simplified) representation 
* Modeling is something we all do all the time because
  we never have enough data and time!
  
  :::{style="height:50px;"}
  :::
  
* Thinking = problem-solving = modeling

## What Is A Model? {#what-is-a-model-3}

<ul>
<li>
Modeling adaptive behavior means trying to model the models used
    by adaptive agents
    (plants, animals, humans, organizations, etc.)
</li><li class="fragment">
A model is a model is a model
</li>
</ul>

# Is Modeling Essential? {#essential-sec data-transition="fade-out" data-state="skip_slide"}

## Is Modeling Essential? {#essential data-transition="fade-in"}

<ul>
<li>
When trying to solve a problem, we keep asking ourselves,
  "is this aspect of the real system essential for solving my problem?"
</li><li class="fragment">
How can we know whether something is essential?
  <ul>
  <li class="fragment">
  We cannot know
  </li><li class="fragment">
  In science, we keep developing the model to test our assumptions
  </li></ul>
</li>
</ul>

## Example: Model A Forest {#modeling-forest}

> * Without a clearly stated question or problem we cannot formulate a simplified representation.
>   * We don’t know the purpose of the model
> * The strategy: 
>
>   <span style="color:#4F94CD;font-style:italic;">Model first, then think about what problems we can solve with the model</span> 
>
>   does not work!
> * Forest model:
>   * Timber extraction
>   * Ecosystem preservation
>   * Forest fires
>   * ...

## Example: Checkout Queue {#queue-model}

<ul>
<li>
Your purpose:
  <ul>
  <li class="fragment">
  Minimize waiting time
  </li></ul>
</li><li class="fragment">
Manager's purpose:
  <ul>
  <li class="fragment">
  Minimize waiting time of all customers
  </li></ul>
</li><li class="fragment">
Manager's solution:
  <ul>
  <li class="fragment">
  Single queue for all customers
<ul><li>
  Airports, banks, etc.
</li></ul>
  </li></ul>
</li>
</ul>

# Lessons for Agent-Based Modeling {#lessons-sec data-transition="fade-out" data-state="skip_slide"}

## Lessons for Agent-Based Modeling {#lessons data-transition="fade-in"}

* ABM requires some specific techniques (programming, math, statistics)
* But general modeling principles apply.
    * Scientific modeling explicitly states heuristics, simplifying assumptions
    * **Use math & computer logic to rigorously explore consequences of assumptions**

## Lessons for Agent-Based Modeling {#lessons-2}

* We must start with a clearly formulated research question
* We need to **simplify**
* Iterative process:
    * Formulate question
    * Create simplified representation
    * Implement model as program
    * Test program
    * Analyze output
    * Start over with modified question/model/program/etc.
* Modeling cycle

# The Modeling Cycle {#modeling-cycle-sec data-transition="fade-out" data-state="skip_slide"}

## The Modeling Cycle {#modeling-cycle data-transition="fade-in"}

![Modeling Cycle](assets/images/modeling-cycle.png){height=900}

## Modeling Cycle Tasks {#tasks-1}

### **Formulate the Question**

* Question or problem serves as filter for what to include in the model.
* Modeling the system first and then specifying the question <span style="color:#800000;">*does not work*</span>


<div class="fragment" style="padding-top:50px;">

### **Assemble Hypotheses**

* We need a **conceptual** (often verbal, graphical) **model** of how the system works and what the answer is.
* This conceptual model can be based on: empiricial experience, theory, feeling
* Discuss and revise the conceptual model thoroughly, but not forever.
    * *It can't be tested in your head!*

</div>

## Modeling Cycle Tasks {#tasks-2}

### **Choose Model Structure**

* What are the model's **entities**? 
    * How are they characterized (state variables)?
* How do you represent the environment? 
* What are temporal and spatial resolutions and extents?

<div class="fragment" style="padding-top:50px;">

### **Implement the Model**

* Write down equations and/or implement model as computer program
* Choose appropriate software platform/system

</div>

## Modeling Cycle Tasks {#tasks-3}


### **Analyze the Model**

* Perform controlled experiments to understand your model
* Design & analyze simulation experiments just like real experiments
* This is the hard part (95% of the time)

<div class="fragment" style="padding-top:50px;">

### **Communicate the Model**

* Like lab protocol: Model development has to be documented
* Keep a notebook of what y ou do.
* Keep old versions of your model
    * <span style="font-size:80%;">Name files `model_1.nlogo`, `model_2.nlogo`, etc.</span>
    * <span style="font-size:80%;">
    Or use revision-control software (git, mercurial, etc.)<br/>
    (See "Reading Resources and Computing Tools" handout)
    </span>
* Final documentation should enable peers to fully understand and re-implement model (ODD specification) (More on this next week)

</div>

## The Modeling Cycle {#modeling-cycle-final}

![Modeling Cycle](assets/images/modeling-cycle.png){height=900}

# Example Models {#example-model-sec data-transition="fade-out" data-state="skip_slide"}

## Examples of Agent-Based Model Research at Vanderbilt {#example-model-vu data-transition="fade-in"}

* Impact of land-use change on Brazilian ecosystems
* Spread of solar-roof systems in California
* Adaptation to drought by rice farmers in Sri Lanka
* Interaction of land-use and sea-level rise in Bangladesh
* Interaction of environmental change and population migration in Bangladesh
* Co-evolution of mega-herbivores and steppe ecosystems at Pleistocene-Holocene boundary
* Predicting traffic congestion for navigation apps
* Impact of Nashville gentrification on mobility & access to mass transit
* Can prediction market affect belief in climate change?
* Teaching K-12 science


## Other Examples of Agent-Based Model Applications {#example-model data-transition="fade-in"}

* Predator-prey interactions
* Preserving viability of threatened species
* Interaction of public belief in global warming, engineering projects, and future vulnerability of coastal communities.
* Impact of natural disasters on cities
* Designing effective political institutions
* Designing evacuation routes from buildings
* Predicting and managing disease epidemics
* Mechanisms of septic shock (bacteria in human body)
* Developing strategies for responding to mass shootings
* Effect of opium trafficking on Taliban insurgency in Afghanistan