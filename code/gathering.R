gather_predictions <- function(...){
  p <- list(...)
  
  p %>%
    map_df(~ mutate(.$pred, 
                    name = str_extract(filter(.$metadata, var == "Station Name")$value, 
                                       "^([A-Z])\\w+")))
}

gather_metadata <- function(...){
  p <- list(...)
  
  p %>%
    map_df(~ mutate(.$metadata, 
                    name = str_extract(filter(.$metadata, var == "Station Name")$value, 
                                       "^([A-Z])\\w+")))
}
