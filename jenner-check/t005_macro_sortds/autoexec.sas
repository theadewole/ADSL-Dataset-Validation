/* cap input rows for the captured run */
options obs=100;

/* Mock unsorted ADSL-style input for the %sortds macro caller.
   USUBJID intentionally out of order so the sort is observable. */
data DM_ADSL2;
  length USUBJID $30 ARM $50;
  input USUBJID $ ARM $ AGE SEXN;
datalines;
CYT001-GBR-003 CYT001_10MG 47 1
CYT001-USA-001 PLACEBO 54 1
CYT001-CHN-005 CYT001_10MG 58 1
CYT001-CAN-002 CYT001_3MG 61 2
CYT001-ARG-006 CYT001_3MG 66 2
CYT001-DEU-004 PLACEBO 39 2
;
run;
