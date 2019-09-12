---
title: "ODD for Telemarketer Model"
date: "2019-08-22"
pubdate: "2019-08-22"
download_link: "/files/odd/telemarketer_odd.pdf"
descr: "ODD for Telemarketer Model"
output: html_document
---
# THE TELEMARKETER MODEL

This model was produced by S. Railsback and V. Grimm for the book: _Agent-based and Individual-Based Modeling: A Practical Introduction_, 2nd edition (2019).

This version is the first, basic version of the model as described in Section 13.3.1.

Let us visit the formerly remote land of Wasellya, which has developed very rapidly, so suddenly all its citizens have telephones. Naturally, the "invasion" of telephone technology is followed rapidly by an invasion of people tempted to start a telemarketing business. Is this a good business risk? How many telemarketers will stay in business, for how long? How does the average life span of a telemarketing company depend on how many are started? Here is the ODD description of a simple model for this problem; you should implement the model.

## OVERVIEW

### PURPOSE AND PATTERNS

The real purpose of this model is to illustrate several kinds of interaction: how to model them and what their effects are on system behavior. While the modeled system is imaginary and none too serious, it does represent a common ABM scenario: a system of agents that compete for a resource and grow or fail as a result. For such a model we define only simple, general patterns as the criteria for its usefulness: two measures of system performance---the changes over time in the number of telemarketers in business and the median time that telemarketers stay in business---depend on how many agents there are and how they interact. 

### STATE VARIABLES AND SCALES

This model has two kinds of entities: potential customers (households with telephones), which we represent as patches, and telemarketers, which are turtles. The model is spatial: we represent the territory over which a telemarketer contacts potential customers, and the distance between telemarketers and potential customers, in arbitrary units equal to one patch size. World wrapping is turned off, so the space does have borders. 

Potential customers have only one state variable in addition to their location. This is a boolean variable that represents whether they have been called by a telemarketer during the current time step. (In the NetLogo program, you can use the patch's color for this variable: the patch is one color if it has not yet been called, and a second color if it has been called.)  

The telemarketers have state variables for their (floating point) location in space, and for size, which represents how many staff, dialing machines, telephone lines, and other resources they have. Telemarketers also have a state variable for their bank balance, the amount of money they have to pay expenses and grow.  

The model runs at a weekly time step. Simulations are 200 time steps long. There are 40,401 potential customers (the patches in a NetLogo world with the origin in the middle and maximum _x-_ and _y-_ coordinates of 100). 

### PROCESS OVERVIEW AND SCHEDULING

The model includes four actions executed in the following order each time step.  

First, the patches all reset their state variable for whether they have been called by a telemarketer this week to "no" (i.e., set pcolor to the color representing "not called yet").  

Second, the telemarketers do their sales calls, using the submodel detailed below. Each marketer makes all its calls before the next marketer does its calls. A telemarketer calls a number of potential customers; this number increases with telemarketer size. The potential customers are within a radius of the telemarketer that increases with the marketer's size. (In this early stage of Wasellya's development, the cost of phone calls increases steeply with their distance.) Each potential customer buys something from the telemarketer if it has not been called previously in the time step, then sets its variable for whether it has been called to "yes" (i.e., changes its pcolor). If that variable was already "yes," the potential customer hangs up on the telemarketer and buys nothing. (Wasellyans are not very sophisticated yet, but they have short tempers.) The order in which the telemarketers carry out this second action is obviously important because the first marketer to call a customer makes a sale, whereas marketers who call the same customer later in the week make no sale. We will explore this issue in chapter 14, but here we use NetLogo's default scheduling, which is that the order in which telemarketers execute the action is randomly shuffled each time step.  

Third, the telemarketers do their weekly accounting; the submodel is fully described below at item 7. Income is determined from the number of successful calls. Costs of business increase linearly with size. The bank balance state variable is updated by adding sales income and subtracting costs. If the bank balance is negative, the telemarketer goes out of business and is removed from the model. The telemarketer increases its size if its bank balance is high enough.  

The fourth action is observer updates: outputs such as the number of telemarketers still in business, a histogram of their size, and the total number of sales, are reported. 

## DESIGN CONCEPTS

_Basic principles._ The basic concept explored in this model is competition among agents for resources that are limited but renewed.  

