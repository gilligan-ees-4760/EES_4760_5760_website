fix_img_files <- function(semester_dir) {
  home = file.path(semester_dir, 'Lectures')
  dirs <- list.dirs(home, recursive=FALSE)
  for (d in dirs) {
    img_dir <- file.path(d, 'images')
    images <- list.files(img_dir)
    for (f in images) {
      f_lower <- tolower(f)
      if (f != f_lower) {
        src = file.path(img_dir, f)
        dest = file.path(img_dir, f_lower)
        message("Renaming file ", src, " to ", dest)
        file.rename(src,dest)
      }
    }
  }
}
