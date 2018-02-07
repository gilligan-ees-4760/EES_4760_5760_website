# THE BUSINESS INVESTOR MODEL

This model was produced by S. Railsback and V. Grimm for Chapter 10 of the book Agent-Based and Individual-Based Modeling (2012).

This is the first version of the model, as described in Section 10.4.1.

## OVERVIEW

### PURPOSE

The primary purpose of this model is to explore effects of "sensing"--what information agents have and how they obtain it--on emergent outcomes of a model in which agents make adaptive decisions using sensed information. The model uses investment decisions as an example, but is not intended to represent any real investment approach or business sector.

This model could be thought of as approximately representing people who buy and operate local businesses: it assumes investors are familiar with investment opportunities within a limited range of their own experience, and that there is no cost of entering or switching investments (e.g., as if capital to buy a business is borrowed and the repayment is included in the annual profit calculation).

### STATE VARIABLES AND SCALES

The entities in this model are investor agents (turtles) and business alternatives (patches) that vary in profit and risk. The investors have state variables for their location in the space and for their current wealth (_W_, in money units).

The landscape is a grid of business patches, which each have two static variables: the annual profit (_P_; in absolute money units such as dollars) an investor would obtain there, and the annual risk of the investment there failing and losing all its value (_F_; probability per year). This landscape is 19 by 19 patches in size with no wrapping at its edges.

The model time step is one year, and simulations run for 25 years.

### PROCESS OVERVIEW AND SCHEDULING

The model includes the following actions that are executed in this order each time step.

**Investment repositioning:** The investors decide whether any similar business (adjacent patch) offers a better tradeoff of profit and risk; if so, they "reposition" and transfer their investment to that patch, by moving there. Only one investor can occupy a patch at a time. The agents execute this action in randomized order.

**Accounting:** The investors update their wealth state variable. _W_ is set equal to the previous wealth plus the profit of the agent’s current patch. However, unexpected failure of the business is also included in the accounting action. This event is a stochastic function of _F_ at the investor's patch. If a uniform random number between zero and one is less than _F_, then the business fails: the investor's wealth becomes zero, but the investor stays in the model and nothing else about it changes.

**Output:** The world display, plots, and an output file are updated.

## DESIGN CONCEPTS

**Basic principles:** The basic topic of this model is how agents make decisions involving tradeoffs between several objectives—here, increasing profit and decreasing risk.

**Emergence:** The model's primary output is the mean investor value, over time. Important secondary outputs are the mean profit and risk chosen by investors over time, and the number of investors who have suffered a failure. These outputs emerge from how individual investors make their tradeoff decisions, but also from the "business climate": the ranges of _P_ and _F_ values among patches and the number of investors competing for locations on the landscape.

**Adaptive behavior:** The adaptive behavior of investor agents is their decision of which neighboring patch to move to (or whether to stay put), considering the profit and risk of these alternatives. Each time step, investors can reposition themselves to occupy any unoccupied one of the eight adjacent patches in the business landscape, or retain their current position. In this version of the model, investors use a simplified microeconomic analysis to make their decision, moving to the patch providing highest value of an objective function.

**Objective:** (In economics, the term "utility" is used for the objective that agents seek.) Investors rate alternative investment positions by a utility measure that represents their expected future investment value at the end of a time horizon (_T_, a number of future years; we use 5). This expected future wealth is a function of their current investment value, the profit offered by the patch, and the risk of failure at the patch:

  _U_ = (_W_ + _T_ _P_) (1-_F_)<sup>_T_</sup>

where _U_ is expected utility for the patch, _W_ is the investor's current value, and _P_ and _F_ are defined above. The term (_W_ + _T_ _P_) estimates the investment value at the end of the time horizon. The term (1-_F_)<sup>_T_</sup> is the probability of surviving failure over the time horizon; it reduces utility more as failure risk increases. (Economists might expect to use a utility measure such as present value that includes a discount rate to reduce the value of future profit. We ignore discounting to keep this model simple.)

**Prediction:** The fitness measure includes an explicit forecast of utility over a time horizon that uses the assumption that _P_ and _F_ do not change over time. This assumption is accurate here because the patches' _P_ and _F_ values are static.

**Sensing:** The investor agents are assumed to know the profit and risk at their own patch and the adjacent neighbor patches, without error.

**Interaction:** The investors interact with each other only indirectly via competition for patches: an investor cannot reposition itself into a patch that is already occupied by another investor. Investors execute their repositioning action in randomized order, so there is no hierarchy in this competition: investors with higher investment value have no advantage over others in competing for locations.

**Stochasticity:** The initial state of the model is stochastic: the values of _P_ and _F_ of each patch, and initial investor locations, are set randomly. Stochasticity is thus used to simulate an investment environment where alternatives are highly variable and risk is not correlated with profit. Whether each investor fails each year is also stochastic, a simple way to represent risk. The investor reposition action uses stochasticity only in the very unlikely event that more than one potential destination patch offers the same highest utility; when there is such a tie the agent randomly chooses one of the tied patches to move to.

**Observation:** The World display shows the location of each agent on the investment landscape. Graphs show the mean risk and mean profit of patches occupied by investors, and mean investor wealth over time. An output file reports the state of each investor at each time step.

Learning and collectives are not represented.

## DETAILS

### INITIALIZATION

Four model parameters are used to initialize the investment landscape. These define the minimum and maximum values of _P_ (10,000 and 100,000) and _F_ (0.1 and 0.01). The values of _P_ and _F_ for each patch are drawn randomly from uniform real number distributions with these minimum and maximum values.

One hundred investor agents are initialized and put in random patches, but investors cannot be placed in a patch already occupied by another investor. Their wealth state variable _W_ is initialized to zero.

### INPUT DATA

No time-series inputs are used.

### SUBMODELS

**Investor repositioning:** An agent identifies all the businesses that it could invest in: the neighboring (eight, or fewer if on the edge of the space) patches that are unoccupied, plus its current patch. The agent then determines which of these alternatives provides the highest value of the utility function, and moves (or stays) there.

**Accounting:** This action is fully described above ("Process overview and scheduling").
