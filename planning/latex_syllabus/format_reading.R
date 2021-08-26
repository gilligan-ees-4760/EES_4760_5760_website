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
  retval <- homework_df %>% filter(! is.na(homework_id)) %>%
    group_by(homework_id) %>%
    summarize(has_hw = any_true_vec(str_length(homework) > 0) |
                any_true_vec(str_length(homework_notes) > 0),
              has_numbered_hw = has_hw && any_true_vec(hw_is_numbered),
              hw_slug_len = length(unique(hw_slug)),
              hw_slug = head(hw_slug, 1)) %>%
    ungroup()
  bad_slugs <- retval %>% filter(! is.na(hw_slug_len), hw_slug_len != 1)
  if (nrow(bad_slugs) > 0) {
    warning("Bad slug len for ", str_c(bad_slugs$homework_id, collapse = ", "))
  }
  retval %>% select(-hw_slug_len)
}

check_for_lab_asgt <- function(lab_df) {
  homework_df %>% filter(! is.na(lab_id)) %>% group_by(lab_id) %>%
    summarize(has_lab = any_true_vec(str_length(lab_group) > 0),
              lab_num = min(lab_num, na.rm = TRUE)) %>%
    ungroup()
}

check_for_notices <- function(notice_df) {
  notice_df %>% filter(!is.na(topic_id)) %>% group_by(topic_id) %>%
    summarize(has_notice = any_true_vec(str_length(notice) > 0)) %>%
    ungroup()
}

