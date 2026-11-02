# Baseline Demographics Table (SAS/R)

A baseline demographics summary by treatment arm, built in R and repeated in SAS from CDISC pilot ADSL data.

## Objective

This is my first clinical programming project. I wanted to practise building a baseline demographics table the way it appears in a clinical study report, showing age, sex and race for each treatment group.

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
5. Combined everything into one table and saved it as `demographics_table.csv`
6. Exported the Safety population (254 patients, 6 columns) to a CSV file
7. Repeated age, sex and race in SAS (PROC MEANS and PROC FREQ) and checked that the results match R
8. Tested whether the arms differ in age (ANOVA) and sex (chi-square test) in R and SAS (PROC GLM and PROC FREQ), for practice

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

**Tests between arms (for practice):**
- Age: ANOVA, F(2, 251) = 0.52, p = 0.593
- Sex: chi-square test, X² = 3.92, df = 2, p = 0.141

SAS gave the same results (ANOVA F = 0.52, p = 0.5934; chi-square X² = 3.92, p = 0.1409).

Neither test shows a clear difference between the arms. In randomised trials, baseline p-values are usually not reported, because chance alone can cause small differences, so these tests were done to practise the methods.

## What I learned

- Screen Failure patients were in the dataset (52 of 306), but they never received treatment. I first saw four groups instead of three, so I kept only the Safety population (SAFFL = "Y").
- Some race categories have no patients in certain groups. I used `complete()` so these rows show as 0 (0.0%) instead of disappearing from the table.
- I checked my numbers at each step. For example, the sex and race counts in each group add up to the group size (86, 84, 84).
- I got an error while installing the `pharmaverseadam` package. The cause was a missing dependency, and installing it again fixed the problem.
- When I imported the CSV into SAS, the RACE variable was cut to 7 characters, because SAS only checks the first 20 rows by default. "BLACK OR AFRICAN AMERICAN" would have been truncated. Adding `guessingrows=max` fixed it, and RACE now has length 34.
- SAS and R gave the same numbers for age, sex and race. SAS shows two decimals, and rounded to one decimal they match R.
- ANOVA compares the means of three or more groups, and the chi-square test compares counts between groups. Both gave p-values above 0.05, which is what I would expect when patients are randomly assigned.

## Limitations

- The ANOVA and chi-square tests were run for practice. In a real trial, baseline p-values are usually not reported.
- I did not test race, because some cells have very small counts (for example 1 patient), which makes a plain chi-square unreliable.
- The final table is saved as a CSV file. The SAS code reproduces the summaries and tests but does not save a combined table.

## Files

- `01_demographics.R`: R script that builds the table
- `02_export_for_sas.R`: R script that exports the Safety population as a CSV
- `adsl_saf.csv`: Safety population data (public CDISC pilot data)
- `02_demographics.sas`: SAS version of the age, sex and race summaries, plus the ANOVA and chi-square tests
- `demographics_table.csv`: final table from R

## Tools

R (dplyr, tidyr, pharmaverseadam), SAS (PROC IMPORT, PROC MEANS, PROC FREQ, PROC GLM)

## Next steps

- Add a formatted RTF/HTML output
