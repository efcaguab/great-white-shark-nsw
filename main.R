library(drake)

# load functions
functions_folder <- './code'
list_files_with_exts(functions_folder, 'R') %>%
  lapply(source) %>% invisible()
