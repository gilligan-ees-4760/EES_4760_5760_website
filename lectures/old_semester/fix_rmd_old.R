#
# Fix rmarkdown formatting
#
library(stringr)

fix_rmd <- function(filename = 'index.Rmd') {
  str_starts_with <- function(x,y) {
    loc <- str_locate(x, fixed(y))[[1,'start']]
    ! (is.na(loc) || loc > 1)
  }


  lines <- readLines(filename)
  header_delims <- which(str_detect(lines, '^ *---( |$)'))
  header <-head(lines, header_delims[2])
  body <- tail(lines, -header_delims[2])

  body <- unlist(str_split(str_replace_all(body, "^(## [^{}]*)(\\{(.*)\\})? *$", "*** \\3\n\\1"),'\n'))
  body <- unlist(str_split(str_replace_all(body, "^(# [^{}]*)(\\{(.*)\\})? *$", "--- &vertical \\3\n\\1"),'\n'))

  body <- str_replace_all(body, '^([*-]{3} .* )data-transition *= *"([^"]+)"', "\\1dt:\\2")
  body <- str_replace_all(body, '^([*-]{3} .* )data-background-transition *= *"([^"]+)"', "\\1bt:\\2")
  body <- str_replace_all(body, '^([*-]{3} .* )data-background *= *"([^"]+)"', "\\1bg:\\2")
  body <- str_replace_all(body, '^([*-]{3} .* )class *= *"([^"]+)"', "\\1.\\2")
  body <- str_replace_all(body, '^([*-]{3} .* )data-state *= *"([^"]+)"', "\\1ds:\\2")
  body <- str_replace_all(body, '^([*-]{3} .* )id *= *"([^"]+)"', "\\1#\\2")
  body <- str_replace_all(body, '^([*-]{3} .* )data-transition *= *([^ ]+)', "\\1dt:\\2")
  body <- str_replace_all(body, '^([*-]{3} .* )data-background-transition *= *([^ ]+)', "\\1bt:\\2")
  body <- str_replace_all(body, '^([*-]{3} .* )data-background *= *([^ ]+)', "\\1bg:\\2")
  body <- str_replace_all(body, '^([*-]{3} .* )data-state *= *([^ ]+)', "\\1ds:\\2")
  body <- str_replace_all(body, '^([*-]{3} .* )class *= *([^ ]+)', "\\1.\\2")
  body <- str_replace_all(body, '^([*-]{3} .* )id *= *([^ ]+)', "\\1#\\2")

  body <- str_replace_all(body, '^([*-]{3}( .*)*) +(#[^ ]+) +([^ ].*)$','\\1 \\4 \\3')
  body <- str_replace_all(body, '^([*-]{3} +)(([^& ][^ ]+ )+)(&[^ ].*)','\\1 \\5 \\3')
  body <- str_replace_all(body, '^([*-]{3} +(&[^ ]+ +)?)(([^&. ][^ ]+ )+)(\\.[^ ].*)','\\1 \\5 \\3')

  body <- str_replace_all(body, "^\\>( *[*-]) ","\\1 .fragment ")
  body <- str_replace_all(body, "!\\[([^\\]]+)\\]\\(([^)]+)\\)", '<img alt="\\1" src="\\2"/>')

  body <- str_replace_all(body, 'CO~2~', 'CO<sub style="font-size:60%;">2</sub>')
  body <- str_replace_all(body, 'H~2~O', 'C<sub style="font-size:60%;">2</sub>O')
  body <- str_replace_all(body, 'CH~4~', 'CH<sub style="font-size:60%;">4</sub>')

  body <- str_replace_all(body, '(\\<img [^>]+src=")((?!images/).*)"', '\\1images/\\2"')
  body <- str_replace_all(body, '^([*-]{3}( .*)* +bg:)((?!images/)[^ ]+) +', '\\1images/\\3 ')

  body <- unlist(str_split(body,'\n'))

  while(any(str_detect(body, '^([*-]{3}.* ) +')))
    body <- str_replace_all(body, '^([*-]{3}.* ) +', '\\1')

  sec_breaks <- grep('^[*-]{3}', body)
  delete_list <- c()
  for(i in seq_along(head(sec_breaks,-1))) {
    if ( (sec_breaks[i+1] == 1 + sec_breaks[i]) && (
      str_starts_with(body[sec_breaks[i]], body[sec_breaks[i+1]]) ||
      grepl("^[*-]{3} *$", body[sec_breaks[i+1]])
    ))
      delete_list <- c(delete_list, sec_breaks[i+1])
  }
  if (length(delete_list) > 0) body <- body[ - delete_list]

  sec_breaks <- grep('^[*-]{3}', body)
  code_fence <- as.data.frame(matrix(grep('^```', body), ncol=2, byrow=TRUE))
  colnames(code_fence) <- c('start', 'end')
  delete_list <- c()
  for (i in 1:nrow(code_fence)) {
    range <- with(code_fence[i,], start:end)
    indices <- intersect(range, sec_breaks)
    delete_list <- c(delete_list, indices)
  }
  if (length(delete_list) > 0) body <- body[-delete_list]


  old_filename <- file.path(dirname(filename),paste0('old_',basename(filename)))
  file.rename(filename, old_filename)
  writeLines(c(header, body), con = filename)
}
