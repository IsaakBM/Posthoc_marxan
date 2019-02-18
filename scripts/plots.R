test <- par_posthoc(folder_name = "Scenario", nfolder = 14, outdir = "results/")



# a <- read.csv("results/2.csv")
# b <- read.csv("results/3.csv")
# c <- read.csv("results/4.csv")
# 
# df <- rbind(a, b, c)
library(ggplot2)
library(dplyr)
test$scenario <- as.factor(test$scenario)
test$best_solution <- as.factor(test$best_solution)
str(test)
glimpse(test)

df2 <- df[df$best_solution == "YES", ]
df2 <- mutate(xmin = min(df$perimeter), xmax = )


q <- df %>% 
  group_by(df$scenario) %>% 
  summarise(min_per = min(perimeter), max_per = max(perimeter)) %>% 
  data.frame()


dodge <- position_dodge(width = 0.5)
test$scenario <- as.factor(test$scenario)
test$best_solution <- as.factor(test$best_solution)
ggplot() +
  geom_point(data = test, aes(x = perimeter, y = new_cost, colour = scenario, shape = best_solution), size = 3) +
  # geom_errorbar(data = df, aes(ymax = max(df$perimeter), ymin = min(df$perimeter)), position = dodge)
  ggsave("results/plot1.pdf", width = 15, height = 10)
ggplot() +
  geom_point(data = test, aes(x = fragmentation, y = new_cost, colour = scenario, shape = best_solution), size = 3) +
  # geom_errorbar(data = df, aes(ymax = max(df$perimeter), ymin = min(df$perimeter)), position = dodge)
  ggsave("results/plot2.pdf", width = 15, height = 10)


  
  ggplot() +
    geom_point(data = df, aes(x = perimeter, y = new_cost, colour = scenario)) +
    geom_point(data = df2, aes(x = perimeter, y = new_cost, shape = best_solution)) +
    # geom_errorbar(data = df2, aes(x = perimeter, y = perimeter, ymax = perimeter, ymin = perimeter))
  ggsave("results/plot1.pdf")

  df3 <- cbind(df2, q$min_per, q$max_per)
  
  p1 <- ggplot() +
    geom_point(data = df, aes(x = perimeter, y = new_cost, colour = scenario)) +
    geom_point(data = df2, aes(x = perimeter, y = new_cost, shape = best_solution))
    
    

  
  p2 <- ggplot(data = df3, aes(x = df3$perimeter, y = df3$new_cost)) + 
          geom_point() + 
          # geom_errorbar(aes(ymin = ymin,ymax = ymax)) +
          geom_errorbarh(aes(xmin = df3$`q$min_per`,xmax = df3$`q$max_per`))
  
  
  
  
  
  geom_errorbarh(data = q, aes(xmin = q$min_per, xmax = q$max_per))
  
  

  q <- data.frame(x = 1:10,
                   y = 1:10,
                   ymin = (1:10) - runif(10),
                   ymax = (1:10) + runif(10),
                   xmin = (1:10) - runif(10),
                   xmax = (1:10) + runif(10))
  
  ggplot(data = q,aes(x = x,y = y)) + 
    geom_point() + 
    geom_errorbar(aes(ymin = ymin,ymax = ymax)) + 
    geom_errorbarh(aes(xmin = xmin,xmax = xmax))
  