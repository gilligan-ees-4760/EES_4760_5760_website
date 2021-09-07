library(rprojroot)
library(tidyverse)
pacman::p_load_gh("jonathan-g/blogdownDigest")
pacman::p_load_gh("jonathan-g/semestr")
# library(git2r)

regenerate_site <- function(root = NULL, force = FALSE) {
  if (is.null(root)) {
    root = find_root(criterion = has_file(".semestr.here"))
  }
  oldwd = setwd(root)
  on.exit(setwd(oldwd))
  message("Setting working directory to ", getwd())
  semester <- load_semester_db("planning/EES-4760.sqlite3")
  generate_assignments(semester)
  new_update_site(root = getwd(), force = force)
}

new_update_site <- function(root = NULL, force = FALSE) {
  if (is.null(root)) {
    root = find_root(criterion = has_file(".semestr.here"))
  }
  oldwd = setwd(root)
  on.exit(setwd(oldwd))
  message("Setting working directory to ", getwd())
  update_site(force = force)
  out_opts = list(md_extensions = semestr:::get_md_extensions(), toc = TRUE,
                  includes = list(in_header = "ees4760.sty"))
  update_pdfs(force_dest = TRUE, force = force, output_options = out_opts)
}

init_git_tokens <- function(keyring = "git_access") {
  if (keyring::keyring_is_locked(keyring)) {
    try(keyring::keyring_unlock(keyring), silent = TRUE)
    if (keyring::keyring_is_locked(keyring)) {
      warning("Could not unlock keyring.")
      return(invisible(NULL))
    }
  }
  Sys.setenv(GITHUB_PAT = keyring::key_get("GITHUB_PAT", keyring = keyring))
  Sys.setenv(GITLAB_PAT = keyring::key_get("GITLAB_PAT", username = "jonathan",
                                           keyring = keyring))
}

publish <- function(ssh = NULL) {
  init_git_tokens()

  if (is.null(ssh)) {
    rep <- git2r::repository(".")
    remotes <- c("origin", "publish")
    pattern <- "^git@([a-zA-Z][a-zA-Z0-9_\\-.]+):"
    ssh <- map_lgl(remotes, ~str_detect(git2r::remote_url(rep, .x),
                                        pattern)) %>%
      set_names(remotes)
  }

  if (length(ssh) < 2) {
    ssh <- rep_len(ssh, 2)
  }

  cred <- imap(ssh,
               ~if(.x) {
                 NULL
                 } else {
                   git2r::cred_token(ifelse(.y == "origin", "GITLAB_PAT",
                                            "GITHUB_PAT"))
                 }
  )
  git2r::push(".", name = "publish", refspec = "refs/heads/main",
              credentials = cred$publish)
  git2r::push(".", name = "origin", refspec = "refs/heads/main",
              credentials = cred$origin)
}
