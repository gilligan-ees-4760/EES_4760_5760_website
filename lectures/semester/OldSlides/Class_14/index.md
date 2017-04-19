# Interaction and Telemarketers
Jonathan Gilligan  

## Getting Started {#getting-started}

* Download the following files:
    * [https://ees4760.jonathangilligan.org/models/class_14/jg-tif.nls](https://ees4760.jonathangilligan.org/models/class_14/jg-tif.nls)

    * [https://ees4760.jonathangilligan.org/models/class_14/<br/>telemarketer_class_14.nlogo](https://ees4760.jonathangilligan.org/models/class_14/telemarketer_class_14.nlogo)

    * [https://ees4760.jonathangilligan.org/models/class_14/<br/>telemarketer_mergers_class_14.nlogo](https://ees4760.jonathangilligan.org/models/class_14/telemarketer_mergers_class_14.nlogo)

    * [https://ees4760.jonathangilligan.org/models/class_14/<br/>telemarketer_class_14%20vary_initial_telemarketers-table.csv](https://ees4760.jonathangilligan.org/models/class_14/telemarketer_class_14%20vary_initial_telemarketers-table.csv)

    * [https://ees4760.jonathangilligan.org/models/class_14/<br/>telemarketer_mergers_class_14%20vary_initial_telemarketers-table.csv](https://ees4760.jonathangilligan.org/models/class_14/telemarketer_mergers_class_14%20vary_initial_telemarketers-table.csv)

# Business Investors {#investor-sec data-transition="fade-out" data-state="skip_slide"}

## Business Investors {.ninety}

* Expected utility function: 
  $$U = (W + PT) \times (1 - F)^T$$

    W = wealth, P = profit, F = risk of failure, T = time horizon

* How does this change as investors gain more wealth?

* Interactive app <https://ees4760.jonathangilligan.org/contour>

<div  style="padding-top:50px;">
<iframe height=500 width=1800 src="https://ees4760.jonathangilligan.org/contour">
Open app at <https://ees4760.jonathangilligan.org/contour>
</iframe>
</div>


# Telemarketer Model {#telemarketer-sec data-transition="fade-out" data-state="skip_slide"}

## Telemarketer Model {#telemarketer data-transition="fade-in"}

* Telemarketing firms interact
    * Telemarketer calls patches
    * If patch has received a previous call that tick, it hangs up
    * If patch has not received a previous call that tick, it buys something
    * Interaction is indirect, mediated by patches
* Accounting:
    * Net profit = 2 &times; sales &minus; 50 &times; size
    * If balance < 0, firm goes bankrupt
* Growth
    * If balance > growth threshold, firm increases size proportional to excess balance

# Results {#tm-results-sec data-transition="fade-out" data-state="skip_slide"}

## Results {#results data-transition="fade-in"}


![](assets/fig/time_series-1.png)

## Variation {#tm-variation}

![](assets/fig/time_series_bands-1.png)

## Median Weeks in Business {#tm-median-weeks}

![](assets/fig/median_lifetime-1.png)

# Mergers {#merger-sec data-transition="fade-out" data-state="skip_slide"}

## Mergers {#mergers data-transition="fade-in"}

* Instead of going bankrupt when the bank balance drops below 0, firms look for acquisition partner
    * Find a company that's bigger and has enough money to pay off deficit.
    * If it finds a parent, parent pays off deficit (child firm ends up with 0 balance)
    * In future turns, child pays parent 50% of its net profits.
    * In future, if child's balance becomes negative:
        * If parent has enough money, it pays child's deficit
        * If parent does not have enough money, child dies.


## Results {#merger-results}

![](assets/fig/time_series_merger_bands-1.png)

## Variation {#merger-variation}

![](assets/fig/time_series_merger-1.png)

## Median Weeks in Business {#merger-median-weeks}

![](assets/fig/median_lifetime_merger-1.png)
