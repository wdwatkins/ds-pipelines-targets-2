library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval", "retry")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

p1_targets_list <- list(
  #map over site list downloading each site, with retry; then combine
  #or just download in one web service call...
  
  tar_target(
    sites,
    c("01427207", "01432160", "01435000", "01436690", "01466500")
  ),
  tar_target(
    site_data_frames,
    retry(get_nwis_site_data(sites, parameterCd = '00010', 
                             startDate="2014-05-01", endDate="2015-05-01"),
          max_tries = 4,
          when = 'failed',
          interval = 0.5),
    pattern = map(sites),
    error = 'continue'
  ),
  tar_target(
    site_data,
    bind_rows(site_data_frames),
  ),
  #this works as is
  tar_target(
    site_info_csv,
    nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data),
    format = "file"
  )
)

#combine to one target
p2_targets_list <- list(
  tar_target(
    site_data_clean, 
    process_data(site_data, site_filename = site_info_csv)
  )
)

p3_targets_list <- list(
  tar_target(
    figure_1_png,
    plot_nwis_timeseries(fileout = "3_visualize/out/figure_1.png", site_data_clean),
    format = "file"
  )
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
