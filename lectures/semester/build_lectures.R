library(tidyverse)
library(rprojroot)
library(knitr)
library(rmarkdown)
library(revealjs.jg)
library(yaml)
library(magick)

find_semester_dir <- function(dir = '.', up = TRUE) {
  dir = normalizePath(path.expand(dir))
  if(basename(dir) == 'semester') return(dir)
  dirs = list.dirs(dir, recursive = FALSE)
  for (d in dirs) {
    if (! is.null(find_semester_dir(d, FALSE))) return(d)
  }
  if (up) {
    while( basename(dir) != 'semester') {
      d = dirname(dir)
      if (d == dir) return(NULL)
      dir = d
    }
    if (basename(dir) == 'semester') return(dir)
  }
  NULL
}

semester.dir <- find_semester_dir()
data.dir <- file.path(semester.dir, 'data')
script.dir <- file.path(semester.dir, 'util_scripts')

setwd(semester.dir)

source('fix_rmd.R')
source('fix_file_refs.R')


make_pageurl <- function(lecture_no, lecture_dir = 'Slides') {
  server <- 'ees4760.jgilligan.org'
  head_dir <- NA
  URLencode(paste0('https://',
                   c(server, head_dir, lecture_dir, sprintf('Class_%02d/', lecture_no)) %>%
                     discard(~is.na(.x)) %>% reduce(file.path)))
}

make_pdfurl <- function(lecture_no, lecture_dir = 'Slides') {
  server <- 'ees4760.jgilligan.org'
  head_dir <- NA
  URLencode(paste0('https://',
                   c(server, head_dir, lecture_dir, sprintf('Class_%02d/EES_4760_5760_Class_%02d_Slides.pdf', lecture_no, lecture_no)) %>%
                     discard(~is.na(.x)) %>% reduce(file.path)))
}



add_class_number <- function(lecture_number, file = 'index.Rmd') {
  lines <- readLines(file)
  for (i in 2:length(lines)) {
    if (grepl('^\\s*class_no\\s*:\\s*$', lines[i])) {
      lines[i] <- paste(str_trim(lines[i], 'right'), lecture_number)
      break
    }
    if (grepl('^---', lines[i]))
      break
  }
  writeLines(lines, file)
}

set_semester_dir_in_file <- function(semester_dir = '.', file = '_output.yml') {
  lines <- readLines(file)
  lines <- lines %>% str_replace_all('%SEMESTER_DIR%', semester_dir)
  writeLines(lines, file)
}

make_qr <- function(slide_dir, semester_dir = '.') {
  message("semester_dir = ", semester_dir)
  cmdline <- paste("python", file.path(semester_dir,'lecture_qr.py'), slide_dir)
  message("Running \"", cmdline, "\" in directory ", getwd())
  system(cmdline)
}

add_qrimage <- function(image_file = 'qrcode.png', file = 'index.Rmd') {
  lines <- readLines(file)
  for (i in 2:length(lines)) {
    if (grepl('^\\s*qrimage\\s*:\\s*$', lines[i])) {
      lines[i] <- paste(str_trim(lines[i], 'right'), image_file)
      break
      }
    if (grepl('^---', lines[i]))
      break
  }
  writeLines(lines, file)
}

add_pageurl <- function(lecture_no, lecture_dir = "Slides", file = 'index.Rmd') {
  lines <- readLines(file)
  for (i in 2:length(lines)) {
    if (str_detect(lines[i], '^\\s*pageurl\\s*:\\s*$')) {
      page_url <- make_pageurl(lecture_no, lecture_dir) %>%
        str_replace("^https://","")
      lines[i] <- str_trim(lines[i], 'right') %>%
        paste0(' "', page_url, '"')
    }
    if (str_detect(lines[i], '^\\s*pdfurl\\s*:\\s*$')) {
      pdf_url <- make_pdfurl(lecture_no, lecture_dir) %>%
        str_replace("^https://","")
      lines[i] <- str_trim(lines[i], 'right') %>%
        paste0(' "', pdf_url, '"')
    }
    if (grepl('^---', lines[i]))
      break
  }
  writeLines(lines, file)
}

