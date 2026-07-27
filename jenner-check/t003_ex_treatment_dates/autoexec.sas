/* cap input rows for the captured run */
options obs=100;

/* Mock EX (Exposure SDTM) — substitutes LIBNAME Rawdata.EX.
   Columns the author's EX derivation reads: USUBJID, EXTRT, EXSTDTC, EXENDTC
   (ISO-8601 character dates parsed with the ??yymmdd10. informat). */
data EX;
  length USUBJID $30 EXTRT $50 EXSTDTC $10 EXENDTC $10;
  input USUBJID $ 1-14 EXTRT $ 16-30 EXSTDTC $ 32-41 EXENDTC $ 43-52;
datalines;
CYT001-USA-001 PLACEBO        2014-01-02 2014-06-30
CYT001-CAN-002 CYT001 3 MG    2014-02-11 2014-08-01
CYT001-GBR-003 CYT001 10 MG   2014-03-05 2014-09-10
CYT001-DEU-004 PLACEBO        2014-01-20 2014-07-15
CYT001-CHN-005 CYT001 10 MG   2014-04-01 2014-10-01
;
run;
