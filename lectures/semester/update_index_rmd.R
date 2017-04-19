library(stringr)

fix_lines <- function(src = 'index.Rmd', dest = NULL, skip = 0) {
  if (is.null(dest)) dest <- src
  lines <- readLines(src)
  save_lines <- character()
  if (skip > 0) {
    save_lines <- head(lines, skip)
    lines <- tail(lines, -skip)
  }
  xlines <- lines %>% 
    str_replace_all('^([*-]{3} *)( .*)( #[^ ]+)( |$)', '\\1\\3\\2\\4') %>%
    str_replace_all('dt:([^ ]+)( |$)', 'data-transition="\\1" ') %>%
    str_replace_all('bt:([^ ]+)( |$)', 'data-background-transition="\\1" ') %>%
    str_replace_all('bg:([^ ]+)( |$)', 'data-background="\\1" ') %>%
    str_replace_all('^( *[*-] +)\\.fragment ','>\\1 ') %>%
    str_replace_all('^( *[0-9#]\\.? +)\\.fragment ','>\\1 ')
  text <- xlines %>% paste(collapse='\n')
  xtext <- text %>%  
    str_replace_all('\n-{3} +(\\S.*) *\n(#+ +)(\\S.*)\n','\n\n# \\3 {\\1 data-transition="fade-out" data-state="skip_slide"}\n\n\n## \\3 {\\1 data_transition="fade-in"}\n\n') %>%
    str_replace_all('\n\\*{3} +(\\S.*) *\n+(#{3,} +)(\\S.*)\n','\n\n<!--- ---> {\\1}\n------\n\n\\2\\3') %>%
    str_replace_all('\n\\*{3} +(\\S.*) *\n+(#{1,2} +)(\\S.*)\n','\n\n## \\3 {\\1}\n') %>%
    str_replace_all('\n\\*{3} +(\\S.*) *\n','\n\n<!--- ---> {\\1}\n------\n\n') %>%
    str_replace_all(' *&vertical *',' ') %>%
    str_replace_all('\n(#.+\\S) +\\}', '\\1}') %>%
    str_replace_all('\n{3,}','\n\n') %>%
    str_replace_all('\n\\*\\*\\* *\n','\n')
  xtext <- xtext %>% 
    str_replace_all('<img *src *= *"([^"]+)"( +alt *= *"([^"]+)")?( +(style *= *"[^"]+"))? */>', '![\\3](assets/\\1){\\5}') %>%
    str_replace_all('(!\\[.*\\]\\(assets/.*\\))\\{ *\\}', '\\1')
  if (length(save_lines) > 0) {
    xtext <- save_lines %>% paste(collapse = '\n') %>% str_c(xtext, sep = '\n')
  }
  write(xtext, file = dest)
}
