# Designing and Documenting Models:<br/>The ODD Protocol
Jonathan Gilligan  

# Housekeeping at Start of Class: {#housekeeping-sec data-transition="fade-out" data-state="skip_slide"}

## Getting Started: {#getting-started .center data-transition="fade-in"}

Today's slides are at <https://ees4760.jonathangilligan.org/Slides/Class_04>

<div style="padding-top:50px;padding-bottom:50px;"/>
<hr/>
</div>

* Download and save the Butterfly model from <https://ees4760.jonathangilligan.org/models/Class_04/butterfly_odd.nlogo>
* Open NetLogo and load "butterfly_odd.nlogo"

# Designing and Documenting Models {#designing-documenting-sec data-transition="fade-out" data-state="skip_slide"}

## Designing and Documenting Models {#designing-documenting data-transition="fade-in"}

![ODD publication](assets/images/odd_paper.png){height=800}

## Design

* Don't start writing code until you know what you're trying to do.

> * Big picture
>      * What is the **purpose** of your model?
>      * What **things** does your model use?
>      * How do those things **behave**?
> * Design concepts
>      * How do you represent the **things** in your model?
>      * How do you implement their **behavior**?
>      * How will your **things** and **behaviors** realize your **purpose**?
>      * What **data** will you collect from your model?
>      * How will you **use that data** to achieve your **purpose**?

## Overview, Design Concepts, and Details

<div class="noborder">
<table style="vertical-align:middle;margin-top:50px;">
<tr><td>

![ODD Diagram](assets/images/odd_diagram.png){height=900}

</td><td style="vertical-align:middle;text-align:center;">
<p style="padding:0;margin:0;text-align:center;">General</p>

![Arrow](assets/images/arrow.png){height=720 style="border:0;box-shadow:none;margin-left:0;margin-right:0;text-align:center;"}

<p style="padding:0;margin:0;text-align:center;">Detailed</p>
</td></tr>
</table>
</div>

## ODD in perspective: {#odd-perspective .center}

> * Write overview and major parts of design concepts *first*
> * As you write the model code, revisit and revise design concepts.
> * Much of the details will emerge in the course of programming.
> * When you are finished, write a complete ODD. This will be the major 
    documentation for your model.

# ODD Outline {#odd-outline-sec data-transition="fade-out" data-state="skip_slide"} 

## 1. Purpose {#odd-purpose .center data-transition="fade-in"}

*Question:* What is the **purpose** of the model?


## 2. Entities, State Variables, Scale {#odd-entities}

> * What kinds of **entities** are in the model?<br/>
    _Agents, collectives, spatial units, global environment, ..._
> * What attributes (state-variables) characterize the entities?<br/>
    _Age, sex, wealth, mood, opinion, soil type, land costs, rainfall, market price, ..._
> * What are the temporal and spatial resolutions and extents of the model?

## 3. Process Overview and Scheduling {#odd-scheduling}

> * How do states change?
> * What entities do what, and in what order?
>       * Schedule:
>            1. Which entities take actions?
>            2. What actions do they take?
>            3. In what order do they take them?
> * How is time modeled?
>       * Discrete steps?
>        * Continuum, with both continuous processes and discrete events?

# 4. Design Concepts {#design-concept-sec data-transition="fade-out" data-state="skip_slide"} 

## 4. Design Concepts {#design-concepts data-transition="fade-in" .center}

There are **11 design concepts**.

Textbook has one chapter for each.

## Outline of Design Concepts {#design-concept-outline .ninety}

> * **Basic Principles:**  Basis of model in general concepts and theories
> * **Emergence:** What emerges as the model runs?<br/>
    (phenomena not imposed or directly programmed)
> * **Adaptation** How do agents respond to changes in their environment?<br/>
    What decisions do they make, and how do they decide?<br/>
    Do they seek objectives directly (_deliberatly_) or indirectly (_mimic natural behavior_)?
> * **Objectives (Fitness):** Goals of agents? What determines survival?<br/>
    Do objectives change as agent changes?
> * **Learning:** Do individuals change behavior as they gain experience?
> * **Prediction:** How do agents predict consequences of their decisions?<br/>
    (learning, memory, environmental cues, programmed assumptions)
> * **Sensing:** What do agents know or perceive when making decisions?<br/>
    (Is sensing process itself explicitly modelled, or do they _just know_?)
> * **Interaction:** What forms of interaction among agents are there?
> * **Stochasticity:** Is there randomness in model?
    **_Randomness must be justified!_**
> * **Collectives:** Grouping of individuals (Herds, social networks, ...)
> * **Observation:** How are data collected from model for analysis?

# Details {#details-sec  .center}

## 5. Initialization {#odd-initialization}

* What is the initial state of the model world?

* Time \\(t = 0\\) of a simulation run

* In detail: 
    * How many entities, of what type, are there initially?
    * What are the exact values of their state variables?<br/>
      (Or how were they set at random?)
    * Is initialization always the same,<br/>
      or does it vary from one simulation run to the next?
    * Are initial values chosen arbitrarily, or based on data?
    * References to those data should be provided.

## 6. Input data {#odd-input-data}

Does the model use input from external sources<br/>
(data files, other models, human interaction)<br/>
to represent processes that change over time?

If so, what data? 

Where did they come from? 

Provide references, citations.

## 7. Submodels {#odd-submodels}

If the **process scheduling** step contains a list of processes,<br/>
explain, in detail what **submodels** represent those processes.

What are the model parameters?

How were the submodels designed or chosen?

How were they tested?