split_path <- function(p) {
  b<-  basename(p)
  d <- dirname(p)
  if (b == p || d == p | d == '.') return(p)
  # message('"',d,',", "', b, '"')
  return(c(split_path(d), b))
}

rel_path <- function(from, to) {
  from <- normalizePath(from, mustWork = FALSE)
  to <- normalizePath(to, mustWork = FALSE)
  if (from == to)
    return('.')
  from <- split_path(from)
  to <- split_path(to)
  l <- min(length(from), length(to))
  f <- head(from, l)
  t <- head(to, l)
  delta <- which(f != t) - 1
  if (length(delta) == 0) {
    delta <- l
  }

  delta <- delta[1]
  from <- tail(from, -delta)
  to <- tail(to, -delta)
  # message('delta = ', delta, ', from = (', paste(from, collapse=', '), '), to = (', paste(to, collapse = ', '), ')')
  delta_path <- rep('..', length(from))
  delta_path <- c(delta_path, to)
  do.call(file.path, as.list(delta_path))
}

author_lecture <- function(lecture_number, semester_dir = '.',
                           lecture_dir = file.path(semester_dir, 'Slides'),
                           scaffold_dir = file.path(semester_dir, 'scaffold'),
                           open_rmd = TRUE) {
  semester_dir <- normalizePath(semester_dir)
  # message("semester_dir = ", semester_dir)
  if (! dir.exists(lecture_dir)) dir.create(lecture_dir, recursive = TRUE)
  if (is.numeric(lecture_number))
    new_lecture <- sprintf('Class_%02d', lecture_number)
  else
    new_lecture <- paste0('Class_', lecture_number)
  new_lecture_dir <- file.path(lecture_dir, new_lecture)
  if (!dir.exists(new_lecture_dir)) {
    if (!dir.create(new_lecture_dir, recursive = TRUE, mode = 0755)) {
      stop('Could not create lecture directory "', new_lecture_dir, '"')
    }
  }
  if (file.exists(file.path(new_lecture_dir, 'index.Rmd'))) {
    stop('Lecture ', lecture_number, ' already exists.')
  } else {
    file.copy(file.path(scaffold_dir, 'lecture_skeleton', c('index.Rmd', '_output.yml')),
              new_lecture_dir)
    setwd(new_lecture_dir)
    set_semester_dir_in_file(semester_dir = rel_path(new_lecture_dir, semester_dir),
                             file = '_output.yml')
    make_qr(file.path(new_lecture_dir), semester_dir)
    add_class_number(lecture_number)
    dir.create('assets/images', recursive = TRUE)
    add_qrimage()
    add_pageurl(lecture_number, basename(lecture_dir))
    if (open_rmd)
      file.edit('index.Rmd')
  }
}

em_en_dash <- function(infile, outfile) {
  src <- file(infile, 'r')
  text <- readLines(src, warn=FALSE)
  close(src)
  text <- gsub('([[:alnum:]])---([[:alnum:]])', '\\1&mdash;\\2', text)
  text <- gsub('([[:alnum:]])--([[:alnum:]])', '\\1&ndash;\\2', text)
  dest <- file(outfile,'w')
  writeLines(text, dest)
  close(dest)
  invisible(text)
}


build_lecture <- function(inputFile, knit_deck = TRUE,
                          return_page = FALSE, save_payload=FALSE,
                          envir = parent.frame()) {
  if (is.numeric(inputFile)) {
    inputFile <- file.path(semester.dir, 'Slides', sprintf('Class_%02d', inputFile))
  }
  if (dir.exists(inputFile)) {
    inputFile <- file.path(inputFile, 'index.Rmd')
  }
  target <- revealjs_presentation()
  render(inputFile, 'revealjs.jg::revealjs_presentation', runtime = 'static')
  outputFile <- file.path(dirname(page$file),sprintf('%s.html', page$filename))
  message("Processing ", outputFile, " in ", getwd())
  em_en_dash(outputFile, outputFile)
}

