library(pacman)
p_load(knitr)
p_load(RSQLite)
p_load(tidyverse, magrittr, lubridate, rlang)
p_load(xtable)
p_load(assertthat)
p_load(yaml)
p_load(here)
p_load(blogdown)
p_load(blogdownDigest)

database <- "EES_4760_5760.sqlite3"
online_location <- "posted on Brightspace"

root_dir <- here::here()
planning_dir <- here::here("planning")
slide_dir <- here::here("static", "Slides")

md_extensions <- "+tex_math_single_backslash+compact_definition_lists"

any_true_vec <- function(vec) {
  any(map_lgl(vec, isTRUE))
}

check_for_reading_asgt <- function(reading_df) {
  reading_df %>% filter(!is.na(reading_id)) %>% group_by(reading_id) %>%
    summarize(textbook = any_true_vec(textbook),
              handout = any_true_vec(handout),
              prologue = any_true_vec(rd_prologue),
              epilogue = any_true_vec(rd_epilogue),
              url = any_true_vec(str_length(url) > 0)
    ) %>% ungroup() %>%
    transmute(reading_id, has_reading = textbook | handout | prologue |
                epilogue | url)
}

check_for_hw_asgt <- function(homework_df) {
  homework_df %>% filter(! is.na(homework_id)) %>% group_by(homework_id) %>%
    summarize(has_hw = any_true_vec(str_length(homework) > 0) |
                any_true_vec(str_length(homework_notes) > 0),
              has_numbered_hw = has_hw && any_true_vec(hw_is_numbered)) %>%
    ungroup()
}

check_for_lab_asgt <- function(lab_df) {
  homework_df %>% filter(! is.na(lab_id)) %>% group_by(lab_id) %>%
    summarize(has_lab = any_true_vec(str_length(lab_group) > 0)) %>%
    ungroup()
}

check_for_notices <- function(notice_df) {
  notice_df %>% filter(!is.na(topic_id)) %>% group_by(topic_id) %>%
  summarize(has_notice = any_true_vec(str_length(notice) > 0)) %>%
    ungroup()
}

