library(pacman)
p_load(knitr)
p_load(RSQLite)
p_load(tidyverse, magrittr, lubridate)
p_load(xtable)
p_load(assertthat)
p_load(yaml)
p_load(rprojroot)

root_dir <- find_rstudio_root_file()
planning_dir <- find_rstudio_root_file("planning")

md_extensions <- "+tex_math_single_backslash+compact_definition_lists"

semester_db <- src_sqlite(file.path(planning_dir, 'EES_4760_5760.sqlite3'))
calendar <- semester_db %>% tbl('calendar') %>% select(-cal_id, -week) %>%
  mutate(date = date(date)) %>%
  arrange(date) %>%
  collect() %>%
  mutate(seq = seq(n()))

reading_items <- semester_db %>% tbl("reading_items")
reading_sources <- semester_db %>% tbl("reading_sources")
reading_assignments <- semester_db %>% tbl('reading_assignments') %>%
  left_join(reading_items, by = c("reading_group")) %>%
  left_join(reading_sources, by = "source_id") %>%
  select(reading_id, title, short_title, markdown_title, short_markdown_title, textbook,
         handout, chapter, pages, reading_notes, optional,
         rd_break_before, citation, url) %>%
  collect() %>%
  mutate_at(c("textbook", "handout", "optional", "rd_break_before"), as.logical)

notices <- semester_db %>% tbl('notices') %>% select(topic_id, notice) %>%
  collect()

events <- semester_db %>% tbl('events') %>% collect()

text_codes <- semester_db %>% tbl("text_codes") %>% collect() %>%
  { set_names(.$code_value, .$code_name) }

hw_assignments <- semester_db %>% tbl('homework_assignments') %>% collect()
hw_items <- semester_db %>% tbl('homework_items') %>% collect()
homework_assignments <- hw_assignments %>%
  left_join(hw_items, by = 'hw_group') %>%
  select(homework_id, homework_topic, short_homework, homework, homework_notes,
         hw_graduate_only, hw_undergraduate_only, hw_prologue, hw_epilogue,
         hw_order = hw_item_id) %>%
  collect() %>%
  mutate_at(c("hw_undergraduate_only", "hw_graduate_only", "hw_prologue", "hw_epilogue"), as.logical) %>%
  arrange(homework_id, hw_order)

calendar <- calendar %>%
  left_join(events, by = "event_id") %>%
  left_join(reading_assignments %>%
              select(reading_id, textbook, handout, reading_notes), by = 'reading_id') %>%
  left_join(homework_assignments %>%
              select(homework_id, homework), by = 'homework_id') %>%
  left_join(notices %>% select(topic_id, notice), by = 'topic_id') %>%
  mutate(has_reading = ifelse(is.na(textbook) | is.na(handout), FALSE, textbook | handout),
         has_notice =  ! is.na(notice), has_homework = ! is.na(homework)) %>%
  select(-reading_notes, -textbook, -handout, -notice, -homework) %>%
  {
    .g <- names(.) %>% discard(~str_detect(.x, '^has')) %>% (rlang::syms)
    group_by(., !!! .g)
  } %>%
  summarize_all(funs(any(.))) %>%
  ungroup() %>% distinct() %>%
  mutate(homework_num = ifelse(has_homework, cumsum(has_homework), NA))

calendar <- calendar %>%
  left_join(hw_assignments %>% select(homework_id, homework_topic), by = "homework_id")

spring_break <- calendar %>% filter(event == 'SPRING_BREAK') %>% select(date, topic_id, event_id)

select_class <- function(calendar, class_no) {
  class <- calendar %>% filter(class == class_no) %>% select(class, date, topic) %>%
    mutate(weekday = wday(date, label = TRUE), long.weekday = wday(date, label = TRUE, abbr = FALSE),
           month = month(date, label = TRUE), long.month = month(date, label = TRUE, abbr = FALSE),
           day = day(date))
  as.list(class)
}

first_class <- 1
last_class <- NA

if(is.na(first_class)) first_class <- min(calendar$class, na.rm = T)
if (is.na(last_class)) last_class <- max(calendar$class, na.rm = T)

