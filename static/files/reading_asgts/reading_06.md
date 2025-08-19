---
title: Using models for science
subtitle: ''
class_date: 'Reading for Class #6: Monday, Sep 08, 2025'
class_number: 6
weight: 6
slug: reading_06
pubdate: '2025-07-31'
date: 'Reading for Class #6: Monday, Sep 08, 2025'
params:
  par_date: '2025-09-08'
  par_subtitle: ~
pdf_url: /files/reading_asgts/reading_06.pdf
output:
  blogdown::html_page:
    md_extensions: +tex_math_single_backslash+compact_definition_lists
---
## Reading:

### Required Reading (everyone):

* Agent-Based and Individual-Based Modeling, Ch. 5.

### Optional Extra Reading:

* Modeling Social Behavior, Ch. 3.

### Reading Notes:

This reading sets the stage for answering the big question, "How can we use agent-based models to do science?"
There are several aspects to this question, which this chapter will introduce:

1. How can we produce quantitative output from our models?
1. How can your models read and write data to and from files? (This is important for connecting your model to other parts of your project)
1. How should we test our models to make sure they do what we think they do? (More on this in Chapter 6)
1. Making your research reproducible by using version control and documentation.

A number of you may like to use Excel or statistical analysis tools, such as `R`, `SPSS`, or `Stata`. The material in this chapter about
importing and exporting data using text or `.csv` files will be very useful for this. 
By default, NetLogo only allows you to read in data in simple text files. However, if comes with some extensions that you can use to read in 
data from other common file formats, including `.csv` and ArcGIS shapefiles and raster (grid) files.

If you want to read in data from csv files, you may want to 
look at the documentation for the \texttt{csv} extension to NetLogo. To use it, you just put the line `includes [csv]` as the first line of your
model, and then  use functions from the extension, such as `let data csv:from-file "myfile.csv"`.

To read in date from ArcGIS files, look at the documentation for the `GIS` extension. You would put the line `extensions [ gis ]` as the
first line of your model, and then use functions, such as `gis:load-dataset`, which can load vector shape files (`.shp`) 
and raster grid files (`.grd` or `.asc`). The GIS extension offers a lot of functions for working with vector and raster GIS data.
If you're interested in using GIS data in your models, take a look at the GIS examples in the NetLogo model library.


You can download the [data file](/files/models/chapter_05/ElevationData.txt) with the elevations for the realistic butterfly model from 
<https://ees4760.jgilligan.org/files/models/chapter_05/ElevationData.txt>


The chapter from _Modeling Social Behavior_ is an optional supplementary reading. I strongly recommend that graduate students and students interested in social systems and social science read this. 

The main reading for today, from Railsback & Grimm presents a model of an ecological system. This chapter presents a famous agent-based model of racial segregation in housing. 
This model is historically important, and also controversial. It was perhaps the first agent-based model ever used to study a research problem in social sicence, and it was written 
by a researcher who went on to win the Nobel Prize in economics. However, the model is problematic and has been criticized because it is often interpreted in ways that minimize the role 
of institutional racism in driving segregation (e.g., government policies that explicitly prohibited racially integrated housing across large parts of the entire United States). 
This chapter presents the model and also discusses the challenges of using it effectively for science and the importance of considering the actual historical context of the social system
being modeled. Specifically, this model does not account for the historical segregationist policies, so it's important not to assume that experiments using this model can tell us about
real-world segregation in the U.S., but nonetheless, the model can help us identicy potentially important obstacles to remedying the segregated housing patterns that those policies produced.
