# Code reconstruction notes

The scripts in `code/r/` and `code/python/` were reconstructed from the appendices on pages 65–77 of the uploaded research report. The appendix transcription is preserved in `code/original_appendix/appendix_code_transcription.txt`.

The cleaned scripts make the following changes without altering the intended analysis:

- replace personal absolute file paths with repository-relative paths;
- remove `install.packages()` calls from analysis scripts;
- split the work into data cleaning, annual construction, attrition analysis, scraping, cleaning, and Ayton House analysis;
- correct obvious syntax breaks introduced by PDF line wrapping;
- ensure the web scraper appends only initialized records;
- add input validation, logging, output directories, and command-line arguments;
- replace the address-cleaning expression that converted every space to itself with `str_squish()`;
- distinguish deterministic address standardization from true probabilistic fuzzy matching;
- preserve both linear probability and logit models, while making the reported LPM explicit;
- replace hard-coded CPIH arrays with a year-keyed input table.

## Important status

The scripts have been syntax-checked, but the numerical results have **not** been reproduced because the underlying Excel and CSV data files were not included in the uploaded paper. Once those files are added, column names and individual cleaning assumptions should be checked against the original data.

The historical Zoopla selectors reflect the site structure used during the original project. They may no longer work on current or differently archived pages.
