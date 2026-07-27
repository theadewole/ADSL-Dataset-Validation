/* cap input rows for the captured run */
options obs=100;

/* Mock DM_ADSL — the DM-derived table the author's PROC SQL reads from.
   ARM values use the exact spellings the CASE arms test against
   (PLACEBO, 'CYT001 10 MG ', 'CYT001 3 MG ' — trailing blanks intended). */
data DM_ADSL;
  length USUBJID $30 ARM $50 RFSTDTC $10 RFENDTC $10;
  input USUBJID $ 1-14 ARM $ 16-30 RFSTDTC $ 32-41 RFENDTC $ 43-52;
datalines;
CYT001-USA-001 PLACEBO        2014-01-02 2014-06-30
CYT001-CAN-002 CYT001 3 MG    2014-02-11 2014-08-01
CYT001-GBR-003 CYT001 10 MG   2014-03-05 2014-09-10
CYT001-DEU-004 PLACEBO        2014-01-20 2014-07-15
CYT001-CHN-005 CYT001 10 MG   2014-04-01 2014-10-01
CYT001-ARG-006 CYT001 3 MG    2014-02-28 2014-08-30
;
run;
