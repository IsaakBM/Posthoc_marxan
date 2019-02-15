
library(doParallel)
library(parallel)

par_posthoc <- function(folder_name, nfolder, outdir) { # folder name? perhaps?
  
  # Create a vector of every folder scenario
    folders <- paste(name, seq(1, nfolder, 1), sep = "")
  # Define the parallel structure
    UseCores <- detectCores() -1
    cl <- makeCluster(UseCores)  
    registerDoParallel(cl)
  # Init
    ls_csv <- list()
    df_ls <- foreach(i = 1:length(folders), .packages = c("dplyr", "tidyr", "readr", "raster", "sf", "lwgeom", "rgdal")) %dopar% {
      
      cat("remains", length(folders) - which(folders == folders[i])+1,"\n")
      ls_csv[[i]] <- posthoc(path = folders[i], outdir = outdir, scenario = i)  
    } 
    stopCluster(cl)
  
  df_final <- do.call(rbind, df_ls)
  return(df_final)
}
