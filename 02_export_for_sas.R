# Export the Safety population from ADSL so I can repeat the table in SAS
library(pharmaverseadam)
library(dplyr)

adsl <- pharmaverseadam::adsl

adsl_saf <- adsl %>% filter(SAFFL == "Y")

# Only the columns I need for the demographics table
adsl_export <- adsl_saf %>%
  select(USUBJID, TRT01P, AGE, SEX, RACE, SAFFL)

write.csv(adsl_export, "adsl_saf.csv", row.names = FALSE)

dim(adsl_export)