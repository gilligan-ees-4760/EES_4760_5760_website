; __includes ["jg-tif.nls"]

breed [ dogs dog ]
breed [ packs pack ]
breed [ disperser-groups disperser-group ]

globals
[
  ; carrying-capacity  ; integer
  p-half-cc ; probability of breeding when population is half the carrying capacity
  p-full-cc ; probability of breeding when population is the full carrying capacity

  ; num-initial-packs       ; integer
  ; mean-initial-pack-size  ; could be non-integer.
  p-male-initial
  max-age-initial

  mean-litter-size
  p-male-pup

  ;
  ; Mortality rates (floating point, probabilities: range = 0 to 1)
  ;
  mortality-pup
  mortality-yearling
  mortality-subordinate
  mortality-alpha
  ; mortality-disperser

;  mean-meeting-rate       ; number of other disperser-groups met in an average year
  p-dg-merge              ; probablity of 2 compatible disperser-groups to merge


  ;  From p. 216
  ;  z(x) = exp (a + bx)
  ;  P(x) = z(x) / (1 + z(x))
  ;
  a-logistic              ; coefficients for logistic function
  b-logistic

  ; years-to-simulate

  ;
  ; The following variables are used to report statistics about the dog packs
  ;
  births-this-year
  deaths-this-year
  dispersals-this-year
  pack-deaths-this-year
  dg-deaths-this-year

  mergers-this-year
  same-sex-meetings-this-year
  same-birth-pack-meetings-this-year
  compatible-unconsummated-meetings-this-year

  pup-deaths-this-year
  yearling-deaths-this-year
  subordinate-deaths-this-year
  alpha-deaths-this-year
  disperser-deaths-this-year

  pupicides-this-year ; deaths of pup-only packs
  pupless-this-year
  mixed-deaths-this-year

  litters-this-year

  mean-pack-size-this-year
  median-pack-size-this-year
  mean-dg-size-this-year
  median-dg-size-this-year

  trace-file-is-open?
  record-debugging-traces?

  extinct?
  time-to-extinction
  p-extinction
]

dogs-own
[
  age ; years
  sex ; text: "M" or "F"
  status ; text: "pup", "yearling", "subordinate", "alpha", or "disperser"
  birth-pack ; ID of pack the dog was born in. Used by dispersers to prevent incest.
]

packs-own
[
  pups-at-start
  pack-members
]

disperser-groups-own
[
  sex
  birth-pack
  group-members
]

;
;  MAIN INTERFACE PROCEDURES
;

to setup
  ca
  ; For debugging. We can record
  ; debugging information to the trace file.
  set trace-file-is-open? false
  set record-debugging-traces? false

;  initialize-tests
;  set-context "Testing setup"
  initialize-trace-file
  initialize-globals

  create-packs num-initial-packs
  [
    initialize-pack-at-beginning
  ]

  reset-ticks
end

to go
  if ticks >= years-to-simulate or not any? dogs
  [
    if ticks < years-to-simulate
    [
      set time-to-extinction ticks
      set extinct? true
    ]
    cleanup
    stop
  ]

  step

end

to step
  tick

  ask packs [
    set pups-at-start any? pack-members with [ status = "pup" ]
  ]

  set births-this-year 0
  set deaths-this-year 0
  set dispersals-this-year 0
  set pack-deaths-this-year  0
  set dg-deaths-this-year 0

  set mergers-this-year 0
  set same-sex-meetings-this-year 0
  set same-birth-pack-meetings-this-year 0
  set compatible-unconsummated-meetings-this-year 0

  set pup-deaths-this-year 0
  set yearling-deaths-this-year 0
  set subordinate-deaths-this-year 0
  set alpha-deaths-this-year 0
  set disperser-deaths-this-year 0

  set pupicides-this-year 0
  set pupless-this-year 0
  set mixed-deaths-this-year 0

  set litters-this-year 0

  set mean-pack-size-this-year 0
  set median-pack-size-this-year 0
  set mean-dg-size-this-year 0
  set median-dg-size-this-year 0

  age-dogs
  ; test-all-for-consistency

  reproduce
  disperse-packs
  terminate-dogs
  terminate-packs-and-groups
  form-packs


  update-appearances
  update-output
end

;
;  ANNUAL PROCESSING FUNCTIONS
;
;

to age-dogs ; called in global context
  ask dogs
  [
    set age 1 + age
    update-status
    ; test-dog-consistency
  ]
  ask packs
  [
    check-and-update-alphas
  ]
end

to reproduce ; called in global context
  ask packs
  [
    if will-reproduce?
    [ produce-litter ]
  ]
end

to disperse-packs ; called in global context
  ask packs [ disperse ]
end

to terminate-dogs ; called in global context
  ask dogs [ check-mortality-and-die ]
end

to terminate-packs-and-groups ; called in global context
  ask packs [ terminate-pack-if-empty ]
  ask disperser-groups [ terminate-dg-if-empty ]
end

to form-packs ; called in global context
  ask disperser-groups
  [
    meet-and-greet
  ]
end

