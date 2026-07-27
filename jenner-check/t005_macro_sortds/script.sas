/* %sortds macro from QC_ADSL (1).sas — a reusable PROC SORT wrapper that
   sorts &ds BY USUBJID into &dsout. This bundle exercises the macro
   definition verbatim with a small caller over the bundled mock input. */
%MACRO sortds(ds,dsout);
PROC SORT DATA=&ds OUT=&dsout;
	BY USUBJID;
RUN;
%MEND;

%sortds(DM_ADSL2,DM1);

PROC PRINT DATA=DM1;
	VAR USUBJID ARM AGE SEXN;
	TITLE "sortds macro — DM_ADSL2 sorted BY USUBJID into DM1";
RUN;
