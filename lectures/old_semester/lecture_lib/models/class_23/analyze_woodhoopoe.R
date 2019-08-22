library(dplyr)
library(readr)
library(magrittr)
library(tidyr)
library(stringr)
library(purrr)
library(ggplot2)

calibration <- bs_data("Sect20-5_WoodHoopoes Calibration-table.csv")
df <- calibration$data
df <- df %>% rename(population = count.turtles,
                    vacancies = count.patches.with.count.turtles.here.with.is.alpha.2.)
df2 <- df %>% filter(month == 11 & year >= 3)
df2_sum <- df2 %>% group_by(run) %>%
  summarize(scout.prob = mean(scout.prob), survival.prob = mean(survival.prob),
            mean.pop = mean(population), sd.pop = sd(population),
            vacancies = mean(vacancies) / 25.0) %>% ungroup() %>%
  mutate(mean.abundance = (mean.pop >= 115 & mean.pop <= 135),
         variation = (sd.pop >= 10 & sd.pop <= 15),
         vacancy = (vacancies >= 0.15 & vacancies <= 0.30))

ggplot(df2_sum, aes(x = scout.prob, y = survival.prob)) +
  geom_point(aes(shape = I(ifelse(mean.abundance, "Abundance", NA)),
                 size = "Abundance")) +
  geom_point(aes(shape = I(ifelse(variation, "Variation", NA)),
                 size = "Variation")) +
  geom_point(aes(shape = I(ifelse(vacancy, "Vacancy", NA)),
                 size = "Vacancy")) +
  scale_shape_manual(values = c(Abundance = 3, Variation = 0, Vacancy = 19),
                     breaks = c("Abundance", "Variation", "Vacancy"),
                     name = NULL) +
  scale_size_manual(values = c(Abundance = 3, Variation = 3, Vacancy = 2),
                    breaks = c("Abundance", "Variation", "Vacancy"),
                    name = NULL) +
  labs(x = "Scouting Probability", y = "Survival Probability")

ggplot(df2_sum, aes(x = survival.prob, y = mean.pop, color = ordered(scout.prob))) +
  geom_point() + geom_line() +
  geom_hline(yintercept = c(115,135), color = "gray10") +
  labs(x = "Survival Probability", y = "Mean Population") +
  guides(colour = guide_legend(title = "Scouting Probability")) +
  theme(legend.position = c(0,1), legend.justification = c(0,1),
        legend.background = element_blank())
#        legend.background = element_rect(fill = "gray92"))