to update-output
  set-current-plot "Dog populations"
  set-current-plot-pen "pups"
  plot count dogs with [ status = "pup"]
  set-current-plot-pen "yearlings"
  plot count dogs with [ status = "yearling"]
  set-current-plot-pen "subordinates"
  plot count dogs with [ status = "subordinate"]
  set-current-plot-pen "alphas"
  plot count dogs with [ status = "alpha"]
  set-current-plot-pen "dispersers"
  plot count dogs with [ status = "disperser"]
;  set-current-plot-pen "total"
;  plot count dogs

  set-current-plot "Packs"
  set-current-plot-pen "packs"
  plot count packs
  set-current-plot-pen "dgs"
  plot count disperser-groups


  ifelse any? packs
  [
    set mean-pack-size-this-year mean [ count pack-members ] of packs
    set median-pack-size-this-year median [ count pack-members ] of packs
  ]
  [
    set mean-pack-size-this-year 0
    set median-pack-size-this-year 0
  ]

  set-current-plot "Average pack size"
  set-current-plot-pen "pack size"
  plot mean-pack-size-this-year
  set-current-plot-pen "pack median"
  plot median-pack-size-this-year

  ifelse any? disperser-groups
  [
    set mean-dg-size-this-year mean [ count group-members ] of disperser-groups
    set median-dg-size-this-year median [ count group-members ] of disperser-groups
  ]
  [
    set mean-dg-size-this-year 0
    set median-dg-size-this-year 0
  ]

  set-current-plot-pen "dg size"
  plot mean-dg-size-this-year


  set-current-plot "Births and deaths"
  set-current-plot-pen "births"
  plot births-this-year
  set-current-plot-pen "deaths"
  plot deaths-this-year
  set-current-plot-pen "pack deaths"
  plot pack-deaths-this-year
  set-current-plot-pen "dg deaths"
  plot dg-deaths-this-year
  set-current-plot-pen "mergers"
  plot mergers-this-year
  set-current-plot-pen "dispersals"
  plot dispersals-this-year
end

to update-appearances
  ask packs
  [
    update-pack-appearance
  ]
  ask disperser-groups
  [
    update-dg-appearance
  ]
end

;
;  INITIALIZATION FUNCTIONS
;
;

to initialize-trace-file
  if record-debugging-traces?
  [
    let trace-file-name "trace-file.csv."

  if (is-boolean? trace-file-is-open? and trace-file-is-open?)
     or (is-number? trace-file-is-open? and trace-file-is-open? != 0)
     [
       file-close
       set trace-file-is-open? false
     ]

  if file-exists? trace-file-name
  [ file-delete trace-file-name ]

  file-open trace-file-name
  set trace-file-is-open? true
  ]
end

to initialize-globals ; observer context
  ; set carrying-capacity 60
  ; set years-to-simulate 100

  let half-cc 0.5 * carrying-capacity
  let full-cc carrying-capacity
  set p-half-cc 0.5
  set p-full-cc 0.1

  ; set num-initial-packs 10
  ; set mean-initial-pack-size 5
  set p-male-initial 0.50
  set max-age-initial 7 ; TODO check whether this should be 6

  set mean-litter-size 7.9
  set p-male-pup 0.55

  set mortality-pup 0.12
  set mortality-yearling 0.25
  set mortality-subordinate mortality-adult
  set mortality-alpha mortality-adult
  ; set mortality-disperser 0.44

;  set mean-meeting-rate 1.0
  set p-dg-merge 0.65

  ; extinct? tells us whether all the dogs
  ; in the reserve have died
  set extinct? false
  set time-to-extinction -1

  let d ln(p-half-cc / (1 - p-half-cc))
  let c ln(p-full-cc / (1 - p-full-cc))
  set b-logistic (d - c) / (half-cc - full-cc)
  set a-logistic d - (b-logistic * half-cc)

;  print (word "a = " a-logistic)
;  print (word "b = " b-logistic)
;  print (word "c = " c)
;  print (word "d = " d)

end

to initialize-pack-at-beginning ; pack context

  ; We can't have a pack with 0 dogs, so ensure that the pack has
  ; at least 1, but with a mean of mean-initial-pack-size
  let num-dogs 1 + random-poisson (mean-initial-pack-size - 1)

  hatch-dogs num-dogs
  [
    initialize-dog myself max-age-initial p-male-initial
  ]

  set pack-members dogs with [birth-pack = myself]
  ; test-that "Number of dogs in pack is the number just created"
  ; expect-that num-dogs equals count pack-members

  check-and-update-alphas

  initialize-pack-appearance

  ; test-pack-consistency

end

to initialize-pack-from-disperser-groups [ group1 group2 ]; pack context
  ;
  ; Both group1 and group2 should be disperser groups.
  ; Check whether they really are.
  ;
  ; test-that "Group 1 is a disperser group"
;  expect-that is-disperser-group? group1 is-true
;  test-that "Group 2 is a disperser group"
;  expect-that is-disperser-group? group2 is-true

  set pack-members (turtle-set [ group-members ] of group1 [ group-members ] of group2)

  ;
  ; Disperser groups should only have dogs whose social status is "diserperser".
  ; Check whether that's true.
  ;
;  test-that "Number of pack-members is consistent with disperser groups"
;  expect-that count pack-members with [status = "disperser"] equals (count [group-members] of group1 + count [group-members] of group2)

  ask pack-members
  [
    set status "subordinate"
  ]


  check-and-update-alphas

;  test-pack-consistency
end

