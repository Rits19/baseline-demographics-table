/* Baseline Demographics Table - SAS version
   Data: Safety population from CDISC pilot ADSL (exported from R as adsl_saf.csv)
   Purpose: repeat the R table in SAS and check that the results match */

/* Put the path to the CSV file here, in one place */
%let csvpath = /home/u64544172/adsl_saf.csv;

/* ---- Read the data ---- */
/* guessingrows=max so RACE is not cut short (SAS only reads 20 rows by default) */
proc import datafile="&csvpath"
    out=work.adsl_saf
    dbms=csv
    replace;
    getnames=yes;
    guessingrows=max;
run;

/* Check: 254 observations, RACE length 34 */
proc contents data=work.adsl_saf;
run;

/* ---- Age by treatment arm ---- */
proc means data=work.adsl_saf n mean std median min max maxdec=1;
    class TRT01P;
    var AGE;
run;

/* ---- Sex by treatment arm: n and row % (arm total is the denominator) ---- */
proc freq data=work.adsl_saf;
    tables TRT01P*SEX / nocol nopercent;
run;

/* ---- Race by treatment arm: n and row % ---- */
proc freq data=work.adsl_saf;
    tables TRT01P*RACE / nocol nopercent;
run;