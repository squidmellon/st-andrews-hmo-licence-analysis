# HMO Licence Retention and Rental Supply in St Andrews


## Quick links

- [One-page project summary](report/project_summary.pdf)
- [Full research report](report/full_research_report.pdf)
- [Methodology](docs/methodology.md)
- [Data dictionary](docs/data_dictionary.md)
- [Limitations](docs/limitations.md)
- [Contribution statement](docs/contribution_statement.md)
- [Reproducibility status](docs/reproducibility_status.md)
- [R code](code/r/)
- [Python code](code/python/)
- [Original HMO workbook](data/original/HMO_By_Years.xlsx)

## Project overview

In April 2019, Fife Council introduced a freeze on new Houses in Multiple Occupation (HMO) licences in St Andrews, Scotland. Existing licence holders could continue to apply for renewal, but the policy limited the addition of new HMO-licensed properties to the local rental market.

This project examines changes in the supply and retention of HMO-licensed properties surrounding the 2019 policy. The analysis combines a longitudinal database constructed from Fife Council's HMO Public Register with historical rental listings collected from archived property websites.

The work was completed as part of a research assistantship in the School of Economics and Finance at the University of St Andrews. I completed the HMO-register data construction, statistical analysis, historical web scraping, rental-data cleaning, and written interpretation presented in this repository. The survey component of the broader research project is not included in the analytical portfolio; the full report is retained unchanged as an archival source. The Ayton House analysis is retained in full even though its original CSV is no longer available.

## Research questions

The project addresses three related questions:

1. How did the number of active HMO licences and licensed bedrooms change before and after the 2019 freeze?
2. Which property characteristics were associated with licence retention over time?
3. Can archived rental listings be used to examine changes in rental prices and rental supply in St Andrews?

## Data

### HMO Public Register

The primary administrative source was Fife Council's HMO Public Register. The original register was distributed as a PDF and contained HMO licence applications from 2004 through the first quarter of 2022.

The PDF was converted into a spreadsheet and imported into R. Records outside the St Andrews study area, hotels, blank rows, and duplicate property-year applications were removed. After cleaning and deduplication, the final longitudinal database contained **4,918 HMO licence records**.

The database was used to reconstruct:

- annual active HMO licences;
- annual licensed bedroom capacity;
- property-level licence retention;
- property size, measured by the number of licensed occupants; and
- whether a property was located within the St Andrews conservation area.

### Historical rental listings

Historical rental listings were collected from archived versions of Zoopla and other property websites using the Internet Archive's Wayback Machine. The Python pipeline used Selenium to load archived webpages and Beautiful Soup to extract listing information.

The initial scrape produced approximately **1,400 records** containing available fields such as listing date, address, bedroom count, monthly rent, and source URL. After duplicate removal, geographic filtering, and manual validation of unclear addresses, **478 relevant St Andrews rental records** remained.

## Methodology

### Longitudinal licence construction

Each licence was expanded across the years in which it was active, using its issue and expiry dates. This made it possible to estimate the number of active licences and licensed bedrooms in each calendar year.

Property addresses were standardized before matching records across years. The cleaning function harmonized capitalization, punctuation, street abbreviations, spacing, and selected geographic terms. This reduced false nonmatches caused by small differences in how the same property address was recorded.

### Licence-retention analysis

The principal retention analysis compared properties with active HMO licences in 2015 with their licence status in 2022. The outcome variable indicated whether the same standardized property address appeared as active in both years.

A linear probability model was estimated using:

- property size categories;
- conservation-area status; and
- three-bedroom properties as the reference category.

An alternate-period specification comparing 2014 with 2021 was used as a robustness check.

### Rental-listing analysis

The rental dataset was cleaned by year. Listings with the same address, rent, and property type in the same year were treated as suspected duplicates and reduced to one observation. Non-St Andrews listings were removed using geographic keyword filters and manual review.

Because the archived listings formed a small, nonrandom, and uneven sample, the rental analysis was treated as exploratory. Descriptive distributions were used rather than interpreting yearly sample averages as representative of the entire St Andrews rental market.

## Key findings

- Active HMO licences declined from **1,262 in 2018 to 700 in 2022**, a decrease of approximately **44.5%**.
- Licensed bedroom capacity declined from **7,764 bedrooms in 2018 to 4,347 in 2022**, a decrease of approximately **44.0%**.
- Of 1,193 properties active in 2015, 500 were no longer active in 2022.
- Larger properties were more likely than three-bedroom properties to retain an HMO licence.
- In the 2015-2022 model, five-bedroom properties were estimated to be **16.8 percentage points less likely to lose a licence**, while properties with six or more occupants were **27.8 percentage points less likely to lose a licence**.
- Conservation-area status was not statistically significant in either the main or alternate-period specification.
- The 2014-2021 specification produced similar directional results, supporting the robustness of the property-size finding.

These results document a substantial contraction in the observed stock of active HMO licences and licensed bedrooms surrounding the policy period. They do not, on their own, establish that the 2019 freeze caused the entire decline.

## Tools

- **R:** data cleaning, longitudinal construction, address standardization, regression analysis, robustness testing, and visualization
- **Python:** Selenium, Beautiful Soup, Requests, pandas, NumPy, and historical web scraping
- **Excel:** manual validation, duplicate review, and collaborative data quality checks
- **Data sources:** Fife Council HMO Public Register, archived rental-property webpages, and the Internet Archive Wayback Machine

## Repository structure

```text
st-andrews-hmo-licence-analysis/
├── README.md
├── code/
│   ├── r/
│   └── python/
├── data/
│   ├── README.md
│   └── sample/
├── docs/
│   ├── methodology.md
│   ├── data_dictionary.md
│   ├── limitations.md
│   └── contribution_statement.md
├── figures/
└── report/
    ├── project_summary.pdf
    └── full_research_report.pdf
```

## Limitations

The HMO-register analysis is observational. A licence that no longer appeared as active may reflect nonrenewal, denial, owner exit, property conversion, administrative recording differences, or another cause. The analysis therefore documents licence attrition surrounding the policy but does not identify a fully causal policy effect.

The rental-listing sample is also incomplete and nonrandom. Archived webpages were not consistently available, some websites required inaccessible secondary pages, and property listings did not always contain complete addresses. Results from this sample should therefore be interpreted as exploratory rather than representative of the entire rental market.

See [`docs/limitations.md`](docs/limitations.md) for additional detail.

## Attribution

This repository presents work completed during a collaborative University of St Andrews research project. I completed the empirical work included here, excluding the survey component. The full team report is retained as supporting documentation and should be cited separately where appropriate.