to initialize-dog [ initial-pack max-age p-male] ; dog-context
  set age random max-age
  set size 1
  set color gray
  hide-turtle

  ifelse random-binomial? p-male
  [ set sex "M" ]
  [ set sex "F" ]

  set birth-pack initial-pack
  update-status

;  test-dog-consistency
end


;
; DOG FUNCTIONS
;

to update-status ; dog context
;  test-that "update-status should have dog context"
;  expect-that is-dog? self is-true

  ifelse age < 1
  [
    set status "pup"
  ]
  [
    ifelse age <= 2
    [
      set status "yearling"
    ]
    [
      if not member? status (list "alpha" "disperser")
      [
        set status "subordinate"
      ]
    ]
  ]
end

to check-mortality-and-die
;  test-that "check-mortality-and-die should have dog context"
;  expect-that is-dog? self is-true

  let p-mortality -1
  if status = "pup" [ set p-mortality mortality-pup ]
  if status = "yearling" [ set p-mortality mortality-yearling ]
  if status = "subordinate" [ set p-mortality mortality-subordinate ]
  if status = "alpha" [ set p-mortality mortality-alpha ]
  if status = "disperser" [ set p-mortality mortality-disperser ]

  ; Make sure I didn't forget a status in the list above.
;  test-that "Mortality has been initialized"
;  expect-that p-mortality is-greater-or-equal 0

  if random-binomial? p-mortality
  [
    set deaths-this-year deaths-this-year + 1
    if status = "pup" [ set pup-deaths-this-year pup-deaths-this-year + 1 ]
    if status = "yearling" [ set yearling-deaths-this-year yearling-deaths-this-year + 1 ]
    if status = "subordinate" [ set subordinate-deaths-this-year subordinate-deaths-this-year + 1 ]
    if status = "alpha" [ set alpha-deaths-this-year alpha-deaths-this-year + 1 ]
    if status = "disperser" [ set disperser-deaths-this-year disperser-deaths-this-year  + 1 ]
    die
  ]
end

;
; PACK FUNCTIONS
;

to check-and-update-alphas ; pack context
;  test-that "check-and-update-alpha should have pack context"
;  expect-that is-pack? self is-true

  check-and-update-alpha-of-sex "M"
  check-and-update-alpha-of-sex "F"
end

to check-and-update-alpha-of-sex [ alpha-sex ] ; pack context
;  test-that "check-and-update-alpha-of-sex should have pack context"
;  expect-that is-pack? self is-true

  if not any? pack-members with [ status = "alpha" and sex = alpha-sex ]
  [
    let candidates pack-members with [ status = "subordinate" and sex = alpha-sex]
    if any? candidates
    [
      let new-alpha one-of candidates
      ask new-alpha [set status "alpha"]
    ]
  ]
end

to-report will-reproduce?
;  test-that "will-reproduce? should have pack context"
;  expect-that is-pack? self is-true

  let alphas pack-members with [status = "alpha"]
  if any? alphas with [sex = "M"] and any? alphas with [sex = "F"]
  [
;    set reproduction-tests reproduction-tests + 1
    report random-binomial? (logistic count dogs)
  ]
  report false
end

to produce-litter ; pack context
;  test-that "produce-litter should have pack context"
;  expect-that is-pack? self is-true

  set litters-this-year litters-this-year + 1
  let old-size count pack-members
  let litter-size random-poisson mean-litter-size
  set births-this-year births-this-year + litter-size
  let litter turtle-set nobody
  hatch-dogs litter-size
  [
    initialize-dog myself 0 p-male-pup
    set litter (turtle-set litter self)
  ]
  set pack-members (turtle-set pack-members litter)

;  test-that (word "Pack " who " size has grown from " old-size " by the litter size " litter-size )
;  expect-that count pack-members equals (old-size + litter-size)
;
;  test-pack-consistency
end

to initialize-pack-appearance
;  test-that "initialize-pack-appearance should have pack context"
;  expect-that is-pack? self is-true

  set shape "circle"
  let max-rad max [size] of turtles
  let target-patch one-of patches with [ not any? turtles in-radius (2.0 * max-rad) ]
  if target-patch = nobody
  [
  set target-patch one-of patches with [ not any? turtles in-radius max-rad ]
  ]
  if target-patch = nobody
  [
    set target-patch max-one-of patches [min [distance myself] of turtles]
  ]
  move-to target-patch

  update-pack-appearance
end

to update-pack-appearance
;  test-that "update-pack-appearance should have pack context"
;  expect-that is-pack? self is-true

  set shape "circle"
  set size 0.25 * count pack-members
  let alphas pack-members with [ status = "alpha"]
  ifelse count alphas = 2
  [ set color yellow ]
  [
    ifelse any? alphas with [sex = "M"]
    [ set color blue ]
    [
      ifelse any? alphas
      [ set color green ]
      [ set color brown ]
    ]
  ]
end

to disperse
;  test-that "disperse should have pack context"
;  expect-that is-pack? self is-true

  foreach (list "M" "F")
  [ ?1 ->
    if will-disperse? ?1
    [
      make-disperser-group ?1
      set dispersals-this-year dispersals-this-year + 1
    ]
  ]
end

