find_blog_root <- function(dir = ".", quiet = FALSE) {
  try({
  dir <- rprojroot::find_root(rprojroot::has_file_pattern("\\.Rproj$|config.(toml|yaml)"),
                       path = dir)
  }, silent = quiet)
}

find_blog_content <- function(dir = ".") {
  file.path(find_blog_root(dir), "content")
}

needs_rebuild <- function(current_digest, current_dest_digest,
                          old_digest, old_dest_digest) {
  out_of_date = current_digest != old_digest |
    current_dest_digest !=  old_dest_digest
  out_of_date = ifelse(is.na(out_of_date), TRUE, out_of_date)
  out_of_date
}

digest_if_exists <- function(file) {
  if (file.exists(file)) digest::digest(file, file = TRUE, algo = "sha256")
  else as.character(NA)
}

files_to_rebuild <- function(files) {
  base <- find_blog_root()
  files <- unique(files)
  files <- files[file.exists(files)]
  df <- data.frame(file = files,
               dest = blogdown:::output_file(files),
               stringsAsFactors = FALSE)
  df <- within(df, {
    cur_digest <- sapply(file, digest_if_exists)
    cur_dest_digest <- sapply(dest, digest_if_exists)
  })

  digest_file <- file.path(base, "digests.Rds")

  if (file.exists(digest_file)) {
    digest <- readRDS(digest_file)
    digest <- within(digest, {
      file <- sub("^~", base, file)
      })
    digest <- digest[,colnames(digest) != "dest"]
    df <- merge(df, digest, by = "file")
  } else {
    df <- within(df, {
      digest <- NA
      dest_digest <- NA
      })
  }

  df <- within(df, {
    rebuild <- needs_rebuild(cur_digest, cur_dest_digest, digest, dest_digest)
    })

  df[df$rebuild,"file"]
}

update_rmd_digests <- function(files) {
  base <- find_blog_root()
  files <- unique(files)
  files <- files[file.exists(files)]

  digest_file <- file.path(base, "digests.Rds")

  digests <- data.frame(file = files,
                        dest = blogdown:::output_file(files),
                        stringsAsFactors = FALSE)
  digests <- within(digests, {
    digest <- sapply(file, digest_if_exists)
    dest_digest <- sapply(dest, digest_if_exists)
    file <- sub(base, "~", file, fixed = TRUE)
    dest <- sub(base, "~", dest, fixed = TRUE)
    })
  saveRDS(digests, file = digest_file)
}

update_site <- function(dir = NULL, quiet = FALSE) {

  if (is.null(dir)) {
    dir <- find_blog_content()
  }
  files <- blogdown:::list_rmds(dir)
  to_build <- files_to_rebuild(files)
  if (! quiet) {
    message("Building ", length(to_build), " out of date ",
            ifelse(length(to_build) == 1, "file", "files"),
            "; site has ", length(files), " ",
            ifelse(length(files) == 1, "file", "files"),
            " in total.")
  }
  blogdown:::build_rmds(to_build)
  update_rmd_digests(files)
}