build_semester_index <- function(semester_dir = '.', last_lecture = NA) {
  old_wd <- getwd()
  setwd(semester_dir)
  site = yaml.load_file('semester.yml')
  last_lecture_file <- file.path(semester_dir, 'last_lecture.yml')
  if (is.na(last_lecture)) {
    if (file.exists(last_lecture_file)) file.remove(last_lecture_file)
  } else {
    cat('last_lecture: ', last_lecture, '\n', sep='', append=FALSE, file = last_lecture_file)
  }
  semester_file = dir(".", recursive = FALSE, pattern = "*.Rmd")
  rmarkdown::render(semester_file, 'revealjs.jg::revealjs_presentation')
  setwd(old_wd)
}


build_lectures <- function (semester_dir = ".", last_lecture = NA, envir = parent.frame())
{
  cwd = getwd()
  on.exit(setwd(cwd))
  setwd(semester_dir)
  if (! file.exists('semester.yml') && ! dir.exists('libraries') && dir.exists('semester')) setwd('semester')
  build_semester_index(last_lecture = last_lecture, envir = new.env())
  LectureFiles <- dir('Slides', pattern="*.Rmd", recursive = TRUE,
                      full.names = TRUE)
  p <- c()
  for(f in LectureFiles) {
    message("Processing ", f)
    p <- c(p, build_lecture(f, envir = new.env()))
  }
  message("Lecture Building Successful :-)")
  #  return(invisible(list(pages = pages, site = site, tags = tags)))
}



run_decktape <- function(class = NULL) {
  if (is.null(class)) {
    class_dir = getwd() %>% basename()
    class = class_dir %>% str_extract("[0-9]+$") %>%
      simplify() %>% as.integer()
    dest_dir = "."
  } else {
    class = as.integer(class)
    class_dir = sprintf("Class_%02d", class)
    dest_dir = file.path(semester.dir, "Slides", class_dir)
  }
  dest = file.path(dest_dir, sprintf("EES_4760_5760_Class_%02d_Slides.pdf", class))
  slide_path = str_c("Slides/", class_dir)
  output_yml = file.path(dest_dir, "_output.yml")
  res = "1920x1080"
  if (file.exists(output_yml)) {
    y = yaml.load_file(output_yml)
    params = y[["revealjs.jg::revealjs_presentation"]]
    if (all (c("height", "width") %in% names(params))) {
      h = params$height
      w = params$width
      res = str_c(w, "x", h)
    }
  }
  screenshot_dir <- "tmp_screenshots"
  if (dir.exists(screenshot_dir)) {
    ss_files <- file.path(screenshot_dir, list.files(screenshot_dir))
    if (length(ss_files) > 0)
      file.remove(ss_files)
  } else {
    dir.create(screenshot_dir, recursive = TRUE)
  }

  slide_url <- str_c("http://localhost:8000/", slide_path)
  decktape_cmd_line = str_c("decktape reveal -s", res, "--screenshots --screenshots-directory", screenshot_dir,
                   slide_url, " ", dest, sep = " ")
  system(decktape_cmd_line)

  magick_files <- tibble(fname = list.files(screenshot_dir)) %>%
    mutate(index = str_extract(fname, "(?<=_Slides_)[0-9]+(?=_)") %>% as.integer()) %>%
    arrange(index) %>%
    select(fname) %>% flatten() %>% simplify()
  screen_shots <- image_read(file.path(screenshot_dir, magick_files))
  image_write(screen_shots, dest, format = "pdf", quality = "100")
  unlink(screenshot_dir, recursive = TRUE, force = TRUE)
}

