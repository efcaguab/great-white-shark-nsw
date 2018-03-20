library(drake)
library(dplyr)
library(tools)
library(readr)
library(stringr)

# load functions
functions_folder <- './code'
list_files_with_exts(functions_folder, 'R') %>%
  lapply(source) %>% invisible()

tide_files <- list_files_with_exts('./data/tides', 'csv')
tide_names <- basename(tide_files) %>% file_path_sans_ext() %>% 
  str_extract("^([A-Z])\\w+")
tide_files <- paste0("'", tide_files, "'")

tides_plan <- drake_plan(
  raw = read_tide(FILE)
) %>%
  evaluate_plan(rules = list(FILE = tide_files), expand = T) %>%
  mutate(target = paste("raw", tide_names, sep = "_"))

plan <- rbind(tides_plan)

config <- drake_config(plan)
vis_drake_graph(config)
make(tides_plan)