to make-disperser-group [ dg-sex ]
;  test-that "make-disperser-group should have pack context"
;  expect-that is-pack? self is-true

  let old-pack-size count pack-members
  let dispersers pack-members with [ status = "subordinate" and sex = dg-sex ]
  set pack-members pack-members with [ not member? self dispersers ]
  hatch-disperser-groups 1
  [
    initialize-disperser-group dispersers
    initialize-dg-appearance
    create-link-from myself
  ]

;  test-that (word "size of pack " who " has decreased from " old-pack-size " by " count dispersers " of dispersers.")
;  expect-that old-pack-size equals (count pack-members + count dispersers)
;
;  test-pack-consistency
end

to-report will-disperse? [ dg-sex ]
;  test-that "will-disperse should have pack context"
;  expect-that is-pack? self is-true

  let candidates pack-members with [ sex = dg-sex and status = "subordinate" ]
  if any? candidates
  [
    if count candidates = 1
    [
      report random-binomial? 0.5
    ]
    report true
  ]
  report false
end

to terminate-pack-if-empty
;  test-that "terminate-pack-if-empty should have pack context"
;  expect-that is-pack? self is-true

  if any? pack-members with [ status != "pup" ]
  [ stop ]
  ifelse any? pack-members with [ status = "pup"]
  [
    set pupicides-this-year pupicides-this-year + 1
  ]
  [
    ifelse pups-at-start
    [
      set mixed-deaths-this-year mixed-deaths-this-year + 1
    ]
    [
      set pupless-this-year pupless-this-year + 1
    ]
  ]
  ask pack-members with [ status = "pup" ] [ die ]

;  test-that "Pack should be empty here"
;  expect-that any? pack-members is-false

  set pack-deaths-this-year pack-deaths-this-year + 1
  die

end

;
; DISPERSER-GROUP FUNCTIONS
;

to initialize-disperser-group [ members ]
;  test-that "initialize-disperser-group should have disperser group context"
;  expect-that is-disperser-group? self is-true
;
;  test-that "Initializing disperser-group with non-empty set"
;  expect-that any? members is-true

  set sex [ sex] of one-of members
;  test-that "All members of new disperser group have the same sex"
;  expect-that any? members with [sex != [sex] of myself] is-false

;  set birth-pack [ birth-pack ] of one-of members
;  test-that "All members of new disperser group have the same birth pack"
;  expect-that any? members with [birth-pack != [ birth-pack ] of myself] is-false

  set group-members members
  ask group-members
  [
    set status "disperser"
  ]

;  test-dg-consistency
end

to initialize-dg-appearance
;  test-that "initialize-dg-appearance should have disperser group context"
;  expect-that is-disperser-group? self is-true

  set shape "square"
  let max-rad max [size] of turtles
  if not is-turtle? self [ stop ]
  let candidates patches with [ not any? turtles in-radius (2.0 * max-rad)]
  ifelse any? candidates
  [
    move-to min-one-of candidates [distance myself]
  ]
  [
    move-to one-of patches with [not any? turtles-here]
  ]
  update-dg-appearance
end

to update-dg-appearance
;  test-that "update-dg-appearance should have disperser group context"
;  expect-that is-disperser-group? self is-true

  set shape "square"
  set size dg-size
  ifelse sex = "M"
  [ set color blue + 2 ]
  [ set color green + 2 ]
end

to-report dg-size
;  test-that "dg-size should have disperser-group context"
;  expect-that is-disperser-group? self is-true
  report 0.25 * count group-members
end

to terminate-dg-if-empty
;  test-that "terminate-dg-if-empty should have disperser group context"
;  expect-that is-disperser-group? self is-true

  if not any? group-members with [ status != "pup" ]
  [
    set dg-deaths-this-year dg-deaths-this-year + 1
    die
  ]
end

to meet-and-greet ; disperser-group context
;  test-that "meet-and-greet should have disperser group context"
;  expect-that is-disperser-group? self is-true

  let n-encounters random-poisson mean-meeting-rate
  foreach n-values n-encounters [ ?1 -> ?1 ]
  [
     if any? other disperser-groups
     [
      let partner one-of other disperser-groups
      if dgs-are-compatible? partner
      [
        ifelse random-binomial? p-dg-merge
        [
          hatch-packs 1
          [
            initialize-pack-from-disperser-groups myself partner
            initialize-pack-appearance
          ]
;        set dg-deaths-this-year dg-deaths-this-year + 2
        set mergers-this-year mergers-this-year + 1
        ask partner [ die ]
        die
        stop
        ]
        [
          set compatible-unconsummated-meetings-this-year compatible-unconsummated-meetings-this-year + 1
        ]
      ]
    ]
  ]
end

to-report dgs-are-compatible? [ partner ]
;  test-that "dgs-are-compatible? should have disperser group context."
;  expect-that is-disperser-group? self is-true
;
;  test-that "dgs-are-compatible? partner should be disperser group."
;  expect-that is-disperser-group? partner is-true

  if sex = [ sex ] of partner
  [
    set same-sex-meetings-this-year same-sex-meetings-this-year + 1
    report false
  ]
  let compatible? true
  ask group-members [
    if any? ([group-members] of partner) with [ birth-pack = [ birth-pack ] of myself ]
    [
      set same-birth-pack-meetings-this-year same-birth-pack-meetings-this-year + 1
      set compatible? false
    ]
  ]
  report compatible?
