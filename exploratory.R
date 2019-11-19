# Import
library(readxl)
library(tidyverse)
library(ggplot2)
library(reshape2)
library(DataExplorer)

co_data <- read_xlsx('data/raw/2018_GEI_1ENER.xlsx', sheet = 'TEST', na = c(' ', '-', ''), trim_ws = T, progress = T) 
co_data_clean <- co_data %>% select(-1)
co_data_renamed <- co_data_clean %>% rename(categoria_generador = `Categorías de fuente y sumidero de gases de efecto invernadero`)
co_data_long <- melt(co_data_renamed, variable.name = 'ano', value.name = 'co2')

# plot missing data per year
plot_missing(co_data_renamed)

# plot missing data per category
co_data_rotated <- data.frame(t(co_data_renamed), stringsAsFactors = F)
colnames(co_data_rotated) <- co_data_rotated[1, ]
co_data_rotated <- co_data_rotated[-1]
co_data_rotated <- rownames_to_column(co_data_rotated, "name")
plot_missing(co_data_rotated)


# Plot distros across years of all sources
co_data_decades <- co_data_long %>% filter(ano %in% c('1990','2000','2010','2016'))
ggplot(co_data_decades, aes(x = co2)) + geom_density(aes(fill = ano), alpha = 0.5) + labs(x = NULL)

