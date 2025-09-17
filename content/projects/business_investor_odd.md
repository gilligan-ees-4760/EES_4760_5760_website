---
title: "ODD for Business Investor Model"
date: "2019-08-22"
pubdate: "2019-08-22"
download_link: "/files/odd/business_investor_odd.pdf"
descr: "ODD for Business Investor Model"
output: html_document
---
# THE BUSINESS INVESTOR MODEL

This model was produced by S. Railsback and V. Grimm for Chapter 10 of the book Agent-Based and Individual-Based Modeling, 2nd edition (2019).

This is the first version of the model, as described in Section 10.4.1.

## OVERVIEW

### PURPOSE AND PATTERNS

The primary purpose of this model is to explore the effects of sensing---what information agents have and how they obtain it---on emergent outcomes of a model in which agents make adaptive decisions using sensed information. The model uses investment decisions as an example, but it is not intended to represent any real investment approach or business sector. (In fact, you will see by the end of chapter 12 that models like this one that are designed mainly to explore the system-level effects of sensing and other concepts can produce very different results depending on exactly how those concepts are implemented. What can we learn from such models if their results depend on what seem like details? In part III of this course we will learn to solve this problem by tying models more closely to real systems.) 

This model can be thought of as approximately representing people who buy and operate local businesses: it assumes investors are familiar with businesses they could buy within a limited range of their own experience. The investment "environment" assumes that there is no cost of entering or switching businesses (e.g., as if capital to buy a business is borrowed and the repayment is included in the annual profit calculation), that high profits are rarer than low profits, and that risk of failure is unrelated to profit. We can use the model to address questions such as how the average wealth of the investors, and how evenly wealth is distributed among individuals, depends on how much information the investors can sense. 

Because this model is conceptual and not intended to represent a specific real system, we can only use general patterns as criteria for its usefulness. These patterns are that investor decisions depend on the profit and risk "landscape," and that the decisions change with investor wealth. 

### ENTITIES, STATE VARIABLES, AND SCALES

The entities in this model are investor agents (turtles) and business alternatives (patches) that vary in profit and risk. The investors have state variables for their location in the space and for their current wealth (_W_, in money units).  

The landscape is a grid of business patches, each of which has two static variables: the annual net profit that a business there would provide (_P_, in money units such as dollars per year) and the annual risk of that business failing and its investor losing all its wealth (_F_, as probability per year). This landscape is 19 &times; 19 patches in size with no wrapping at its edges.  

The model time step is 1 year, and simulations run for 50 years. 

### PROCESS OVERVIEW AND SCHEDULING

The model includes the following actions that are executed in this order each time step:  

_Investor repositioning._ The investors decide whether any similar business (adjacent patch) offers a better tradeoff of profit and risk; if so, they "reposition" and transfer their investment to that patch, by moving there. The repositioning submodel is described at element 7. Only one investor can occupy a patch at a time. The agents execute this repositioning action in randomized order.  

_Accounting._ The investors update their wealth state variable. _W_ is set equal to the previous wealth plus the profit of the agent's current patch. However, unexpected failure of the business is also included in the accounting action. This event is a stochastic function of _F_ at the investor's patch. If a uniform random number between zero and one is less than _F_, then the business fails: the investor's _W_ is set to zero, but the investor stays in the model and continues to behave in the same way.  

_Output._ The View, plots, and an output file are updated. 

## DESIGN CONCEPTS

_Basic principles._ The basic topic of this model is how agents make decisions involving tradeoffs between several objectives---here, increasing profit and decreasing risk.  

_Emergence._ The model's primary output is mean investor wealth over time. Important secondary outputs are the mean profit and risk chosen by investors over time, and the number of investors who have suffered a failure. These outputs emerge from how individual investors make their tradeoff between profit and risk but also from the "business climate": the ranges of _P_ and _F_ values among patches and the number of investors competing for locations on the landscape.  

_Adaptive behavior._ The adaptive behavior of investor agents is repositioning: the decision of which neighboring business to move to (or whether to stay put), considering the profit and risk of these alternatives. Each time step, investors can reposition to any unoccupied one of their adjacent patches or retain their current position. In this version of the model, investors use a simplified microeconomic analysis to make their decision, moving to the patch providing the highest value of an objective function.  

_Objective._ (In economics, the term utility is used for the objective that agents seek.) Investors rate business alternatives by a utility measure that represents their expected future wealth at the end of a time horizon (_T_, a number of future years; we use 5) if they buy and operate the business. This expected future wealth is a function of the investor's current wealth and the profit and failure risk offered by the patch:  

_U_ = (_W_ + _TP_) (1 b
