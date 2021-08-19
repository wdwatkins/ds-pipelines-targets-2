process_data <- function(nwis_data, site_filename){
  site_info <- read_csv(site_filename)
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
  
  return(nwis_data_clean)
}
