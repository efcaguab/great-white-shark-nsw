high_lows <- function(predictions) {
  predictions %>%
    rename(height = value) %>%
    split(.$name) %>%
    map_df(get_high_low_table) %>%
    rename(tide = h_l) %>%
    mutate(tide = if_else(tide, "high-tide", "low-tide")) %>%
    select(-l_m_m)
}

# to find high and low tide times -----------------------------------------

# This is the main function. Uses inflection and max/min functions to find high
# and low tide times. Input for is a data frame with a column named height
# Output is a data frame containing only the rows in which tide is high (TRUE)
# or low (FALSE)
get_high_low_table <- function(height){
  l_m_m <- inflection(height$height)
  h_l <- max_or_min(height$height, l_m_m)
  height %>%
    dplyr::slice(l_m_m) %>%
    dplyr::mutate(l_m_m = l_m_m, 
                  h_l = h_l) %>%
    dplyr::filter(!is.na(h_l), l_m_m != 1)
}

# use first derivative to find inflexion points
inflection <- function(x) {
  # Use -Inf instead if x is numeric (non-integer)
  y <- diff(c(-.Machine$integer.max, x)) > 0L
  rle(y)$lengths
  y <- cumsum(rle(y)$lengths)
  # y <- y[seq.int(1L, length(y), 2L)]
  if (x[[1]] == x[[2]]) {
    y <- y[-1]
  }
  y
}

# using second derivative to determine wether inflexion points are maxima or minima
max_or_min <- function(x, z = inflection(x)) {
  # Use -Inf instead if x is numeric (non-integer)
  y <- diff(c(-.Machine$integer.max, x), differences = 2) > 0L
  !y[z]
}
