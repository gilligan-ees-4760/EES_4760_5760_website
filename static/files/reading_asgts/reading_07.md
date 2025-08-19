---
title: Testing and validating models
subtitle: ''
class_date: 'Reading for Class #7: Wednesday, Sep 10, 2025'
class_number: 7
weight: 7
slug: reading_07
pubdate: '2025-07-31'
date: 'Reading for Class #7: Wednesday, Sep 10, 2025'
params:
  par_date: '2025-09-10'
  par_subtitle: ~
pdf_url: /files/reading_asgts/reading_07.pdf
output:
  blogdown::html_page:
    md_extensions: +tex_math_single_backslash+compact_definition_lists
---
## Reading:

### Required Reading (everyone):

* Agent-Based and Individual-Based Modeling, Ch. 6.

### Reading Notes:

No one writes perfect programs. Errors in programs controlling medical equipment 
have killed people. Errors in computer models and data analysis code have not had 
such dire results, but have wasted lots of time for researchers and have caused 
public policy to proceed on incorrect assumptions. In many cases, these errors 
were uncovered only after a great deal of frustration because the original 
researchers would not share their computer codes with others who were suspicious 
of their results.

You can never be certain that your model is correct, but the more aggressively 
you check for errors the more confident you can be that it does not have major problems.

Two very important things you can do to ensure that your research does not suffer 
a similar fate are:

1. Test your code. Assume your program has errors in it and make the search for 
those errors a priority in your programming process.
    Some things you can do in this regard are:
      * Write your code with tests that will help you find errors.
      * Work with a partner: after one of you writes code, the other should read 
        it and check for errors.
      * Break your program up into small chunks. It is easier to test and find 
        bugs if you are looking at a short block of code than if you are looking 
        at hundreds of lines of code.
      * Independently reimplement submodels and check whether they agree with the 
        submodel you are using.
1. Publish your code. If you trust your results and believe they are important 
   enough to publish in a book or journal, then you should make your code available 
   (there are many free sites, such as [`github.com`](https://github.com) and 
   [`openabm.org`](https://openabm.org) where people can 
   publish their models and other computer code). 
    
      The more that other researchers can read your code, the greater the probability 
      that they will find any errors, and if you make it easy for others to use your 
      code, it will help science because other people can build on your work, and it 
      will help your reputation because when other people use your model or other 
      code they are likely to cite the publication in which you first announced 
      it, so your work will get attention.
    
      Many scholarly journals demand that you make your code available as a 
      condition for publishing your paper, and federal funding agencies are 
      increasingly requiring that any research funded by their grants must make 
      its code and data available to other researchers and the public.

**The Cultural Dissemination Model**

The 
[paper describing the culture dissemination model](//files/models/chapter_06/axelrod_culture_dissemination_1997.pdf)
and a 
[NetLogo model](/files/models/chapter_06/CultureDissemination_Untested.nlogo) 
that implements the ODD, but with many errors, can be downloaded from the class web site: 

* <https://ees4760.jgilligan.org/files/models/chapter_06/axelrod_culture_dissemination_1997.pdf>, 
* and <https://ees4760.jgilligan.org/files/models/chapter_06/CultureDissemination_Untested.nlogo>.
