/* cap input rows for the captured run */
options obs=100;

/* Mock VS (Vital Signs SDTM) — substitutes LIBNAME Rawdata.VS.
   Columns the VS/BMI derivation reads: USUBJID, VSTESTCD, VSBLFL, VSSTRESN.
   Two baseline records per subject (WEIGHT + HEIGHT, VSBLFL='Y'). */
data VS;
  length USUBJID $30 VSTESTCD $8 VSBLFL $1;
  input USUBJID $ VSTESTCD $ VSBLFL $ VSSTRESN;
datalines;
CYT001-USA-001 WEIGHT Y 82.5
CYT001-USA-001 HEIGHT Y 178
CYT001-CAN-002 WEIGHT Y 68.0
CYT001-CAN-002 HEIGHT Y 165
CYT001-GBR-003 WEIGHT Y 91.2
CYT001-GBR-003 HEIGHT Y 183
CYT001-DEU-004 WEIGHT Y 74.8
CYT001-DEU-004 HEIGHT Y 170
;
run;
