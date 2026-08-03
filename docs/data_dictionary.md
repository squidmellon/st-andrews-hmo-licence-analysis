# Data Dictionary

This document describes the principal variables used in the HMO-register and historical rental-listing analyses. Exact names may be adjusted when the original scripts are cleaned for publication.

## HMO-register data

| Variable | Type | Description |
|---|---|---|
| `number` | Character/integer | Administrative record number from the public register. |
| `name` | Character | Applicant or licence-holder name as listed in the source register. This field should be removed from any public analytical dataset unless there is a clear reason to retain it. |
| `ward` | Character | Fife Council ward associated with the property. |
| `address_raw` | Character | Property address as recorded in the original register. |
| `address_std` | Character | Standardized property address used for record matching across years. |
| `status` | Character | Licence or application status reported in the register. |
| `applied_date` | Date | Date on which the licence application was submitted, where available. |
| `issued_date` | Date | Date on which the HMO licence was issued. |
| `expiry_date` | Date | Recorded licence-expiry date. |
| `issue_year` | Integer | Calendar year derived from `issued_date`. |
| `occupants` | Integer | Maximum number of occupants permitted under the licence; used as an approximation of licensed bedroom capacity. |
| `decision` | Character | Recorded administrative decision, where available. |
| `active_year` | Integer | Calendar year during which a licence was classified as active. |
| `active_2015` | Binary | Equals 1 when the standardized property address had an active licence in 2015. |
| `active_2022` | Binary | Equals 1 when the standardized property address had an active licence in 2022. |
| `retained_2015_2022` | Binary | Equals 1 when a property active in 2015 was also active in 2022. |
| `active_2014` | Binary | Equals 1 when the standardized property address had an active licence in 2014. |
| `active_2021` | Binary | Equals 1 when the standardized property address had an active licence in 2021. |
| `retained_2014_2021` | Binary | Equals 1 when a property active in 2014 was also active in 2021. |
| `bedroom_group` | Categorical | Property-size category: 3, 4, 5, or 6+ licensed occupants. |
| `conservation_area` | Binary | Indicator based on the central St Andrews postcode rule used in the project. |

## Aggregated annual HMO data

| Variable | Type | Description |
|---|---|---|
| `year` | Integer | Calendar year. |
| `active_licences` | Integer | Number of HMO licences classified as active during the year. |
| `licensed_bedrooms` | Integer | Sum of licensed occupants across active licences; interpreted as approximate licensed bedroom capacity. |
| `three_occupant_licences` | Integer | Number of active licences permitting three occupants. |
| `four_occupant_licences` | Integer | Number of active licences permitting four occupants. |
| `five_occupant_licences` | Integer | Number of active licences permitting five occupants. |
| `six_plus_occupant_licences` | Integer | Number of active licences permitting six or more occupants. |

## Historical rental-listing data

| Variable | Type | Description |
|---|---|---|
| `listing_date` | Date | Date associated with the archived property listing. |
| `listing_year` | Integer | Calendar year derived from `listing_date`. |
| `address_raw` | Character | Address displayed on the listing page. |
| `address_clean` | Character | Cleaned address used for geographic filtering and duplicate review. |
| `property_type` | Character/integer | Property type or number of bedrooms, depending on source-page structure. |
| `bedrooms` | Integer | Number of bedrooms when available. |
| `monthly_rent` | Numeric | Advertised total monthly rent in pounds sterling. |
| `rent_per_room` | Numeric | `monthly_rent` divided by the number of bedrooms. |
| `source_url` | Character | Archived listing or source-page URL. |
| `source_site` | Character | Website from which the archived listing was collected. |
| `in_st_andrews` | Binary | Final geographic inclusion decision. |
| `suspected_duplicate` | Binary | Flag indicating a repeated address-rent-property-type combination within a year. |
| `manual_location_check` | Character/binary | Result of manual review for an address not resolved by automated geographic rules. |

## Public-data recommendation

A public repository should not include applicant names or other unnecessary personal information from the HMO register. A small synthetic or redacted sample can be provided to demonstrate file structure, while the repository documents how users may obtain the original public register from Fife Council.
