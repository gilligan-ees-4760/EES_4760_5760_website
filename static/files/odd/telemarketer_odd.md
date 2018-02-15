# THE TELEMARKETER MODEL

This model was produced by S. Railsback and V. Grimm for the book: _Agent-based and Individual-Based Modeling: A Practical Introduction_ (2012).

This version is the first, basic version of the model as described in Section 13.3.

## OVERVIEW

### PURPOSE

The formerly remote land of Wasellya has developed very rapidly and experienced universal adoption of telephones. Naturally, the "invasion" of telephone technology is followed rapidly by an invasion of people tempted to start a telemarketing business. Is this a good business risk? How many telemarketers will stay in business, for how long? How does the average life span of a telemarketing company depend on how many are started?

The real purpose of this model is to illustrate several kinds of interaction: how to model them and what their effects are on system behavior. While the modeled system is imaginary and none too serious, it does represent a common ABM scenario: a system containing a number of agents that compete for a resource and grow or die as a result.

### STATE VARIABLES AND SCALES

This model has two kinds of entities: potential customers (households with telephones), which we represent as patches, and telemarketers, which are turtles. The model is spatial: we represent the territory over which a telemarketer contacts potential customers, and the distance between telemarketers and potential customers, in arbitrary units equal to one patch size. World wrapping is turned off, so the space does have borders.

Potential customers have only one state variable in addition to their location. This is a boolean variable that represents whether they have been called by a telemarketer during the current time step. (In the NetLogo program you can use the patch's color for this variable: the patch is one color if it has not yet been called and a second color if it has been called.)

The telemarketers have a state variable "size" (we use NetLogo's built-in size variable) that represents the size of their company--how many staff and dialing machines, telephone lines, etc. they have. Telemarketers have a second state variable for their bank balance, their current financial reserves.

The model runs at a weekly time step. Simulations are 200 time steps long. There are 40,401 potential customers (the patches in a NetLogo world with the origin in the middle and maximum X and Y coordinates of 100).

### PROCESS OVERVIEW AND SCHEDULING

The model includes four actions executed in the following order each time step.

First, the patches re-set their state variable for whether they have been called by a telemarketer this week to "no".

Second, the telemarketers all do their sales calls. Each marketer calls a number of potential customers; this number increases with telemarketer size. The potential customers are within a radius of the telemarketer that increases with the marketer's size. (In this early stage of Wasellya's development, the cost of phone calls increases steeply with their distance.) Each potential customer buys something if it has not been called previously in the time step, then sets its variable for whether it has been called to "yes". If that variable was already "yes", the potential customer hangs up on the telemarketer and buys nothing. (Wasellyans are not very sophisticated yet, but they have short tempers.)

The order in which the telemarketers do this second action is obviously important because the first marketer to call a customer makes a sale, whereas marketers who call later in the same week make no sale. We will explore this issue in Chapter 14 but here we use NetLogo's default scheduling, which is that the order in which telemarketers execute the action is randomly shuffled each time step.

Third, the telemarketers do their weekly accounting. Income is determined from the number of successful calls. Costs of business increase linearly with size. The bank balance state variable is updated by adding sales income and subtracting costs. If the bank balance is negative, the telemarketer goes out of business and is removed from the model. Finally, the telemarketer increases its size if its bank balance is high enough.

The fourth action is observer updates: outputs such as the number of telemarketers still in business, a histogram of their size, and the total number of sales, are reported.

## DESIGN CONCEPTS

**Emergence.** The primary model result we are interested in is patterns in the number of telemarketers in business over time as a simulation proceeds. (The size distribution of telemarketing companies--how  many big ones  and how many small ones there are, over time--is another potentially interesting result but we neglected it here.) These results emerge from how many telemarketers there are, how they compete with each other, how many customers there are and how they respond to calls, and how the telemarketers turn their income into growth.

**Adaptive behavior.** The telemarketers adapt to their sales success by deciding whether to grow in size, and how much to grow. However, this behavior is modeled very simply and rigidly: any bank balance above a minimum is automatically spent to increase in size. Potential customers have one simple behavior: when called, they decide whether to make a purchase by whether they have already been called during the time step. There are no adaptive tradeoff decisions.

**Prediction.** The telemarketer's adaptive behavior is based on an implicit prediction that if sales are higher than needed to maintain a minimum bank balance, then increasing in size will further increase income. (Note that this implicit prediction is different from--and perhaps not as smart as--predicting that growth will be beneficial as long as income is increasing. Is it smart to grow when income is high but decreasing?)

**Sensing.** The telemarketers can sense whether each potential customer has already bought something on the current time step and, hence, whether it makes a purchase or not.

**Interaction.** There are two kinds of interaction: between telemarketers and potential customers, and among the telemarketers. The telemarketers interact directly with potential customers by communicating to find out whether the customers will buy, and then by changing the customers' state to indicate that the customer has bought during the current time step. The telemarketers' interaction with each other is mediated by the resource they compete for: customers. When the territories of telemarketers overlap, customers of one telemarketer are no longer available as potential sales for other telemarketers.

**Stochasticity.**  There are three stochastic elements of the model. First, telemarketers are placed at random locations, uniformly distributed, when the model is initialized. Second, telemarketers select the customers they call randomly from all the potential customers (see the Telemarketer sales submodel, below). Third, the order in which telemarketers make their calls is randomly shuffled each time step, to avoid bias from the advantage that first callers have.

**Observation.** The primary outputs of interest can be observed via a plot of the number of telemarketers still in business. However, to understand how the system is working it is also useful to have a histogram of telemarketer sizes.  The number of telemarketers in business is output to a file each time step so that statistics on how long telemarketers stay in business (e.g., their median life span---the time at which half have failed) can be calculated at the end of a simulation.

![Fig. 13.1](file:fig_13_1.jpg)

## DETAILS

### INITIALIZATION

The model is initialized with 200 telemarketers, each with size 1.0 and bank balance of 0.0, and a random location. (For display purposes, these are given random colors and drawn as circles.) The potential customers have their variable for whether they have been called during the week initialized to "no".

### SUBMODELS

**Telemarketer sales.** A telemarketer's potential customers are the patches within the marketer's territory, which is a circle around the marketer's location with radius equal to 10 times the square root of the telemarketer's size. The maximum number of calls a telemarketer can make each step is 100 times its size. (Therefore, unless the territory overlaps the space's edge, there are about 3.14 times more potential customers than calls.) If the number of potential customers is greater than the maximum number of calls, then the telemarketer randomly chooses this maximum number of potential customers to call. If instead the number of potential customers is less than the maximum number of calls (possible for marketers on the edge of the space), then all potential customers are called. The number of successful sales is the number of potential customers called who have not previously been called by a telemarketer on the same time step.

**Telemarketer accounting.** The weekly cost of business is equal to the telemarketer's size times 50. (We use arbitrary units for money.) The income from sales is 2 times the number of successful sales. The bank balance is updated by adding the income from sales and subtracting the cost of business.

If the new bank balance is greater than 1000, then the telemarketer converts all but 1000 of this balance to increase in growth. For every 1 unit of bank balance above 1000, the telemarketer's size increases by 0.001.

If the new bank balance is less than zero, the telemarketer goes out of business and is removed from the model.
