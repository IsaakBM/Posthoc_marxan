
library(dplyr)
library(tidyr) 
library(readr) 
library(raster)
library(sf)
library(lwgeom)
library(doParallel)
library(parallel)

path <- "Iterations"
# Define all the directories 
dir.scenarios <- list.dirs(paste(list.dirs(path = path, full.names = TRUE, recursive = FALSE)), full.names = TRUE, recursive = FALSE)

for(i in 1:length(dir.scenarios)) {
  
  # Define folders per scenario
  folders <- list.dirs(dir.scenarios[i], full.names = TRUE, recursive = FALSE)
  # Files location
  out_files <- list.files(path = folders[2], pattern = "*_r.*.csv$", full.names = TRUE)
  out_log <- list.files(path = folders[2], pattern = "*_log.*.dat$", full.names = TRUE) 
  shp_files <- list.files(path = folders[3], pattern = "*.shp$", full.names = TRUE)
  # Read shapefile just one time 
  dt_shp <- st_read(shp_files) %>% dplyr::select(id, cost, geometry) %>% arrange(id)
  
  # Define the parallel structure
  UseCores <- detectCores() -1
  cl <- makeCluster(UseCores)  
  registerDoParallel(cl)
  
  ls_geom <- list() # empty list to allocate results
  
  geom_list <- foreach(j = 1:length(out_files), .packages = c("sf", "raster", "dplyr", "tidyr", "readr", "lwgeom")) %dopar% {
    
    dt <- read.table(out_files[j], sep = ",", header = TRUE) # read every element from the out_files object
    dt <- dt[(dt[,2] == 1),] %>% rename(id = names(dt[1]), solution = names(dt[2]))
    # Marxan's solution names
    name <- unlist(strsplit(out_files[j], "_"))[2]
    name <- sub(pattern = "*.csv", "", name)
    # Best solution find 
    dt_outlog <- readLines(out_log)
    name_outlog <- dt_outlog[grep("Best solution*", x = dt_outlog)]
    name_outlog <- unlist(strsplit(name_outlog, " "))[5]
    # Extract from the shapefile the object dt
    dt2 <- dt_shp[dt_shp$id %in% dt$id, ]
    head(dt2)
    dt3 <- dt2 %>% dplyr::summarise(new_cost = sum(cost, do_union = TRUE))
    dt_final <- dt3 %>% mutate(area = st_area(dt3), perimeter = st_perimeter(dt3), solution = name, 
                                      scenario = unlist(strsplit(folders[1], split = "/"))[[3]], 
                                      best_solution = ifelse(as.character(readr::parse_number(name)) == name_outlog, "YES", "NO"))
    # Fragmentation process
    dt_final <- dt_final %>% mutate(per_circle = (sqrt(area/pi))*2*pi)
    dt_final <- dt_final %>% mutate(fragmentation = perimeter/per_circle)
    
    ls_geom[[j]] <- dt_final # a list where results will be added
  } 
  stopCluster(cl)
  
  
}


