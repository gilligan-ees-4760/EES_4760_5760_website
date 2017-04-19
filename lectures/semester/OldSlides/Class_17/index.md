# Scheduling Model Behavior
Jonathan Gilligan  

## Mousetrap model {#mousetrap-netlogo .center}

<https://ees4760.jonathangilligan.org/models/class_17/Mousetrap_Ch14.nlogo>

<https://ees4760.jonathangilligan.org/models/class_17/Mousetrap_Ch14_v2.nlogo>


# Scheduling Actions: {#scheduling-sec .center data-transition="fade-out" data-state="skip_slide"}

## Scheduling Actions: {#scheduling .center data-transition="fade-in"}

* Representing time:
    * Discrete (`tick`)
    * Continuous (`tick-advance`)
* Execution order
    * Synchronous
    * Asynchronous
        * Random order
        * Determined order

## Repeating actions

* `repeat` repeats a certain number of times

    ```
    repeat 5 [ wander ]
    ```
    or
    ```
    repeat random count turtles [ wander ]
    ```
  
* `while` repeats as long as a condition is true

    ```
    while not any? turtles-here [ wander ]
    ```
  
* `loop` repeats forever (until `stop` or `report`)

    ```
    loop [
      wander
      if any? turtles-here [ stop ]
    ]
    ```

## Discrete vs. continuous time

* Almost all models use discrete time:
    * `tick` advances tick counter by 1.
    * `ticks` is always an integer.
* Continuous time
    * `tick-advance 2.3`
* Things to think about:
      * When to tick?

<table style="width:100%;border:0;" class="fragment fade-in noborder">
<tbody>
<tr style="width:100%;">
<td style="width:50%;">

```
to go
  ask patches [ do-patch-stuff ]
  ask turtles [ do-turtle-stuff ]

  tick
  if ticks > run-duration [stop]
end
```


</td><td style="width:50%;">

```
to go
  tick
  if ticks > run-duration [stop]

  ask patches [ do-patch-stuff ]
  ask turtles [ do-turtle-stuff ]
end
```

</td></tr>
</tbody>
</table>

## Order of execution

> * `ask`: Asks turtles in a random order.
>     * <!--- --->
        ```
        ask turtles [do-sales]
        ```
> * Suppose we wanted bigger turtles to act before the smaller ones?
>      * <!--- --->
         ```
         foreach sort-on [size] turtles [ ask ? [do-sales] ]
         ```


## Concurrent execution

* `ask-concurrent` (<span style="color:darkred;">**not recommended**</span>)

    ```
    to go
      ask turtles [turtle-action]
    end
    
    to go-concurrent
      ask-concurrent turtles [turtle-action]
    end
    
    to turtle-action
      ask one-of patches with [pcolor = blue]
      [
        set patch-value patch-value + 1
        set pcolor red
      ]
    end
    ```

* What is the difference between `go` and `go-concurrent`?

## <code>ask</code> vs. <code>ask-concurrent</code>  {#ask-concurrent .ninety}

```
ask patches [ set patch-value 0 ]
ask turtles [turtle-action]

to turtle-action
  ask one-of patches with [pcolor = blue]
  [
    set patch-value patch-value + 1
    set pcolor red
  ]
end
```

> * Each turtle finishes everything in brackets before the next turtle starts
>      1. First turtle checks `[pcolor] of patch 20 20`: it's blue
>      1. First turtle increments `patch-value` (1)
>      1. First turtle sets `pcolor` to red
>      1. Second turtle checks `[pcolor] of patch 20 20`: it's red
>      1. Second turtle checks another patch
> * `[patch-value] of patch 20 20` is 1


## <code>ask</code> vs. <code>ask-concurrent</code>  {#ask-concurrent-2 .ninety}

```
ask patches [ set patch-value 0 ]
ask-concurrent turtles [turtle-action]

to turtle-action
  ask one-of patches with [pcolor = blue]
  [
    set patch-value patch-value + 1
    set pcolor red
  ]
end
```

> * Multiple turtles running at the same time, with no synchronization.
>      1. First turtle checks `[pcolor] of patch 20 20`: it's blue
>      1. Second turtle checks `[pcolor] of patch 20 20`: it's blue
>      1. Second turtle increments `patch-value` (1)
>      1. First turtle increments `patch-value` (2)
>      1. First turtle sets `pcolor` to red
>      1. Second turtle sets `pcolor` to red
> * `[patch-value] of patch 20 20` is 2

## Synchronous vs. asynchronous updating

> * What is the difference?
> * When would you want to use one or the other?
>     * Business investor model?
>     * Telemarketer model?
> * How would you do *asynchronous* updating?
> * How would you do *synchronous* updating?
>     * Hidden state-variables (turtle can't see other turtle's hidden variables)
>     * Two ways:
>         1. Break submodel into two parts:
>             1. Turtles sense and update hidden state-variables that others can't sense
>             2. Update environment (including state-variables that others can sense)
>         2. Make shadow copy of all state variables:
>             1. Sensing sees originals, updates change shadow-copies
>             2. Update the original (`set original shadow-copy`)

## Mousetrap model {#mousetrap-video .center}


[https://youtu.be/XIvHd76EdQ4](https://youtu.be/XIvHd76EdQ4?t=1m25s){target="_blank"}


## Mousetrap model {#mousetrap-netlogo .center}

<https://ees4760.jonathangilligan.org/models/class_17/Mousetrap_Ch14.nlogo>

<https://ees4760.jonathangilligan.org/models/class_17/Mousetrap_Ch14_v2.nlogo>

* Play with models
* Compare continuous updating with updating on ticks
