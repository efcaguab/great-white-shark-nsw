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
           date = lubridate::dmy_hms(date, tz = "Australia/Sydney"),
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

predict_tide <- function(x, y, by = 0.25){
  
  # get minimum and maximum time from the data
  min_date <- min(y$data$date, na.rm = T)
  max_date <- max(y$data$date, na.rm = T)
  
  # build predictions at the specified interval
  p <- data_frame(date = seq(min_date, max_date, by = paste(round(by * 60), "min")), 
             value = predict(x$fit, min_date, max_date, by = by))
  
  list(pred = p, metadata = x$metadata)
}


error <- function(raw, fit){
  raw <- readd(raw_BallinaBreakwall)
  fit <- readd(fit_BallinaBreakwall)
  a <- dplyr::inner_join(raw$data, fit$pred, by = "date") %>%
    dplyr::mutate(diff = value.x - value.y) %>%
    filter(date > as.POSIXct("2017-01-01"), date < as.POSIXct("2018-01-01"))
  
  plot(a$date, a$diff, "l")
}
