# Optional diagnostics and sensitivity checks for binary-outcome models

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
})

message("This placeholder documents recommended checks for the cleaned analysis:")
message("1. Heteroskedasticity-robust standard errors for the linear probability model.")
message("2. Average marginal effects from the logit model.")
message("3. Predicted-probability range checks.")
message("4. Sensitivity to address-match rules and duplicate handling.")
message("5. Spatial validation of the conservation-area indicator.")
