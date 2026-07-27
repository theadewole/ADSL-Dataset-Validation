/* cap input rows for the captured run */
options obs=100;

/* Two small ADSL-style tables standing in for the author's
   Analysis.Adsl (base) and Work.QC_ADSL (QC-derived). Same subjects and
   key ADSL variables; a couple of cells differ so PROC COMPARE has
   something to report — exactly what a validation run surfaces. */
data base_adsl;
  length USUBJID $20 ARM $50 REGION $20 SEXN 8 AGE 8 BMI 8;
  input USUBJID $ ARM $ REGION $ SEXN AGE BMI;
datalines;
CYT001-USA-001 PLACEBO NORTH_AMERICA 1 54 26.0
CYT001-CAN-002 CYT001_3MG NORTH_AMERICA 2 61 25.0
CYT001-GBR-003 CYT001_10MG NORTHERN_EUROPE 1 47 27.2
CYT001-DEU-004 PLACEBO CENTRAL_EUROPE 2 39 25.9
;
run;

data qc_adsl;
  length USUBJID $20 ARM $50 REGION $20 SEXN 8 AGE 8 BMI 8;
  input USUBJID $ ARM $ REGION $ SEXN AGE BMI;
datalines;
CYT001-USA-001 PLACEBO NORTH_AMERICA 1 54 26.0
CYT001-CAN-002 CYT001_3MG NORTH_AMERICA 2 61 25.0
CYT001-GBR-003 CYT001_10MG NORTHERN_EUROPE 1 47 27.4
CYT001-DEU-004 PLACEBO CENTRAL_EUROPE 2 40 25.9
;
run;
