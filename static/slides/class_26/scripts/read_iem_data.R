library(tidyverse)
library(stringr)
library(rvest)
library(lubridate)

make_url <- function(month, year) {
  str_c('https://iemweb.biz.uiowa.edu/pricehistory/PriceHistory_GetData.cfm?Market_ID=361&Month=',
        formatC(month, flag = '0', width = 2, format = 'd'), '&Year=', year)
}

clean_df <- function(df) {
  df <- x %>% mutate(Date = mdy(Date),
                     Contract = Contract %>% str_trim() %>%
                       ordered(levels = c('UDEM16_VS', 'UREP16_VS'),
                               labels = c('Democrat', 'Republican'))) %>%
    dplyr::filter(! is.na(AvgPrice)) %>% select(Date, Contract, AvgPrice) %>%
    spread(key = Contract, value = AvgPrice) %>%
    mutate(Total = Democrat + Republican, Democrat = Democrat / Total, Republican = Republican / Total) %>%
    dplyr::filter(! is.na(Total)) %>% select(-Total) %>%
    gather(key = Contract, value = VoteShare, -Date) %>%
    mutate(Contract = ordered(Contract, levels = c('Democrat', 'Republican')))

  invisible(df)
}

get_iem_data <- function(start = as.Date('2015-10-01'), end = as.Date('2016-11-08')) {
  pd = interval(start = start, end = end) %>% as.period(unit = 'months')
  df <- tibble()
  for (m in seq(0, month(pd))) {
    dt <- start %m+% months(m)
    yr <- year(dt)
    mon <- month(dt)
    url <- make_url(mon, yr)
    message("reading ", mon, ":", yr, " from ", url)
    html <- read_html(url)
    df_mon <- html %>% html_nodes('table') %>% html_table(header = T, trim = TRUE)
    if (is.list(df_mon)) df_mon <- df_mon[[1]]
    names(df_mon) <- names(df_mon) %>% str_replace_all('[^[:alpha:]]+', '')
    if (is.character(df_mon$Units))
      df_mon <- df_mon %>% mutate(Units = Units %>% str_replace_all(',','') %>% as.integer())
    df <- df %>% bind_rows(df_mon)
  }
  df <- clean_df(df)
  invisible(df)
}

final_clinton <- 60966953
final_trump <- 60328203
final_vs <- final_clinton / (final_clinton + final_trump)


plot_iem <- function(df) {
  final_clinton <- 60966953
  final_trump <- 60328203
  final_vs <- tibble(Contract = 'Result', VoteShare = final_clinton / (final_clinton + final_trump))

  df %>% dplyr::filter(! is.na(VoteShare) & Date <= as.Date('2016-11-07')) %>%
    mutate(Contract = ordered(Contract, levels = c('Democrat', 'Republican', 'Result'))) %>%
    ggplot(aes(x = Date, y = 100 * VoteShare, color = Contract)) +
    geom_step(size=1) +
    geom_hline(data = final_vs, aes(yintercept = 100 * VoteShare, color = Contract), size = 1) +
    scale_color_manual(values = c(Democrat = 'darkblue', Republican = 'darkred', Result = 'darkgreen'),
                       name = "Vote Share", drop = F) +
    labs(x = 'Date', y = 'Vote Share (%)') +  theme_bw()
}