first_date <- calendar %>% filter(class == first_class) %>% select(date) %>% unlist()
last_date <- calendar %>% filter(class == last_class) %>% select(date) %>% unlist()

year_taught <- year(first_date)

pub_date <- "2018-01-01"

append_newline_if_needed <- function(txt) {
  txt <- str_trim(txt)
  txt[str_detect(txt, '[^\n]$')] <- str_c(txt, '\n')
  txt
}

format_page_range <- function(pages) {
  multiple <- str_detect(pages, "-+|,|;| and ")
  str_c(ifelse(multiple, "pp. ", "p. "), pages)
}

add_period <- function(str) {
  str_trim(str, "right") %>%
    str_replace("([^.?!])$", "\\1.")
}

item_format <- function(str, item_text, pad_len) {
  lines <- str_split(str, "\n") %>% simplify()
  pad_text <- str_dup(" ", str_length(item_text))
  left_pad <- c(item_text, rep(pad_text, length(lines) - 1))
  output <- str_c(str_dup(" ", pad_len), left_pad, " ", lines) %>%
    str_trim("right") %>% str_c(collapse = "\n") %>%
    str_trim("right")
  if (str_detect(output, "\n\n")) {
    output <- str_c(output, "\n")
  }
  output
}

add_level <- function(pad_len = 0, list_type = c("itemize", "enumerate", "definition"), enum_type = "#.") {
  list_type = match.arg(list_type)
  if (list_type == "itemize") {
    pad_len <- pad_len + 2
  } else if (list_type == "enumerate") {
    pad_len <- pad_len + str_length(enum_type) + 1
  } else if (list_type == "definition") {
    pad_len <- pad_len + 4
  } else {
    stop("Illegal list type: ", list_type)
  }
  pad_len
}

itemize <- function(text, pad_len = 0) {
  map_chr(text, ~item_format(.x, "*", pad_len)) %>%
    str_c(collapse = "\n")
}


enumerate <- function(text, pad_len = 0, enum_type = "#.") {
  map_chr(text, ~item_format(.x, enum_type, pad_len)) %>%
    str_c(collapse = "\n")
}

expand_codes <- function(text, delim = c("<%", "%>")) {
  invoke(knit_expand, .x = text_codes, text = text, delim = delim)
}

expand_code <- function(text) {
  str_c("<%", text, "%>") %>% expand_codes()
}

format_textbook_reading_item <- function(reading_item) {
  output <- reading_item$short_markdown_title
  if (! is.na(reading_item$chapter)) {
    output <- str_c(output, ", Ch. ", reading_item$chapter)
  }
  if (! is.na(reading_item$pages)) {
    output <- str_c(output, ", ", format_page_range(reading_item$pages))
  }
  output <- output %>% str_trim() %>% add_period()
  output
}

format_textbook_reading <- function(reading_list) {
  if (nrow(reading_list) > 0) {
    output <- reading_list %>% do(reading = format_textbook_reading_item(.)) %>%
      unlist() %>% unname()
  }  else {
    output <- NULL
  }
  output
}

format_handout_reading_item <- function(reading_item) {
  output <- str_c("Handout: ", reading_item$citation)
  if (! is.na(reading_item$chapter)) {
    output <- str_c(output, ", Ch. ", reading_item$chapter)
  }
  if (! is.na(reading_item$pages)) {
    output <- str_c(output, ", ", format_page_range(reading_item$pages))
  }
  output <- output %>% str_trim() %>%
    str_c(" (posted online)") %>%
    add_period()
  output
}

format_handout_reading <- function(reading_list) {
  if (nrow(reading_list) > 0) {
    output <- reading_list %>% do(reading = format_handout_reading_item(.)) %>%
      unlist() %>% unname()
  } else {
    output <- NULL
  }
  output
}

