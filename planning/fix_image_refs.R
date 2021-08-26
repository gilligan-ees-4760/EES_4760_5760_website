library(tidyverse)

find_image_refs <- function(file, force = TRUE) {
  dir <- dirname(file)
  reldir <- dir %>% str_replace_all("^(.*/)?content/", "")
  file_dest <- file.path("static", reldir, str_replace_all(basename(file), "\\.Rmd", ""))
  text <- readr::read_file(file)
  images <- str_extract_all(text, "!\\[(?<desc>[^\\]]*)\\]\\((?<img>[A-Za-z0-9_.\\- \\\\//]+)\\)") %>%
    flatten() %>% unlist()
  img_files <- str_replace_all(images, "!\\[(?<desc>[^\\]]*)\\]\\((?<img>[A-Za-z0-9_.\\- \\\\//]+)\\)", "\\2")
  existing_files <- img_files %>% keep(~file.exists(file.path(dir, .x)))
  target <- file.path(file_dest, existing_files)
  missing_targets <- dirname(target) %>% discard(dir.exists) %>% unique()
  if (force && length(missing_targets) > 0) {
    walk(missing_targets, ~dir.create(.x, recursive = TRUE))
  }
  file.copy(file.path(dir, img_files), target, recursive = FALSE, overwrite = TRUE)
}

fix_image_refs <- function(dirs) {
  for (d in dirs) {
    if (dir.exists(d)) {
      f <- list.files(d, pattern = "*.Rmd")
      if (length(f) > 0)
        message("files in ", d, ": [", str_c(f, collapse = ", "), "]")
        walk(file.path(d, f), find_image_refs)
    }
  }
}
