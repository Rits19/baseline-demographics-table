# Baseline Demographics Table

A baseline demographics summary by treatment arm, built in R from CDISC pilot ADSL data.

## Objective

Summarise age, sex and race for each treatment arm, as in the demographics table of a clinical study report.

## Data

- **Source:** ADSL dataset from the public `pharmaverseadam` R package (CDISC pilot data)
- **Population:** Safety population (`SAFFL = "Y"`), N = 254
- **Excluded:** 52 Screen Failure patients, who never received treatment
- **Treatment variable:** `TRT01P` (planned treatment)

## Method

1. Loaded ADSL (306 patients, 57 variables)
2. Checked treatment-group counts: Placebo 86, Xanomeline High Dose 84, Xanomeline Low Dose 84
3. Summarised age (mean (SD), median, min, max)
4. Summarised sex and race as n (%) within each treatment arm, including zero-count categories
5. Combined everything into one table and saved it as a CSV file

## Result

| Variable | Statistic | Placebo (N=86) | Xanomeline High Dose (N=84) | Xanomeline Low Dose (N=84) |
|---|---|---|---|---|
| Age (years) | Mean (SD) | 75.2 (8.6) | 74.4 (7.9) | 75.7 (8.3) |
| Age (years) | Median | 76 | 76 | 77.5 |
| Age (years) | Min, Max | 52, 89 | 56, 88 | 51, 88 |
| Sex | F | 53 (61.6%) | 40 (47.6%) | 50 (59.5%) |
| Sex | M | 33 (38.4%) | 44 (52.4%) | 34 (40.5%) |
| Race | American Indian or Alaska Native | 0 (0.0%) | 1 (1.2%) | 0 (0.0%) |
| Race | Black or African American | 8 (9.3%) | 9 (10.7%) | 6 (7.1%) |
| Race | White | 78 (90.7%) | 74 (88.1%) | 78 (92.9%) |

Percentages use the number of patients in each treatment arm as the denominator.

## Files

- `01_demographics.R`: R script that builds the table
- `demographics_table.csv`: output table

## Tools

R, dplyr, tidyr, pharmaverseadam

## Next steps

- Add a SAS version of the same table (PROC MEANS / PROC FREQ)
- Add a formatted RTF/HTML output
