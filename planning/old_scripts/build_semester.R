library(pacman)
p_load(knitr)
p_load(rprojroot)
p_load(rmarkdown)
p_load(blogdown)

build_semester <- function() {

  old_path <- getwd()
  root_path <- find_rstudio_root_file("/")
  planning_path <- find_rstudio_root_file("/planning")
  static_path <- find_rstudio_root_file("/static")

  setwd(planning_path)
  source("generate_assignments.R")
  generate_assignments()

  assignment_base <- "EES_4760_5760_Assignments"
  syllabus_base <- "EES_4760_5760_Syllabus"

  assignment_pdf <- str_c(assignment_base, ".pdf")
  syllabus_pdf <- str_c(syllabus_base, ".pdf")

  create_dir_if_needed <- function(path) {
    if (! dir.exists(path)) {
      dir.create(path, recursive = T)
    }
  }

  rmarkdown::render(file.path(planning_path, str_c(assignment_base, ".Rmd")),
                    clean = TRUE)

  file.copy(file.path(planning_path, assignment_pdf),
            file.path(static_path, "assignment", assignment_pdf),
            overwrite = TRUE)

  knitr::knit2pdf(file.path(planning_path, str_c(syllabus_base, ".Rnw")),
                  clean = TRUE)

  file.copy(file.path(planning_path, syllabus_pdf),
            file.path(static_path, "files", syllabus_pdf),
            overwrite = TRUE)


  setwd(root_path)

  build_site()

  setwd(old_path)
}
