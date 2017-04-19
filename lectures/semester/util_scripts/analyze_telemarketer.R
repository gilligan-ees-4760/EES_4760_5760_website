library(ggplot2)
library(dplyr)
library(purrr)
library(stringr)
library(tidyr)

theme_set(theme_bw(base_size = 20))

read_data <- function(filename) {
  text <- readLines(filename)
  skip_lines <- which(str_detect(text, '^"\\[run number\\]"'))
  if (length(skip_lines) > 0) skip_lines = skip_lines[1] - 1
  d <- read.csv(text = text, header = TRUE, skip = skip_lines) %>%
    rename(run = X.run.number., tick = X.step.)
  num_vars <- d %>% map(is.numeric) %>% keep(~.x) %>% names()
  d <- d %>% select_(.dots = num_vars) %>%
    arrange(run, tick)
  names(d) <- str_replace_all(names(d), '\\.+','.')
  d
}

fix_names <- function(df) {
  df <- df %>% rename(initial.telemarketers = initial.num.marketers,
                      businesses = count.turtles,
                      week = tick)
}

median_ticks <- function(df) {
  # The median number of weeks in business is when half of the telemarketers have
  # failed, so # marketers = initial # / 2. By taking delta = the absolute value of
  # (# marketers - initial # / 2), delta is zero when we're at the median,
  # so I can sort the data by delta and take the minimum value.
  #
  df %>% mutate(delta = abs(businesses - (initial.telemarketers/2))) %>%
    group_by(run, initial.telemarketers) %>%
    top_n(-1, delta) %>%
    group_by(initial.telemarketers) %>%
    summarize(week_sd = sd(week), week = mean(week)) %>%
    ungroup()
}

plot_time_series <- function(df, bands = FALSE) {
  df <- df %>% mutate(initial.telemarketers = ordered(initial.telemarketers)) %>%
    group_by(week, initial.telemarketers) %>%
    summarize(businesses_sd = sd(businesses), businesses = mean(businesses)) %>%
    ungroup()
  p <- df %>% 
    ggplot(aes(x = week, y = businesses, 
               ymax = businesses + businesses_sd,
               ymin = businesses - businesses_sd,
               color = initial.telemarketers,
               fill = initial.telemarketers))
  if (bands)
    p <- p + geom_ribbon(alpha = 0.1)
  p <- p + geom_line(size = 1) +
    scale_color_discrete(name = "Initial telemarketers") +
    scale_fill_discrete(name = "Initial telemarketers") +
    labs(x = "Week", y = "# telemarketers in business") +
    theme(legend.position = c(0.99,0.99), legend.justification = c(1,1))
  p
}

plot_median_weeks <- function(df, max_weeks = 100, bands = FALSE) {
  p <- df %>% median_ticks() %>% 
    ggplot(aes(x = initial.telemarketers, y = week, 
               ymin = week - week_sd, ymax = week + week_sd,
               color = I("dark blue"), fill = I("blue")))
  if (bands)
    p <- p + geom_ribbon(alpha = 0.1)
  p <- p + geom_line(size =1) +
    geom_point(size = 3) +
    scale_y_continuous(limits = c(0,max_weeks), breaks = seq(0, max_weeks, 50),
                       expand = c(0,0)) +
    labs(x = "Initial # telemarketers", y = "Median weeks in business")
  p
}

load_data <- function(data_dir) {
  expt_data <- read_data(file.path(data_dir, 'Telemarketer vary_initial_telemarketers-table.csv')) %>% 
    fix_names()
  merger_data <- read_data(file.path(data_dir, 'Telemarketer_mergers vary_initial_telemarketers-table.csv')) %>% 
    fix_names()
  list(expt_data = expt_data, merger_data = merger_data) %>% invisible()
}

plot_results <- function() {
  expt_data <- read_data(file.path('assets', 'data', 
                                   'Telemarketer vary_initial_telemarketers-table.csv')) %>% 
    fix_names()
  merger_data <- read_data(file.path('assets', 'data', 
                                     'Telemarketer_mergers vary_initial_telemarketers-table.csv')) %>% 
    fix_names()
  
  plot_time_series(expt_data)
  plot_median_weeks(expt_data)
  
  plot_time_series(merger_data)
  plot_median_weeks(merger_data)
}
