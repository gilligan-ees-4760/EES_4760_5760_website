#
# Fix rmarkdown formatting
#
library(stringr)

fix_rmd <- function(filename = 'index.Rmd') {
  str_starts_with <- function(x,y) {
    loc <- str_locate(x, fixed(y))[[1,'start']]
    ! (is.na(loc) || loc > 1)
  }


  lines <- read_lines(filename)
  header_delims <- which(str_detect(lines, '^ *---( |$)'))
  header <-head(lines, header_delims[2])
  body <- tail(lines, -header_delims[2]) %>% str_c(collapse = '\n')

  body <- str_replace_all(body, "^\\*{3} *([^ ].+[^ ]) *\n#+ +([^ ].*[^ ]) *$", "##\\2 {#\\2 \\1}")
  body <- str_replace_all(body, "^-{3} *\\&vertical *([^ ].+[^ ]) *\n#+ +([^ ].*[^ ]) *$", "#\\2 {#\\2-sec \\1")
  body <- body %>% str_split('\n') %>% unlist()

  body <- str_replace_all(body, '^(#+ .+ \\{(.* )*)dt:([^ ]++)', '\\1 data-transition="\\3"')
  body <- str_replace_all(body, '^(#+ .+ \\{(.* )*)bt:([^ ]++)', '\\1 data-background-transition="\\3"')
  body <- str_replace_all(body, '^(#+ .+ \\{(.* )*)bg:([^ ]++)', '\\1 data-background="\\3"')
  body <- str_replace_all(body, '^(#+ .+ \\{(.* )*)ds:([^ ]++)', '\\1 data-state="\\3"')
  body <- str_replace_all(body, '^(#+ .+ \\{(.* )*)dt:([^ ]++)', '\\1 data-transition="\\3"')
  body <- str_replace_all(body, '^(#+ .+ \\{(.* )*)id:([^ ]++)', '\\1 #"\\3"')

  body <- str_replace_all(body, "^( *)\\* +\\.fragment ", ">\\1 *")
  body <- str_replace_all(body, "^( *)([1-9a-zA-Z]\\. ) *\\.fragment ", ">\\1 \\2")

  body <- str_replace_all(body, '<img( +alt *= *"([^"]+)")?( +src *= *"([^"]+)")( +style *= *"([^"]+)")?( +[^>]+)?>', '![\\2](\\4){style="\\6"}')

  old_filename <- file.path(dirname(filename),paste0('old_',basename(filename)))
  file.rename(filename, old_filename)
  writeLines(c(header, body), con = filename)
}
