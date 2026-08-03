# Construct annual active-licence and licensed-bedroom measures
# Source: reconstructed and corrected from Appendix 2.

suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(tidyr)
  library(lubridate)
  library(ggplot2)
  library(readr)
})

input_path <- "data/processed/hmo_register_clean.xlsx"
fig_dir <- "outputs/figures"
table_dir <- "outputs/tables"
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(table_dir, recursive = TRUE, showWarnings = FALSE)

if (!file.exists(input_path)) stop("Missing input file: ", input_path)

hmo <- read_excel(input_path)
required <- c("Date Issued", "Expire Date", "Tot Occs")
missing_cols <- setdiff(required, names(hmo))
if (length(missing_cols) > 0) stop("Missing columns: ", paste(missing_cols, collapse = ", "))

hmo <- hmo %>%
  mutate(
    `Date Issued` = as.Date(`Date Issued`),
    `Expire Date` = as.Date(`Expire Date`),
    # The report assigned a 2022-12-30 end date to one recent missing record.
    `Expire Date` = coalesce(`Expire Date`, as.Date("2022-12-30")),
    issue_year = year(`Date Issued`),
    expiry_year = year(`Expire Date`)
  ) %>%
  filter(!is.na(issue_year), !is.na(expiry_year), expiry_year >= issue_year)

# Expand each licence into one row for every calendar year in which it was active.
hmo_year <- hmo %>%
  rowwise() %>%
  mutate(active_year = list(seq(issue_year, expiry_year))) %>%
  unnest(active_year) %>%
  ungroup()

annual_licences <- hmo_year %>%
  count(active_year, name = "active_licences")

annual_bedrooms <- hmo_year %>%
  group_by(active_year) %>%
  summarise(
    three_occupant_licences = sum(`Tot Occs` == 3, na.rm = TRUE),
    four_occupant_licences = sum(`Tot Occs` == 4, na.rm = TRUE),
    five_occupant_licences = sum(`Tot Occs` == 5, na.rm = TRUE),
    six_plus_occupant_licences = sum(`Tot Occs` >= 6, na.rm = TRUE),
    licensed_bedrooms = sum(`Tot Occs`, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(annual_licences, file.path(table_dir, "annual_active_licences.csv"))
write_csv(annual_bedrooms, file.path(table_dir, "annual_licensed_bedrooms.csv"))

p1 <- annual_licences %>%
  filter(active_year >= 2010, active_year <= 2022) %>%
  ggplot(aes(active_year, active_licences)) +
  geom_line() + geom_point() +
  geom_vline(xintercept = 2019, linetype = "dashed") +
  labs(title = "Active HMO Licences by Year", x = "Year", y = "Active licences") +
  theme_minimal()

ggsave(file.path(fig_dir, "active_hmo_licences.png"), p1, width = 8, height = 5, dpi = 300)

p2 <- annual_bedrooms %>%
  filter(active_year >= 2010, active_year <= 2022) %>%
  ggplot(aes(active_year, licensed_bedrooms)) +
  geom_line() + geom_point() +
  geom_vline(xintercept = 2019, linetype = "dashed") +
  labs(title = "Licensed Bedroom Capacity by Year", x = "Year", y = "Licensed occupants") +
  theme_minimal()

ggsave(file.path(fig_dir, "licensed_bedroom_capacity.png"), p2, width = 8, height = 5, dpi = 300)
