p2 <- predictions %>%
  dplyr::filter(date > min(hl_tides$date),
                date < max(hl_tides$date))

plot(p2$date, p2$value)

min <- 1
max <- 2


a <- approx(hl_tides$height[min:max], c(0, 1), 
       dplyr::filter(predictions, 
                     date >= hl_tides$date[min],
                     date <= hl_tides$date[max])$value) %>%
  as.data.frame() %>%
  cbind(dplyr::filter(predictions, 
                      date >= hl_tides$date[min],
                      date <= hl_tides$date[max]))


min <- 2
max <- 3


b <- approx(hl_tides$height[min:max], c(1, 0), 
            dplyr::filter(predictions, 
                          date >= hl_tides$date[min],
                          date <= hl_tides$date[max])$value) %>%
  as.data.frame() %>%
  cbind(dplyr::filter(predictions, 
                      date >= hl_tides$date[min],
                      date <= hl_tides$date[max]))

rbind(a, b) %$%
  plot(date, y)
