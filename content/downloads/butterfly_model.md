---
title: "Butterfly Models"
weight: 5
date: "2019-09-05"
due_date: "2021-09-09"
pubdate: "2019-08-22"
descr: "Writing the Butterfly Model (Sept. 4)"
output: html_document
---
# Butterfly Model for In-Class Exercises on Sept. 4
 
* Download the 
  [Basic Butterfly Model](/models/class_05/butterfly_model_class_5.nlogo)


* Download the 
  [Enhanced Butterfly Model](/models/class_05/enhanced_butterfly_model_class_5.nlogo)
  that we wrote in class.
  
  I have made a few changes to the enhanced model that are different from what
  we did in class:
  
  * I changed the name of the turtles-own variable `start-patch` to `origin`
    to be more concise.
  * I changed the equation for the corridor width from 
    $$ \frac{\text{\# patches visited}}{\text{sum}(\text{distance-moved})} $$ 
    to
    $$ \frac{\text{\# patches visited}}{\text{mean}(\text{distance-moved})} $$
    because that's what the book uses in Chapter 5.
  * I define the turtle to be at the top of a hill when its patch is the 
    highest in a radius of 3 patches, rather than the highest of all its
    neighbors.
  * I add a turtles-own variable `at-top?` that records whether the turtle is
    at the top of a hill, and in the `to go` procedure, I tell the model to
    stop running if all the turtles are at the top of a hill before it gets to
    1000 ticks.
