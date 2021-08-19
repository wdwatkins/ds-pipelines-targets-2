source("2_process/src/process_and_style.R")

p2_targets_list <- list(
  tar_target(
    p2_site_data_clean_csv, 
    process_data(out_file = '2_process/out/site_data_clean.csv', 
                 nwis_data_file = p1_nwis_data_csv, p1_site_info),
    format = 'file'
  )
)