#
# Fix case on data and images
#

options(stringsAsFactors = FALSE)

testing <- FALSE

path_from_strings <- function(strings) {
  path <- ''
  strings <- gsub("['\"]","",strings)
  strings <- strsplit(strings, ',')
  strings <- unlist(strings)
  do.call(file.path, as.list(strings))
}

fix_img_lines <- function(lines, cwd = '.') {
  rex <- ' (bg:|src *= *")images/[[:alnum:]][[:alnum:]_.-]*'
  matches <- regexpr(rex, as.character(lines))
  for (i in seq_along(matches)) {
    m0 <- matches[[i]]
    m0.len <- attr(matches, 'match.length')[[i]]
    if (m0 < 0) next
    s0 <- lines[[i]]
    prefix <- ''
    f <- substring(s0, m0, m0 + m0.len - 1)
    while (grepl('[[:upper:]]', f)) {
      nf <- tolower(gsub('([[:alnum:]])([[:upper:]])', '\\1_\\2', f))
      from <- file.path(cwd, gsub('.+(images/[[:alnum:]][[:alnum:]_.-]*)([^[:alnum:]_.-]|$)','\\1', f))
      to <- file.path(cwd, gsub('.+(images/[[:alnum:]][[:alnum:]_.-]*)([^[:alnum:]_.-]|$)','\\1', nf))
      if (file.exists(from)) {
        message('Moving "', from, '" to "', to, '".')
        if (! testing) file.rename(from, to)
      } else {
        message('Imaginary move from "', from, '" to "', to, '".')
      }
      if (testing) message('Prefix = "', prefix, '", next = "', substring(s0, 1, m0 - 1), '", nf = "', nf, '", remainder = "', substring(s0, m0 + m0.len), '".')
      prefix <- paste0(prefix, substring(s0, 1, m0 - 1), nf)
      s0 <- substring(s0, m0 + m0.len)
      m <- regexpr(rex, s0)
      if (m >= 0) {
        m0 <- m[[1]]
        m0.len <- attr(m, 'match.length')[[1]]
        f <- substring(s0, m0, m0 + m0.len - 1)
      } else {
        f <- ''
      }
    }
    if (nchar(prefix) > 0) {
      new_line <- paste0(prefix, s0)
      if (testing) message('Changing line #', i, ' from "', lines[[i]], '" to "', new_line, '" = ("', prefix, '", "', s0, '")')
      lines[[i]] <- new_line
    }
  }
  lines
}


fix_data_lines <- function(lines, data.dir) {
  rex <- '(file.path\\(data\\.dir[[:space:]]*,[[:space:]]*)((["\'][[:alnum:]_. ]+["\'][[:space:]]*,[[:space:]]*)*)(["\'][[:alnum:]_./ ]+["\'])\\)'
  match_lines <- regexpr(rex, as.character(lines))
  match_groups <- regmatches(lines, regexec(rex, as.character(lines)))
  for (i in seq_along(match_lines)) {
    m0 <- match_lines[[i]]
    m0.len <- attr(match_lines,'match.length')[[i]]
    if (m0 < 0) next
    mm <- match_groups[[i]]
    s0 <- lines[[i]]
    prefix <- ''
    p <- mm[[1]]
    d <- mm[[2]]
    f <- mm[[4]]
    while (grepl('[[:upper:]]', f)) {
      nf <- tolower(gsub('([[:alnum:]])([[:upper:]])', '\\1_\\2', f))
      from <- path_from_strings(c(data.dir, d, f))
      to <- path_from_strings(c(data.dir, d, nf))
      if (file.exists(from)) {
        message('Moving "', from, '" to "', to, '".')
        if (testing) file.rename(from, to)
      } else {
        message('Imaginary move from "', from, '" to "', to, '".')
      }
      new_text <- paste0(p, d, nf, ")")
      if (testing) message('Prefix = "', prefix, '", next = "', substring(s0, 1, m0 - 1), 
                           '", new text = "', new_text, '", remainder = "', substring(s0, m0 + m0.len), '".')
      prefix <- paste0(prefix, substring(s0, 1, m0 - 1), new_text)
      s0 <- substring(s0, m0 + m0.len)
      m <- regexpr(rex, s0)
      if (m >= 0) {
        m0 <- m[[1]]
        m0.len <- attr(m, 'match.length')[[1]]
        mm <- regmatches(s0, regexec(rex, s0))
        p <- mm[[1]]
        d <- mm[[2]]
        f <- mm[[4]]
      } else {
        f <- ''
      }
    }
    if (nchar(prefix) > 0) {
      new_line <- paste0(prefix, s0)
      message('Changing line #', i, ' from "', lines[[i]], '" to "', new_line, '" = ("', prefix, '", "', s0, '")')
      lines[[i]] <- new_line
    }
  }
  lines
}

fix_files <- function(input_file, semester.dir = '.', file.dir = NULL) {
  if (! is.null(file.dir)) input_file <- file.path(file.dir, input_file)
  data.dir <- file.path(semester.dir, 'data')
  lines <- readLines(input_file, warn = FALSE)
  img_line_indices <- grep('images/', lines, value=FALSE)
  img_lines <- data.frame(index = img_line_indices, line = lines[img_line_indices], stringsAsFactors = FALSE)
  
  img_lines$fixed_line <- fix_img_lines(img_lines$line, cwd = dirname(input_file))
  lines[img_line_indices] <- img_lines$fixed_line
  
  data_line_indices <- grep('file\\.path\\(data\\.dir *, *[\'"]', lines, value=FALSE)
  data_lines <- data.frame(index = data_line_indices, line = lines[data_line_indices])
  
  data_lines$fixed_line <- fix_data_lines(data_lines$line, data.dir)
  lines[data_line_indices] <- data_lines$fixed_line
  
  file.rename(input_file, file.path(dirname(input_file), paste0('old_', basename(input_file))))
  writeLines(lines, con=input_file)
}
