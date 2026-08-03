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