make_reading_assignment <- function(reading_entry) {
  textbook_reading <- reading_entry %>% filter(textbook & ! optional)
  handout_reading <- reading_entry %>% filter(handout & ! optional)
  optional_textbook_reading <- reading_entry %>% filter(textbook & optional)
  optional_handout_reading <- reading_entry %>% filter(handout & optional)
  reading_notes <- reading_entry %>% filter(!is.na(reading_notes))
  has_req_reading <- (nrow(textbook_reading) + nrow(handout_reading)) > 0
  has_opt_reading <- (nrow(optional_textbook_reading) +
                        nrow(optional_handout_reading)) > 0
  has_notes <- nrow(reading_notes) > 0
  output <- '## Reading:'
  if (! has_req_reading) {
    output <- str_c(str_trim(output), '',
                    'No new reading for today.',
                    '', sep = '\n')
  } else {
    readings <- c(format_textbook_reading(textbook_reading),
                  format_handout_reading(handout_reading)) %>%
      itemize()
    output <- str_c(str_trim(output),
                    '',
                    append_newline_if_needed(readings),
                    '',
                    '', sep = '\n')
  }
  if (has_opt_reading) {
    extra_readings <- c(format_textbook_reading(optional_textbook_reading),
                        format_handout_reading(optional_handout_reading)) %>%
      itemize()
    output <- str_c(str_trim(output),
                    '### Optional Extra Reading:', '',
                    append_newline_if_needed(extra_readings), '',
                    sep = '\n')
  }
  if (has_notes) {
    reading_note_str <- reading_notes$reading_notes %>% str_trim() %>%
      str_c(collapse = "\n\n")
    output <- str_c(str_trim(output), '',
                    ifelse(has_req_reading || has_opt_reading,
                           '### Reading Notes:',
                           '### Notes:'),
                    '', reading_note_str, '',
                    sep = '\n')
  }
  output
}

make_homework_assignment <- function(homework_entries) {
  hw <- homework_entries %>% filter(! is.na(homework) & str_length(homework) > 0)
  hw_a <- hw %>% filter(!hw_prologue, !hw_epilogue)
  grad_hw <- hw_a %>% filter(hw_graduate_only)
  ugrad_hw <- hw_a %>% filter(hw_undergraduate_only)
  everyone_hw <- hw_a %>% filter(!hw_graduate_only & ! hw_undergraduate_only)

  prologue <- hw %>% filter(hw_prologue)
  epilogue <- hw %>% filter(hw_epilogue)

  notes <- homework_entries %>% filter(! is.na(homework_notes))
  main_notes <- notes %>% filter(! (hw_prologue | hw_epilogue))
  grad_notes <- main_notes %>% filter(hw_graduate_only)
  ugrad_notes <- main_notes %>% filter(hw_undergraduate_only)
  everyone_notes <- main_notes %>% filter(!hw_graduate_only & ! hw_undergraduate_only)
  prologue_notes <- notes %>% filter(hw_prologue)
  epilogue_notes <- notes %>% filter(hw_epilogue)

  output <- "## Homework"

  if (nrow(prologue) > 0) {
    prologue_str <- str_c(discard(prologue$homework, ~is.na(.x) | .x == ""), collapse = "\n\n")
  } else {
    prologue_str <- 'Turn in the following homework on Box by 11:59 pm:'
  }

  if (nrow(epilogue) > 0) {
    prologue_str <- str_c(discard(epilogue$homework, ~is.na(.x) | .x == ""), collapse = "\n\n")
  } else {
    epilogue_str <-  NULL
  }

  output <- str_c(output, prologue_str, '', '', sep = '\n')
  if (nrow(ugrad_hw) > 0) {
    ugrad_hw_items <- ugrad_hw$homework %>% itemize() %>%
      str_c("**Undergraduate Students:**", ., sep = "\n")
  } else {
    ugrad_hw_items <- NULL
  }
  if (nrow(grad_hw) > 0) {
    grad_hw_items <- grad_hw$homework %>% itemize() %>%
    str_c("**Graduate Students:**", ., sep = "\n")
  } else {
    grad_hw_items <- NULL
  }
  if (nrow(everyone_hw) > 0) {
    everyone_hw_items <- everyone_hw$homework %>% itemize()
    if (! all(is.null(grad_hw_items), is.null(ugrad_hw_items))) {
      everyone_hw_items <- str_c("**Everyone:**", everyone_hw_items, sep = "\n")
    }
  } else {
    everyone_hw_items <- NULL
  }
  if (all(is.null(grad_hw_items), is.null(ugrad_hw_items))) {
    output <- str_c(str_trim(output), "",
                    everyone_hw_items,
                    "", sep = "\n")
  } else {
    output <- str_c(str_trim(output), "",
                    itemize(c(everyone_hw_items, ugrad_hw_items, grad_hw_items)),
                    "", sep = "\n")
  }

  output <- str_c(str_trim(output), "",
                  epilogue_str, "",
                  sep = "\n"
  )

  everyone_notes <- bind_rows(prologue_notes, everyone_notes, epilogue_notes)

  if (nrow(everyone_notes) > 0) {
    everyone_note_items <- everyone_notes$homework_notes %>%
      str_trim("right") %>% str_c(collapse = "\n\n")
  } else {
    everyone_note_items <- NULL
  }

  if (nrow(ugrad_notes) > 0) {
    ugrad_note_items <- ugrad_notes$homework_notes %>%
      str_trim("right") %>% str_c(collapse = "\n\n")
  } else {
    ugrad_note_items <- NULL
  }

  if (nrow(grad_notes) > 0) {
    grad_note_items <- grad_notes$homework_notes %>%
      str_trim("right") %>% str_c(collapse = "\n\n")
  } else {
    grad_note_items <- NULL
  }

  if (c(everyone_note_items, ugrad_note_items, grad_note_items) %>%
      map_lgl(is.null) %>% all() %>% not()) {
    output <- output %>% str_trim() %>%
      str_c("", '### Notes on Homework:', '', sep = '\n')

    if (c(ugrad_note_items, grad_note_items) %>%
        map_lgl(is.null) %>% all()) {
      output <- str_c(output, everyone_note_items, sep = "\n")
    } else {
      everyone_note_items <- str_c("**Everyone:**", everyone_note_items, collapse = "\n")
      ugrad_note_items <- str_c("**Undergraduates:**", ugrad_note_items, collapse = "\n")
      grad_note_items <- str_c("**Graduate Students:**", grad_note_items, collapse = "\n")
      notes <- c(everyone_note_items, ugrad_note_items, grad_note_items) %>% itemize()
      output <- str_c(output, "",
                      append_newline_if_needed(notes),
                      "", sep = "\n")
    }
  }
  output
}