end
;
; NUMERICAL FUNCTIONS
;
;

to-report logistic [x]
  let z exp(a-logistic + b-logistic * x)
  report z / (1 + z) ; note that this is the complement of the function on p. 216 of the book.
end

to-report random-binomial? [p]
  report random-float 1.0 < p
end

;
;  CLEANUP AND HOUSEKEEPING
;
to cleanup
  cleanup-trace-file
;  resume-all-tests
end

to cleanup-trace-file
  if trace-file-is-open?
  [
    file-close
    set trace-file-is-open? false
  ]
end

;
;  TEST ROUTINES
;
;
;to test-dog-consistency ; dog context
;  ifelse age < 1
;  [
;    test-that "Age < 1 means pup"
;    expect-that status is-identical-to "pup"
;  ]
;  [
;    ifelse age <= 2
;    [
;      test-that "Age in range 1-2 is yearling"
;      expect-that status is-identical-to "yearling"
;    ]
;    [
;      test-that "Age > 2: subordinate, alpha, or disperser"
;      expect-that (member? status (list "subordinate" "alpha" "disperser")) is-true
;    ]
;  ]
;end

;to test-pack-consistency ; pack context
;  test-that (word "Pack " who " is not empty")
;  expect-that any? pack-members is-true
;
;  ifelse any? pack-members with [status = "alpha" and sex = "M"]
;  [
;    test-that (word "Pack " who " has only one alpha male")
;    expect-that (count pack-members with [status = "alpha" and sex = "M"]) equals 1
;  ]
;  [
;    test-that (word "Pack " who " has no subordinate male without alpha male")
;    expect-that (any? pack-members with [status = "subordinate" and sex = "M"]) is-false
;  ]
;
;  ifelse any? pack-members with [status = "alpha" and sex = "F"]
;  [
;    test-that (word "Pack " who " has only one alpha female")
;    expect-that (count pack-members with [status = "alpha" and sex = "F"]) equals  1
;  ]
;  [
;    test-that (word "Pack " who " has no subordinate female without alpha female")
;    expect-that (any? pack-members with [status = "subordinate" and sex = "F"]) is-false
;  ]
;end

;to test-dg-consistency ; disperser-group context
;  test-that (word "Disperser-group " who " is not empty")
;  expect-that any? group-members is-true
;
;  test-that (word "All members of dg " who " have the same sex")
;  let my-sex sex
;  expect-that (any? group-members with [ sex != my-sex]) is-false
;  test-that (word "All members of dg " who " come from the same original pack")
;  let origin-pack [ birth-pack ] of one-of group-members
;  expect-that (any? group-members with [ birth-pack != origin-pack ]) is-false
;
;  test-that (word "Male and female members of dg " who " come from different birth packs")
;  let compatible? true
;  let males group-members with [ sex = "M" ]
;  ask group-members with [ sex = "F" ]
;  [
;    let f-birth birth-pack
;    if any? males with [ birth-pack = f-birth ]
;    [ set compatible? false ]
;  ]
;  expect-that compatible? is-true
;
;  test-that (word "All members of dg " who " have status disperser")
;  expect-that (any? group-members with [ status != "disperser" ]) is-false
;
;end
;
;to test-logistic
;  test-that "logistic( 0 ) = 1.0"
;  expect-that abs(logistic (0.0) - 1.0) is-less-than 0.0001
;  test-that "logistic( 0.5 carrying capacity) = 0.5"
;  expect-that abs(logistic (0.5 * carrying-capacity) - 0.5) is-less-than 1.0E-6
;  test-that "logistic( carrying capacity) = 0.1"
;  expect-that abs(logistic (carrying-capacity) - 0.1) is-less-than 1.0E-6
;end

to test-logistic-plot
  set-current-plot "logistic"
  let xvalues n-values 100 [ ?1 -> ?1 * 2.0 * carrying-capacity / 100. ]
  foreach xvalues [ ?1 -> plot logistic ?1 ]
end

;to test-all-for-consistency
;  ask dogs [ test-dog-consistency ]
;  ask packs [ test-pack-consistency ]
;  ask disperser-groups [ test-dg-consistency ]
;end

to-report p-extinct
  ifelse extinct?
  [ report 1 ]
  [ report 2]
end

to get-p-extinct [ n-runs ]
  let n-extinct 0
  let tte 0
  repeat n-runs
  [
    setup
    while [ticks < years-to-simulate and not extinct?] [ go ]
    if extinct? [ set n-extinct n-extinct + 1 ]
    set tte tte + ticks
  ]
  set time-to-extinction tte / n-runs
  set p-extinction n-extinct / n-runs
end
@#$#@#$#@
GRAPHICS-WINDOW
5
10
442
448
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
ticks
30.0

PLOT
104
942
775
1380
logistic
x
f(x)
0.0
1.0
0.0
1.0
true
false
"" ""
PENS
"original" 1.0 0 -2674135 true "" ""
"extra-crispy" 1.0 0 -7500403 true "" ""

