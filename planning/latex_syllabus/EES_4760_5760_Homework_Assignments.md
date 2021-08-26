---
title: "Homework Assignments"
author: "EES 4760/5760: Agent- and Individual-Based Computational Modeling"
date: "Fall, 2021"
output:
  pdf_document: 
    includes:
      in_header: assignment_header.sty
    keep_tex: yes
    keep_md: yes
  html_document:
    df_print: paged
---



# General instructions for homework assignments


* Homework must be turned in on Brightspace by 11:59 pm on the 
  due date unless the assignment gives a different time. 
  * Late homework will lose 5% for every day it is late, but will not lose
    more than 50%, no matter how late it is (you can always get up to half
    credit for completing late homework).

I encourage you to discuss homework assignments with your classmates. 
Some assignments will explicitly tell you to work in a team with a classmate. 
Even when the assignments do not specify working in teams, it is still fine to 
work together on homework assignments, but 
**unless the assignment tells you to work in a team, you must actually do all 
the work yourself**. 
This means that you can ask a classmate to explain how they solved a problem 
but you have to go through the steps independently and put the answer in your 
own words, not simply copy someone else's work.

**It is a violation of the honor code to turn in homework that someone 
else has done for you or which you copied from someone else.** 
If you are unsure about how the honor code applies to an assignment, please ask 
me.

## Homework Policy: Extra-Credit Options

Some homework problems are assigned to graduate students only.
Undergraduate students may choose to do any of these problems that interest 
them, and will receive for extra credit if they do.

I assign grades based on the required work, so your grade will not be affected 
by whether or not other students do extra credit problems (in other words, 
I never curve grades downward).

If you did poorly on some homework problems, or did not turn in some homework 
problems, you can make up some of that deficit by doing extra-credit
problems on subsequent assignments. Extra credit on homework only counts toward 
your homework grade for the semester and cannot compensate for missed work on 
other assignments, such as the team project or research project.


## Disclaimer

This is a schedule of homework assignments through the entire term. 
I have worked hard to plan the semester, but I may need to deviate from this 
schedule.

