# Baseline Demographics Table
# Data: CDISC pilot ADSL (pharmaverseadam package)
# Population: Safety (SAFFL = "Y")

# ---- Load packages and data ----
library(pharmaverseadam)
library(dplyr)
library(tidyr)

adsl <- pharmaverseadam::adsl   # full ADSL: 306 patients

# Keep only patients who received at least one dose.
# Screen Failures never got treatment, so they are left out.
adsl_saf <- adsl %>% filter(SAFFL == "Y")

# ---- First look at each variable (checked in the console) ----

# Age: count, mean, SD, median, min and max for each treatment arm
age_summary <- adsl_saf %>%
  group_by(TRT01P) %>%
  summarise(
    n      = n(),
    mean   = round(mean(AGE), 1),
    sd     = round(sd(AGE), 1),
    median = median(AGE),
    min    = min(AGE),
    max    = max(AGE)
  )

age_summary

# Sex: number of patients and % within each treatment arm
sex_summary <- adsl_saf %>%
  count(TRT01P, SEX) %>%
  group_by(TRT01P) %>%
  mutate(pct = round(n / sum(n) * 100, 1))

sex_summary

# Race: same method as sex
race_summary <- adsl_saf %>%
  count(TRT01P, RACE) %>%
  group_by(TRT01P) %>%
  mutate(pct = round(n / sum(n) * 100, 1))

race_summary

# ---- Combine age, sex and race into one table ----

# Age rows: Mean (SD), Median and Min, Max written as text
age_rows <- adsl_saf %>%
  group_by(TRT01P) %>%
  summarise(
    `Mean (SD)` = paste0(round(mean(AGE), 1), " (", round(sd(AGE), 1), ")"),
    `Median`    = as.character(median(AGE)),
    `Min, Max`  = paste0(min(AGE), ", ", max(AGE))
  ) %>%
  pivot_longer(-TRT01P, names_to = "Statistic", values_to = "value") %>%
  mutate(Variable = "Age (years)")

# Sex rows: n (%) for each arm.
# complete() adds a row with 0 if a category has no patients in an arm.
sex_rows <- adsl_saf %>%
  count(TRT01P, SEX) %>%
  complete(TRT01P, SEX, fill = list(n = 0)) %>%
  group_by(TRT01P) %>%
  mutate(pct = n / sum(n) * 100) %>%
  ungroup() %>%
  mutate(value = paste0(n, " (", sprintf("%.1f", pct), "%)"),
         Variable = "Sex",
         Statistic = SEX) %>%
  select(TRT01P, Variable, Statistic, value)

# Race rows: same method as sex rows
race_rows <- adsl_saf %>%
  count(TRT01P, RACE) %>%
  complete(TRT01P, RACE, fill = list(n = 0)) %>%
  group_by(TRT01P) %>%
  mutate(pct = n / sum(n) * 100) %>%
  ungroup() %>%
  mutate(value = paste0(n, " (", sprintf("%.1f", pct), "%)"),
         Variable = "Race",
         Statistic = RACE) %>%
  select(TRT01P, Variable, Statistic, value)

# Stack the three blocks, then put each treatment arm in its own column
demog_table <- bind_rows(age_rows, sex_rows, race_rows) %>%
  pivot_wider(names_from = TRT01P, values_from = value)

print(demog_table, n = Inf)

# ---- Tidy column order and save the table ----

demog_table <- demog_table %>%
  select(Variable, Statistic, everything())

dir.create("output", showWarnings = FALSE)
write.csv(demog_table, "output/demographics_table.csv", row.names = FALSE)
