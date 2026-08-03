# Clean the Fife Council HMO register
# Source: reconstructed from Appendix 1 of the research report.
# This script expects a spreadsheet created from the source PDF.

suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(stringr)
  library(lubridate)
  library(writexl)
})

input_path <- "data/raw/hmo_register_converted.xlsx"
output_path <- "data/interim/hmo_register_initial_clean.xlsx"

if (!file.exists(input_path)) {
  stop("Missing input file: ", input_path,
       "\nPlace the PDF-converted register in data/raw/ or update input_path.")
}

raw <- read_excel(input_path)

# The original appendix used these source-column names. Adjust this mapping if
# the converted spreadsheet uses different headers.
required <- c("Occupants", "Ward", "Name", "Address", "Applied", "Issued", "Expiry")
missing_cols <- setdiff(required, names(raw))
if (length(missing_cols) > 0) {
  stop("Missing expected columns: ", paste(missing_cols, collapse = ", "))
}

clean <- raw %>%
  filter(!is.na(Occupants)) %>%
  filter(!str_detect(coalesce(as.character(Ward), ""), "NW13|NW18")) %>%
  filter(!str_detect(coalesce(as.character(Name), ""), regex("Hotel", ignore_case = TRUE))) %>%
  mutate(
    Applied = as.Date(Applied),
    Issued = as.Date(Issued),
    Expiry = as.Date(Expiry),
    year = year(Issued)
  )

# The original workflow exported this intermediate file for manual duplicate
# review within issue year. The subsequent public version should replace that
# manual step with a documented scripted rule once the raw file is available.
write_xlsx(clean, output_path)
message("Wrote ", nrow(clean), " rows to ", output_path)