# Example: Virtual Corridors for Conservation Management {#butterfly-sec data-transition="fade-out" data-state="skip_slide"}

## Example: Virtual Corridors for Conservation Management {#butterfly-example .center}

![Virtual Corridors Paper](assets/images/butterfly_paper.png){height=800}

<small>Pe'er, G., D. Saltz, and K. Frank, "Virtual corridors for conservation management," Conservation Biology **19**, 1997 (2005).</small>

## Butterfly Model in NetLogo {#start-netlogo}

Open NetLogo and load "butterfly_odd.nlogo"

* Code section is blank, but ODD is filled in on "Info" tab.
    * You will fill in the code based on ODD while reading Chapter 4
* Click on "Edit" (pencil icon) to see what Info tab looks like when you edit it.
    * For details on editing "Info" tab, open [NetLogo User Guide](https://ccl.northwestern.edu/netlogo/docs/infotab.html) from the NetLogo Help menu and go to ["Info Tab Guide"](https://ccl.northwestern.edu/netlogo/docs/infotab.html) in the "Reference Section"


## Purpose {#butterfly-purpose}

* Ecologists observe that as butterflies move uphill, they concentrate into narrow and well-definied _virtual corridors_ rather than following any old path to the top of the hill.

* Explore the concept of _virtual corridors:_ 

  Can concentrations of migrating animals emerge spontaneously from movement 
  behavior and topography, instead of being a special habitat?

* Specifically, How does the concentration of hill-topping butterflies emerge from:
    * How butterflies move uphill
    * Landscape topography


## Entities, State Variables, and Scales {#butterfly-odd-entities}

* **Landscape:**
    * Square grid cells, with one *state variable*: **elevation**.
* **Butterflies:**
    * Have one *state variable*: **location**<br/>
    (discrete: which patch they're in)

## Entities, State Variables, and Scales {#butterfly-odd-scale}

* **Spatial Scale:**
    * 150 &times; 150 cells
    * Corresponds to 25 &times; 25 meters in real landscape
    
* **Time Scale:**
    * Simulations last 1000 ticks
    * Tick length is unspecified (time for a butterfly to move one cell).

## Process Overview and Scheduling  {#butterfly-odd-scheduling}

* **Only one process:** butterfly movement
    * On each tick, each butterfly moves once
    * The order in which butterflies move is unimportant because they don't interact
    
## Design concepts (important ones)  {#butterfly-odd-design-concepts}

* **Emergence:** results (concentration of butterflies in corridors)<br/>emerge from movement rule and topography
* **Sensing:** Butterflies can sense elevation in  current and 9 surrounding cells
* **Interaction:** None
* **Stochasticity:** Used to represent reasons why butterflies do not move straight uphill
* **Observation:** We need a way to measure of butterfly concentration

## Initialization  {#butterfly-odd-initialization}

* **Landscape:** cell elevations set to flat landscape with two conical hills
* **Butterflies:** 500 are created and placed in one cell

![Butterfly landscape plan](assets/images/hill_plan.png){width=600}

![Butterfly landscape elevation](assets/images/hill_elevation.png){width=600}

## Submodel: Butterfly movement  {#butterfly-odd-submodel-movement}

* Global parameter *q* is probability that butterfly moves straight uphill,<br/>
  vs. moving to random neighbor cell.

![Butterfly patch movement](assets/images/butterfly_patches.jpg){height=700}

# Extra Material {#extra-sec .center}

## Adaptive behavior:<br/>Characteristic patterns in trout habitat selection {#adaptive-trout .eightyfive}

![Trout](assets/images/trout.jpg){height=800}


## Adaptive behavior:<br/>Characteristic patterns in trout habitat selection {#trout-habitat-selection .eightyfive}

* Use of shallow habitat when small; deep habitat when big
* Shift in habitat when predators, larger competitors are introduced
* Hierarchical feeding: big guys get the best spots
* Movement to margins during floods
* Use of slower, quieter habitat in high turbidity
* Use of lower velocities at lower temperatures

Source: Railsback and Harvey, 2002.

## Example: flocks of starlings {#realistic-starling-flocking}

* Thousands of individuals
    * unique and different
    * interact locally
    * show adaptive behavior

![Starlings](assets/images/starlings.png){height=600}

## Flock of thousands of starlings {#starling-movie}

<video width="960" height="720" controls>
  <source src="assets/video/MovieS6.mp4" type="video/mp4">
Your browser does not support the video tag.<br/>
You can play the video at 
<a href="https://ees4760.jonathangilligan.org/Slides/Class_03/assets/video/MovieS6.mp4">https://ees4760.jonathangilligan.org/Slides/Class_03/assets/video/MovieS6.mp4</a>
</video> 


## Simulated flock of thousands of starlings {#starling-model}

<video width="960" height="720" controls>
  <source src="assets/video/MovieS1.mp4" type="video/mp4">
Your browser does not support the video tag.<br/>
You can play the video at 
<a href="https://ees4760.jonathangilligan.org/Slides/Class_03/assets/video/MovieS1.mp4">https://ees4760.jonathangilligan.org/Slides/Class_03/assets/video/MovieS1.mp4</a>
</video> 

## Simulated flock of thousands of starlings {#starling-model-2}

<video width="960" height="720" controls>
  <source src="assets/video/MovieS2.mp4" type="video/mp4">
Your browser does not support the video tag.<br/>
You can play the video at 
<a href="https://ees4760.jonathangilligan.org/Slides/Class_03/assets/video/MovieS2.mp4">https://ees4760.jonathangilligan.org/Slides/Class_03/assets/video/MovieS2.mp4</a>
</video> 

