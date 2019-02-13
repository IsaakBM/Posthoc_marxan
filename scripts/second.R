test <- posthoc(path = "Scenario1", outdir = "scripts/", scenario = "1")


folders <- paste("Scenario", seq(1, 20, 1), sep = "")

ls_csv <- list()
for (j in 1:length(sc_files)) {
  
  cat("remains", length(sc_files) - which(sc_files == sc_files[k])+1,"\n")
  ls_csv[[j]] <- test <- posthoc(path = folders[i], outdir = "CSV/", scenario = i)  
  
}

# do a parallel on this function
