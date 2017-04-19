# Testing and Validating Models
Jonathan Gilligan  

# Organization {#org-sec data-transition="fade-out" data-state="skip_slide"}

## Organization {#organization data-transition="fade-in"}

<div style="text-align:left;">


* Download marriage model from Blackboard or <https://ees4760.jonathangilligan.org/models/class_07/marriage_model.nlogo>
    * Marriage Model ODD is at <https://ees4760.jonathangilligan.org/models/class_07/MarriageAgeModel-ODD_PrintVersion.pdf>

</div>

. . .

<div style="text-align:left;padding-top:50px;">



* Team Projects:
    * Class Presentations March 2
    * Choice of two projects:
        * Adaptive behavior (Business investor model, Ch. 10)
        * Agent interactions (Telemarketer model, Ch. 13)
    * Decide which one you want to do and choose a partner
      <br/>(undergrads with undergrads, grads with grads)


</div>

# Finding and Fixing Errors {#error-sec .center}

## Classes of Errors {#error-classes .eighty}

* Typographical (typing `pxcor` when you mean `pycor`)

* Syntax

* Misunderstanding NetLogo language:

    <div style="width:70%;">

    ```
    ask turtle 5 [
      let neighbor-turtles turtles in-radius 2
      ask neighbor-turtles [set color green]
    ]
    ```

    </div>
    versus
    <div style="width:80%;">

    ```
    ask turtle 5 [
      let neighbor-turtles turtles-on patches in-radius 2
      ask neighbor-turtles [set color green]
    ]
    ```

    </div>
* Wrong display settings (wrapping)

* Run-time errors (e.g., division by zero, moving turtle out of world
  <br/>forgetting to initialize globals,
  turtles-own, or patches-own)

* Logic errors **<span style="color:#0000A0;">(hard to find)</span>**

* Formulation errors **<span style="color:#0000A0;">(hard to find)</span>**

## Finding Errors {#finding-errors}

* Syntax checks
* Visual tests
* Print statements (highly recommended)
    * `print`, `show`, `type`, `write`, ...
    * `output-print`, `output-show`, ...  outputs to model output area instead of Command Center
    * `file-print`, `file-show`, ... outputs to a file. 
        * Must call `file-open` first
* Spot tests with monitors on interface
* Unit tests with `jg-tif.nls`


## Chasing Down Errors {#chasing}

* Stress tests 
    * Run with many different extreme values using unit tests
* Code reviews (teamwork)
* Statistical analysis of output
    * BehaviorSpace
    * `file-open`, `file-print`, ...
    * `export-plot`

## Independent Re-Implementation of Submodels {#re-implementation}

* If your model needs a tricky calculation:
    * Try it in another format: 
      spreadsheet, scripting language (Python, R, Matlab, etc.)
    * Compare to NetLogo results


# Marriage Model {#marriage-sec data-transition="fade-out" data-state="skip_slide"}

## Marriage Model ODD {#marriage-odd data-transition="fade-in"}

* **Purpose:** Describes social norms of age at which people marry
* **Entities, State-Variables, Scales:** Agents are individual people.
    * Age (0--60), sex, marital status
    * Social angle: describes location in social network
        * Social network like cylinder: coordinates are age and social angle

<!-- --> {#social-network}
------

![social network: age goes from 0--65, social angle goes from 0--360](assets/images/marriage_fig.jpg){height=900}


