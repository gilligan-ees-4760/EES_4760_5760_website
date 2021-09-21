library(tidyverse)

survey_dir <- file.path("../EES-4760-course-material/",
                        "Grades/")
survey_file <- file.path(survey_dir, "project-survey.csv")

survey <- read_csv(survey_file, skip = 1,
                   col_names = c("section", "q_num", "q_type", "q_title",
                                 "q_text", "bonus", "diff",
                                 "ans", "ans_match", "n_resp"),
                   col_types = cols(n_resp = col_integer(),
                                    q_num = col_integer(),
                                      .default = col_character()))

name_replacements <- c("Nolan S$" = "Nolan Siegel",
                       "Nolan$" = "Nolan Siegel",
                       "Clark$" = "Clark Kaminsky",
                       "Madeline C. Allen" = "Madeline Allen",
                       "Gonzalvez" = "Gonzalez")

survey_2 <- survey %>% select(name = section, q_num, q_title, ans, ans_match,
                            n_resp) %>%
  mutate(
    name = accumulate(name, function(last, this) {
      if (is.na(this))
        last
      else
        this
      }),
    ans = ifelse(q_num == 2, ans_match, ans),
    question = c("project", "teammates")[q_num]
  ) %>%
  filter(! is.na(ans), is.na(n_resp) | n_resp > 0) %>%
  select(name, question, ans) %>%
  group_by(name, question) %>%
  summarize(ans = list(ans), .groups = "drop") %>%
  pivot_wider(names_from = "question", values_from = "ans") %>%
  mutate(teammates = map2_chr(name, teammates,
                              ~c(.x, .y) %>%
                                str_replace_all(name_replacements) %>%
                                sort %>%
                                str_c(collapse = ", ")),
         project = map_chr(project, ~str_c(.x, collapse = ", "))) %>%
  select(-name) %>%
  arrange(project, teammates) %>%
  distinct()

