# Methodology

## 1. Study design

The project was designed to quantify changes in the St Andrews rental market surrounding Fife Council's 2019 freeze on new Houses in Multiple Occupation licences. The empirical work was divided into two connected components:

1. construction and analysis of a longitudinal HMO-register database; and
2. collection and exploratory analysis of historical rental listings.

The HMO register was interpreted as an indicator of the licensed supply of shared rental properties. The number of active licences measures the number of licensed properties, while the number of permitted occupants provides an approximate measure of licensed bedroom capacity.

## 2. HMO-register data collection

Fife Council is required to maintain a public register containing information on HMO licence applications and licences issued within the council area. The version used in this project contained applications from 2004 through the first quarter of 2022.

The register was published as a PDF and could not be imported directly into R in a reliable tabular form. It was therefore converted to an Excel workbook and then read into RStudio.

The original file contained numerous empty rows and columns, repeated property applications, geographic records outside the St Andrews study area, and formatting differences introduced through conversion between PDF, Excel, and R.

## 3. Initial cleaning

The following cleaning steps were applied:

- removed empty columns created during PDF conversion;
- renamed the retained variables for consistency;
- removed blank or structurally incomplete rows;
- excluded addresses outside the St Andrews study area;
- removed selected hotels and other records not treated as student rental properties;
- removed wards outside the area of interest;
- reviewed suspected duplicate applications; and
- retained one record per property address within each issue year.

After the initial geographic and structural filters, 6,440 relevant observations remained. Duplicate review reduced the database to 4,918 licence records.

Some duplicate review was completed in Excel because conditional formatting made it possible to identify repeated addresses within each annual sheet and allowed all team members to participate in manual validation.

## 4. Date and annual-activity construction

The issue-date variable was converted to a calendar year. The cleaned data were then used to construct annual files and to identify licences active during a requested period.

For annual supply estimates, each licence was counted during the years between its issue and expiry dates. This produced a licence-year dataset that could be aggregated to estimate:

- the number of active HMO licences in each year; and
- the number of licensed occupants, used as an approximation of bedroom supply.

The analysis used calendar years because Fife Council's register was not structured around an academic or fiscal year.

## 5. Address standardization and record linkage

The same property was often entered differently across licence applications. Examples included differences in capitalization, punctuation, street abbreviations, spacing, line breaks, and the inclusion of the word “Fife.”

A standardization function was created in R to:

- convert addresses to title case;
- remove punctuation;
- expand selected street abbreviations;
- remove inconsistent geographic suffixes;
- replace line breaks; and
- collapse repeated spaces.

The standardized addresses were used to match properties across years. This process was described as fuzzy matching in the original report, although the implemented procedure primarily used deterministic string standardization followed by address matching.

## 6. Licence-retention outcome

The main retention analysis began with all properties active in 2015. Each standardized address was then checked against the set of properties active in 2022.

The binary outcome equaled one when a property was active in both years and zero when a property active in 2015 was no longer observed as active in 2022.

The choice of 2015 and 2022 provided observations on opposite sides of the 2019 policy and allowed sufficient time for licences active in 2015 to expire and require renewal.

## 7. Explanatory variables

Property size was measured using the register's licensed-occupant field and grouped into:

- three occupants;
- four occupants;
- five occupants; and
- six or more occupants.

Three-occupant properties were used as the reference category.

A conservation-area indicator was created using addresses with postcodes beginning with `KY16 9`, following the geographic definition used in the project. This variable was included to test whether properties in the central conservation area experienced different retention patterns.

## 8. Linear probability model

A linear probability model was estimated with licence retention as the dependent variable. Property-size indicators and conservation-area status were included as explanatory variables.

The model was selected because its coefficients could be interpreted directly as percentage-point differences in retention probability. The original project also intended the supply-side results to be integrated with later linear rental-price analysis.

The main specification compared 2015 with 2022. A second specification comparing 2014 with 2021 was estimated as an alternate-period robustness check.

## 9. Historical rental-data collection

The rental-data component was designed to collect historical asking rents for properties in St Andrews. Archived versions of Zoopla and other listing pages were accessed through the Internet Archive Wayback Machine.

The scraper was written in Python. Selenium loaded archived webpages containing dynamic content, while Beautiful Soup was used to locate repeated listing elements and extract available information. Requests was used where a faster direct webpage request was sufficient.

The extracted fields included, where available:

- listing date;
- property address;
- bedroom count or property type;
- monthly rent; and
- source URL.

Approximately 1,400 raw observations were collected.

## 10. Rental-data cleaning

The rental records were separated by year and duplicate observations were removed. A record was treated as a suspected duplicate when the address, rent, and property type were repeated within the same year.

The geographic cleaning process used both automated rules and manual review:

- removed listings explicitly associated with Dundee, Kirkcaldy, Cupar, Boarhills, and other non-St Andrews locations;
- retained records explicitly containing common forms of “St Andrews”;
- manually checked 54 unclear addresses; and
- removed three of those manually reviewed records as outside St Andrews.

After deduplication and geographic cleaning, 478 relevant records remained.

## 11. Rental-price analysis

Monthly rent per room was calculated to support comparisons across properties with different bedroom counts. The 2018, 2019, and 2020 samples were summarized using distributions and percentage breakdowns across rent bands.

The analysis did not treat yearly sample averages as representative estimates of the St Andrews rental market. The number and composition of archived listings differed by year, the sample excluded privately let properties, and listing websites selected which properties appeared publicly.

A specific-property analysis was also undertaken using Ayton House, where repeated room-type prices were available over time. This reduced some of the compositional problems created by comparing different properties across years, although it remained a descriptive case study.

## 12. Interpretation

The project documents changes in observed HMO licence supply, licensed bedroom capacity, property-level retention, and available archived rental listings. The timing of these changes is discussed in relation to the 2019 HMO freeze.

The research design does not contain an untreated comparison group or a causal identification strategy capable of separating the policy effect from all other changes in the St Andrews housing market. Results should therefore be described as changes occurring around or following the policy, rather than as a definitive causal estimate.