make_hw_page <- function(cal_entry) {
  hw_date <- cal_entry$date
  homework <- homework_assignments %>% filter(homework_id == cal_entry$homework_id)
  hw_topic <- head(homework$homework_topic, 1)
  hw_num <- cal_entry$homework_num

  delim <- "---"
  header <- tibble(title = hw_topic, due_date = hw_date,
                   assignment_number = hw_num, weight = hw_num,
                   slug = sprintf("homework_%02d", hw_num),
                   pubdate = pub_date, date = hw_date,
                   output = list("blogdown::html_page" = list(md_extensions = md_extensions))
                   ) %>%
    as.yaml() %>% str_trim("right") %>%
    str_c(delim, ., delim, sep = "\n")
  hw_page <- str_c(
    header,
    make_homework_assignment(homework),
    sep = "\n"
  ) %>% expand_codes()

}

make_short_hw_assignment <- function(cal_entry) {
  d <- cal_entry$date
  homework <- homework_assignments %>% filter(homework_id == cal_entry$homework_id) %>%
    arrange(hw_undergraduate_only, hw_graduate_only, homework_id, hw_order)
  homework_topic <- homework %>% filter(! is.na(short_homework)) %>%
    mutate(topic = str_trim(short_homework))
  if (any(homework_topic$hw_undergraduate_only | homework_topic$hw_graduate_only)) {
    homework_topic <- homework_topic %>%
    mutate(topic = str_c(topic, " (",
                         ifelse(hw_undergraduate_only, "undergrads",
                                ifelse(hw_graduate_only, "grad.\ students",
                                       "everyone")),
                         ")"))
  }
  homework_topic <- homework_topic %>%
    select(topic) %>% simplify() %>% unname()
  if (length(homework_topic) > 1) {
    if (length(homework_topic) > 2) {
      homework_topic <- homework_topic %>%
        {
          c( head(., -1) %>% str_c(collapse = ", "), tail(., 1)) %>%
          str_c(collapse = ", and ")
        }
    } else {
      homework_topic <- str_c(homework_topic, collapse = " and ")
    }
  }
  output <- NULL
  if (length(homework_topic > 0)) {
    output <- str_c( "Homework #", cal_entry$homework_num, " is due today: ",
                     add_period(homework_topic),
                     " See the homework assignment sheet for details.") %>%
      str_c( "## Homework", "", .,  '', sep = '\n' )
  }
  output
}

