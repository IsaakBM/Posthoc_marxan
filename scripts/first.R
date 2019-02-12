
library(dplyr)
library(tidyr)
library(raster)
library(sf)
library(rgdal)

# 1. first step "clean"
  path <- list.files(path = "scenarios", pattern = "*.txt", full.names = TRUE)
  out_dt <- read.table(path, sep = ",", header = TRUE)
    out_dt <- out_dt[out_dt$solution == 1,]
    nrow(out_dt)
  head(out_dt)
  
# 2. step read shapefile
  path2 <- list.files(path = "CTI_pu", pattern = "*.shp", full.names = TRUE)[1]
  dt_shp <- st_read(path2)
  colnames(dt_shp)
  dt_shp <- dt_shp %>% select(ET_ID, COST, geometry)
    
  out_dt <- out_dt %>% arrange(planning_unit)
  dt_shp <- dt_shp %>% arrange(ET_ID)
  
  
  trial <- dt_shp[dt_shp$ET_ID %in% out_dt$planning_unit, ]
    head(trial); nrow(trial)
    head(out_dt)
  trial_sp <- as(trial, "Spatial")
  
  # writeOGR(trial_sp, layer = "trial_sp", dsn = "CTI_pu/", driver = "ESRI Shapefile")
  
  # 3. sum all cost column and merge
  
  trial2 <- trial %>% summarise(new_cost = sum(COST, do_union = TRUE))
  trial2_sp <- as(trial2, "Spatial")
  
  # this should be 1.74
  
  writeOGR(trial2_sp, layer = "trial2_sp", dsn = "CTI_pu/", driver = "ESRI Shapefile")
  
  
  
  # 4. add a column with perimeter and area
  
  
  
  # 5. output should be a dataframe cost, ID scenario, ID solution (from 1 to 100), area, perimeter
  #     and a shapefile
  


  
  
  
  # from output_log.dat file extract ()


