#
#
#
#
#
#
#
#
#
#
packages = c("ggplot2", "readxl", "dplyr", "tidyr", "xtable")
# Install packages not yet installed
installed_packages = packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}
# Packages loading
invisible(lapply(packages, library, character.only = TRUE))
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
data = read.csv2(file = "C:/your/path/data_to_open.csv")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
write.csv2(data, file = "C:/your/path/temp/name_of_the_dataset.csv", row.names = FALSE)
#
#
#
#
#
#
#
#
#
#
#
path = "C:/Users/mateomoglia/Dropbox/courses/polytechnique/2027_eco51432ep"

data = read.csv2(file = paste0(path, "/raw_data/idf_data.csv"))
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
merged_df = left_join(df1, df2, by = "codgeo")
#
#
#
#
#
merged_df = left_join(df1, df2, by = c("codgeo" = "code_commune"))
#
#
#
#
#
merged_df = df1 %>%
  left_join(df2, by = "codgeo")
#
#
#
#
#
#
#
#
#
#
nrow(df1)                                            # rows you started with
nrow(merged_df)                                      # rows you ended with
df1 %>% anti_join(df2, by = "codgeo") %>% nrow()     # left rows with no match
#
#
#
#
#
#
#
#
#
#
#
#
#
#
data_long = data_wide %>%
  tidyr::pivot_longer(
    cols = starts_with("pop"), # Might have used -codgeo
    names_to = "year",         # New col name
    values_to = "population",  # New col name
    names_prefix = "pop"       # Remove the prefix 
  ) %>%
  mutate(year = as.integer(year)) # Not necessary, but usually year is numeric
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#-------------------------------------------------------------------------------
# 1_build_idf_data.R
# Builds the main dataset for the class: population, CSP, rents.
#
# Author: your name
# Date: today
#-------------------------------------------------------------------------------

library(dplyr)
library(tidyr)

path = "C:/Users/mateomoglia/Dropbox/courses/polytechnique/2027_eco51432ep"

# 1. Open and inspect ----------------------------------------------------------

pop = read.csv2(file = paste0(path, "/raw_data/idf_pop.csv"))

str(pop)      # every numeric column must be num or int, and codgeo must be chr
summary(pop)  # look at the min and the max of every column

# 2-4. Population in the most recent year --------------------------------------

pop_last = pop %>%
  select(codgeo, starts_with("population")) %>%
  pivot_longer(
    cols = starts_with("population"),
    names_to = "year",
    values_to = "population",
    names_prefix = "population"
  ) %>%
  mutate(year = as.integer(year)) %>%
  filter(year == max(year, na.rm = TRUE)) # a function, not a hardcoded 2021

# 5. Population by CSP ---------------------------------------------------------

pop_csp = pop %>%
  select(codgeo, agri, cadre, profint, employ, ouvri, retraite, autsap)

# 6-7. Rents -------------------------------------------------------------------

rents = read.csv2(file = paste0(path, "/raw_data/idf_rents.csv")) %>%
  select(codgeo, rent_appartement, rent_house)

# 8. Merge, and check ----------------------------------------------------------

idf_data = pop_last %>%
  left_join(pop_csp, by = "codgeo") %>%
  left_join(rents,   by = "codgeo")

nrow(pop_last)                                          # expected
nrow(idf_data)                                          # obtained: must be equal
pop_last %>% anti_join(rents, by = "codgeo") %>% nrow()  # municipalities with no rent

# 9. Save ----------------------------------------------------------------------

write.csv2(idf_data,
           file = paste0(path, "/temp/idf_data.csv"),
           row.names = FALSE)

sessionInfo()
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
