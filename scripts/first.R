
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
    
    # 5. output should be a dataframe cost, ID scenario, ID solution (from 1 to 100), area, perimeter
    #     and a shapefile
    # writeOGR(trial_sp, layer = "trial_sp", dsn = "CTI_pu/", driver = "ESRI Shapefile")
}
