
library(dplyr)
library(tidyr)
library(raster)
library(sf)
library(lwgeom) # st_perimeter check https://r-spatial.github.io/lwgeom/index.html
library(rgdal)

posthoc <- function(path) {
  # Set wd to start working
    dir <- path
    input <- paste(dir, "/input", sep = "")
    output <- paste(dir, "/output", sep = "")
    shp <- paste(dir, "/CTI_pu", sep = "")
  # Files location
    out_files <- list.files(path = output, pattern = "*_r.*.txt$", full.names = TRUE) # should be 100
    shp_files <- list.files(path = shp, pattern = "*.shp$", full.names = TRUE) # should be 1
  # Read shapefile just one time 
    dt_shp <- st_read(shp_files) %>% dplyr::select(ET_ID, COST, geometry)
      dt_shp <- dt_shp %>% arrange(ET_ID)
  # Loop to read and do spatial calcualtions
    ls_geom <- list() # empty list to allocate results
    for (i in 1:length(out_files)) {

      dt <- read.table(out_files[i], sep = ",", header = TRUE) # read every element from the out_files object
        dt <- dt[dt$solution == 1,] # keep just the selected planning units
        dt <- dt %>% arrange(planning_unit)
      # Extract from the shapefile dt
        dt2 <- dt_shp[dt_shp$ET_ID %in% dt$planning_unit, ]  
        dt3 <- dt2 %>% summarise(new_cost = sum(COST, do_union = TRUE)) # keep only ID, cost and geometry
        dt_final <- dt3 %>% mutate(area = st_area(trial2), perimeter = st_perimeter(trial2))
      
        ls_geom[[i]] <- dt_final # a list where results will be added


    }
    
    df_geom <- do.call(rbind, ls_geom) # create a dataframe of the previous list
    sp_geom <- as(df_geom, "Spatial")
  
  # final <- c(input, output, shp)
  return(df_geom)
  
}


system.time(a <- posthoc(path = "Scenario1"))
out_files <- list.files(path = a[2], pattern = "*_r.*.txt$", full.names = TRUE) 

shp <- list.files(path = a[3], pattern = "*.shp$", full.names = TRUE)
dt_shp <- st_read(shp) %>% dplyr::select(ET_ID, COST, geometry)
dt_shp <- dt_shp %>% arrange(ET_ID) 

ls_trial <- list()

for (i in 1:length(out_files)) {
  
  dt <- read.table(out_files[i], sep = ",", header = TRUE)
    dt <- dt[dt$solution == 1,]
    dt <- dt %>% arrange(planning_unit)
  dt2 <- dt_shp[dt_shp$ET_ID %in% dt$planning_unit, ]  
  dt3 <- dt2 %>% summarise(new_cost = sum(COST, do_union = TRUE))
  dt_final <- dt3 %>% mutate(area = st_area(trial2), perimeter = st_perimeter(trial2))
  
  ls_trial[[i]] <- dt_final
  
}

df_geom <- do.call(rbind, ls_trial)
sp_geom <- as(df_geom, "Spatial")

plot(df_geom$perimeter, df_geom$new_cost)


# 1. Clean scenarios files
  path <- list.files(path = output, pattern = "*_r.*.txt$", full.names = TRUE)
  out_dt <- read.table(path, sep = ",", header = TRUE)
    out_dt <- out_dt[out_dt$solution == 1,] # keep just the selected planning units
# 2. Read shapefile
  path2 <- list.files(path = "CTI_pu", pattern = "*.shp$", full.names = TRUE)
  dt_shp <- st_read(path2)
  dt_shp <- dt_shp %>% dplyr::select(ET_ID, COST, geometry) # keep only ID, cost and geometry
  # arrange by ID (just in case)
    out_dt <- out_dt %>% arrange(planning_unit)
    dt_shp <- dt_shp %>% arrange(ET_ID)
  # select from shapefile the output planning units previously filtered
    trial <- dt_shp[dt_shp$ET_ID %in% out_dt$planning_unit, ]
    # trial_sp <- as(trial, "Spatial") # from sf to sp object
# 3. Analyses
    # merge polygons and calculate sum of cost
    trial2 <- trial %>% summarise(new_cost = sum(COST, do_union = TRUE))
      # area + perimeter of new polygon (check area according to projection!!!)
      trial2 <- trial2 %>% mutate(area = st_area(trial2), perimeter = st_perimeter(trial2))
    
    
    trial2_sp <- as(trial2, "Spatial")
    
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


