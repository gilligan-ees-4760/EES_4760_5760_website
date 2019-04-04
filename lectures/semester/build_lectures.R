library(knitr)
library(rmarkdown)
library(revealjs.jg)
library(yaml)
library(tidyverse)
library(stringr)

source('fix_rmd.R')
source('fix_file_refs.R')

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


make_pageurl <- function(lecture_no, lecture_dir = 'Slides') {
  server <- 'ees3310.jgilligan.org'
  head_dir <- NA
  URLencode(paste0('https://',
                   c(server, head_dir, lecture_dir, sprintf('Class_%02d/', lecture_no)) %>%
                     discard(~is.na(.x)) %>% reduce(file.path)))
}

make_pdfurl <- function(lecture_no, lecture_dir = 'Slides') {
  server <- 'ees3310.jgilligan.org'
  head_dir <- NA
  URLencode(paste0('https://',
                   c(server, head_dir, lecture_dir, sprintf('Class_%02d', lecture_no),
                     sprintf('EES_3310_5310_Class_%02d_Slides.pdf', lecture_no)) %>%
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
      break
    }
    if (grepl('^---', lines[i]))
      break
  }
  writeLines(lines, file)
}

add_pdfurl <- function(lecture_no, lecture_dir = "Slides", file = 'index.Rmd') {
  lines <- readLines(file)
  for (i in 2:length(lines)) {
    if (str_detect(lines[i], '^\\s*pdfurl\\s*:\\s*$')) {
      pdf_url <- make_pdfurl(lecture_no, lecture_dir) %>%
        str_replace("^https://","")
      lines[i] <- str_trim(lines[i], 'right') %>%
        paste0(' "', pdf_url, '"')
      break
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
    add_pdfurl(lecture_number, basename(lecture_dir))
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
  old_wd = getwd()
  setwd(here::here())
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

clean_images <- function(dir = NULL, dry_run = FALSE, quiet = FALSE) {
  strip_leading <- function(s) {
    str_replace(s, "^assets/images/", "")
  }

  cwd = getwd()
  if (! is.null(dir)) {
    setwd(dir)
  }

  lines = readLines("index.html")
  lines = lines %>% keep(~str_detect(.x, fixed("images/")))
  images = lines %>% str_extract_all("images/[a-zA-Z0-9_.\\-]+") %>%
    unlist() %>% simplify() %>% unique() %>% file.path("assets", .)
  image_df <- tibble(im = images, lc = str_to_lower(im))
  image_files = list.files('assets/images') %>% file.path('assets/images', .)
  image_file_df = tibble(im_file = image_files, lc = str_to_lower(im_file))
  big_df = image_file_df %>% left_join(image_df, by = "lc") %>%
    filter(! str_detect(lc, '^corel'), ! str_detect(lc, "\\.pspimage$"))
  files_to_remove = big_df %>% filter(is.na(im))
  files_to_rename = big_df %>% filter(!is.na(im) & im_file != im)
  missing_files = image_file_df %>% right_join(image_df, by = "lc") %>%
    filter(is.na(im_file))

  if (!quiet) {
    message("Files to remove = [",
            str_c(strip_leading(files_to_remove$im_file),
                  collapse = ", "), "]")
    message("Files to rename = [",
            str_c(strip_leading(files_to_rename$im_file),
                  strip_leading(files_to_rename$im),
                  sep = " --> ", collapse = ", "), "]")
  }

  if (nrow(missing_files) > 0) {
    warning("Missing files: [",
            str_c(strip_leading(missing_files$im), collapse = ", "), "]")
  }

  if (! dry_run) {
    file.remove(files_to_remove$im_file)
    file.rename(files_to_rename$im_file, files_to_rename$im)
  }

  setwd(cwd)
}

copy_image_files_worker = function(source, dest) {
  source_dir = file.path(source, 'assets/images/')
  if (! dir.exists(source_dir)) {
    source_dir = file.path(source, 'images/')
    if (! dir.exists(source_dir)) {
      return
    }
  }
  dest_dir = file.path(dest, 'assets/images/')
  if (dir.exists(dest) & ! dir.exists(dest_dir)) {
    if (! dir.create(dest_dir, recursive = TRUE))
      return
  }
  dest_dir = dirname(dest_dir)
  message("source = ", source, ", source_dir = ", source_dir, ", dest = ", dest, " dest_dir = ", dest_dir)
  file.copy(source_dir, dest_dir, recursive = TRUE, overwrite = FALSE,
            copy.mode = TRUE, copy.date = TRUE)
}

copy_image_files <- function(source, dest, subdir = "Slides") {
  if (! is.na(subdir) && ! is.null(subdir)) {
    source = file.path(source, subdir)
    dest = file.path(dest, subdir)
  }

  dirs = intersect(list.dirs(source, recursive = FALSE, full.names = FALSE),
                     list.dirs(dest, recursive = FALSE, full.names = FALSE))
  for (dir in dirs) {
    message("Processing ", dir)
    copy_image_files_worker(file.path(source, dir), file.path(dest, dir))
  }
}

copy_lecture_images = function(num, dest = NULL) {
  source_path = file.path(semester.dir, '..', 'old_lectures', 'Slides',
                          sprintf("Class_%02d", num)) %>%
    normalizePath()
  if (is.null(dest)) {
    cwd = getwd()
    if (str_detect(cwd, 'Class_[0-9]+$')) {
      dest = '.'
    } else {
      dest = file.path(semester.dir, 'Slides', sprintf("Class_%02d"))
    }
  }
  if (dir.exists(source_path) & dir.exists(dest)) {
    copy_image_files_worker(source_path, dest)
  }
}

copy_lecture_template = function(num, dest_dir = NULL) {
  source = file.path(semester.dir, '..', 'old_lectures', 'Slides',
                          sprintf("Class_%02d", num), 'index.Rmd') %>%
    normalizePath()
  if (is.null(dest_dir)) {
    cwd = getwd()
    if (str_detect(cwd, 'Class_[0-9]+$')) {
      dest_dir = '.'
    } else {
      dest_dir = file.path(semester.dir, 'Slides', sprintf("Class_%02d"))
    }
  }
  if (file.exists(source) & dir.exists(dest_dir)) {
    dest = sprintf('index-%02d.Rmd', num)
    message("source = ", source, ", dest = ", dest, " dest_dir = ", dest_dir)
    file.copy(source, dest, recursive = FALSE, overwrite = FALSE,
              copy.mode = TRUE, copy.date = TRUE)
  }
}

semester.dir <- find_semester_dir()
data.dir <- file.path(semester.dir, 'data')
script.dir <- file.path(semester.dir, 'util_scripts')


