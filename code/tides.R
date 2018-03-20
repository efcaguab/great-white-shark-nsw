#' Parse data from csv files
#'
#' @param x file with tide data
#'
#' @return a data frame with columns date, value and state
#'
read_tide <- function(x){
  data <- read_csv(x, skip = 31, 
                   col_names = c("date", "time", "value", "state"), 
                   col_types = "ccdc") %>%
    mutate(date = paste(date, time), 
           date = as.POSIXct(date, 
                             tz = "Australia/Sydney", 
                             format = "%d/%m/%Y %H:%M"), 
           value = as.numeric(value)) %>%
    select(-time) 
  
  metadata <- read_csv(x, skip = 20, n_max = 8, col_names = c("var", "value"), 
                       col_types = "cc")
  
  list(data = data, metadata = metadata)
}
