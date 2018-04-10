source('scripts/process_bs.R', echo=FALSE)

library(viridis)

bs <- bs_data('data/wild_dogs big-sensitivity-analysis-table.csv')
df <- bs$data
x <- df %>% group_by(carrying.capacity, mortality.adult, mortality.disperser, mean.meeting.rate) %>%
  summarize(n.100 = sum(tick == 100), n.survive = sum(count.dogs > 0),
            frac.100 = sum(tick == 100) / n(),
            frac.survive = sum(count.dogs > 0) / n(),
            count = n(), max.year = max(tick)) %>%
  ungroup()

y <- x %>%
  mutate(carrying.capacity = ordered(carrying.capacity, levels = unique(carrying.capacity),
                                     labels = str_c("Carrying capacity: ", unique(carrying.capacity))),
         mortality.adult = ordered(mortality.adult , levels = unique(mortality.adult),
                                   labels = str_c("Adult mortality: ", unique(mortality.adult))))

p <- ggplot(y, aes(x = mortality.disperser, y = mean.meeting.rate,
                   fill = 100 * (1 - frac.survive), z = 100 * (1 - frac.survive))) +
  geom_raster(interpolate=TRUE) +
  scale_x_continuous(expand = expand_scale(0,0)) +
  scale_y_continuous(expand = expand_scale(0,0)) +
  # scale_fill_distiller(type = "seq", palette = "Blues") +
  expand_limits(fill = seq(0,100,10)) +
  scale_fill_viridis(option = "viridis", limits = c(0, 100), expand = expand_scale(0,0), name = "% extinct\nwithin\n100 years") +
  facet_grid(mortality.adult ~ carrying.capacity) +
  labs(x = "Disperser mortality rate", y = "Disperser meeting rate") +
  theme_bw(base_size = 20) +
  theme(legend.key.height = grid::unit(0.15, "npc"))
print(p)
