library(tidyverse)
library(lubridate)
library(DBI)


d0 <- ymd('2018-01-09') # first day of classes

src <- src_sqlite('EES_4760_5760.sqlite3')
calendar <- tbl(src, 'calendar')

new_calendar <- calendar %>% collect() %>%
  mutate(date = d0 + days(2 * ((cal_id + 1) %% 2) + 7 * ((cal_id + 1) %/% 2 - 1))) %>%
  mutate(date = as.character(date))

con <- dbConnect(RSQLite::SQLite(), "EES_4760_5760.sqlite3")
dbWriteTable(con, "calendar", new_calendar, overwrite = TRUE)
