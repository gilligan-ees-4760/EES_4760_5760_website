library(tidyverse)
library(snakecase)

data <- read_csv("Explore-headings-output.csv", skip = 5, name_repair = to_snake_case)

data  |> mutate(avg_heading = (stationary_turtle_heading + moving_turtle_heading) / 2, 
                diff = ordered(abs(stationary_turtle_heading - moving_turtle_heading)))  |> 
  ggplot(aes(x = avg_heading, y = average_flockmate_heading, color = diff)) + 
  geom_point(size = 2) + 
  scale_x_continuous(breaks = seq(-360, 360, 90)) + 
  scale_y_continuous(breaks = seq(-360, 360, 90)) + 
  scale_color_viridis_d(option = "magma", name = "Heading difference") + 
  labs(x = "Arithmetic average of headings", y = "Actual average flockmate heading") + 
  theme_gray(base_size = 20)