The most up-to-date versions of the homework assignments will be posted on the
"Schedule" page of the 
[course web site](https://ees4760.jgilligan.org/schedule): 
<https://ees4760.jgilligan.org/schedule>


# Tue., Aug. 31: Set up NetLogo

## Homework
**There is nothing for you to turn in**, but do the following task to prepare for next week:

* Download NetLogo version 6.2.0 from <https://ccl.northwestern.edu/netlogo/> and install it on your computer.



# Thu., Sep. 2: Introducing NetLogo

## Homework

* As you read along with Section 2.3, follow along on your computer and build the _Mushroom Hunt_ model by typing in the code shown in the textbook. The whole program is shown on pages 27--29.
  **Save your model as `mushroom_hunt.nlogo`**.

  This exercise may seem very simple, but it is the first step toward learning how to program NetLogo and it will be an important first step toward writing your own models.

  After you are done typing in your model, try running it.

  **When you are done, turn your model in on Brightspace.**

### Notes on Homework:

I recommend getting together with a classmate and working together on this assignment. Since the assignment consists of typing code in and running it, do not worry about your work being identical to your partner's. However, I strongly recommend that you type everything in yourself because you will not learn if you just copy someone else's code or download the code from a source on the web.

If you run into trouble and cannot make your model work, do not worry. Ask a classmate for help, or email me (and attach your `.nlogo` model file), or simply come to class on Tuesday with questions about the problems you had getting your model to work.



# Tue., Sep. 7: Becoming familiar with NetLogo

## Homework
This homework consists of reading and working through tutorials, so there is nothing to turn in.

* Everyone should do exercises 1--2 in Chapter 2 of Railsback & Grimm. This consists of reading and working through tutorials, so there is nothing to turn in.



# Thu., Sep. 9: Experimenting with NetLogo

## Homework
Upload your work to Brightspace when you're done (Word or text files for the descriptions and ODD document, and `.nlogo` files for your NetLogo models).

* Railsback & Grimm, Chapter 2, exercises Exercises 3--4.

  For exercise 4 in chapter 2, you will make seven sequential modifications of the basic mushroom hunt model. Each step modifies the previous one, so the last model will have all the modifications from the bulleted list in Ex. 2.4. Save each model with a new name, such as `ex_2_4a.nlogo`, `ex_2_4b.nlogo`, \dots, `ex_2_4g.nlogo`

* Railsback & Grimm, Chapter 3 exercise 3.

  Write your answers in any convenient text format (a simple text file, a Word document, a `.pdf` file, or whatever suits you). Call the file `ex_3_3.docx` (or `ex_3_3.pdf`, etc.).

### Notes on Homework:

My advice for Chapter 3, Exercise 3 is don't be too ambitious with your model, but keep it very
simple. Don't worry about getting everything right. If there are things you don't feel sure about or
don't know how to express, you should just write a parenthetical note in your ODD document commenting
on your difficulty. Come to class prepared to talk about how this exercise went and where
you felt confused about trying to specify your model.



# Thu., Sep. 16: Science with models: Butterfly mating

## Homework

* **Everyone:**
  * Railsback & Grimm, Ch. 4, Ex. 4.2, 4.4

    For exercise 4.4, **instead of the way the exercise is described in the book, do the following:**

    * Try adding "noise" to the landscape by adding a random number to the patch elevation.
      1. Add a switch to the interface and call it "noise"
      2. In the `ask patches` statement in `to setup`, change the elevation to this:
         ```
         ask patches
         [
           set elevation 200 + (100 * (sin (pxcor * 3.8) +
                                       sin (pycor * 3.8)))
           if noise [
             set elevation elevation +
                           random-float 20.0 - 10.0
           ]
           set pcolor scale-color green elevation 0 400
         ]
         ```
      3. In the `crt` statementin `to setup` (where you create the turtles), instead of
         `setxy random-pxcor random-pycor` write `setxy 71 71` to start the turtles in the
         middle of the hills.
      Write up answers to the following questions and turn them in on Brightspace:

      1. Compare the turtle behavior with `noise` off to `noise` on for several values of `q`.
         How does the noise affect the movement?
      2. Does this give you any insight into why the paths in the original (noise-free) model look
         artificial and unlike what you might expect butterflies to do in the real world?

  * Railsback & Grimm, Ch. 5, Ex. 5.1, 5.2, 5.4, and 5.7.

* **Graduate Students,** also do the following:
  * Railsback & Grimm, Ch. 5, exercises 5.5 and 5.8

### Notes on Homework:


* **Everyone:**For exercise 5.1, you should have three versions of the model. Each version adds new changes on top of the previous version:

  * one version of the model that incorporates all the changes (listed with triangular bullets in the book) in section 5.2 (pp. 64--68),
  * one version that starts with the previous version from 5.2 and also incorporates the additional changes in section 5.4 (p. 70),
  * one version that starts with the previous version from 5.4 and also incorporates the additional changes in section 5.5 (p. 73)

  For exercise 5.2, look in the NetLogo dictionary for a command that does what you want. The point of this exercise is to start getting
  you used to looking for new NetLogo commands when you want to do something you haven't yet learned about.

  Exercise 5.7 asks you to answer a question about the modified model. Be sure to turn in an answer to the question (you can do this in
  a separate text document or you can edit the "Info" tab in NetLogo to put your answer at the top of the info page for your model by pasting the following in and
  editing to add your answer.

  ```
  # Answer to 5.7

  answer goes here...

  ```

  If you prefer to hand-write your answer, that's fine. Just take a picture of it with your phone and upload it to Brightspace.

* **Undergraduates:**
* **Graduate Students:**For exercises 5.5 and 5.8, you need to answer questions about your models. Do this in a file that you upload to Brightspace, or write your answers on paper and take a picture and upload it, or edit the "Info" page of your model and put the answer there.



# Thu., Sep. 23: Reproducing a model from its ODD

## Homework

* **Graduate Students:**
  * Graduate students should do Railsback & Grimm, Ex. 5.11

### Notes on Homework:


* **Everyone:**
* **Undergraduates:**
* **Graduate Students:**You can download the journal article for this exercise, [R. Jovani & V. Grimm. (2008) "Breeding synchrony in colonial birds: From local stress to global harmony", _Proc. Royal Soc. London B_ **275**, 1567--63](/files/models/chapter_05/Jovani_Grimm_2008_Breeding.pdf) from the class web site,
  <https://ees4760.jgilligan.org/files/models/chapter_05/Jovani_Grimm_2008_Breeding.pdf>.

  You don't have to reproduce all of the figures in the paper. Focus on reproducing the information in Figure 2 (make a figure of colony synchrony versus NR and some other figures showing histograms of breeding dates for NR = 0.00, 0.08, 0.20, and 1.00 and comparing them to the histograms in Fig. 2.

  You may also (optionally) try to reproduce Fig. 1 and Fig. 4.

  Fig. 3 is very hard to reproduce because you would need to write a reporter to calculate the size of the colonies and that is quite difficult with what you know at this point about NetLogo programming, so I don't recommend this.

  * The paper by Jovani and Grimm forgot to specify the parameter `SD.` It should have the value 10.0.



# Tue., Sep. 28: Research project proposal

## Homework

* Turn in a one-to-two page (double-spaced) proposal for your semester research project.

### Notes on Homework:

This proposal should describe the topic you want to work on, 
identify a published open-source model you want to work with,
and and describe how you think you might want to extend it.

You should consult the textbook, the Model Library in NetLogo, 
and the list of reading and computational tools and
resources I distributed on the first day of class (it's also posted on the
course web site).

If you really want to write your own model instead of working with a
published one, that is also acceptable, but be aware that it may be a lot
more work. I recommend that you do this only if you have previous experience
in programming.

See the semester project assignment for details.



# Fri., Oct. 1: Testing and debugging models

## Homework

* **Everyone:**
  * Railsback & Grimm, Ch. 6, Ex. 6.2, 6.3
* **Graduate Students,** also do the following:
  * Railsback & Grimm, Ch. 6, Ex. 6.4, 6.5, 6.7

### Notes on Homework:

A hint for exercise 6.3:  Patches have integer coordinates (representing the center of the patch). How does the turtle determine the angle to face during `setup`? How does it determine the angle to face in `go-back`? Can you think of a different way to record the path so the `go-back` exactly retraces the path it took during `setup`? If you knew the direction the turtle was heading at each step during `setup`, could you use this heading information to exactly retrace the path?



# Tue., Oct. 5: Analyzing model experiments

## Homework

* **Everyone:**
  * Railsback & Grimm, Ch. 8, Ex. 8.1, 8.2
  * Railsback & Grimm, Ch. 9, Ex. 9.1, 9.3, 9.4
* **Graduate Students,** also do the following:
  * Railsback & Grimm, Ch. 8, Ex. 8.3, 8.4
  * Railsback & Grimm, Ch. 9, Ex. 9.6



# Thu., Oct. 7: Programming agent sensing

## Homework

* Railsback & Grimm, Ch. 10, Ex. 10.1, 10.2
* Railsback & Grimm, Ch. 11, Ex. 11.1



# Tue., Oct. 12: Analysis of a published model

## Homework

* Study the code and ODD of the model you chose for your semester research project, play with the model and run some BehaviorSpace experiments to examine its
  output.

  Turn in a 3--5 page (double-spaced) write-up about the model.

### Notes on Homework:

See the project assignment sheet for details about this assignment.



# Thu., Oct. 21: Team modeling project presentations

## Homework

* Teams will give a presentation on their projects.

### Notes on Homework:

See the team project assignment sheet for details on what I expect for the presentation.



# Fri., Oct. 22: Team modeling project reports

## Homework

* Turn in the written report for your team project on Brightspace.

### Notes on Homework:

See the team project assignment sheet for details.



# Fri., Oct. 29: Research project ODD

## Homework

* Turn in an ODD for extending your chosen model to ask new questions.

### Notes on Homework:

See the semester research project assignment sheet for details.



# Fri., Nov. 12: Draft model code for research project

## Homework

* Turn in a draft `.nlogo` file with your modified model. The ODD for your modified model should be included in the "Info" section of the model.

  You should _also_ turn in a document that describes what you are satisfied with about your draft model and what problems you are struggling with.

### Notes on Homework:

The model code you turn in should run, but it does not need to be perfect. 
   
The point of this deadline is so that you can check in with me about how
things are going so I can give you feedback and suggestions.

See the project assignment sheet for details.



# Tue., Dec. 7: Research project presentations

## Homework

* You will make a ten-minute presentation in class about your model (seven minutes of talking and three minutes for questions).

### Notes on Homework:

There will not be time to go into all the details in your presentation, so focus on:

* the big question you were addressing,
* a short description of the approach you took to answer it using an agent-based model,
* what you learned from running the model.

See the project assignment sheet for details.



# Fri., Dec. 10: Research project report

## Homework

* Turn in a written report about your research project. Your report should follow the model of a research report for _Science_ magazine:

### Notes on Homework:

See the project assignment sheet for details.