load_semester_db <- function() {
  semester_db <- src_sqlite(file.path(planning_dir, database))

  reading_items <- semester_db %>% tbl("reading_items")
  reading_sources <- semester_db %>% tbl("reading_sources")
  reading_assignments <- semester_db %>% tbl("reading_assignments") %>%
    left_join(reading_items, by = c("rd_group")) %>%
    left_join(reading_sources, by = "source_id") %>%
    select(rd_item_id, reading_id, title, short_title,
           markdown_title, short_markdown_title,
           textbook, handout, chapter, pages, reading_notes,
           rd_undergraduate_only = undergraduate_only,
           rd_graduate_only = graduate_only,
           rd_optional = optional,
           rd_prologue, rd_epilogue, rd_break_before, citation, url) %>%
    collect() %>%
    mutate_at(c("textbook", "handout",
                "rd_undergraduate_only", "rd_graduate_only", "rd_optional",
                "rd_prologue", "rd_epilogue", "rd_break_before"),
              ~ifelse(is.na(.), FALSE, as.logical(.))) %>%
    arrange(reading_id, desc(rd_prologue), rd_epilogue, rd_optional,
            rd_undergraduate_only, rd_graduate_only, rd_item_id)

  notices <- semester_db %>% tbl("notices") %>% select(topic_id, notice) %>%
    collect()

  events <- semester_db %>% tbl("events") %>% collect()

  text_codes <- semester_db %>% tbl("text_codes") %>% collect() %>%
    { set_names(.$code_value, .$code_name) }

  has_lab_assignments <- FALSE

  if (dbExistsTable(semester_db$con, "lab_assignments")) {
    has_lab_assignments <- TRUE
    lab_asg <- semester_db %>% tbl("lab_assignments") %>% collect()
    lab_groups <- semester_db %>% tbl("lab_groups") %>% collect()
    lab_docs <- semester_db %>% tbl("lab_items") %>% collect()
    lab_solutions <- semester_db %>% tbl("lab_solutions") %>% collect()

    lab_assignments <- lab_asg %>%
      left_join(lab_groups, by = "lab_group") %>%
      select(lab_id, lab_group,
             lab_title, lab_description, lab_assignment_url,
             lab_due_date = report_due_date, lab_present_date = presentation_date
      )
  } else {
    lab_assignments <- tibble(
      lab_id = character(0), lab_group = character(0), lab_title = character(0),
      lab_description = character(0), lab_due_date = character(0),
      lab_present_date = character(0)
    )
    lab_docs <- tibble(
      lab_item_id = integer(0), lab_group = character(0),
      lab_document_title = character(0), doc_author = character(0),
      doc_filename = character(0), lab_document_pdf_url = character(0),
      bibliography = character(0), lab_document_markdown = character(0)
    )
    lab_solutions <- tibble(
      lab_sol_id = integer(0), lab_group = character(0),
      lab_sol_pub_date = character(0), lab_sol_title = character(0),
      lab_sol_author = character(0), lab_sol_filename = character(0),
      lab_sol_pdf_url = character(0), lab_sol_markdown = character(0)
    )
  }

  has_hw_assignments <- FALSE

  if (dbExistsTable(semester_db$con, "homework_assignments")) {
    has_hw_assignments <- TRUE
    hw_assignments <- semester_db %>% tbl("homework_assignments") %>% collect()
    hw_groups <- semester_db %>% tbl("homework_groups") %>% collect() %>%
      select(-homework_order)
    hw_topics <- semester_db %>% tbl("homework_topics") %>% collect()
    hw_items <- semester_db %>% tbl("homework_items") %>% collect()
    homework_solutions <- semester_db %>% tbl("homework_solutions") %>%
      collect()
  }

  calendar <- semester_db %>% tbl("calendar") %>% select(-cal_id, -week) %>%
    mutate(date = date(date)) %>%
    arrange(date) %>%
    collect() %>%
    mutate(seq = seq(n()))

  if (has_hw_assignments) {
    homework_assignments <- hw_assignments %>%
      left_join(hw_groups, by = "hw_group") %>%
      left_join(hw_topics, by = "homework_id") %>%
      left_join(hw_items, by = "hw_group") %>%
      select(homework_id, hw_group, hw_due_date, hw_topic = homework_topic,
             short_homework, homework, homework_notes,
             hw_graduate_only = graduate_only,
             hw_undergraduate_only = undergraduate_only,
             hw_prologue, hw_epilogue, hw_break_before,
             hw_is_numbered, hw_order = hw_item_id) %>%
      collect() %>%
      mutate_at(c("hw_undergraduate_only", "hw_graduate_only",
                  "hw_prologue", "hw_epilogue", "hw_break_before",
                  "hw_is_numbered"), as.logical) %>%
      filter(homework_id %in% calendar$homework_id) %>%
      left_join(select(calendar, date, homework_id), by = "homework_id") %>%
      mutate(hw_due_date = ifelse(is.na(hw_due_date), date, hw_due_date) %>% date()) %>%
      arrange(date, hw_order) %>%
      select(-date)

    hw_assignment_numbering <- homework_assignments %>%
      filter(hw_is_numbered) %>% select(homework_id) %>%
      distinct() %>% mutate(hw_num = seq_along(homework_id))

    homework_assignments <- homework_assignments %>%
      left_join(hw_assignment_numbering, by = "homework_id")
  } else {
    homework_assignments <- tibble(
      homework_id = character(0), hw_group = character(0),
      hw_due_date = date(character(0)), hw_topic = character(0),
      short_homework = character(0), homework = character(0),
      homework_notes = character(0),
      hw_graduate_only = logical(0), hw_undergraduate_only = logical(0),
      hw_prologue = logical(0), hw_epilogue = logical(0),
      hw_break_before = logical(0), hw_is_numbered = logical(0),
      hw_order = integer(0), hw_num = integer(0)
    )
  }

  if (has_lab_assignments) {
    lab_assignments <- lab_assignments %>%
      inner_join(calendar %>% select(lab_id, lab_date = date, seq), by = "lab_id") %>%
      arrange(seq) %>% mutate(lab_num = seq_along(lab_id)) %>% select(-seq)
  } else {
    lab_assignments <- lab_assignments %>%
      mutate(lab_id = character(0), lab_date = character(0), lab_num = integer(0))
  }

  calendar <- calendar %>%
    left_join(events, by = "event_id") %>%
    left_join(check_for_reading_asgt(reading_assignments), by = "reading_id") %>%
    mutate(has_reading = map_lgl(has_reading, isTRUE))

  if (has_lab_assignments) {
    calendar <- calendar %>%
      left_join(check_for_lab_asgt(lab_assignments), by = "lab_id") %>%
      mutate(has_lab = map_lgl(has_lab, isTRUE))
  } else {
    calendar <- calendar %>%
      mutate(has_lab = FALSE)
  }

  if (TRUE || has_hw_assignments) {
    calendar <- calendar %>%
      left_join(check_for_hw_asgt(homework_assignments), by = "homework_id") %>%
      mutate(has_hw = map_lgl(has_hw, isTRUE),
             has_numbered_hw = map_lgl(has_numbered_hw, isTRUE))
  } else {
    calendar <- calendar %>%
      mutate(has_hw = FALSE, has_numbered_hw = FALSE)
  }

  calendar <- calendar %>%
    left_join(check_for_notices(notices), by = "topic_id") %>%
    mutate(homework_index = ifelse(has_hw, cumsum(has_hw), NA_integer_),
           homework_num = ifelse(has_hw, cumsum(has_numbered_hw), NA_integer_))

  spring_break <- calendar %>% filter(event_id == "SPRING_BREAK") %>%
    select(date, topic_id, event_id)

  fall_break <- calendar %>% filter(event_id == "FALL_BREAK") %>%
    select(date, topic_id, event_id)

  thanksgiving_break <- calendar %>% filter(event_id == "THANKSGIVING_BREAK") %>%
    select(date, topic_id, event_id)

  select_class <- function(calendar, class_no) {
    class <- calendar %>% filter(class == class_no) %>%
      select(class, date, topic) %>%
      mutate(weekday = wday(date, label = TRUE),
             long.weekday = wday(date, label = TRUE, abbr = FALSE),
             month = month(date, label = TRUE),
             long.month = month(date, label = TRUE, abbr = FALSE),
             day = day(date))
    as.list(class)
  }

  first_class <- 1
  last_class <- NA

  if(is.na(first_class)) first_class <- min(calendar$class, na.rm = T)
  if (is.na(last_class)) last_class <- max(calendar$class, na.rm = T)

  first_date <- calendar %>%
    filter(class == first_class) %>% select(date) %>% unlist()
  last_date <- calendar %>%
    filter(class == last_class) %>% select(date) %>% unlist()

  year_taught <- year(first_date)

  # Pub date should be last day of previous month.
  pub_date <- first_date %>% as_date() %>% rollback() %>% as.character()
  if (today() < pub_date) pub_date <- today()

  globals <- c("calendar", "reading_assignments",
               "homework_assignments", "homework_solutions",
               "lab_assignments","lab_docs", "lab_solutions",
               "text_codes",
               "first_class", "last_class", "first_date", "last_date",
               "year_taught", "pub_date",
               "has_hw_assignments", "has_lab_assignments")
  for (g in globals) {
    assign(g, get(g), envir = globalenv())
  }
}

