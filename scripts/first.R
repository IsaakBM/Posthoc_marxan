

posthoc <- function(path, scenario, outdir) { # add output_log file
  library(dplyr)
  library(tidyr) # extract_number
  library(readr) # parse_number instead of extract_number
  library(raster)
  library(sf)
  library(lwgeom) # st_perimeter check https://r-spatial.github.io/lwgeom/index.html
  library(rgdal)
  
  # Set wd to start working
    dir <- path
    input <- paste(dir, "/input", sep = "")
    output <- paste(dir, "/output", sep = "")
    shp <- paste(dir, "/CTI_pu", sep = "")
  # Files location
    out_files <- list.files(path = output, pattern = "*_r.*.txt$", full.names = TRUE) # should be 100
    out_log <- list.files(path = output, pattern = "*_log.*.dat$", full.names = TRUE) # should be 100
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
        # Marxan's solution names
          name <- unlist(strsplit(out_files[i], "_"))[2]
            name <- sub(pattern = "*.txt", "", name)
        # Best solution find 
          dt_outlog <- readLines(out_log)
            name_outlog <- dt_outlog[grep("Best solution*", x = dt_outlog)]
              name_outlog <- unlist(strsplit(name_outlog, " "))[5]
      # Extract from the shapefile the object dt
        dt2 <- dt_shp[dt_shp$ET_ID %in% dt$planning_unit, ]  
        dt3 <- dt2 %>% summarise(new_cost = sum(COST, do_union = TRUE)) # keep only ID, cost and geometry
        dt_final <- dt3 %>% mutate(area = st_area(dt3), perimeter = st_perimeter(dt3), solution = name, scenario = scenario, 
                                   best_solution = ifelse(as.character(tidyr::extract_numeric(name)) == name_outlog, "YES", "NO"))
      # Fragmentation process
        dt_final <- dt_final %>% mutate(per_circle = (sqrt(area/pi))*2*pi)
          dt_final <- dt_final %>% mutate(fragmentation = perimeter/per_circle)
        
      ls_geom[[i]] <- dt_final # a list where results will be added
    }
  
  # final objects to work with
    df_geom <- do.call(rbind, ls_geom) # create a dataframe of the previous list
    sp_geom <- as(df_geom, "Spatial") # create an sp object
  # Write files
    st_write(obj = df_geom, dsn = paste(outdir, scenario, ".shp", sep = "")) # some warnings due perimeter, solution and scenario variables... check again
    write.csv(sp_geom@data, paste(outdir, scenario, ".csv", sep = ""), row.names = FALSE)
    
  return(sp_geom@data)
}

