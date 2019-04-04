library(tidyverse)
library(lubridate)
library(DBI)
library(RSQLite)


d0 <- ymd('2018-08-22') # first day of classes

database <- 'EES_3310_5310.sqlite3'

driver <- RSQLite::SQLite()

db <- dbConnect(driver, database, flags = SQLITE_RW)
calendar <- tbl(db, 'calendar')

new_calendar <- calendar %>% collect() %>%
  mutate(date = d0 + days(2 * ((cal_id + 1) %% 2) + 7 * ((cal_id + 1) %/% 2 - 1))) %>%
  mutate(date = as.character(date))

dbWriteTable(con, "calendar", new_calendar, overwrite = TRUE)
