aggregate_tides <- function(predictions, by = "1 hour"){
  predictions %>%
    split(.$name) %>%
    map_df(aggregate_tide, by)
}

aggregate_tide <- function(x, by){
  x %>%
    mutate(date_interval = cut(date, breaks = by)) %>%
    group_by(date_interval) %>%
    summarise(date = first(date),
              mean_height = mean(value), 
              name = first(name)) %>%
    group_by() %>%
    select(-date_interval)
}
