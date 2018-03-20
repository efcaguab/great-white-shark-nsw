#' Parse data from csv files
#'
#' @param x file with tide data
#'
#' @return a data frame with columns date, value and state
#'
read_tide <- function(x){
  # read files
  data <- read_csv(x, skip = 31, 
                   col_names = c("date", "time", "value", "state"), 
                   col_types = "ccdc") %>%
    # extract date from data
    mutate(date = paste(date, time), 
           date = as.POSIXct(date, 
                             tz = "Australia/Sydney", 
                             format = "%d/%m/%Y %H:%M"), 
           # make sure value is treated as numeric
           value = as.numeric(value)) %>%
    select(-time) 
  
  # extract some metadata about the sites
  metadata <- read_csv(x, skip = 20, n_max = 8, col_names = c("var", "value"), 
                       col_types = "cc")
  
  list(data = data, metadata = metadata)
}

fit_tide <- function(x){
  # make sure there is not NA date values
  x$data <- x$data %>%
    filter(!is.na(date))
  
  # predict tides with as many harmonics as possible
  t <- ftide(x$data$value, x$data$date, TideHarmonics::hc114)
  
  list(fit = t, metadata = x$metadata)
}