BUTTON
450
10
513
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
450
50
513
83
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
520
50
583
83
NIL
step
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
648
20
1204
330
Dog populations
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"pups" 1.0 0 -13403783 true "" ""
"yearlings" 1.0 0 -15040220 true "" ""
"subordinates" 1.0 0 -13345367 true "" ""
"alphas" 1.0 0 -2674135 true "" ""
"dispersers" 1.0 0 -5825686 true "" ""
"total" 1.0 0 -16777216 true "" ""

PLOT
650
341
1206
600
Packs
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"packs" 1.0 0 -14070903 true "" ""
"dgs" 1.0 0 -15040220 true "" ""

PLOT
1212
18
1657
328
Births and Deaths
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"births" 1.0 0 -10899396 true "" ""
"deaths" 1.0 0 -8053223 true "" ""
"pack deaths" 1.0 0 -2674135 true "" ""
"dg deaths" 1.0 0 -955883 true "" ""
"mergers" 1.0 0 -13345367 true "" ""
"dispersals" 1.0 0 -5825686 true "" ""

TEXTBOX
40
479
190
549
circle = pack\n  yellow = two alphas\n  green = female alpha only\n  blue = male alpha only\n  brown = no alphas
11
0.0
1

TEXTBOX
185
480
335
522
square = disperser group\n  blue = male\n  green = female
11
0.0
1

MONITOR
455
415
553
460
NIL
litters-this-year
0
1
11

MONITOR
455
465
567
510
mergers
mergers-this-year
0
1
11

MONITOR
520
365
577
410
NIL
extinct?
0
1
11

SLIDER
455
165
627
198
mean-meeting-rate
mean-meeting-rate
0
4
1.0
0.01
1
NIL
HORIZONTAL

PLOT
1211
337
1656
604
Average pack size
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"pack size" 1.0 0 -13345367 true "" ""
"dg size" 1.0 0 -10899396 true "" ""
"pack median" 1.0 0 -5298144 true "" ""

SLIDER
455
90
636
123
years-to-simulate
years-to-simulate
20
500
100.0
10
1
years
HORIZONTAL

SLIDER
455
130
627
163
carrying-capacity
carrying-capacity
10
100
60.0
10
1
NIL
HORIZONTAL

MONITOR
455
365
512
410
pop
count dogs
0
1
11

SLIDER
455
200
627
233
mortality-disperser
mortality-disperser
0
1
0.44
0.01
1
NIL
HORIZONTAL

BUTTON
520
10
642
43
Restore Defaults
set years-to-simulate 100\nset carrying-capacity 60\nset mean-meeting-rate 1.0\nset mortality-disperser 0.44\nset mortality-adult 0.20\nset num-initial-packs 2\nset mean-initial-pack-size 5
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
455
235
627
268
mortality-adult
mortality-adult
0
1
0.2
0.05
1
NIL
HORIZONTAL

SLIDER
455
275
627
308
num-initial-packs
num-initial-packs
1
20
2.0
1
1
NIL
HORIZONTAL

SLIDER
455
315
627
348
mean-initial-pack-size
mean-initial-pack-size
1
10
5.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
# Wild Dog Model ODD

## Purpose

The purpose of the model is to evaluate how the persistence of a wild dog population
depends on

1. the reserve's carrying capacity,
1. the ability of dispersing dogs to find each other,
1. and the mortality risk of dispersing dogs.

Measures of "persistence" include

* the average number of years (over a number of replicate simulations) until the population is extinct,
* and the percentage of simulations in which the population survives for at least 100 years.

For evaluating the usefulness of the original model for this purpose, Gusset _et al._ (2009) defined five patterns observed in teh real wild dog population of Hluhluwe-iMfolozi Park in South Africa. The patterns relevant to this version of the model are:

1. the range (mean and standard deviation) of the pack size, year by year.
2. the sex ratio of males to females
3. the proportion of the population that are pups
4. the proportion of disperser groups that fail to form new packs

The model's purposes as a NetLogo exercise are to demonstrate the use of breeds to represent collectives and to illustrate stochastic modeling techniques.

## Entities, State Variables, and Scales

The model includes three kinds of agent: **dogs**, **dog packs**, and **disperser groups**.

### Dogs
Dogs have state variables for:

*  **age** in years,
*  **sex**,
*  **the pack they were born in**.
    **NOTE:** In the book, the ODD says, "the pack or disperser group they belong to," but when two disperser groups meet, this state variable is used to ensure that the dogs were not born into the same pack, so at that point, this has to indicate the birth pack, not the disperser group. Thus, I interpret this as meaning that this variable refers only to the last pack, not disperser group, the dog belongs to.
* and **social status**.
    The social status of a dog can be
        a. **pup:** meaning its age is less than one;
        b. **yearling:** with age between 1 and 2;
        c. **subordinate:** meaning age is greater than 2 but the dog is not an alpha;
        d. **alpha:** the dominant individual of its sex in a pack; and
        e. **disperser:** meaning the dog currently belongs to a disperser group, not a pack.

### Dog packs

Dog packs have one state variable:
* an agentset of the dogs that belong to the pack.

### Disperser groups

Disperser groups have state variables for
* sex (all members are of the same sex)
* and an agentset of member dogs.

### Scales

The time step is one year. The model is nonspatial: locations of packs and dogs are not represented. However, its parameters reflect the size and resources of one nature reserve. The key parameter that characterizes the scale of the wildlife reserve is the *carrying capacity*, which is 60 dogs.

