
library(ggplot2)
library(dplyr)

# Read every .csv file from the folder (where you put them all together) # you can change the directory!!!!
  rs6 <- read.csv("ydataframes/finalresults6.csv")
  rs7 <- read.csv("ydataframes/finalresults7.csv")
  rs8 <- read.csv("ydataframes/finalresults8.csv")
  rs9 <- read.csv("ydataframes/finalresults9.csv")

# This is a simple function to convert some columns into factors
  data_manipulation <- function(df) {
    
    df$scenario <- as.factor(df$scenario)
    df$best_solution <- as.factor(df$best_solution)
    
    return(df)
  }

# Apply this function to every data frame and then add a new colum "it" which means interation
  rs6 <- data_manipulation(rs6)
    rs6$it <- as.factor("it6")
  rs7 <- data_manipulation(rs7)
    rs7$it <- as.factor("it7")
  rs8 <- data_manipulation(rs8)
    rs8$it <- as.factor("it8")
  rs9 <- data_manipulation(rs9)
    rs9$it <- as.factor("it9")
  # Merge data frames into onw 
    rs_list <- list(rs6, rs7, rs8, rs9)
    rs_final <- do.call(rbind, rs_list)


# Plotting
  # Plot without including it as an argument (original plots maybe?)
    # Perimeter
      ggplot() +
        geom_point(data = rs_final, aes(x = perimeter, y = new_cost, colour = scenario, shape = best_solution), size = 3) +
        ggsave("results/plot02_perimeter.pdf", width = 15, height = 10)
    # Fragmentation
      ggplot() +
        geom_point(data = rs_final, aes(x = fragmentation, y = new_cost, colour = scenario, shape = best_solution), size = 3) +
        ggsave("results/plot02_fragmentation.pdf", width = 15, height = 10)

  # Plot including it as an argument (original plots maybe?)
    # Option 1
      ggplot() +
        geom_point(data = rs_final, aes(x = perimeter, y = new_cost, colour = scenario, shape = it), size = 2) +
        ggsave("results/plot03_a_perimeter.pdf", width = 15, height = 10)
    # Option 2
      ggplot() +
        geom_point(data = rs_final, aes(x = perimeter, y = new_cost, colour = it, shape = best_solution), size = 2) +
        ggsave("results/plot03_b_perimeter.pdf", width = 15, height = 10)
    # Option 2
      ggplot() +
        geom_point(data = rs_final, aes(x = perimeter, y = new_cost, colour = scenario, shape = it), size = 3) +
        facet_wrap( ~ best_solution) +
        ggsave("results/plot03_c_perimeter.pdf", width = 15, height = 10)