_Emergence._ The primary model results we are interested in are patterns in the number of telemarketers in business over time as a simulation proceeds. (The size distribution of telemarketing companies---how many big ones and how many small ones there are, over time---is another potentially interesting result.) These results emerge from how many telemarketers are initialized, how they compete with each other, how many customers there are and how they respond to calls, and how the telemarketers turn their income into growth.  

_Adaptive behavior._ The telemarketers adapt to their sales success by deciding whether to grow in size, and how much to grow. However, this behavior is modeled very simply and rigidly: any bank balance above a minimum is automatically spent to increase the company's size. Potential customers have one simple behavior: when called, they decide whether to make a purchase by whether they have already been called during the time step. There are no adaptive tradeoff decisions.  

_Prediction._ The telemarketer's adaptive behavior is based on an implicit prediction that if sales are higher than needed to maintain a minimum bank balance, then increasing in size will further increase income. (Note that this implicit prediction is different from---and perhaps not as smart as---predicting that growth will be beneficial as long as income is increasing. Is it smart to grow when income is high but decreasing?)  

_Sensing._ The telemarketers sense whether each potential customer has already bought something on the current time step.  

_Interaction._ There are two kinds of interaction: between telemarketers and potential customers, and among the telemarketers. The telemarketers interact directly with potential customers by communicating to find out whether the customers will buy, and then by making the customers change their state to indicate that they bought during the current time step. The telemarketers' interactions with each other are mediated by the resource they compete for: customers. When the territories of telemarketers overlap, customers of one telemarketer are no longer available as potential sales for other telemarketers.  

_Stochasticity._ There are three stochastic elements of the model. First, telemarketers are placed at random locations when the model is initialized. Second, telemarketers select the customers they call randomly from all the potential customers (see the telemarketer sales submodel, below). Third, the order in which telemarketers make their calls is randomly shuffled each time step, to avoid bias from the advantage that first callers have.  

_Observation._ The primary outputs of interest can be observed via a plot of the number of telemarketers still in business. However, to understand how the system is working it is also useful to have a histogram of telemarketer sizes (figure 13.1). The number of telemarketers in business is output to a file each time step so that statistics on how long telemarketers stay in business (e.g., their median life span---the time at which half have failed) can be calculated at the end of a simulation. 

![Fig. 13.1](fig_13_1.jpg)

## DETAILS

### INITIALIZATION

The model is initialized with 200 telemarketers, each with size 1.0 and bank balance of 0.0, and a location chosen randomly from all the points in the space, with equal probability for all points. (For display, these are given random colors and drawn as circles.) The potential customers have their variable for whether they have been called during the week initialized to "no.

### INPUT DATA

This model uses no time-series inputs.

### SUBMODELS

_Telemarketer sales._ A telemarketer's potential customers are the patches within the marketer's territory, which is a circle around the marketer's location with radius equal to 10 times the square root of the telemarketer's size. The maximum number of calls a telemarketer can make each step is 100 times its size. (Therefore, unless the territory overlaps the space's edge, there are about 3.14 times more potential customers than calls.) If the number of potential customers is greater than the maximum number of calls, then the telemarketer randomly chooses this maximum number of potential customers to call. If instead the number of potential customers is less than the maximum number of calls (possible for marketers on the edge of the space), then all potential customers are called. The number of successful sales is the number of potential customers called who have not previously been called by a different telemarketer on the same time step (i.e., they still were the color representing "not called yet"). (Programming hint: It is not necessary to simulate each sales call! Telemarketers can simply identify a subset of potential customers that they sell to, count that subset, and then ask its members to identify themselves as having been called.)  

_Telemarketer accounting._ The weekly cost of business is equal to the telemarketer's size times 50. (Money units are arbitrary.) The income from sales is 2 times the number of successful sales. The bank balance is updated by adding the income from sales and subtracting the cost of business.  

A parameter growth-param determines how rapidly telemarketer businesses grow. If the new bank balance is greater than growth-param, then the telemarketer converts all but growthparam of this balance to increase in growth. For every 1 unit of bank balance above growthparam, the telemarketer's size increases by the amount of a parameter money-size-ratio, which is 0.001. The value of growth-param is 1000, so, for example, if the new bank balance is 1500, then bank balance is set to 1000 and the telemarketer's size increases by 0.5 (which is [1500 &minus; 1000] &times; 0.001). (Telemarketer size never decreases.)  

If the new bank balance is less than zero, the telemarketer goes out of business and is removed from the model immediately. 
