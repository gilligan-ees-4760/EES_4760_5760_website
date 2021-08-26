library(tidyverse)
library(lubridate)
library(DBI)


d0 <- ymd('2018-08-22') # first day of classes

src <- src_sqlite('EES_3310_5310_Class_Schedule.sqlite3')
calendar <- tbl(src, 'calendar')

new_calendar <- calendar %>% collect() %>% 
  mutate(date = d0 + - 2 + days(2 * (cal_id %% 3) + 7 * (cal_id %/% 3))) %>% 
  mutate(date = as.character(date))

con <- dbConnect(RSQLite::SQLite(), "EES_3310_5310_Class_Schedule.sqlite3")
dbWriteTable(con, "calendar", new_calendar, overwrite = TRUE)
