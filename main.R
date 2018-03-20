library(drake)
library(dplyr)
library(tools)
library(readr)
library(stringr)
library(TideHarmonics)
library(purrr)

# load functions
functions_folder <- './code'
list_files_with_exts(functions_folder, 'R') %>%
  lapply(source) %>% invisible()

# list raw files with tide data
tide_files <- list_files_with_exts('./data/tides', 'csv')
tide_names <- basename(tide_files) %>% file_path_sans_ext() %>% 
  str_extract("^([A-Z])\\w+")
tide_files <- paste0("'", tide_files, "'")

# make a plan to read the data
tides_read <- drake_plan(
  raw = read_tide(FILE)
) %>%
  evaluate_plan(rules = list(FILE = tide_files), expand = T) %>%
  mutate(target = paste("raw", tide_names, sep = "_"))

# make a plan to fit tide data
tides_fit <- drake_plan(
  model = fit_tide(raw_NAME)
) %>%
  evaluate_plan(rules = list(NAME = tide_names))

# make a plan to compute corrected tide data
tides_pred <- drake_plan(
  fit = predict_tide(model_NAME, raw_NAME)
) %>%
  evaluate_plan(rules = list(NAME = tide_names))

tides_gather_pred <- tides_pred %>%
  gather_plan("predictions", "gather_predictions")

tides_gather_meta <- tides_read %>%
  gather_plan("metadata", "gather_metadata")

# gather plan
plan <- rbind(tides_read, tides_fit)
config <- drake_config(plan)
vis_drake_graph(config)

# run plan
make(plan)

