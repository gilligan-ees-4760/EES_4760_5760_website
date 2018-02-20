---
title: Prediction and Interaction
class_no: 13
class_date: Tuesday, Feb. 20
qrimage: qrcode.png
qrbottom: '-90%'
pageurl: "ees4760.jgilligan.org/Slides/Class_13"
pdfurl: "ees4760.jgilligan.org/Slides/Class_13/EES_4760_5760_Class_13_Slides.pdf"
course      : "EES 4760/5760"
course_name : "Agent-Based & Individual-Based Computational Modeling"
author      : "Jonathan Gilligan"
semester    : Spring
year        : 2018
output:
  revealjs.jg::revealjs_presentation
---

# Getting Started {.center}

## Getting Started  {.eighty}

Download

* <https://ees4760.jgilligan.org/models/class_13/BusinessInvestor.nlogo>
* <https://ees4760.jgilligan.org/models/class_13/BusinessInvestor_satisfice.nlogo>
* <https://ees4760.jgilligan.org/models/class_13/BusinessInvestor_bayesian.nlogo>
* <https://ees4760.jgilligan.org/models/class_13/jg-tif.nls>

# Prediction {.center}

## Prediction

> * What do investors want?
>   * Maximize their wealth over time
> * How do investors decide what patch to move to?
>   * _Predict_ what their wealth is likely to be after a certain number of
      ticks on each square.
      $$ U = (W + P \times T) \times (1 - F)^T $$
> * Farmer planting crops
>   * Predict what weather will be
>   * Predict what crops will be in demand at end of season
>   * Past experience, statistical analysis, ...
> * Predator chasing prey
>   * Predict where prey will be in order to intercept
>   * Extrapolate from current position, velocity ...

## Modeling Prediction

* Sensing: What do agents know?
* Cognition: How do agents think?
* Learning: Do agents learn from experience?

## Business Investor

> * How does agent decide how far into the future to try to predict expected utility?
> * How does this time horizon affect behaviors and outcomes?


. . .


* Interactive app <https://alo.ees.vanderbilt.edu/shiny/ees4760/contour/>

<div  style="padding-top:50px;">
<iframe height=450 width=1800 src="https://alo.ees.vanderbilt.edu/shiny/ees4760/contour/">
Open app at <https://alo.ees.vanderbilt.edu/shiny/ees4760/contour/>
</iframe>
</div>

## Varying Time Horizon: Wealth



![](assets/fig/wealth-vs-horizon-detail-1.png)

## Varying Time Horizon: Failures

![](assets/fig/failures-vs-horizon-1.png)

## Varying Time Horizon: Profit

![](assets/fig/profit-vs-horizon-1.png)

## Varying Time Horizon: Risk

![](assets/fig/risk-vs-horizon-1.png)

# Modeling Prediction {.center}

## Investor Ignorance {.eighty}

> * Suppose the investor does not know risks of failure?
> * Learn about risk from experience
> * Bayesian updating:
>   * Start assuming that each patch has same risk (average)
>   * Each turn investors get new information about failures
>   * _beta_ function:
      $$F_{\text{est}} = \frac{\alpha}{\alpha + \beta}$$
      What are $\alpha$ and $\beta$?
>   * $\alpha$ represents number of failures on a patch
>   * $\beta$ represents number of non-failures
>   * Initial guess:
      $$\begin{aligned}
      \alpha &= (R^2 - R^3 - RV) / V\\
      \beta &= (R/V) (1 - R^2) + (R - 1),
      \end{aligned}$$
      where $R$ is the average risk across patches and
      $V$ is the variance of risk across patches.
>   * Every tick, increment $\alpha$ for patches with failures and increment
      $\beta$ for patches without failures.

## Experiment

* Open `BusinessInvestor_bayesian.nlogo`
