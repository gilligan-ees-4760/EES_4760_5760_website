---
title: "Interaction and Telemarketers"
class_no: 14
class_date: "Thurs. February 22"
qrimage: qrcode.png
qrbottom: '-90%'
pageurl: "ees4760.jgilligan.org/Slides/Class_14"
pdfurl: "ees4760.jgilligan.org/Slides/Class_14/EES_4760_5760_Class_14_Slides.pdf"
course      : "EES 4760/5760"
course_name : "Agent-Based & Individual-Based Computational Modeling"
author      : "Jonathan Gilligan"
semester    : Spring
year        : 2018
output:
  revealjs.jg::revealjs_presentation
---

## Getting Started {#getting-started .eighty}

* Download the zip file 
  <https://ees4760.jgilligan.org/models/class_14/class_14_models.zip>,
  which contains
  * NetLogo Library:
    * [jg-tif.nls](/models/class_14/jg-tif.nls)
  * NetLogo Models:
    * [telemarketer_class_14.nlogo](/models/class_14/telemarketer_class_14.nlogo)
    * [telemarketer_class_14.nlogo](/models/class_14/telemarketer_non_spatial_class_14.nlogo)
    * [telemarketer_mergers_class_14.nlogo](/models/class_14/telemarketer_mergers_class_14.nlogo)
    * [telemarketer_mergers_class_14.nlogo](/models/class_14/telemarketer_compare_class_14.nlogo)
  * Behaviorspace Output:
    * [telemarketer_class_14_vary_initial_telemarketers-table.csv](/models/class_14/telemarketer_class_14_vary_initial_telemarketers-table.csv)
    * [telemarketer_non_spatial_class_14_vary_initial_telemarketers-table.csv](/models/class_14/telemarketer_non_spatial_class_14_vary_initial_telemarketers-table.csv)
    * [telemarketer_mergers_class_14_vary_initial_telemarketers-table.csv](/models/class_14/telemarketer_mergers_class_14_vary_initial_telemarketers-table.csv)

# Telemarketer Model {#telemarketer-sec data-transition="fade-out" data-state="skip_slide"}

## Telemarketer Model {#telemarketer data-transition="fade-in"}

* Telemarketing firms interact
  * Telemarketer calls patches
    * \# patches proportional to size
    * Calls around 1/3 of patches in range
  * If patch has received a previous call that tick, it hangs up
  * If patch has not received a previous call that tick, it buys something
  * Interaction is indirect, mediated by patches
* Accounting:
  * Net profit = 2 &times; sales &minus; 50 &times; size
  * If balance < 0, firm goes bankrupt
* Growth
  * If balance > growth threshold, firm grows proportional to excess balance

# Results {#tm-results-sec data-transition="fade-out" data-state="skip_slide"}

## Results {#results data-transition="fade-in"}


![](assets/fig/time-series-1.png)

## Variation {#tm-variation}

![](assets/fig/time-series-bands-1.png)

## Median Weeks in Business {#tm-median-weeks}

![](assets/fig/median-lifetime-1.png)

# Non-Spatial Variant {#non-spatial-sec .center}


## Non-Spatial Variant {#non-spatial}

* As Wasellya develops, phone range increases.
* Telemarketers can call any patch
* How does this change things?

<!-- -->

* Add a switch to the interface called "limit-calls?"
* Change the code in the submodel `make-calls` from
  ```
  let customers patches in-radius r
  ```
  to
  ```
  let customers patches
  if limit-calls?
  [set customers patches in-radius r]
  ```

## Survival of Businesses {#non-spatial-time-series}

![](assets/fig/non-spatial-time-series-1.png)

## Variation {#non-spatial-variation}

![](assets/fig/non-spatial-time-series-bands-1.png)

## Median Weeks in Business {#non-spatial-median-weeks}

![](assets/fig/non-spatial-median-lifetime-1.png)


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

![](assets/fig/time-series-merger-bands-1.png)

## Variation {#merger-variation}

![](assets/fig/time-series-merger-1.png)

## Median Weeks in Business {#merger-median-weeks}

![](assets/fig/median-lifetime-merger-1.png)


# Comparison of Models {.center}

## Comparison of Models

![](assets/fig/model-comparison-1.png)
