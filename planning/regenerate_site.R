library(rprojroot)
library(tidyverse)
pacman::p_load_gh("jonathan-g/blogdownDigest")
# pacman::p_load_gh("jonathan-g/semestr")
library(semestr)
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

config_cred <- function(val, lbl, repo) {
  if(val) {
    url <- git2r::remote_url(repo, lbl)
    key_path <- NULL
    # message("url = ", url)
    if (str_starts(url, fixed("git@github.com"))) {
      key_path <- git2r::ssh_path(file.path("github.com",
                                            "id_ed25519_gh"))
    } else if (str_starts(url, fixed("git@gitlab.com"))) {
      key_path <- git2r::ssh_path(file.path("gitlab.com",
                                            "id_ed25519_gl_com"))
    } else if (str_starts(url, fixed("git@gitlab.jgilligan.org"))) {
      key_path <- git2r::ssh_path(file.path("jg_gitlab", "id_ed25519"))
    }
    if (! is.null(key_path)) {
      # message("key_path = ", key_path)
      git2r::cred_ssh_key(
        publickey = str_c(key_path, ".pub"),
        privatekey = key_path,
        passphrase = keyring::key_get("SSH_KEY_PASSWORD",
                                      keyring = "git_access",
                                      username = "jonathan")
      )
    } else {
      NULL
    }
  } else {
    git2r::cred_token(ifelse(lbl == "origin", "GITLAB_PAT",
                             "GITHUB_PAT"))
  }
}

publish <- function(ssh = NULL, repo = ".") {
  init_git_tokens()
  repo = git2r::repository(repo)

  if (is.null(ssh)) {
    remotes <- c("origin", "publish")
    pattern <- "^git@([a-zA-Z][a-zA-Z0-9_\\-.]+):"
    ssh <- map_lgl(remotes, ~str_detect(git2r::remote_url(repo, .x),
                                        pattern)) %>%
      set_names(remotes)
  }

  if (length(ssh) < 2) {
    ssh <- rep_len(ssh, 2)
  }

  cred <- imap(ssh, config_cred, repo = repo)
  git2r::push(".", name = "publish", refspec = "refs/heads/main",
              credentials = cred$publish)
  git2r::push(".", name = "origin", refspec = "refs/heads/main",
              credentials = cred$origin)
}