load_semester_db <- function(semester_db) {
  reading_items <- semester_db %>% tbl("reading_items")
  reading_sources <- semester_db %>% tbl("reading_sources")
  reading_assignments <- semester_db %>% tbl("reading_assignments") %>%
    left_join(reading_items, by = c("rd_group")) %>%
    left_join(reading_sources, by = "source_id") %>%
    select(rd_item_id, reading_id, title, short_title,
           markdown_title, short_markdown_title,
           latex_title, short_latex_title,
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
    { set_names(.$latex_value, .$code_name) }

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
    collect() %>%
    mutate(date = date(date)) %>%
    arrange(date) %>%
    mutate(seq = seq(n()), has_class = as.logical(has_class))

  if (has_hw_assignments) {
    homework_assignments <- hw_assignments %>%
      left_join(hw_groups, by = "hw_group") %>%
      left_join(hw_topics, by = "homework_id") %>%
      left_join(hw_items, by = "hw_group") %>%
      select(homework_id, hw_group, hw_due_date,
             hw_type, short_hw_type,
             hw_topic = homework_topic, hw_title, hw_slug,
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
      mutate(hw_due_date = ifelse(is.na(hw_due_date), date, date(hw_due_date)) %>% as_date) %>%
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
      mutate(has_lab = FALSE, lab_num = NA)
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
    mutate(hw_index = ifelse(has_hw, cumsum(has_hw), NA_integer_),
           hw_num = ifelse(has_numbered_hw, cumsum(has_numbered_hw), NA_integer_))

  spring_break <- calendar %>% filter(event_id == "SPRING_BREAK") %>%
    select(date, topic_id, event_id)

  fall_break <- calendar %>% filter(event_id == "FALL_BREAK") %>%
    select(date, topic_id, event_id)

  thanksgiving_break <- calendar %>% filter(event_id == "THANKSGIVING_BREAK") %>%
    select(date, topic_id, event_id)

  first_class <- 1
  last_class <- NA

  if(is.na(first_class)) first_class <- min(calendar$class, na.rm = T)
  if (is.na(last_class)) last_class <- max(calendar$class, na.rm = T)

  first_date <- calendar %>%
    filter(class == first_class) %>% select(date) %>% simplify() %>% as_date()
  last_date <- calendar %>%
    filter(class == last_class) %>% select(date) %>% simplify() %>% as_date()

  year_taught <- year(first_date)

  # Pub date should be last day of previous month.
  pub_date <- first_date %>% as_date() %>% rollback() %>% as.character()
  if (today() < pub_date) pub_date <- today()

  globals <- c("calendar", "reading_assignments",
               "homework_assignments", "homework_solutions",
               "lab_assignments","lab_docs", "lab_solutions",
               "notices",
               "text_codes",
               "first_class", "last_class", "first_date", "last_date",
               "year_taught", "pub_date",
               "has_hw_assignments", "has_lab_assignments")
  for (g in globals) {
    assign(g, get(g), envir = globalenv())
  }
}

select_event <- function(calendar, seq_index) {
  event <- calendar %>% filter(seq == seq_index) %>% select(seq, date, topic) %>%
    mutate(weekday = wday(date, label = TRUE), long.weekday = wday(date, label = TRUE, abbr = FALSE),
           month = month(date, label = TRUE), long.month = month(date, label = TRUE, abbr = FALSE),
           day = day(date))
  as.list(event)
}


select_class <- function(calendar, class_no) {
  class <- calendar %>% filter(class == class_no) %>% select(class, date, topic) %>%
    mutate(weekday = wday(date, label = TRUE), long.weekday = wday(date, label = TRUE, abbr = FALSE),
           month = month(date, label = TRUE), long.month = month(date, label = TRUE, abbr = FALSE),
           day = day(date))
  as.list(class)
}

expand_codes <- function(text, delim = c("<%", "%>")) {
  rlang::exec(knit_expand, !!!text_codes, text = text, delim = delim)
}

expand_code <- function(text) {
  str_c("<%", text, "%>") %>% expand_codes()
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
  if (abbr) m <- str_c(m, '.')
  m
}

format_wday <- function(d, abbr = TRUE) {
  wd <- wday(d, label = TRUE, abbr = abbr)
  if (abbr) wd <- str_c(wd, '.')
  wd
}

format_class_date <- function(d, abbr = TRUE) {
  str_c(format_month(d, abbr = abbr), "~", day(d))
}

format_class_day_date <- function(d, abbr_month = TRUE, abbr_wday = TRUE) {
  str_c(format_wday(d, abbr_wday), ", ",
        format_month(d, abbr_month), "~", day(d))
}

format_date_range_by_class_no <- function(calendar, classes, abbr = TRUE) {
  dates <- calendar %>% filter(class %in% na.omit(classes)) %>%
    summarize(start = min(date, na.rm = T), stop = max(date, na.rm = T))
  with(dates, {
    output <- format_class_date(start, abbr)
    if(start != stop) {
      output <- str_c(str_trim(output), '--',
                      ifelse(month(stop) == month(start), day(stop),
                             format_class_date(stop, abbr)))
    }
    output
  })
}

format_date_range_by_topic_id <- function(calendar, topics, abbr = TRUE) {
  dates <- calendar %>% filter(topic_id %in% topics) %>%
    summarize(start = min(date, na.rm = T), stop = max(date, na.rm = T))
  with(dates, {
    output <- format_class_date(start, abbr)
    if(start != stop) {
      output <- str_c(str_trim(output), '--',
                      ifelse(month(stop) == month(start), day(stop),
                             format_class_date(stop, abbr)))
    }
  })
  output
}

format_date_range_by_event_id <- function(calendar, event_ids, abbr = TRUE) {
  dates <- calendar %>% filter(event_id %in% event_ids) %>%
    select(date) %>% summarize(start = min(date, na.rm = T), stop = max(date, na.rm = T))
  with(dates, {
    output <- format_class_date(start, abbr)
    if(start != stop) {
      output <- str_c(str_trim(output), '--',
                      ifelse(month(stop) == month(start), day(stop),
                             format_class_date(stop, abbr)))
    }
    output
  })
}

format_day_date_range_by_event_id <- function(calendar, event_ids, abbr_month = TRUE, abbr_wday = TRUE) {
  dates <- calendar %>% filter(event_id %in% event_ids) %>%
    select(date) %>% summarize(start = min(date, na.rm = T), stop = max(date, na.rm = T))
  with(dates, {
    output <- format_class_day_date(start, abbr_month, abbr_wday)
    if (start != stop) {
      output <- str_c(output, '--',
                      format_class_day_date(stop, abbr_wday))
    }
    output})
}

format_page_range <- function(pages) {
  multiple <- str_detect(pages, "-+|,|;| and ")
  str_c(ifelse(multiple, "pp. ", "p. "), pages)
}

chapterpages <- function(chapter, pages, textbook, handout) {
  result = ''
  if (handout) {
    result = str_c(result, '\\ (Handout)')
  }
  if (!is.na(chapter)) {
    ch_text <- str_replace_all(chapter, "Ch\\. +", "Ch.~")
    if (! str_detect(ch_text, "^[[:space:]]*Ch")) {
      ch_text = str_c("Ch.~", ch_text)
    }
    result = str_c(result, ch_text, sep = ", ")
  }
  if (!is.na(pages)) {
    result = str_c(result, ifelse(str_detect(pages, '[,- ]'), ', pp.~', ', p.~'))
  }
  result
}

format_reading_item <- function(df) {
  df %>% rowwise() %>%
    mutate(reading = str_c(
      ifelse(rd_break_before, '\\\\',''),
      short_latex_title,
      chapterpages(chapter, pages, textbook, handout)
    )) %>%
    ungroup()
}

format_sheet_number <- function() {
  ifelse(is.null(this_sheet_revision), this_sheet,
         str_c(this_sheet, " (", this_sheet_revision, ")"))
}

make_section <- function(cal_entry) {
  d <- cal_entry$date
  str_c('\\section[',
        format_class_date(d, abbr = TRUE),
        ']{',
        format_class_day_date(d, TRUE, TRUE),
        ': ',
        cal_entry$topic,
        '}\n')
}

make_reading_assignment <- function(reading_entry) {
  output <- '\\subsection{Reading}'
  reading_items <- format_reading_item(reading_entry) %>%
    filter(! is.na(reading))
  if (nrow(reading_items) == 0) {
    output <- str_c(str_trim(output),
                    'No new reading for today.',
                    '', sep = '\n')
  } else {
    output <- str_c(str_trim(output),
                    '\\begin{itemize}',
                    str_c("\\item ", str_trim(reading_items$reading),
                          collapse = "\n"),
                    '\\end{itemize}',
                    '', sep = '\n')
  }
  # if (! is.na(reading_entry$extra_reading)) {
  #   output <- str_c(str_trim(output),
  #                   '\\subsection{Optional Extra Reading}',
  #                   '\\begin{itemize}',
  #                   append_newline_if_needed(reading_entry$extra_reading),
  #                   '\\end{itemize}',
  #                   '', sep = '\n'
  #   )
  # }
  reading_notes <- reading_entry %>% filter(!is.na(reading_notes)) %>%
    mutate(reading_notes = map_chr(reading_notes,
                                   ~markdown_latex(
                                     expand_codes(.x),
                                     smart=TRUE, normalize=TRUE,
                                     extensions = TRUE)) %>%
             str_trim() )
  if (nrow(reading_notes) > 0) {
    output <- with(reading_notes,
                   str_c(str_trim(output), '',
                         ifelse(nrow(reading_items) == 0,
                                '\\subsection{Notes}',
                                '\\subsection{Reading Notes}'),
                         str_c(str_trim(reading_notes), collapse = "\n\n"),
                         '', sep = '\n'))
  }
  output <- output %>% str_replace_all("\n\n+", "\n\n")
  output
}

make_homework_assignment <- function(homework_entries) {
  hw_type = unique(homework_entries$hw_type) %>% discard(is.na)
  short_hw_type = unique(homework_entries$short_hw_type) %>% discard(is.na)
  hw_num = unique(homework_entries$hw_num) %>% discard(is.na)
  hw_title = unique(homework_entries$hw_title) %>% discard(is.na)
  if (length(hw_type) == 0) hw_type <- "Homework"
  if (length(short_hw_type) == 0) short_hw_type = "HW"
  if (length(hw_num) == 0) hw_num = NA_integer_
  if (length(hw_title) == 0) hw_title = NA_character_

  if (length(hw_type) > 1 || length(short_hw_type) > 1 || length(hw_num) > 1 ||
      length(hw_title) > 1) {
    stop("Heterogeneous homework type.")
  }

  hw_string <- str_trim(hw_type)
  if (! is.na(hw_num)) hw_string <- str_c(hw_string, " \\#", hw_num) %>% str_trim()
  if (! is.na(hw_title))
    hw_string <- str_c(hw_string, ": ", expand_codes(hw_title)) %>% str_trim()

  homework_entries <- homework_entries %>%
    select(hw_type, short_hw_type, hw_topic, hw_title, short_homework, homework,
           homework_notes, hw_graduate_only, hw_undergraduate_only, hw_prologue,
           hw_epilogue, hw_break_before) %>%
    distinct() %>%
    mutate(homework = map_chr(homework,
                              ~.x %>% discard(is.na) %>% expand_codes %>%
                                markdown_latex(smart=TRUE, normalize=TRUE,
                                               extensions = TRUE)) %>%
             str_trim() %>% ifelse(str_length(.) == 0, NA_character_, .),
           homework_notes = map_chr(homework_notes,
                                    ~.x %>% discard(is.na) %>% expand_codes %>%
                                      markdown_latex(smart=TRUE, normalize=TRUE,
                                                     extensions = TRUE)) %>%
             str_trim() %>% ifelse(str_length(.) == 0, NA_character_, .))

  grad_hw <- homework_entries %>% filter(hw_graduate_only & ! is.na(homework))
  ugrad_hw <- homework_entries %>%
    filter(hw_undergraduate_only & ! is.na(homework))
  everyone_hw <- homework_entries %>%
    filter(!hw_graduate_only & ! hw_undergraduate_only & ! is.na(homework))
  grad_notes <- homework_entries %>%
    filter(hw_graduate_only & ! is.na(homework_notes))
  ugrad_notes <- homework_entries %>%
    filter(hw_undergraduate_only & ! is.na(homework_notes))
  everyone_notes <- homework_entries %>%
    filter(!hw_graduate_only & ! hw_undergraduate_only & ! is.na(homework_notes))

  output <- ''
  if (nrow(ugrad_hw) + nrow(grad_hw) + nrow(everyone_hw) > 0) {
    output <- str_c(str_trim(output),
                    str_c('\\subsection{', hw_string, '}'),
                    'A the beginning of class today, turn in the following homework:',
                    '', sep = '\n')
    if (nrow(everyone_hw) > 0) {
      output <- str_c(str_trim(output),
                      '\\subsubsection{Everyone:}',
                      '',
                      '\\begin{itemize}',
                      str_c('\\item ', everyone_hw$homework, collapse = "\n"),
                      '\\end{itemize}',
                      '', sep = '\n')
    }
    if (nrow(ugrad_hw) > 0) {
      output <- str_c(str_trim(output),
                      '\\subsubsection{Undergraduate Students:}',
                      '',
                      '\\begin{itemize}',
                      str_c('\\item ', ugrad_hw$homework, collapse = "\n"),
                      '\\end{itemize}',
                      '', sep = '\n', collapse = '\n')
    }
    if (nrow(grad_hw) > 0) {
      output <- str_c(str_trim(output),
                      '\\subsubsection{Graduate Students:}',
                      '',
                      '\\begin{itemize}',
                      str_c('\\item ', grad_hw$homework, collapse = "\n"),
                      '\\end{itemize}',
                      '', sep = '\n', collapse = '\n')
    }
  } else {
    output <- str_c(str_trim(output),
                    'No homework for today.',
                    '', sep = '\n')
  }

  if (nrow(grad_notes) + nrow(ugrad_notes) + nrow(everyone_notes) > 0) {
    output <- str_c(str_trim(output),
                    '\\subsection{Notes on Homework}\n',
                    '', sep = '\n')
    if (nrow(everyone_notes) > 0) {
      output <- str_c(str_trim(output),
                      str_c(str_trim(everyone_notes$homework_notes),
                            collapse = '\n\n'),
                      '', sep = '\n')
    }
    if (nrow(ugrad_notes) > 0) {
      output <- str_c(str_trim(output),
                      '\\subsubsection{Undergraduate Students:}',
                      '',
                      str_c(str_trim(ugrad_notes$homework_notes),
                            collapse = '\n\n'),
                      '', sep = '\n')
    }
    if (nrow(grad_notes) > 0) {
      output <- str_c(str_trim(output),
                      '\\subsubsection{Graduate Students:}',
                      '',
                      str_c(str_trim(grad_notes$homework_notes),
                            collapse = '\n\n'),
                      '', sep = '\n')
    }
  }

  output
}

make_hw_section <- function(cal_entry) {
  d <- cal_entry$date
  homework <- homework_assignments %>% filter(homework_id == cal_entry$homework_id)
  homework_topic <- homework$short_homework %>% discard(is.na) %>%
    str_trim() %>% str_c(collapse = "\n")
  hw_assignment_details <- homework %>%
    select(homework_id, hw_group, hw_type, short_hw_type, hw_slug,
           hw_topic, hw_title, hw_is_numbered, hw_num) %>%
    distinct()
  if (nrow(hw_assignment_details) > 1) {
    stop("Error: heterogeneous homework assignment.")
  }

  str_c('\\section[',
        format_class_date(d, abbr = TRUE),
        ']{',
        format_class_day_date(d, TRUE, TRUE),
        ': ',
        str_c('Homework \\#', hw_assignment_details$hw_num, ': ', homework_topic),
        '}\n') %>%
    expand_codes()
}

make_short_hw_assignment <- function(cal_entry) {
  d <- cal_entry$date
  homework <- homework_assignments %>% filter(homework_id == cal_entry$homework_id) %>%
    mutate(homework = map_chr(homework,
                              ~.x %>% discard(is.na) %>% expand_codes %>%
                                markdown_latex(smart=TRUE, normalize=TRUE,
                                               extensions = TRUE)) %>%
             str_trim() %>% ifelse(str_length(.) == 0, NA_character_, .),
           homework_notes = map_chr(homework_notes,
                                    ~.x %>% discard(is.na) %>% expand_codes %>%
                                      markdown_latex(smart=TRUE, normalize=TRUE,
                                                     extensions = TRUE)) %>%
             str_trim() %>% ifelse(str_length(.) == 0, NA_character_, .))
  if (length(unique(homework$hw_due_date)) > 1) {
    message("Filtering from ", length(unique(homework$hw_due_date)),
            " rows to ...")
    homework <- homework %>% filter(hw_due_date == d)
    message(length(unique(homework$hw_due_date)))
  }
  homework_topic <- homework$short_homework %>% discard(is.na) %>%
    str_trim()
  if (length(homework_topic) > 1) {
    if (length(homework_topic) > 2) {
      homework_topic = str_c(
        str_c(head(homework_topic, -1), collapse = ', '),
        tail(homework_topic, 1), sep = ", and ")
    } else {
      homework_topic = str_c(homework_topic, collapse = " and ")
    }
  }
  hw_assignment_details <- homework %>%
    select(homework_id, hw_group, hw_type, short_hw_type, hw_slug,
           hw_topic, hw_title, hw_is_numbered, hw_num) %>%
    distinct()
  if (nrow(hw_assignment_details) > 1) {
    stop("Error: heterogeneous homework assignment.")
  }

  output <- "\\subsection{Homework}"
  if (hw_assignment_details$hw_is_numbered) {
    output <- str_c( str_trim(output),
                     str_c( "Homework \\#", hw_assignment_details$hw_num, ": ",
                            homework_topic,
                            " is due today.  See the homework assignment sheet for details."),
                     '', sep = '\n' )
  } else {
    output <- str_c( str_trim(output),
                     str_c( hw_assignment_details$hw_type, ": ",
                            homework_topic,
                            " is due today.  See the assignment sheet for details."),
                     '', sep = '\n' )
  }
}

make_notice <- function(notice_entries) {
  if (length(notice_entries) > 1) {
    output <- str_c('\\subsection{Notices:}',
                    '\\begin{itemize}',
                    str_c('\\item', notice_entries$notice,
                          sep = ' ', collapse = '\n'),
                    '\\end{itemize}',
                    '', sep = '\n')
  } else {
    output <- str_c('\\subsection{Notice:}',
                    notice_entries$notice,
                    '', sep = '\n')
  }
  output
}

format_assignment_entry <- function(class_no) {
  cal_entry <- calendar %>% filter(class == class_no)
  hw_entry <- homework_assignments %>% filter(class == class_no)

  output <- make_hw_section(cal_entry)
  if (cal_entry$has_homework) {
    output <- str_c(str_trim(output),
                    make_homework_assignment(hw_entry),
                    '', sep = '\n')
  }
  knit_expand(text = output, this_class_no = class_no,
              this_class_date = cal_entry$date,
              calendar = calendar,
              delim = c('<%','%>'))
}

format_class_entry <- function(class_no) {
  cal_entry <- calendar %>% filter(class == class_no)
  hw_entry <- homework_assignments %>% filter(homework_id %in% cal_entry$homework_id)
  reading_entry <- reading_assignments %>% filter(reading_id %in% cal_entry$reading_id)
  notice_entry <- notices %>% filter(topic_id == cal_entry$topic_id)

  output <- make_section(cal_entry)
  if (nrow(notice_entry) > 0) {
    output <- str_c(str_trim(output),
                    make_notice(notice_entry),
                    '', sep = '\n')
  }
  if (nrow(hw_entry) > 0) {
    if(FALSE) {
      output <- str_c(str_trim(output),
                      make_homework_assignment(hw_entry),
                      '', sep = '\n')
    } else {
      output <- str_c(str_trim(output),
                      make_short_hw_assignment(cal_entry),
                      '', sep = '\n')
    }
  }
  if (nrow(reading_entry) > 0) {
    output <-str_c(str_trim(output),
                   make_reading_assignment(reading_entry),
                   '', sep = '\n')
  } else {
    # output <- str_c(str_trim(output),
    #                  '\\subsection{Reading}',
    #                  'No new reading for today.',
    #                  '', sep = '\n')
  }
  output <- expand_codes(output)
  output
}