## Process Overview and Scheduling

The following actions are executed once per time step, in this given order (details are found in the Submodels section):

1. *Age and social status update*: (submodel)
2. *Reproduction*: (submodel)
3. **Dispersal:** (submodel) Subordinate dogs can leave their packs in hopes of establishing a new pack. These "dispersers" form disperser groups, which comprise one or more subordinates of the same sex that came from the same pack.
4. **Dog mortality:** (submodel) Mortality is scheduled before pack formation because mortality of dispersers is high. Whether or not each dog dies is determined stochastically.
5. **Mortality of collectives:** (submodel)
6. **Pack formation:** (submodel) Disperser groups may meet other disperser groups, and if they meet a disperser group of the opposite sex and from a different pack, the groups may or may not join to form a new pack.

## Design Concepts

### Emergence

Population and pack dynamics emerge from the the behavior of individuals, but individual behavior was entirely imposed by probabilistic empirical rules.

### Adaptation

There is no adaptation. Individual behavior is driven entirely by stochastic rules.

### Objectives

Individuals do not seek objectives.

### Learning

There is no learning

### Prediction

There is no prediction

### Sensing

When one disperser groups meets another, it sense whether the other pack has is of the opposite sex, and whether it was born in the same pack.

### Interaction

Three types of interaction were modeled:
    1. Within each pack, dispersing individuals of the same sex formed a disperser group.
    2. Disperser groups could meet and form new packs
    3. Dominant (alpha) individuals suppressed reproduction by subordinate pack members.

### Stochasticity

All demographic and behavioral parameters in the model were interpreted as probabilities, using a Bernoulli trial to include demographic stochasticity, and were drawn from empirical probability distributions to include environmental stochasticity.

### Collectives

Individuals were grouped into packs and disperser groups that represented independent entities, with some processes being explicitly related to these collectives (e.g., reproduction or formation of new packs).

### Observation

For model analysis, the time to extinction was recorded.

## Initialization

* Parameters for the model:
    * Carrying capacity = 60
* The model is initialized with:
      * 10 packs and no disperser groups.
      * The number of dogs in each initial pack is drawn from a Poisson distribution with mean of 5 (the Poisson distribution is convenient even though its assumptions are not met in this application).
      * The sex of each dog is set randomly with equal probabilities for male and female.
      * The age of individuals is drawn from a uniform integer distribution between 0 and 6.
      * Social status is set according to age.
      * The alpha male and female of each pack are selected randomly from among its subordinates; if there are no subordinates of a sex, then the pack has no alpha of that sex.

## Input Data

The model does not use any input data.

## Submodels

### Age and update social status:
* The age of all dogs is incremented.
* Their social status variable is updated according to the new age:
   * Age < 1: "pup"
    * Age = 1--2 (inclusive): "yearling
    * Age > 2 and in-pack: "subordinate" or "alpha"
    * Age > 2 and not in-pack: "disperser"
* Each pack updates its alpha males and females. If any pack is missing one or both alphas, and if it has subordinates of the appropriate sex, a subordinate of that sex is randomly selected and its social status variable set to "alpha."
* For testing: __At the end of this step, check that the pack is consistent with these rules:__
    * All dogs' social status is consistent with age and pack membership.
    * Each pack has exactly one alpha male or else it has no subordinate males.
    * Each pack has exactly one alpha female or else it has no subordinate females.

### Reproduction
Packs determine how many pups they produce, using these rules:

* If the pack does not include both an alpha female and alpha male, no pups are produced.
* Otherwise, the probability of a pack producing pups depends on the total number of dogs in the reserve, *N* (not counting any pups already born in the current time step).
* The probability of reproducing is modeled as a logistic function *P(N)* such that
    *P(N)* = 0.5 when *N* = half the carrying capacity and *P(N)* = 0.1 when *N* = the carrying capacity. See the logistic function submodel, below, for details.
    * Determine whether pack breeds, based on this probability.
    * If the pack reproduces, the number of pups is drawn from a Poisson distribution that has a mean birth rate (pups per pack per year) of 7.9.
          * Assign sex of new-born pups randomly with *P*(male) = 0.55
          * Set age of new-born pups to zero.

### Dispersal
Subordinate dogs can leave their packs in hopes of establishing a new pack. These "dispersers" form disperser groups, which comprise one or more subordinates of the same sex that came from the same pack.

Each pack follows these rules to produce disperser groups:
      * If a pack has no subordinates, then no disperser group is created.
      * If a pack has only one subordinate of its sex, it has a probability of 0.5 of forming a one-member disperser group.
      * If a pack has two or more subordinates of the same sex, the subordinates *always* form a disperser group.
      * Dogs that join a disperser group no longer belong to their original pack, and their social status variable is set to "disperser." However, dogs that join disperser groups still keep the pack identifier of the pack they were born into. This is used if it meets another disperser group.

### Dog mortality
Whether or not each dog dies is determined stochastically using the following probabilities of dying:
      * *P*(death) = 0.44 for dispersers,
      * *P*(death) = 0.25 for yearlings,
      * *P*(death) = 0.20 for subordinates and alphas,
      * and *P*(death) = 0.12 for pups.

### Mortality of collectives
* If any pack or dispersal group has no members, it is removed from the model.
* If any pack contains only pups, the pups die and the pack is removed.

