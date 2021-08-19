process_data <- function(out_file, nwis_data_file, site_info){
  #site_info <- read_csv(site_filename)
  nwis_data <- read_csv(nwis_data_file, col_types = 'ccTdcccc')
  nwis_data_clean <- rename(nwis_data, 
                            water_temperature = X_00010_00000) %>% 
    select(-agency_cd, -X_00010_00000_cd, -tz_cd) %>% 
    left_join(site_info, by = "site_no") %>% 
    select(station_name = station_nm, 
           site_no, 
           dateTime, 
           water_temperature, 
           latitude = dec_lat_va, 
           longitude = dec_long_va) %>% 
    mutate(station_name = as.factor(station_name))
  
  write_csv(nwis_data_clean, file = out_file)
  return(out_file)
}
