test <- par_posthoc(folder_name = "Scenario", nfolder = 4, outdir = "results/")



a <- read.csv("results/2.csv")
b <- read.csv("results/3.csv")
c <- read.csv("results/4.csv")

df <- rbind(a, b, c)
library(ggplot2)
df$scenario <- as.factor(df$scenario)
df$best_solution <- as.factor(df$best_solution)
str(df)
glimpse(df)

ggplot() +
  geom_point(data = df, aes(x = perimeter, y = new_cost, colour = scenario, shape = best_solution), size = 3) +
  ggsave("results/plot1.pdf")




