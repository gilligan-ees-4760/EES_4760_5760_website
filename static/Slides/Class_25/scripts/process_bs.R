library(readr)
library(dplyr)
library(stringr)
library(purrr)
library(tidyr)
library(hellno)
library(ggplot2)

experiment_ <- list(data = data.frame(),
                   ind_vars <- character(0),
                   dep_vars <- character(0),
                   mapping <- data.frame(col = character(0),
                                         name = character(0))
)

input_ <- list(
x_var = '',
  y_var = '',
  group_var = '',
  last_tick_only = FALSE,
  points = TRUE,
  lines = TRUE
)

tx_name <- function(var_name) {
  experiment_$mapping %>% filter(name == var_name) %>% {.$col}
}

tx_col <- function(var_col) {
  experiment_$mapping %>% filter(col == var_col) %>% {.$name}
}

calc_vars <- function(experiment, x_var , y_var) {
  if (nrow(experiment$data) == 0) return(character(0))
  vars <- experiment$mapping %>%
    filter(!(name %in% c(x_var, y_var, 'run')))
  vars <- vars %>%
    filter(
      col %>% lapply(function(x)
        length(unique(experiment$data[,as.character(x)])) > 1) %>%
        unlist()
    )
  vars
}

expt_vars <- function(experiment = experiment_){
  exp_data <- experiment$data
  if (nrow(exp_data) == 0) return(character(0))
  vars <- experiment$mapping %>%
    filter(!(name %in% c('run')))
  vars <- vars %>%
    filter(
      col %>% lapply(function(x)
        length(unique(experiment$data[,as.character(x)])) > 1) %>%
        unlist()
    )
  vars
}

expt_yvars <- function(experiment = experiment_, input = input_){
  vars <- expt_vars(experiment) %>%
    filter(name != input$x_var)
  vars
}

expt_group_vars <- function(experiment = experiment_, input = input_){
  vars <- expt_yvars(experiment = experiment_, input = input) %>%
    filter(name != input$y_var & col %in% experiment$ind_vars)
  vars
}

expt_plot_vars <- function(experiment = experiment_, input = input_){
  vars <- expt_yvars(experiment = experiment_, input = input) %>%
    filter(name != input$y_var & col %in% c(experiment$ind_vars, experiment$dep_vars))
  vars
}


classify_vars <- function(df) {
  n <- colnames(df)
  run <- which(n == 'run')
  tick <- which(n == 'tick')
  ind_vars <- character(0)
  if (tick > run + 1) {
    ind_vars <- n[(run + 1):(tick - 1)]
  }
  dep_vars <-  tail(n, -tick)
  list(ind_vars = ind_vars, dep_vars = dep_vars)
}

bs_data <- function(inFile){
  # input$file1 will be NULL initially. After the user selects
  # and uploads a file, it will be a data frame with 'name',
  # 'size', 'type', and 'datapath' columns. The 'datapath'
  # column will contain the local filenames where the data can
  # be found.

  text <- readLines(inFile, n = 100)
  skip_lines <- which(str_detect(text, '^"\\[run number\\]"'))
  if (length(skip_lines) > 0) skip_lines = skip_lines[1] - 1
  # cat('skip lines = ', skip_lines, '\n')
  d <- read.csv(inFile, header = TRUE, skip = skip_lines) %>%
    rename(run = X.run.number., tick = X.step.)
  # cat('d has ', nrow(d), 'rows.\n')
  num_vars <- d %>% map_lgl(is.numeric) %>% keep(~.x) %>% names()
  d <- d %>% select_(.dots = num_vars) %>%
    arrange(run, tick)
  # cat('shape of d is ', dim(d), '\n')
  names(d) <- str_replace_all(names(d), '\\.+','.')
  vars <- classify_vars(head(d, min(100, nrow(d))))
  invisible(list(data = d, ind_vars = vars$ind_vars, dep_vars = vars$dep_vars,
       mapping = data.frame(col = names(d), name = names(d),
                            stringsAsFactors = F)))
}

plot_data <- function(experiment = experiment_, input = input_){
  x_var <- input$x_var
  y_var <- input$y_var
  exp_data <- experiment$data

  # message("plot_data: Data = ", class(exp_data))
  if (nrow(exp_data) == 0) {
    # message("plot_data: empty data")
    return(data.frame())
  }
  if (! all(expt_plot_vars()$col %in% names(exp_data))) {
    # message("Variable mismatch")
    return(data.frame())
  }

  # message("Checking plotting variables")
  if (! all(c(tx_name(x_var), tx_name(y_var)) %in% names(exp_data))) {
    # message("Bad plotting variables")
    return(data.frame())
  }

  pv <- expt_plot_vars(experiment, input)
  gv <- expt_group_vars(experiment, input)
  # message("Plot vars = ", paste0(pv, collapse = ', '))

  if (! 'tick' %in% c(tx_name(x_var), tx_name(y_var))) {
    max_tick <- max(exp_data$tick, na.rm=T)
    # message("Filtering to last tick: ", max_tick)
    exp_data <- exp_data %>% filter(tick == max_tick)
  }

  if (length(pv) >= 1) {
    if (input$group_var %in% gv) {
      grouping <- unique(c('tick', tx_name(x_var), tx_name(input$group_var)))
    } else {
      grouping <- unique(c('tick', tx_name(x_var)))
    }
    grouping <- grouping %>% discard(~.x == tx_name(y_var))

    message("Summarizing ", y_var, " by ", paste(map_chr(grouping, tx_col), collapse=", "))
    dots <- setNames(paste0(c("mean","sd"), "(", tx_name(y_var), ")"),
                     c(paste0(tx_name(y_var), "_mean"), paste0(tx_name(y_var), "_sd")))
    message("dots = ", paste0(dots, collapse = ", "))
    message("Gropuing")
    exp_data <- exp_data %>% group_by_(.dots = grouping) %>%
      summarize_(.dots = dots) %>%
      rename_(.dots = setNames(list(paste0(tx_name(y_var), "_mean")), c(tx_name(y_var)))) %>%
      ungroup()
    message("Ungrouped: names = ", paste0(names(exp_data), collapse = ', '))
  }
  exp_data
}

plot_mapping <- function(experiment = experiment_, input = input_) {
  if (input$x_var == "" || input$y_var == "") return(NULL)
  if (nrow(plot_data()) == 0) return(NULL)
  # message("Mapping")
  if (input$group_var %in% expt_group_vars(experiment, input)$name) {
    gv <- tx_name(input$group_var)
    mapping <- aes_string(x = tx_name(input$x_var),
                          y = tx_name(input$y_var),
                          colour = paste0("ordered(", gv,")"))
    legend <- input$group_var
  } else {
    mapping <- aes_string(x = tx_name(input$x_var),
                          y = tx_name(input$y_var))
    legend <- NULL
  }
  labs <- labs(x = input$x_var, y = input$y_var)
  list = list(mapping = mapping, labs = labs, legend = legend)
}

plot_output <- function(experiment = experiment_, input = input_) {
  mapping <- plot_mapping()
  if (is.null(mapping)) return()
  if (nrow(plot_data()) == 0) return()
  # message("Plotting")
  p <- ggplot(plot_data(), mapping$mapping)
  if (input$points) p <- p + geom_point()
  if (input$lines) p <- p + geom_line()
  if (! is.null(mapping$legend)) {
    p <- p + scale_colour_discrete(guide = guide_legend(mapping$legend, reverse = TRUE))
    }

  p <- p + mapping$labs
  p + theme_bw(base_size = 20)
}
