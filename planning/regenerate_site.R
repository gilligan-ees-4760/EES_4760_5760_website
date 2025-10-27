library(rprojroot)
library(tidyverse)
pacman::p_load_gh("jonathan-g/blogdownDigest")
# pacman::p_load_gh("jonathan-g/semestr")
library(semestr)

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
    password <- askpass::askpass(prompt =
                                   str_c("Password to unlock keyring \"",
                                         keyring, "\""))
    try(keyring::keyring_unlock(keyring, password = password),
        silent = TRUE)
    if (keyring::keyring_is_locked(keyring)) {
      warning("Could not unlock keyring.")
      return(invisible(NULL))
    }
  }
  Sys.setenv(GITHUB_PAT = keyring::key_get("GITHUB_PAT",
                                           username = "jonathan-g",
                                           keyring = keyring))
  Sys.setenv(GITLAB_PAT = keyring::key_get("GITLAB_PAT",
                                           username = "jonathan",
                                           keyring = keyring))
}

config_cred <- function(val, lbl, repo) {
  if(val) {
    if (.Platform$OS.type == "windows") {
      home_dir <- Sys.getenv("USERPROFILE")
    } else {
      home_dir <- path.expand("~")
    }
    url <- gert::git_remote_info(lbl, repo)$url
    key_path <- NULL
    # message("url = ", url)
    if (str_starts(url, fixed("git@github.com"))) {
      key_path <- file.path(home_dir, ".ssh", "github.com",
                            "id_ed25519_gh")
    } else if (str_starts(url, fixed("git@gitlab.com"))) {
      key_path <- file.path(home_dir, ".ssh", "gitlab.com",
                            "id_ed25519_gl_com")
    } else if (str_starts(url, fixed("git@gitlab.jgilligan.org"))) {
      key_path <- file.path(home_dir, ".ssh", "jg_gitlab", "id_ed25519")
    }
    if (! is.null(key_path)) {
      # message("key_path = ", key_path)
      structure(list(
        publickey = normalizePath(str_c(key_path, ".pub"),
                                  mustWork = TRUE),
        privatekey = normalizePath(key_path, mustWork = TRUE),
        passphrase = keyring::key_get("SSH_KEY_PASSWORD",
                                      keyring = "git_access",
                                      username = "jonathan"),
        class = "cred_ssh_key")
      )
    } else {
      NULL
    }
  } else {
    if (str_starts(url, fixed("https://github.com"))) {
      token = "GITHUB_PAT"
    } else if (str_starts(url, fixed("https://gitlab.jgilligan.org"))) {
      token = "GITLAB_PAT"
    }
    structure(list(token = Sys.getenv(token)),
              class = "cred_token")
  }
}

process_cred <- function(cred) {
  if ("cred_token" %in% class(cred)) {
    cred <- structure(list(publickey = NULL, privatekey = NULL,
                           passphrase = cred$token),
                      class = "cred_ssh_key")
  }
  cred
}

get_cred <- function(val, lbl, repo) {
  process_cred(config_cred(val, lbl, repo))
}

publish <- function(ssh = NULL, repo = ".") {
  init_git_tokens()

  if (is.null(ssh)) {
    remotes <- c("origin", "publish")
    pattern <- "^git@([a-zA-Z][a-zA-Z0-9_\\-.]+):"
    ssh <- map_lgl(remotes,
                   ~str_detect(gert::git_remote_info(.x, repo)$url,
                               pattern)) %>%
      set_names(remotes)
  }

  if (length(ssh) < 2) {
    ssh <- rep_len(ssh, 2)
  }

  cred <- imap(ssh, get_cred, repo = repo)
  message("Pushing publish main ...")
  gert::git_push(remote = "publish", refspec = "refs/heads/main",
             password = cred$publish$passphrase,
             ssh_key = cred$publish$privatekey)
  message("Done.")
  message("Pushing origin main")
  gert::git_push(remote = "origin", refspec = "refs/heads/main",
             password = cred$origin$passphrase,
             ssh_key = cred$origin$privatekey)
  message("Done.")
}