### Pack formation
Disperser groups may meet other disperser groups, and if they meet a disperser group of the opposite sex and from a different pack, the groups may or may not join to form a new pack. This process is modeled by having each disperser group execute the following steps. The order in which disperser groups execute this action is randomly shuffled each time step:
        * Determine how many time the pack disperser group meets another disperser group. The number of meetings (variable num-groups-met) is modeled as a Poisson process with the rate of meeting (the average number of times per year that a disperser group meets another disperser group) equal to the number of other disperser groups times a parameter controlling how often groups meet.
            * num-groups-met = Poisson(*x* * number of other disperser groups)
            * The meeting rate parameter *x* can potentially have any value of 0.0 or higher (it can be greater than 1) but is given a value of 1.0.
            * The following steps are repeated up to num-groups-met times, stopping if the disperser group selects another to join:
                    1. Randomly select one other disperser group. It is possible to select the same other group more than once.
                    1. If the other group is of the same sex, or originated from the same pack, then do nothing more.
                    1. If the other group is of the opposite sex and a different pack, then there is a probability of 0.64 that the two groups join into a new pack.
                          * If they do not join, nothing else happens.
                          * If two disperser groups do join, a new pack is created immediately:
                                * All the dogs in the two groups become its members.
                                * The alpha male and female are chosen randomly.
                                * All other members are given a social status of "subordinate."
                                * The two disperser groups are no longer available to merge with remaining groups.

### Logistic function
The logistic function *P(N)* should be 0.5 when *N* = 0.5 carrying capacity and 0.1 when *N* = carrying capacity. One way to program this function is with the following  intermediate variables:
        * *X*<sub>1</sub> = carrying-capacity / 2
                * *X*<sub>2</sub> = carrying-capacity
                * *P*<sub>1</sub> = 0.5
                * *P*<sub>2</sub> = 0.1
                * *D* = ln(*P*<sub>1</sub> / (1 - *P*<sub>1</sub>))
                * *C* = ln(*P*<sub>2</sub> / (1 - *P*<sub>2</sub>))
                * *B* = (*D* - *C*) / (*X*<sub>1</sub> - *X*<sub>2</sub>)
                * *A* = *D* - (*B* * *X*<sub>1</sub>)
                Now we can write the logistic function:
                        * *z(x)* = exp(*A* + (*B x*))
                        * *P(x)* = *z(x)* / (1 + *z(x)*)
            We only need to calculate the intermediate variables *A*, *B*, *C*, and *D* once, during the initialization.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="vary_initialization" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <exitCondition>extinct?</exitCondition>
    <metric>ticks</metric>
    <steppedValueSet variable="num-initial-packs" first="2" step="2" last="10"/>
    <enumeratedValueSet variable="mean-meeting-rate">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mortality-adult">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mortality-disperser">
      <value value="0.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="years-to-simulate">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="carrying-capacity">
      <value value="60"/>
    </enumeratedValueSet>
    <steppedValueSet variable="mean-initial-pack-size" first="2" step="2" last="10"/>
  </experiment>
  <experiment name="vary_meeting_disp_mortality" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <exitCondition>extinct?</exitCondition>
    <metric>ticks</metric>
    <enumeratedValueSet variable="num-initial-packs">
      <value value="2"/>
    </enumeratedValueSet>
    <steppedValueSet variable="mean-meeting-rate" first="0" step="0.5" last="4"/>
    <enumeratedValueSet variable="mortality-adult">
      <value value="0.2"/>
    </enumeratedValueSet>
    <steppedValueSet variable="mortality-disperser" first="0.2" step="0.05" last="0.6"/>
    <enumeratedValueSet variable="years-to-simulate">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="carrying-capacity">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-initial-pack-size">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="vary_initialization_pe" repetitions="20" runMetricsEveryStep="false">
    <go>get-p-extinct 100</go>
    <timeLimit steps="1"/>
    <metric>p-extinction</metric>
    <metric>time-to-extinction</metric>
    <steppedValueSet variable="num-initial-packs" first="2" step="2" last="10"/>
    <enumeratedValueSet variable="mean-meeting-rate">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mortality-adult">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mortality-disperser">
      <value value="0.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="years-to-simulate">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="carrying-capacity">
      <value value="60"/>
    </enumeratedValueSet>
    <steppedValueSet variable="mean-initial-pack-size" first="2" step="2" last="10"/>
  </experiment>
  <experiment name="vary_meeting_disp_mortality_pe" repetitions="20" runMetricsEveryStep="false">
    <go>get-p-extinct 100</go>
    <timeLimit steps="1"/>
    <metric>p-extinction</metric>
    <metric>time-to-extinction</metric>
    <enumeratedValueSet variable="num-initial-packs">
      <value value="2"/>
    </enumeratedValueSet>
    <steppedValueSet variable="mean-meeting-rate" first="0" step="0.5" last="4"/>
    <enumeratedValueSet variable="mortality-adult">
      <value value="0.2"/>
    </enumeratedValueSet>
    <steppedValueSet variable="mortality-disperser" first="0.2" step="0.05" last="0.6"/>
    <enumeratedValueSet variable="years-to-simulate">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="carrying-capacity">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-initial-pack-size">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