select_class <- function(calendar, class_no) {
  class <- calendar %>% filter(class == class_no) %>% select(class, date, topic) %>%
    mutate(weekday = wday(date, label = TRUE), long.weekday = wday(date, label = TRUE, abbr = FALSE),
           month = month(date, label = TRUE), long.month = month(date, label = TRUE, abbr = FALSE),
           day = day(date))
  as.list(class)
}

append_newline_if_needed <- function(txt) {
  txt <- str_trim(txt)
  txt[str_detect(txt, '[^\n]$')] <- str_c(txt, '\n')
  txt
}

escape_dollar <- function(txt) {
  txt %>% str_replace_all(c("([^\\\\])\\\\\\$" = "\\1\\\\\\\\$",
                            "^\\\\\\$" = "\\\\\\\\$"))
}

format_month <- function(d, abbr = TRUE) {
  m <- month(d, label = TRUE, abbr = abbr)
  if (abbr) m <- paste0(m, '.')
  m
}

format_wday <- function(d, abbr = TRUE) {
  wd <- wday(d, label = TRUE, abbr = abbr)
  if (abbr) wd <- paste0(wd, '.')
  wd
}

format_class_date <- function(d, abbr = TRUE) {
  paste0(format_month(d, abbr = abbr), " ", day(d))
}

format_class_day_date <- function(d, abbr_month = TRUE, abbr_wday = TRUE) {
  paste0(format_wday(d, abbr_wday), ", ",
         format_month(d, abbr_month), " ", day(d))
}

format_date_range_by_class_no <- function(calendar, classes, abbr = TRUE) {
  dates <- calendar %>% filter(class %in% na.omit(classes)) %>%
    summarize(start = min(date, na.rm = T), stop = max(date, na.rm = T))
  with(dates, paste0(format_class_date(start, abbr), '--',
                     ifelse(month(stop) == month(start), day(stop),
                            format_class_date(stop, abbr))))
}

format_date_range_by_topic_id <- function(calendar, topics, abbr = TRUE) {
  dates <- calendar %>% filter(topic_id %in% topics) %>%
    summarize(start = min(date, na.rm = T), stop = max(date, na.rm = T))
  with(dates, paste0(format_class_date(start, abbr), '--',
                     ifelse(month(stop) == month(start), day(stop),
                            format_class_date(stop, abbr))))
}

format_date_range_by_event_id <- function(calendar, event_ids, abbr = TRUE) {
  dates <- calendar %>% filter(event_id %in% event_ids) %>%
    select(date) %>% summarize(start = min(date, na.rm = T), stop = max(date, na.rm = T))
  with(dates, {
    output <- format_class_date(start, abbr)
    if (start != stop) {
      output <- paste0(output, '--',
                       ifelse(month(stop) == month(start), day(stop),
                              format_class_date(stop, abbr)))
    }
    output})
}

