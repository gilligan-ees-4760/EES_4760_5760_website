#
# Initialize semester directory info
#

find_semester_dir <- function(p = NULL) {
  if (is.null(p)) p <- getwd()
  p <- normalizePath(p)
  if (file.exists(file.path(p,'semester.yml'))) {
    return(p)
  } else {
    d <- dirname(p)
    if (d == p) return(NA)
    return(find_semester_dir(d))
  }
}


if(!exists('semester.dir') || ! dir.exists(semester.dir) || ! file.exists(file.path(semester.dir, 'semester.yml'))) {
#  message("Creating semester.dir")
  semester.dir <- find_semester_dir()
} else {
#  message("Semester.dir exists:", semester.dir, '\n')
}

if(!exists('script.dir') || ! dir.exists(script.dir)) script.dir <- file.path(semester.dir, 'util_scripts')
if(!exists('data.dir') || ! dir.exists(data.dir)) data.dir <- file.path(semester.dir,'data')

#message('Data dir = ', data.dir, " and it ", ifelse(dir.exists(data.dir), 'exists.', 'does not exist.'))
