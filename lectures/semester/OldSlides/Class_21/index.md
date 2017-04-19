# Theory Development
Jonathan Gilligan  

# Theory Development {#theory-development-sec data-transition="fade-out" data-state="skip_slide"}

## Models as a Virtual Laboratory {#virtual-laboratory data-transition="fade-in"}

> * How to use models to run experiments?
> * Strong inference (John Platt)
> * Identify traits (individual behaviors) that give rise to multiple macroscopic patterns


> 1. Identify alternative traits (hypotheses)
> 2. Implement traits in ABM
> 3. Test and compare alternatives:
>       * How well did model reproduce observed patterns?
>       * Falsify traits that did not reproduce patterns
> 4. Repeat cycle as needed. Revise behavior traits, look for additional patterns, etc.

## Pattern-Oriented Modeling Cycle {#pom-cycle}

![POM Cycle](assets/images/POM_cycle.png){height=800}


# Example: Trader intelligence {#trader-intelligence-sec data-transition="fade-out" data-state="skip_slide"}

## Example: Trader intelligence {#trader-intelligence data-transition="fade-in"}

### Continuous Double Auction

1. Traders establish buying and selling prices
    * If someone offers a price $\ge$ selling price, trader sells.
    * If someone offers to sell for $\le$ buying price, trader buys
2. Match traders: 
    * If traders $i$ and $j$ have $P_{i,\text{sell}} \le P_{j,\text{buy}}$, then transaction occurs.


## Zero-intelligence agent {#zero-intelligence .center data-transition="fade-out"}

* Agent sets random buying and selling price
* If $P_{i,\text{buy}} > P_{i,\text{sell}}$, then trader $i$ will lose money.


## Minimal-intelligence agent {#min-intelligence .center data-transition="fade-in"}

* Random buying and selling price with constraint: $P_{i,\text{buy}} < P_{i,\text{sell}}$.

## Results {#trading-results .ninety}

* Minimal-intelligence agent was better than zero-intelligence
    * Zero-intelligence produced wild price fluctuations
    * Minimal-intelligence reproduced observed pattern of rapid price convergence
    * Minimal-intelligence also reproduced observed effects of price-ceiling.
* But simple models had limits:
    * Observed volatility of lower-end prices was not reproduced by models
    * As experimental markets got more complicated, human traders did worse,
      but models did ***much*** worse.

. . .


### **Lessons**


> Using zero-intelligence as a baseline, the researcher can ask: 
> what is the minimal additional structure or restrictions on 
> agent behavior that are necessary to achieve a certain goal.



# Example: Harvesting Common Resource {#cpr-sec data-transition="fade-out" data-state="skip_slide"}

## Example: Harvesting Common Resource {#cpr data-transition="fade-in"}

* Experimental subjects move avatars on screen to harvest tokens 
  <br/>(like simple video game)
* Players compete to get most tokens
* Tokens grow back at some rate
* Patterns:
    #. Number of tokens on screen over time
    #. Inequality between players
    #. \# tokens collected in first four minutes
    #. Number of straight-line moves

## Theory development {#cpr-theory .ninety}

#. N&auml;ive model: (random) Moves randomly
#. N&auml;ive model: (greedy) Always goes to nearest token
#. Clever model: 
    * Prefers nearby tokens
    * Prefers clusters of tokens
    * Prefers tokens straight ahead
    * Avoids tokens close to other players

. . .

* N&auml;ive models do not match any of the four patterns.
* Ran clever model 100 times for each of 65,536 different combinations of parameters that characterize preferences.
    <div class = "fragment">
    * Only 37 combinations of parameters matched all four patterns in data.
    * Patterns 2 and 3 are seen for most parameter values
    * Patterns 1 and 4 seen less frequently
    * Therefore:
        * Patterns 2 and 3 are built into the structure of the game.
        * Patterns 1 and 4 may give insight into human behavior.
    </div>


# Example: Woodhoopoe {#woodhoopoe-sec  data-transition="fade-out" data-state="skip_slide"}

## Example: Woodhoopoe {#woodhoopoe  data-transition="fade-in"}

![](assets/images/bom_green_woodhoopoe_e_skelton.jpg){height=800}

<https://ees4760.jonathangilligan.org/models/class_21/wood_hoopoe_class_21.nlogo>{style="font-size:80%;"}
<https://ees4760.jonathangilligan.org/models/class_21/wood_hoopoe_odd.pdf>{target="blank_" style="font-size:80%;"}

## Observed Behaviors {#woodhoopoe-behavior}

* Groups occupy spatial territories
* One **alpha** of each sex in a territory
* Only alpha couple reproduces
* If alpha dies, oldest subordinate of that sex becomes alpha
* **Scouting forays**
    * Subordinate adult leaves territory
    * If it finds territory without alpha, it stays, becomes alpha
    * Otherwise, returns home
    * Risk of predation (death) is high on scouting forays
* Alpha couple breeds once a year, in December

## Observed Patterns {#woodhoopoe-patterns}

#. Characteristic group size distribution (adults)
    <p style="text-align:center;">
    ![Group-size histogram](assets/images/histogram.png){height=400 style="text-align:center;"}
    </p>
#. Average age of birds on scouting forays is younger than<br/>average age of all subordinates.
#. Scouting forays most common April--October

## Modeling Woodhoopoe {#woodhoopoe-model}

* Start simple: 
    * One-dimensional world
    * One tick = one month
    * Every tick, bird has 1% chance of dying (0.99 probability to survive)
    * Scouting forays have 20% chance of death (0.80 probability to survive)
    * Adult subordinates go scouting at random (50% probability each tick)

* Does model reproduce patterns?

## Developing Alternative Strategies {#woodhoopoe-strategies}

<https://ees4760.jonathangilligan.org/models/class_21/wood_hoopoe_strategies.nlogo>{style="font-size:80%;"}
