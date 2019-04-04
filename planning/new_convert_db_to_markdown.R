library(tidyverse)
library(RSQLite)
library(lubridate)

sanitize_string <- function(src_str) {
  # message("Sanitizing \"", src_str, "\"")
  brace_commands <- tribble(
    ~target, ~prefix, ~suffix,
    "emph", "_", "_",
    "textbf", "**", "**",
    "url", "<", ">"
  )

  bar_commands <- tribble(
    ~target, ~prefix, ~suffix,
    "lstinline", "`", "`"
  )

  simple_commands <- tribble(
    ~target, ~subst,
    "Archer", "<%ARCHER%>",
    "MedArcher", "<%MEDIUM_ARCHER%>",
    "ShortArcher", "<%SHORT_ARCHER%>",
    "Nordhaus", "<%NORDHAUS%>",
    "MedNordhaus", "<%MEDIUM_NORDHAUS%>",
    "ShortNordhaus", "<%SHORT_NORDHAUS%>",
    "Pielke", "<%PIELKE%>",
    "MedPielke", "<%MEDIUM_PIELKE%>",
    "ShortPielke", "<%SHORT_PIELKE%>",
    "RStudio", "<%RSTUDIO%>"
  )

  unesc_chars <- tribble(
    ~target, ~subst,
    "(\\\\([&%$ ]))", "\\2",
    "~", " ",
    "\\\\/", "",
    "`", "'",
    "``", '"',
    "''", '"'
  )

  patterns <- c(open = "\\{", close = "\\}", bar = "\\|", cmd = "\\\\[a-zA-Z]+",
                nbspace = "~", space = "\\\\ ")

  src_str <- src_str %>%
    str_replace_all(set_names(unesc_chars$subst, unesc_chars$target))

  specials <- str_locate_all(src_str, patterns) %>%
    set_names(names(patterns)) %>% map(as.tibble)

  braces <- bind_rows(
    specials$open  %>% select(index = start) %>% mutate(transition = "open"),
    specials$close %>% select(index = start) %>% mutate(transition = "close")
  ) %>%
    arrange(index) %>%
    mutate(depth = cumsum(transition == "open") -
             cumsum(transition == "close") + (transition == "close")) %>%
    arrange(depth, index)

  if (nrow(braces) > 0) {
    btest <- braces %>%
      mutate(next_trans = lead(transition),
             valid = ifelse(transition == "open", next_trans == "close",
                            transition == "close"))
    btest$valid[nrow(btest)] <- tail(btest$transition,1) == "close"
    btest$valid[1] <- btest$valid[1] && btest$transition[1] == "open"

    if (!all(btest$valid)) {
      stop("ERROR: Unbalanced braces")
    }

    braces <- braces %>%
      mutate(close = lead(index, 1)) %>% filter(transition == "open") %>%
      rename(open = index)

    bars <- specials$bar %>% select(open = start) %>%
      mutate(close = lead(open, 1))
  }


  commands <- specials$cmd %>%
    mutate(cmd = str_sub(src_str, start + 1, end)) %>%
    mutate(arg_start = end + 1L, bar_start = arg_start) %>%
    left_join(select(braces, arg_start = open, arg_stop = close),
              by = "arg_start") %>%
    left_join(select(bars, bar_start = open, bar_stop = close),
              by = "bar_start") %>%
    mutate(has_arg   = ! is.na(arg_stop),
           arg_start = ifelse(has_arg, arg_start, arg_start),
           arg_stop  = ifelse(has_arg, arg_stop, arg_start),
           has_bar   = ! is.na(bar_stop),
           bar_start = ifelse(has_bar, bar_start, NA),
           bar_stop  = ifelse(has_bar, bar_stop, NA)
    ) %>%
    select(cmd, start, end, has_arg, arg_start, arg_stop, has_bar, bar_start,
           bar_stop) %>%
    left_join(bind_rows(brace_commands, bar_commands),
              by = c("cmd" = "target")) %>%
    left_join(simple_commands, by = c("cmd" = "target")) %>%
    filter(cmd %in% c(brace_commands$target, bar_commands$target,
                      simple_commands$target)) %>%
    mutate(prefix = ifelse(is.na(prefix),
                           ifelse(is.na(subst), str_c("\\", cmd), subst),
                           prefix),
           suffix = ifelse(is.na(suffix), "", suffix)
           )

  if (FALSE && nrow(braces) > 0) {
    lists <- specials$cmd %>%
      mutate(cmd = str_sub(src_str, start + 1, end)) %>%
      filter(str_detect(cmd, "begin|end|item"))

    lists <- lists %>%
      left_join(mutate(braces, end = open - 1), by = "end") %>%
      mutate(arg = str_sub(src_str, open + 1, close - 1))

    cmd_stack = character(0)
    depth <- 0
    for (i in seq(nrow(lists))) {
      lcmd <- lists$cmd[i]
      larg <- lists$arg[i]
      if (lcmd == "begin") {
        depth <- depth + 1
        cmd_stack <- c(cmd_stack, larg)
        message("line ", i, ": cmd = ", lcmd, ", depth = ", depth,
                ", arg = ", larg,
                ", cmd_stack = (", str_c(cmd_stack, collapse = ", "), ")")
      } else if (lcmd == "end") {
        depth <- depth - 1
        cmd_stack <- head(cmd_stack, -1)
        message("line ", i, ": cmd = ", lcmd, ", depth = ", depth,
                ", arg = ", larg,
                ", cmd_stack = (", str_c(cmd_stack, collapse = ", "), ")")
      } else {
        lists$depth[i] <- depth
        if (is.na(lists$arg[i]))
          lists$arg[i] <- tail(cmd_stack, 1)
      }
    }

    lists <- lists %>% filter(cmd == "item")

    lists <- lists %>%
      mutate(has_arg = FALSE, arg_start = NA, arg_stop = NA, has_bar = FALSE,
             bar_start = NA, bar_stop = NA,
             prefix = str_c(str_dup(" ", (depth - 1) * 4),
                            ifelse(arg == "itemize", "*", "1.")),
             suffix = "", subst = prefix) %>%
      select(one_of(names(commands)))

    # commands <- commands %>% bind_rows(lists) %>% arrange(start)
  }

  output <- ""
  pointer <- 1
  while(nrow(commands) > 0) {
    cmd <- head(commands, 1)
    old_pointer <- pointer
    # message("output = \"", output, "\"")
    # message("cmd = ", cmd$cmd, ", pointer = ", pointer)
    if (cmd$start > pointer) {
      output <- str_c(output, str_sub(src_str, pointer, cmd$start - 1))
    }
    if (cmd$cmd %in% brace_commands$target) {
      if (cmd$has_arg) {
        if (cmd$arg_stop > cmd$arg_start + 1) {
          arg <- str_sub(src_str, cmd$arg_start + 1, cmd$arg_stop - 1) %>%
            str_trim() %>% sanitize_string() %>%
            str_c(cmd$prefix, ., cmd$suffix)
        } else {
          arg <- ""
        }
        pointer <- cmd$arg_stop + 1
      } else {
        arg <- ""
        pointer <- cmd$arg_start
      }
    } else if (cmd$cmd %in% bar_commands$target) {
      if (cmd$bar_stop > cmd$bar_start + 1) {
        arg <- str_sub(src_str, cmd$bar_start + 1, cmd$bar_stop - 1) %>%
          str_trim() %>% str_c(cmd$prefix, ., cmd$suffix)
      } else {
        arg <- ""
      }
      pointer <- cmd$bar_stop + 1
    } else {
      if (is.na(cmd$subst)) {
        arg <- str_c("\\", cmd$cmd)
      } else {
        arg <- cmd$subst
      }
      if (cmd$has_arg) {
        if (cmd$arg_stop > cmd$arg_start + 1) {
          arg <- str_sub(src_str, cmd$arg_start + 1, cmd$arg_stop - 1) %>%
            str_trim() %>% sanitize_string() %>%
            str_c(arg, ., sep = " ") %>% str_trim()
        }
        pointer <- cmd$arg_stop + 1
      } else {
        pointer <- cmd$arg_start
      }
    }
    output <- str_c(output, arg)
    # message("Finishing loop: output = \"", output, "\", pointer = ", pointer)
    commands <- commands %>% filter(start >= pointer)
    stopifnot(pointer > old_pointer)
  }
  output <- str_c(output, str_sub(src_str, pointer))
  output
}

