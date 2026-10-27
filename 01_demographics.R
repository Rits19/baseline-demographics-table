# Baseline Demographics Table
# Data: CDISC pilot ADSL (pharmaverseadam package)
# Population: Safety (SAFFL = "Y")

library(pharmaverseadam)
library(dplyr)
library(tidyr)

adsl <- pharmaverseadam::adsl

adsl_saf <- adsl %>% filter(SAFFL == "Y")

# Age summary by treatment arm
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

# Sex summary by treatment arm
sex_summary <- adsl_saf %>%
  count(TRT01P, SEX) %>%
  group_by(TRT01P) %>%
  mutate(pct = round(n / sum(n) * 100, 1))

sex_summary

# Race summary by treatment arm
race_summary <- adsl_saf %>%
  count(TRT01P, RACE) %>%
  group_by(TRT01P) %>%
  mutate(pct = round(n / sum(n) * 100, 1))

race_summary

print(race_summary, n = Inf)

# ---- Combine age, sex and race into one table ----

age_rows <- adsl_saf %>%
  group_by(TRT01P) %>%
  summarise(
    `Mean (SD)` = paste0(round(mean(AGE), 1), " (", round(sd(AGE), 1), ")"),
    `Median`    = as.character(median(AGE)),
    `Min, Max`  = paste0(min(AGE), ", ", max(AGE))
  ) %>%
  pivot_longer(-TRT01P, names_to = "Statistic", values_to = "value") %>%
  mutate(Variable = "Age (years)")

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

demog_table <- bind_rows(age_rows, sex_rows, race_rows) %>%
  pivot_wider(names_from = TRT01P, values_from = value)

print(demog_table, n = Inf)

# ---- Tidy column order and save the table ----

demog_table <- demog_table %>%
  select(Variable, Statistic, everything())

dir.create("output", showWarnings = FALSE)
write.csv(demog_table, "output/demographics_table.csv", row.names = FALSE)