format_day_date_range_by_event_id <- function(calendar, event_ids, abbr_month = TRUE, abbr_wday = TRUE) {
  dates <- calendar %>% filter(event_id %in% event_ids) %>%
    select(date) %>% summarize(start = min(date, na.rm = T), stop = max(date, na.rm = T))
  with(dates, {
    output <- format_class_day_date(start, abbr_month, abbr_wday)
    if (start != stop) {
      output <- paste0(output, '--',
                       format_class_day_date(stop, abbr_wday))
    }
    output})
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

add_level <- function(pad_len = 0,
                      list_type = c("itemize", "enumerate", "definition"),
                      enum_type = "#.") {
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
  rlang::exec(knit_expand, !!!text_codes, text = text, delim = delim)
}

expand_code <- function(text) {
  str_c("<%", text, "%>") %>% expand_codes()
}

format_textbook_reading_item <- function(reading_item) {
  output <- reading_item$markdown_title
  if (! is.na(reading_item$chapter)) {
    output <- str_c(output, ", ", reading_item$chapter)
  }
  if (! is.na(reading_item$pages)) {
    output <- str_c(output, ", ", reading_item$pages)
  }
  output <- output %>% str_trim() %>% add_period()
  output
}

format_textbook_reading <- function(reading_list) {
  # g_reading_list <<- reading_list
  # Nice trick for row-wise function calls thanks to
  # Jenny Bryan.
  # See https://speakerdeck.com/jennybc/row-oriented-workflows-in-r-with-the-tidyverse?slide=40
  if (nrow(reading_list) > 0) {
    output <- reading_list %>%
      purrr::transpose(.) %>%
      map_chr(format_textbook_reading_item)
  }  else {
    output <- NULL
  }
  output
}

format_handout_reading_item <- function(reading_item) {
  if(is.null(reading_item$url) || is.na(reading_item$url)) {
    pre = ""
    post = ""
    loc = str_c(" (", online_location, ")")
  } else {
    pre = "["
    post = str_c("](", reading_item$url, '){target="_blank"}')
    loc = ""
  }
  output <- str_c("Handout: ", pre, reading_item$citation, post)
  if (! is.na(reading_item$chapter)) {
    output <- str_c(output, ", ", reading_item$chapter)
  }
  if (! is.na(reading_item$pages)) {
    output <- str_c(output, ", ", reading_item$pages)
  }
  output <- output %>% str_trim() %>%
    str_c(loc) %>%
    add_period()
  output
}

format_handout_reading <- function(reading_list) {
  if (nrow(reading_list) > 0) {
    output <- reading_list %>% purrr::transpose() %>%
      map_chr(format_handout_reading_item)
  } else {
    output <- NULL
  }
  output
}

make_reading_assignment <- function(reading_entry) {
  textbook_reading <- reading_entry %>%
    filter(textbook &
             ! (rd_optional | rd_undergraduate_only | rd_graduate_only ))
  handout_reading <- reading_entry %>%
    filter(handout &
             ! (rd_optional | rd_undergraduate_only | rd_graduate_only ))
  ugrad_textbook_reading <- reading_entry %>%
    filter(textbook & rd_undergraduate_only )
  ugrad_handout_reading <- reading_entry %>%
    filter(handout & rd_undergraduate_only )
  grad_textbook_reading <- reading_entry %>%
    filter(textbook & rd_graduate_only )
  grad_handout_reading <- reading_entry %>%
    filter(handout & rd_graduate_only )
  optional_textbook_reading <- reading_entry %>% filter(textbook & rd_optional)
  optional_handout_reading <- reading_entry %>% filter(handout & rd_optional)

  reading_notes <- reading_entry %>% filter(!is.na(reading_notes))

  has_req_reading <- (nrow(textbook_reading) + nrow(handout_reading)) > 0
  has_ugrad_reading <- (nrow(ugrad_textbook_reading) +
                          nrow(ugrad_handout_reading)) > 0
  has_grad_reading <- (nrow(grad_textbook_reading) +
                         nrow(grad_handout_reading)) > 0
  has_opt_reading <- (nrow(optional_textbook_reading) +
                        nrow(optional_handout_reading)) > 0
  has_any_reading <- has_req_reading || has_ugrad_reading ||
    has_grad_reading || has_opt_reading

  has_notes <- nrow(reading_notes) > 0

  output <- "## Reading:"
  if (! has_any_reading) {
    output <- str_c(str_trim(output), "",
                    "No new reading for today.",
                    "", sep = "\n")
  } else {
    if (has_req_reading) {
      readings <- c(format_textbook_reading(textbook_reading),
                    format_handout_reading(handout_reading)) %>%
        itemize()
      output <- str_c(str_trim(output),
                      "",
                      "### Required Reading (everyone):",
                      append_newline_if_needed(readings),
                      "",
                      "", sep = "\n")
    }
    if (has_ugrad_reading) {
      ug_readings <- c(format_textbook_reading(ugrad_textbook_reading),
                    format_handout_reading(ugrad_handout_reading)) %>%
        itemize()
      output <- str_c(str_trim(output),
                      "",
                      "### Required for Undergrads (optional for grad students):",
                      append_newline_if_needed(ug_readings),
                      "",
                      "", sep = "\n")
    }
    if (has_grad_reading) {
      g_readings <- c(format_textbook_reading(grad_textbook_reading),
                    format_handout_reading(grad_handout_reading)) %>%
        itemize()
      output <- str_c(str_trim(output),
                      "",
                      "### Required for Grad Students (optional for undergrads):",
                      append_newline_if_needed(g_readings),
                      "",
                      "", sep = "\n")
    }
    if (has_opt_reading) {
      extra_readings <- c(format_textbook_reading(optional_textbook_reading),
                          format_handout_reading(optional_handout_reading)) %>%
        itemize()
      output <- str_c(str_trim(output), "",
                      "### Optional Extra Reading:", "",
                      append_newline_if_needed(extra_readings), "",
                      sep = "\n")
    }
  }
  if (has_notes) {
    reading_note_str <- reading_notes$reading_notes %>% str_trim() %>%
      str_c(collapse = "\n\n")
    output <- str_c(str_trim(output), "",
                    ifelse(has_req_reading || has_opt_reading,
                           "### Reading Notes:",
                           "### Notes:"),
                    "", reading_note_str, "",
                    sep = "\n")
  }
  output
}

make_hw_solution_page <- function(solution, assignment) {
  # g_doc <<- solution
  # g_asg <<- assignment

  message("Generating markdown for solutions to homework #", assignment$hw_num)

  delim <- "---"
  header <- list(
    title = solution$hw_sol_title,
    hw_number = assignment$hw_num,
    pubdate = as.character(solution$hw_sol_pub_date),
    date = assignment$hw_due_date,
    pdf_url = solution$hw_sol_pdf_url,
    slug = sprintf("homework_%02d_%s", assignment$hw_num, solution$hw_sol_filename)) %>%
    discard(is.na) %>%
    c(
      output = list("blogdown::html_page" =
                      list(md_extensions = md_extensions,
                           toc = TRUE))
    ) %>%
    as.yaml() %>% str_trim("right") %>%
    str_c(delim, ., delim, sep = "\n")
  hw_solution_page <- str_c(
    header,
    solution$hw_sol_markdown,
    sep = "\n"
  ) %>% expand_codes()
  hw_solution_page
}

make_hw_solution <- function(solution, assignment) {
  fname <- sprintf("homework_%02d_%s.Rmd", assignment$hw_num,
                   solution$hw_sol_filename)
  solution_path <- fname %>%
    file.path(root_dir, "content", "homework_solutions/", .)
  solution_url <- fname %>% str_replace("\\.Rmd$", "") %>%
    file.path("/homework_solutions", .)
  message("Making solutions file for homework #", assignment$hw_num, ": ",
          solution_path)
  hw_solution_page <- make_hw_solution_page(solution, assignment)
  cat(hw_solution_page, file = solution_path)
  c(path = solution_path, url = solution_url)
}

make_hw_page <- function(cal_entry) {
  hw_date <- cal_entry$date
  this_assignment <- homework_assignments %>%
    filter(homework_id == cal_entry$homework_id)
  hw_topic <- head(this_assignment$hw_topic, 1)
  hw_num <- cal_entry$homework_num

  message("Making homework page for HW #", hw_num)

  delim <- "---"
  header <- tibble(title = hw_topic, due_date = hw_date,
                   assignment_number = hw_num, weight = hw_num,
                   slug = sprintf("homework_%02d", hw_num),
                   pubdate = pub_date, date = hw_date,
                   output = list("blogdown::html_page" =
                                   list(md_extensions = md_extensions))
                   ) %>%
    as.yaml() %>% str_trim("right") %>%
    str_c(delim, ., delim, sep = "\n")
  hw_page <- str_c(
    header,
    make_homework_assignment(this_assignment, homework_solutions),
    sep = "\n"
  ) %>% expand_codes()
}

make_homework_assignment <- function(this_assignment,
                                     homework_solutions = NULL) {
  if (! is.null(homework_solutions)) {
  solutions <- homework_solutions %>%
    filter(as_datetime(hw_sol_pub_date) <= now())
  } else {
    solutions <- NULL
  }
  hw <- this_assignment %>%
    filter(! is.na(homework) & str_length(homework) > 0)
  hw_a <- hw %>% filter(!hw_prologue, !hw_epilogue)
  grad_hw <- hw_a %>% filter(hw_graduate_only)
  ugrad_hw <- hw_a %>% filter(hw_undergraduate_only)
  everyone_hw <- hw_a %>% filter(!hw_graduate_only & ! hw_undergraduate_only)

  prologue <- hw %>% filter(hw_prologue)
  epilogue <- hw %>% filter(hw_epilogue)

  notes <- this_assignment %>% filter(! is.na(homework_notes))
  main_notes <- notes %>% filter(! (hw_prologue | hw_epilogue))
  grad_notes <- main_notes %>% filter(hw_graduate_only)
  ugrad_notes <- main_notes %>% filter(hw_undergraduate_only)
  everyone_notes <- main_notes %>%
    filter(!hw_graduate_only & ! hw_undergraduate_only)
  prologue_notes <- notes %>% filter(hw_prologue)
  epilogue_notes <- notes %>% filter(hw_epilogue)

  output <- ""

  if (! is.null(solutions) && nrow(solutions) >= 1) {
    message("Making homework solutions")
    output <- output %>% str_c("## Solutions:\n\n")
    for (i in seq(nrow(solutions))) {
      this_sol <- solutions[i,]
      this_sol <- solutions[i,]
      sol <- make_hw_solution(this_sol, this_assignment)
      output <- output %>% str_c("* [", this_sol$hw_sol_title, "](", sol['url'], ")\n")
    }
    output <- str_c(output, "\n")
  }

  output <- str_c(output, "## Homework")
  if (nrow(prologue) > 0) {
    prologue_str <- str_c(discard(prologue$homework, ~is.na(.x) | .x == ""),
                          collapse = "\n\n")
  } else {
    prologue_str <- NULL
  }

  if (nrow(epilogue) > 0) {
    epiloque_str <- str_c(discard(epilogue$homework, ~is.na(.x) | .x == ""), collapse = "\n\n")
  } else {
    epilogue_str <-  NULL
  }

  output <- str_c(output, prologue_str, "", "", sep = "\n")
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
      str_c("", "### Notes on Homework:", "", sep = "\n")

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

make_short_hw_assignment <- function(cal_entry) {
  d <- cal_entry$date
  homework <- homework_assignments %>%
    filter(homework_id == cal_entry$homework_id) %>%
    arrange(hw_undergraduate_only, hw_graduate_only, homework_id, hw_order)
  homework_topic <- homework %>% filter(! is.na(short_homework)) %>%
    mutate(topic = str_trim(short_homework))
  if (any(homework_topic$hw_undergraduate_only |
          homework_topic$hw_graduate_only)) {
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
      str_c( "## Homework", "", .,  "", sep = "\n" )
  }
  output
}

# make_lab_doc_page <- function(doc, assignment) {
#   g_doc <<- doc
#   g_asg <<- assignment
#
#   delim <- "---"
#   header <- list(
#     title = doc$lab_document_title,
#     author = doc$doc_author,
#     lab_number = assignment$lab_num,
#     lab_date = assignment$lab_date,
#     pubdate = pub_date,
#     date = assignment$lab_date,
#     bibliography = doc$bibliography,
#     pdf_url = doc$lab_document_pdf_url,
#     slug = sprintf("lab_%02d_%s", assignment$lab_num, doc$doc_filename)) %>%
#     discard(is.na) %>%
#     c(
#       output = list("blogdown::html_page" =
#                       list(md_extensions = md_extensions,
#                            toc = TRUE))
#     ) %>%
#     as.yaml() %>% str_trim("right") %>%
#     str_c(delim, ., delim, sep = "\n")
#   lab_doc_page <- str_c(
#     header,
#     doc$lab_document_markdown,
#     sep = "\n"
#   ) %>% expand_codes()
#   lab_doc_page
# }
#
# make_lab_doc <- function(doc, assignment) {
#   fname <- sprintf("lab_%02d_%s.Rmd", assignment$lab_num, doc$doc_filename)
#   doc_path <- fname %>% file.path(root_dir, "content", "lab_docs", .)
#   doc_url <- fname %>% str_replace("\\.Rmd$", "") %>%
#     file.path("/lab_docs", .)
#   lab_doc_page <- make_lab_doc_page(doc, assignment)
#   cat(lab_doc_page, file = doc_path)
#   c(path = doc_path, url = doc_url)
# }
#
# make_lab_assignment_page <- function(this_assignment, lab_docs,
#                                      lab_solutions) {
#   delim <- "---"
#   these_docs <- lab_docs %>% filter(lab_group == this_assignment$lab_group) %>%
#     arrange(lab_item_id)
#   these_solutions <- lab_solutions %>%
#     mutate(lab_sol_pub_date = as_datetime(lab_sol_pub_date)) %>%
#     filter(lab_group == this_assignment$lab_group, lab_sol_pub_date <= now()) %>%
#     arrange(lab_sol_id)
#
#   header <- list(
#     title = this_assignment$lab_title,
#     lab_date = this_assignment$lab_date,
#     presentation_date = this_assignment$lab_present_date,
#     report_due_date = this_assignment$lab_due_date,
#     lab_number = this_assignment$lab_num,
#     github_classroom_assignment_url = this_assignment$lab_assignment_url,
#     pubdate = pub_date,
#     date = this_assignment$lab_date,
#     slug = sprintf("lab_%02d_assignment", this_assignment$lab_num),
#     output = list("blogdown::html_page" =
#                     list(md_extensions = md_extensions))
#   ) %>% discard(is.na) %>%
#     as.yaml() %>% str_trim("right") %>%
#     str_c(delim, ., delim, sep = "\n")
#   output <- this_assignment$lab_description
#   if (nrow(these_docs) > 0) {
#     output <- output %>% str_c(
#       "", "## Reading", "",
#       str_c("**Before you come to lab**, please read the following document",
#             ifelse(nrow(these_docs) > 1, "s", ""),
#             ":"), "",
#       sep = "\n")
#     for (i in seq(nrow(these_docs))) {
#       this_doc <- these_docs[i,]
#       doc <- make_lab_doc(this_doc, this_assignment)
#       output <- output %>% str_c("\n* [", this_doc$lab_document_title, "](", doc['url'], ")")
#     }
#   } else {
#     output <- output %>% str_c(
#       "", "## Reading", "",
#       "No reading has been posted yet for this lab.",
#       "", sep = "\n")
#   }
#   url <- this_assignment$lab_assignment_url
#   if (! is.na(url)) {
#     output <- output %>% str_c("", "## Assignment", "",
#                                str_c("Accept the assignment at GitHub Classroom at <", url, ">."),
#                                "", sep = "\n")
#   } else {
#     output <- output %>% str_c("", "## Assignment", "",
#                                "The GitHub Classroom has not been posted yet.",
#                                "", sep = "\n")
#   }
#   if (nrow(these_solutions) > 0) {
#     output <- output %>% str_c(
#       "", "## Solutions", "",
#       "**Solutions for Lab Exercises**:", "",
#       sep = "\n")
#     for (i in seq(nrow(these_solutions))) {
#       this_sol <- these_solutions[i,]
#       sol <- make_lab_solution(this_sol, this_assignment)
#       output <- output %>% str_c("\n* [", this_sol$lab_sol_title, "](", sol['url'], ")")
#     }
#
#
#   }
#   output <- str_c(header, output, sep = "\n") %>% expand_codes()
#   output
# }
#
# make_lab_assignment <- function(group, lab_assignments, lab_docs,
#                                 lab_solutions) {
#   this_assignment <- lab_assignments %>% filter(lab_group == group)
#   fname <- sprintf("lab_%02d_assignment.Rmd", this_assignment$lab_num)
#   lab_path <- fname %>% file.path(root_dir, "content", "lab", .)
#   lab_url <- fname %>% str_replace("\\.Rmd$", "")
#   lab_assignment_page <- make_lab_assignment_page(this_assignment, lab_docs,
#                                                   lab_solutions)
#   cat(lab_assignment_page, file = lab_path)
#   c(path = lab_path, url = lab_url)
# }
#
#

make_reading_page <- function(cal_entry) {
  rd_date <- cal_entry$date
  reading <- reading_assignments %>% filter(reading_id == cal_entry$reading_id)
  rd_topic <- cal_entry$topic
  class_num <- cal_entry$class
  this_class_num <<- class_num
  this_class_date <<- rd_date

  delim <- "---"
  header <- tibble(title = rd_topic, class_date = rd_date,
                   class_number = class_num, weight = class_num,
                   slug = sprintf("reading_%02d", class_num),
                   pubdate = pub_date, date = rd_date,
                   output = list("blogdown::html_page" =
                                   list(md_extensions = md_extensions))
  ) %>%
    as.yaml() %>% str_trim("right") %>%
    str_c(delim, ., delim, sep = "\n")
  rd_page <- str_c(
    header,
    make_short_hw_assignment(cal_entry) %>% escape_dollar(),
    make_reading_assignment(reading) %>% escape_dollar(),
    sep = "\n"
  ) %>% expand_codes()

  rd_page
}

make_lab_solution_page <- function(solution, assignment) {
  # g_doc <<- solution
  # g_asg <<- assignment

  delim <- "---"
  header <- list(
    title = solution$lab_sol_title,
    author = solution$lab_sol_author,
    lab_number = assignment$lab_num,
    lab_date = assignment$lab_date,
    pubdate = as.character(solution$lab_sol_pub_date),
    date = assignment$lab_due_date,
    pdf_url = solution$lab_sol_pdf_url,
    slug = sprintf("lab_%02d_%s", assignment$lab_num, solution$lab_sol_filename)) %>%
    discard(is.na) %>%
    c(
      output = list("blogdown::html_page" =
                      list(md_extensions = md_extensions,
                           toc = TRUE))
    ) %>%
    as.yaml() %>% str_trim("right") %>%
    str_c(delim, ., delim, sep = "\n")
  lab_solution_page <- str_c(
    header,
    solution$lab_sol_markdown,
    sep = "\n"
  ) %>% expand_codes()
  lab_solution_page
}

make_lab_solution <- function(solution, assignment) {
  fname <- sprintf("lab_%02d_%s.Rmd", assignment$lab_num, solution$lab_sol_filename)
  solution_path <- fname %>% file.path(root_dir, "content", "lab_solutions/", .)
  solution_url <- fname %>% str_replace("\\.Rmd$", "") %>%
    file.path("/lab_solutions", .)
  lab_solution_page <- make_lab_solution_page(solution, assignment)
  cat(lab_solution_page, file = solution_path)
  c(path = solution_path, url = solution_url)
}

make_lab_doc_page <- function(doc, assignment) {
  # g_doc <<- doc
  # g_asg <<- assignment

  delim <- "---"
  header <- list(
    title = doc$lab_document_title,
    author = doc$doc_author,
    lab_number = assignment$lab_num,
    lab_date = assignment$lab_date,
    pubdate = pub_date,
    date = assignment$lab_date,
    bibliography = doc$bibliography,
    pdf_url = doc$lab_document_pdf_url,
    slug = sprintf("lab_%02d_%s", assignment$lab_num, doc$doc_filename)) %>%
    discard(is.na) %>%
    c(
    output = list("blogdown::html_page" =
                    list(md_extensions = md_extensions,
                         toc = TRUE))
    ) %>%
    as.yaml() %>% str_trim("right") %>%
    str_c(delim, ., delim, sep = "\n")
  lab_doc_page <- str_c(
    header,
    doc$lab_document_markdown,
    sep = "\n"
  ) %>% expand_codes()
  lab_doc_page
}

make_lab_doc <- function(doc, assignment) {
  fname <- sprintf("lab_%02d_%s.Rmd", assignment$lab_num, doc$doc_filename)
  doc_path <- fname %>% file.path(root_dir, "content", "lab_docs", .)
  doc_url <- fname %>% str_replace("\\.Rmd$", "") %>%
    file.path("/lab_docs", .)
  lab_doc_page <- make_lab_doc_page(doc, assignment)
  cat(lab_doc_page, file = doc_path)
  c(path = doc_path, url = doc_url)
}

make_lab_assignment_page <- function(this_assignment, lab_docs,
                                     lab_solutions) {
  delim <- "---"
  these_docs <- lab_docs %>% filter(lab_group == this_assignment$lab_group) %>%
    arrange(lab_item_id)
  these_solutions <- lab_solutions %>%
    mutate(lab_sol_pub_date = as_datetime(lab_sol_pub_date)) %>%
    filter(lab_group == this_assignment$lab_group, lab_sol_pub_date <= now()) %>%
    arrange(lab_sol_id)

  header <- list(
    title = this_assignment$lab_title,
    lab_date = this_assignment$lab_date,
    presentation_date = this_assignment$lab_present_date,
    report_due_date = this_assignment$lab_due_date,
    lab_number = this_assignment$lab_num,
    github_classroom_assignment_url = this_assignment$lab_assignment_url,
    pubdate = pub_date,
    date = this_assignment$lab_date,
    slug = sprintf("lab_%02d_assignment", this_assignment$lab_num),
    output = list("blogdown::html_page" =
                    list(md_extensions = md_extensions))
  ) %>% discard(is.na) %>%
    as.yaml() %>% str_trim("right") %>%
    str_c(delim, ., delim, sep = "\n")
  output <- this_assignment$lab_description
  if (nrow(these_docs) > 0) {
    output <- output %>% str_c(
      "", "## Reading", "",
      str_c("**Before you come to lab**, please read the following document",
            ifelse(nrow(these_docs) > 1, "s", ""),
            ":"), "",
      sep = "\n")
    for (i in seq(nrow(these_docs))) {
      this_doc <- these_docs[i,]
      doc <- make_lab_doc(this_doc, this_assignment)
      output <- output %>% str_c("\n* [", this_doc$lab_document_title, "](", doc['url'], ")")
    }
  } else {
    output <- output %>% str_c(
      "", "## Reading", "",
      "No reading has been posted yet for this lab.",
      "", sep = "\n")
  }
  url <- this_assignment$lab_assignment_url
  if (! is.na(url)) {
    output <- output %>% str_c("", "## Assignment", "",
                               str_c("Accept the assignment at GitHub Classroom at <", url, ">."),
                               "", sep = "\n")
  } else {
    output <- output %>% str_c("", "## Assignment", "",
                               "The GitHub Classroom has not been posted yet.",
                               "", sep = "\n")
  }
  if (nrow(these_solutions) > 0) {
    output <- output %>% str_c(
      "", "## Solutions", "",
      "**Solutions for Lab Exercises**:", "",
      sep = "\n")
    for (i in seq(nrow(these_solutions))) {
      this_sol <- these_solutions[i,]
      sol <- make_lab_solution(this_sol, this_assignment)
      output <- output %>% str_c("\n* [", this_sol$lab_sol_title, "](", sol['url'], ")")
    }


  }
  output <- str_c(header, output, sep = "\n") %>% expand_codes()
  output
}

make_lab_assignment <- function(group, lab_assignments, lab_docs,
                                lab_solutions) {
  this_assignment <- lab_assignments %>% filter(lab_group == group)
  fname <- sprintf("lab_%02d_assignment.Rmd", this_assignment$lab_num)
  lab_path <- fname %>% file.path(root_dir, "content", "lab", .)
  lab_url <- fname %>% str_replace("\\.Rmd$", "")
  lab_assignment_page <- make_lab_assignment_page(this_assignment, lab_docs,
                                                  lab_solutions)
  cat(lab_assignment_page, file = lab_path)
  c(path = lab_path, url = lab_url)
}


make_notice <- function(notice_entries) {
  if (length(notice_entries) > 1) {
    output <- str_c("## Notices:", "",
                    str_c("* ", notice_entries$notice,
                          sep = " ", collapse = "\n"), "", "",
                    sep = "\n")
  } else {
    output <- paste("## Notice:", "",
                    notice_entries$notice, "",
                    sep = "\n")
  }
  output %>% escape_dollar()
}

generate_assignments <- function() {
  semester <- calendar %>%
    filter(! event_id %in% c("FINAL_EXAM", "ALT_FINAL_EXAM")) %>%
    select(seq, class, date, topic, homework_num, lab_num) %>%
    mutate(reading_page = NA_character_, homework_page = NA_character_,
           lecture_page = NA_character_, lab_page = NA_character_)
  for (class_num in na.omit(calendar$class)) {
    cal_entry <- calendar %>% filter(class == class_num)
    g_cal_entry <<- cal_entry

    slide_class_dir <- sprintf("Class_%02d", class_num)
    slide_url <- file.path("/Slides", slide_class_dir, fsep = "/")

    if (file.exists(file.path(slide_dir, slide_class_dir, "index.html"))) {
      message("HTML slide_url = ", slide_url)
      semester <- semester %>%
        mutate(lecture_page = ifelse(class == class_num,
                                     slide_url, lecture_page))
    } else {
      slides <- list.files(file.path(slide_dir, slide_class_dir), pattern = "*.ppt*")
      if (length(slides) > 0) {
        if (length(slides) == 1) {
          these_slides <- slides[1]
          message("One ppt slide found: ", these_slides)
        } else {
          slide_df <- tibble(slide = slides) %>%
            mutate(date = file.mtime(file.path(slide_dir, slide_class_dir, slide))) %>%
            arrange(desc(date))
          these_slides <- slide_df$slide[1]
          message(length(slides), " slides found. Choosing ", these_slides)
        }
        slide_url <- file.path(slide_url, these_slides, fsep = "/") %>% URLencode()
        message("slide_url = ", slide_url)
        semester <- semester %>% mutate(lecture_page = ifelse(class == class_num,
                                                              slide_url, lecture_page))
      }
    }

    if (cal_entry$has_reading) {
      message("Making reading page for class #", cal_entry$class)
      rd_fname <- sprintf("reading_%02d.Rmd", cal_entry$class)
      rd_path <- rd_fname %>% file.path(root_dir, "content", "reading", .)
      rd_url <- rd_fname %>% str_replace("\\.Rmd$", "") %>%
        file.path("/reading", .)
      rd_page <- make_reading_page(cal_entry)
      cat(rd_page, file = rd_path)
      semester <- semester %>%
        mutate(reading_page = ifelse(class == cal_entry$class,
                                     rd_url, reading_page))
    }
    if (cal_entry$has_homework) {
      message("Making homework page for assignment #", cal_entry$homework_num)
      hw_fname <- sprintf("homework_%02d.Rmd", cal_entry$homework_num)
      hw_path <- hw_fname %>% file.path(root_dir, "content", "assignment", .)
      hw_url <- hw_fname %>% str_replace("\\.Rmd$", "")
      hw_page <- make_hw_page(cal_entry)
      cat(hw_page, file = hw_path)
      semester <- semester %>%
        mutate(homework_page = ifelse(homework_num == cal_entry$homework_num,
                                     hw_url, homework_page))
    }
    if (cal_entry$has_lab) {
      message("Making lab page for lab #", cal_entry$lab_num )
      lab_assignment <-
        make_lab_assignment(cal_entry$lab_group, lab_assignments,
                            lab_docs, lab_solutions)
      lab_path <- lab_assignment['path']
      lab_url <- lab_assignment['url']
      semester <- semester %>%
        mutate(lab_page = ifelse(lab_num == cal_entry$lab_num,
                                 lab_url, lab_page))

    }
  }

  g_semester <<- semester

  semester %>%
    # filter(! event_id %in% c("FINAL_EXAM", "ALT_FINAL_EXAM")) %>%
    select(date, title = topic, reading = reading_page,
           assignment = homework_page, lecture = lecture_page, lab = lab_page, topic) %>%
    arrange(date) %>%
    rowwise() %>% do(lessons = as.list(.)) %>%
    map(~map(.x, ~discard(.x, is.na))) %>%
    as.yaml() %>% expand_codes() %T>%
    cat(file = file.path(root_dir, "data", "lessons.yml")) -> lesson_plan

  invisible(list(lesson_plan = lesson_plan, semester = semester))
}
