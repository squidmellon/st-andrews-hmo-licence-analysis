# Property-level HMO licence-retention analysis
# Source: reconstructed and corrected from Appendix 4.

suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(stringr)
  library(lubridate)
  library(broom)
  library(readr)
})

input_path <- "data/processed/hmo_register_clean.xlsx"
output_dir <- "outputs/tables"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
if (!file.exists(input_path)) stop("Missing input file: ", input_path)

hmo <- read_excel(input_path)
required <- c("HMO Address", "Date Issued", "Expire Date", "Tot Occs")
missing_cols <- setdiff(required, names(hmo))
if (length(missing_cols) > 0) stop("Missing columns: ", paste(missing_cols, collapse = ", "))

standardize_address <- function(x) {
  x %>%
    str_to_title() %>%
    str_remove_all("[[:punct:]]") %>%
    str_replace_all(regex("\\bStr\\b", ignore_case = TRUE), "Street") %>%
    str_replace_all(regex("\\bSt\\b", ignore_case = TRUE), "Street") %>%
    str_replace_all(regex("\\bAve\\b", ignore_case = TRUE), "Avenue") %>%
    str_replace_all(regex("\\bBlvd\\b", ignore_case = TRUE), "Boulevard") %>%
    str_replace_all(regex("\\bFife\\b", ignore_case = TRUE), "") %>%
    str_replace_all("[\\r\\n]+", " ") %>%
    str_squish()
}

hmo <- hmo %>%
  mutate(
    `Date Issued` = as.Date(`Date Issued`),
    `Expire Date` = as.Date(`Expire Date`),
    address_std = standardize_address(`HMO Address`),
    conservation = str_detect(`HMO Address`, fixed("KY16 9")),
    bedroom = pmin(as.integer(`Tot Occs`), 6L)
  )

active_in_year <- function(data, year_value) {
  data %>% filter(year(`Date Issued`) <= year_value, year(`Expire Date`) >= year_value)
}

run_retention_model <- function(start_year, end_year) {
  start <- active_in_year(hmo, start_year)
  end_addresses <- active_in_year(hmo, end_year) %>% pull(address_std) %>% unique()

  analysis <- start %>%
    distinct(address_std, .keep_all = TRUE) %>%
    mutate(retained = address_std %in% end_addresses)

  lpm <- lm(retained ~ factor(bedroom) + conservation, data = analysis)
  logit <- glm(retained ~ factor(bedroom) + conservation,
               family = binomial(), data = analysis)

  list(data = analysis, lpm = lpm, logit = logit)
}

main <- run_retention_model(2015, 2022)
robust <- run_retention_model(2014, 2021)

write_csv(tidy(main$lpm), file.path(output_dir, "lpm_2015_2022.csv"))
write_csv(tidy(main$logit, exponentiate = TRUE), file.path(output_dir, "logit_odds_2015_2022.csv"))
write_csv(tidy(robust$lpm), file.path(output_dir, "lpm_2014_2021.csv"))
write_csv(tidy(robust$logit, exponentiate = TRUE), file.path(output_dir, "logit_odds_2014_2021.csv"))

cat("2015 properties:", nrow(main$data), "\n")
cat("Retained in 2022:", sum(main$data$retained), "\n")
cat("2014 properties:", nrow(robust$data), "\n")
cat("Retained in 2021:", sum(robust$data$retained), "\n")
