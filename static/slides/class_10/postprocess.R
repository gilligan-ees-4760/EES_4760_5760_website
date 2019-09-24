postprocess <- function(metadata, input_file, output_file, clean, verbose) {
  ht <- xml2::read_html(output_file)
  nodes <- xml2::xml_find_all(ht, xpath = "//*/li[starts-with(normalize-space(text()), '{')]")
  alt_nodes <- xml2::xml_find_all(ht, xpath = "//*/li[normalize-space(text()) = '']/p[(position() = 1) and starts-with(normalize-space(text()), '{')]")
  li_nodes <- nodes %>% purrr::keep(~xml2::xml_name(xml2::xml_contents(.x)[1]) == "text" &&
                                      stringr::str_detect(xml2::xml_text(xml2::xml_contents(.x)[1]), "^ *\\{[^{]"))
  alt_li_nodes <- alt_nodes %>% purrr::keep(~xml2::xml_name(xml2::xml_contents(.x)[1]) == "text" &&
                                          stringr::str_detect(xml2::xml_text(xml2::xml_contents(.x)[1]), "^ *\\{[^{]"))
  if (verbose) {
    message("Found ", length(li_nodes), " regular nodes and ", length(alt_li_nodes), " alt nodes.")
  }
  index <- 0
  for (n in c(li_nodes, alt_li_nodes)) {
    index <- index + 1
    if (verbose) {
      message("Node ", index, ": ", n)
    }
    head_text <- xml2::xml_contents(n)[1]
    if (xml2::xml_name(head_text) != "text") {
      warning("head_text has type \"", xml2::xml_name(head_text), "\"")
    }
    parts <- stringr::str_match(xml2::xml_text(head_text),
                                "^ *\\{(?<meta>[^}]+)\\} *(?<rest>.*)$")[1,]
    meta <- stringr::str_trim(parts[2])
    rest <- parts[3]
    frag <- stringr::str_starts(meta, stringr::fixed("+"))

    idx  <- stringr::str_match(meta, "^\\+([^[:digit:]]* )?([[:digit:]]+)")[1,3]
    if (is.na(idx)) {
      idx <- stringr::str_match(meta, "(?<![^[:space:]])([[:digit:]]+)(?![^[:space:]])")[1,2]
    }
    if (is.na(idx)) {
      idx <- stringr::str_match(meta, "(?<!^[:space:]])data-fragment-index *= *['\"]([[:digit:]]+)['\"](?![^[:space:]])")[1,2]
    }
    if (! is.na(idx)) {
      idx <- as.integer(idx)
    }

    classes <- stringr::str_match_all(meta, "(?<![^[:space:]])\\.([a-zA-Z-]+(?![^[:space:]]))")[[1]][,2]
    if ("fragment" %in% classes) {
      frag <- TRUE
    } else if (frag) {
      classes <- c(classes, "fragment")
    }

    x_class <- stringr::str_match(meta, "^\\+[^:]*:([a-z-]+)")[1,2]
    if (! is.na(x_class)) {
      if (stringr::str_detect(x_class, "red|green|blue")) {
        x_class <- stringr::str_c("highlight", x_class, sep = "-")
      }
      classes <- c(classes, x_class)
    }
    classes <- unique(classes)

    if (frag) {
      n_name <- xml2::xml_name(n)
      if (n_name == "li") {
        np <- n
      } else {
        if (n_name != "p") {
          warning("node isn't li or p: it's ", n_name)
        }
        np <- xml2::xml_parent(n)
        p_name <- xml2::xml_name(np)
        if (p_name != "li") {
          warning("parent of ", n_name, " is a ", p_name)
        }
      }
      node_classes <- xml2::xml_attr(np, "class")
      if (!is.na(node_classes)) {
        node_classes <- stringr::str_split(node_classes, " ")[[1]]
        classes <- c(classes, node_classes)
      }
      classes <- classes %>% unique() %>% stringr::str_c(collapse = " ") %>% stringr::str_trim()
      xml2::xml_set_attr(np, "class", classes)
      if (! is.na(idx)) {
        xml2::xml_set_attr(np, "data-fragment-index", idx)
      }
      xml2::xml_set_text(n, rest)
    }
  }
  if (!clean) {
    temp_file <- file.path(dirname(output_file), stringr::str_c("tmp_", basename(output_file)))
    if (file.exists(temp_file)) {
      file.remove(temp_file)
    }
    file.rename(output_file, temp_file)
  }
  xml2::write_html(ht, file = output_file)
}
