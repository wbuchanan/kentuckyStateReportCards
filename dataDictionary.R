# Loads library for pipe operator
library(magrittr)

# Scrapes the data dictionary from KDE's website
dict <- xml2::read_html("https://applications.education.ky.gov/src/Glossary.aspx") %>%
        rvest::html_table(trim = TRUE, fill = TRUE)

# Sets a vector with new variable names for the data dictionary
nms <- c("category", "file", "varnm", "label")

# Cleans up the data dictionary table and makes variable names match Stata variable names
data <- dict[[2]] %>% dplyr::select(X2, X3, X4, X5) %>%
        dplyr::filter(!is.na(X2) & X2 != 'Category Name') %>%
        dplyr::mutate(X4 = gsub(" ", "_", tolower(X4)))

# Assigns variable names to dataset
names(data) <- nms

# Writes the dataset to disk
write.csv(data, row.names = FALSE, 
          file = "~/Desktop/kentuckyStateReportCards/raw/dataDictionary.csv")


