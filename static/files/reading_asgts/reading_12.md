---
title: Adaptive Behavior and Objectives
subtitle: ''
class_date: 'Reading for Class #12: Monday, Sep 29, 2025'
class_number: 12
weight: 12
slug: reading_12
pubdate: '2025-07-31'
date: 'Reading for Class #12: Monday, Sep 29, 2025'
params:
  par_date: '2025-09-29'
  par_subtitle: ~
pdf_url: /files/reading_asgts/reading_12.pdf
output:
  blogdown::html_page:
    md_extensions: +tex_math_single_backslash+compact_definition_lists
---
## Reading:

### Required Reading (everyone):

* Agent-Based and Individual-Based Modeling, Ch. 11.

### Reading Notes:

Agents' behavior often consists of trying to achieve some **objective**.

I have discussed the way that Adam Smith's "invisible hand of the market" is a kind of agent-based view of a nation's economy: Each person (agent) has an objective of trying to maximize his or her own wealth (that's the agent's **micromotive**), and in doing so, the population of agents manages unintentionally to maximize the total wealth of the nation (an emergent **macrobehavior** that results from the collective interactions of the agents and their micromotives). 

For Darwin, agents whose objectives are to survive and reproduce under changing environmental conditions achieve emergent phenomena of evolution and speciation.

If we are going to program an agent-based model to simulate such an economy (we saw this in the Sugarscape models), you need to program your agents to try to achieve their objective (maximize their wealth). There are two approaches to this:

1. You could program a sophisticated strategy into your agents.
1. You could program a simple strategy into your agents, but give them the ability to learn from their experience and adapt their behavior according to what they learn. (see section 11.3 for details and an example)

This chapter discusses different kinds of objectives you might have your agents employ. An important concept from decision theory and behavioral economics that might be new to you is **satisficing**. This term, introduced by Herbert Simon[^1] in 1956, refers to making decisions by choosing a "good-enough" option when it would take too much time and effort to determine which option is the absolute best. See section 11.4 for details and an example.

[^1]: Herbert Simon (1916--2001) was a fascinating intellectual. Kind of a renaissance scholar, he made major contributions to political science, economics, cognitive psychology, and artificial intelligence. He won the Nobel Prize for economics in 1978. His publications have been cited more than 250,000 times and even 24 years after his death, they are still cited more than 10,000 times per year.
