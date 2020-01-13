
library(ggplot2)
library(dplyr)
library(patchwork)



rs_final <- read.csv("Iterations/PostHoc_Calibration.csv")
rs_final$best_solution <- as.factor(rs_final$best_solution)
rs_final$scenario <- as.factor(rs_final$scenario)

unique(rs_final$iteration)


i6 <- rs_final[rs_final$iteration == 6,]
i8 <- rs_final[rs_final$iteration == 8,]

ggplot() +
  geom_point(data = i6, aes(x = perimeter_m, y = new_cost, colour = scenario, shape = best_solution), size = 3) +
  ggsave("Iterations/perimeter_iteration_6.pdf", width = 15, height = 10)
ggplot() +
  geom_point(data = i6, aes(x = fragmentation_m, y = new_cost, colour = scenario, shape = best_solution), size = 3) +
  ggsave("Iterations/fragmentation_iteration_6.pdf", width = 15, height = 10)


p1 <- ggplot() +
  geom_point(data = i6, aes(x = perimeter_m, y = new_cost, colour = scenario, shape = best_solution), size = 3) +
  ggtitle("Perimeter")
p2 <- ggplot() +
  geom_point(data = i6, aes(x = fragmentation_m, y = new_cost, colour = scenario, shape = best_solution), size = 3) +
  ggtitle("Fragmentation")


pf <- p1/p2 + 
  plot_annotation(tag_levels = 'A', tag_suffix = ')') +
  plot_layout(guides = 'collect') & 
  theme_bw(base_size = 15)

pf <- set_last_plot(pf)
ggsave('Iterations/iteration_6.pdf', pf, width = 15, height = 10)