convert_item <- function(item) {
  output <- item
  if (! is.na(item) && str_length(item) > 0) {
    output <- sanitize_string(item)
  }
  output
}

convert_vector <- function(x) {
  map_chr(x, convert_item)
}

convert_database <- function(src, dest) {
  driver <- SQLite()

  src_db <- dbConnect(driver, src)
  dest_db <- dbConnect(driver, dest)
  sqliteCopyDatabase(src_db, dest_db)
  dbDisconnect(src_db)
  dbDisconnect(dest_db)

  db <- dbConnect(driver, dest, flags = SQLITE_RW)
  calendar <- db %>% tbl("calendar") %>% collect() %>%
    mutate_at(c("topic"), convert_vector)

  copy_to(db, calendar, name = "calendar", overwrite = TRUE, temporary = FALSE)

  hw_items <- db %>% tbl("homework_items") %>% collect() %>%
    mutate_at(c("short_homework", "homework", "homework_notes"), convert_vector)

  copy_to(db, hw_items, name = "homework_items", overwrite = TRUE,
          temporary = FALSE)

  reading_items <- db %>% tbl("reading_items") %>% collect() %>%
    mutate_at(c("reading_notes"), convert_vector)

  copy_to(db, reading_items, name = "reading_items", overwrite = TRUE,
          temporary = FALSE)

  reading_sources <- db %>% tbl("reading_sources") %>% collect() %>%
    mutate_at(c("title", "short_title", "latex_title", "short_latex_title",
                "citation"), convert_vector)

  copy_to(db, reading_sources, name = "reading_sources", overwrite = TRUE,
          temporary = FALSE)

  dbDisconnect(db)
}
