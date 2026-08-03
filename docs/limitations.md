# Limitations and Interpretation

## 1. Causal interpretation

The analysis documents a decline in active HMO licences and licensed bedroom capacity surrounding the 2019 licence freeze. It does not estimate a fully causal policy effect.

There is no untreated comparison group, and the models do not isolate the freeze from other changes occurring in the same period. The results should therefore be described as changes following, surrounding, or occurring during the policy period.

## 2. Meaning of licence attrition

A property classified as no longer active may have left the register for several reasons:

- a renewal application was denied;
- the owner chose not to renew;
- the property was sold or converted to another use;
- the licence information was recorded differently;
- an address failed to match despite standardization; or
- the register had not yet been updated.

The outcome measures observed licence retention, not the reason for attrition.

## 3. Register conversion and duplicate review

The source register was distributed as a PDF and converted into Excel before analysis in R. The conversion created blank cells, split fields, and formatting irregularities.

Some duplicate removal was conducted manually in Excel using address-level conditional formatting. Manual review was practical for the project but is less reproducible than a fully scripted record-linkage procedure.

## 4. Address matching

Address standardization corrected capitalization, punctuation, abbreviations, spacing, and selected geographic terms. However, deterministic cleaning may still fail when addresses differ in flat numbers, building names, numbering conventions, or incomplete information.

A future version could use a documented probabilistic record-linkage process and manually reviewed match thresholds.

## 5. Linear probability model

The linear probability model provides directly interpretable percentage-point coefficients, but it has known limitations for binary outcomes. Predicted probabilities may fall outside the zero-to-one range, and residual variance is heteroskedastic.

The original appendix also includes exploratory logit specifications. A publication-ready update should report heteroskedasticity-robust standard errors for the linear probability model and present average marginal effects from a logit model as a sensitivity check.

## 6. Conservation-area definition

The conservation-area variable was approximated using a postcode rule. A postcode-based indicator may not reproduce the official geographic boundary perfectly.

A stronger version would geocode property addresses and spatially join them to an official conservation-area boundary.

## 7. Rental-listing coverage

Archived rental listings do not represent a random sample of the St Andrews rental market. Coverage depended on:

- which webpages were preserved by the Wayback Machine;
- whether the relevant information appeared on the first accessible page;
- changes in website structure;
- which letting agencies used the websites;
- whether properties were privately let; and
- whether exact addresses were displayed.

The sample therefore cannot be used to estimate a definitive market-wide rent level or annual growth rate.

## 8. Unequal yearly samples and changing composition

The number of archived observations differed across years, and the mix of property sizes, locations, and quality was not constant. Changes in sample composition may appear as changes in rent even when the price of a comparable property did not change.

Rent-per-room partially normalizes for bedroom count but does not make differently sized or differently equipped properties fully comparable.

## 9. Duplicate-listing assumptions

Listings with the same address, rent, and property type in the same year were treated as suspected duplicates. This may remove valid observations where multiple units shared an address and asking rent.

Additional identifiers, such as flat number, image URL, letting agent, or licence number, would improve duplicate resolution.

## 10. COVID-19 and concurrent market changes

The post-policy period overlaps with the COVID-19 pandemic and other changes in housing demand, university enrollment, landlord behavior, inflation, and the broader rental market. These factors complicate interpretation of rent and licence trends.

## 11. Recommended language

Appropriate:

> Active HMO licences declined by approximately 44.5% between 2018 and 2022, surrounding the implementation of the 2019 licence freeze.

Avoid:

> The 2019 licence freeze caused a 44.5% decline in active HMO licences.

Appropriate:

> Larger properties had higher observed licence-retention rates than three-occupant properties in the estimated models.

Avoid:

> Larger properties were protected from the policy.