make_reading_page <- function(cal_entry) {
  rd_date <- cal_entry$date
  reading <- reading_assignments %>% filter(reading_id == cal_entry$reading_id)
  rd_topic <- cal_entry$topic
  class_num <- cal_entry$class

  delim <- "---"
  header <- tibble(title = rd_topic, class_date = rd_date,
                   class_number = class_num, weight = class_num,
                   slug = sprintf("reading_%02d", class_num),
                   pubdate = pub_date, date = rd_date,
                   output = list("blogdown::html_page" = list(md_extensions = md_extensions))
  ) %>%
    as.yaml() %>% str_trim("right") %>%
    str_c(delim, ., delim, sep = "\n")
  rd_page <- str_c(
    header,
    make_short_hw_assignment(cal_entry),
    make_reading_assignment(reading),
    sep = "\n"
  ) %>% expand_codes()

}




make_notice <- function(notice_entries) {
  if (length(notice_entries) > 1) {
    output <- str_c('## Notices:', '',
                    str_c('* ', notice_entries$notice,
                          sep = ' ', collapse = '\n'), '', '',
                    sep = '\n')
  } else {
    output <- paste('## Notice:', '',
                    notice_entries$notice, '',
                    sep = '\n')
  }
  output
}

generate_assignments <- function() {
  semester <- calendar %>% select(seq, class, date, topic, homework_num) %>%
    mutate(reading_page = as.character(NA), homework_page = as.character(NA),
           lecture_page = as.character(NA))
  for (i in na.omit(calendar$class)) {
    cal_entry <- calendar %>% filter(class == i)
    cal_entry <<- cal_entry
    if (cal_entry$has_reading) {
      message("Making reading page for class #", cal_entry$class)
      rd_fname <- sprintf("reading_%02d.Rmd", cal_entry$class)
      rd_path <- rd_fname %>% file.path(root_dir, 'content', 'reading', .)
      rd_url <- rd_fname %>% str_replace("\\.Rmd$", "") %>%
        file.path("/reading", .)
      rd_page <- make_reading_page(cal_entry)
      cat(rd_page, file = rd_path)
      semester <- semester %>%
        mutate(reading_page = ifelse(class == cal_entry$class, rd_url, reading_page))
    }
    if (cal_entry$has_homework) {
      message("Making homework page for assignment #", cal_entry$homework_num)
      hw_fname <- sprintf("homework_%02d.Rmd", cal_entry$homework_num)
      hw_path <- hw_fname %>% file.path(root_dir, 'content', 'assignment', .)
      hw_url <- hw_fname %>% str_replace("\\.Rmd$", "")
      hw_page <- make_hw_page(cal_entry)
      cat(hw_page, file = hw_path)
      semester <- semester %>%
        mutate(homework_page = ifelse(homework_num == cal_entry$homework_num,
                                     hw_url, homework_page))
    }
  }
  semester %>%
    select(date, title = topic, reading = reading_page,
           assignment = homework_page, lecture = lecture_page, topic) %>%
    arrange(date) %>%
    rowwise() %>% do(lessons = as.list(.)) %>%
    map(~map(.x, ~discard(.x, is.na))) %>%
    as.yaml() %>% expand_codes() %T>%
    cat(file = file.path(root_dir, "data", "lessons.yml")) -> lesson_plan

  invisible(list(lesson_plan = lesson_plan, semester = semester))
}
