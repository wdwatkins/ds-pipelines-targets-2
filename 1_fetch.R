source("1_fetch/src/get_nwis_data.R")
p1_targets_list <- list(
  #map over site list downloading each site, with retry; then combine
  #or just download in one web service call...
  
  tar_target(
    p1_sites,
    c("01427207", "01432160", "01435000", "01436690", "01466500")
  ),
  tar_target(
    p1_site_data_frames,
    retry(get_nwis_site_data(p1_sites, parameterCd = '00010', 
                             startDate="2014-05-01", endDate="2015-05-01"),
          max_tries = 4,
          when = 'failed',
          interval = 0.5),
    pattern = map(p1_sites),
    error = 'continue'
  ),
  tar_target(
    p1_nwis_data_csv,
    {out_file <- '2_process/out/site_data.csv'
    write_csv(bind_rows(p1_site_data_frames), file = out_file)
    return(out_file)
    }
  ),
  #this works as is
  tar_target(
    p1_site_info,
    nwis_site_info(nwis_data_file = p1_nwis_data_csv)
  )
)
