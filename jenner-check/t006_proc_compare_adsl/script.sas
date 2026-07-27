/* Creating Listing for comparing the dataset
   From QC_ADSL (1).sas — the validation step: PROC COMPARE of the base ADSL
   against the QC-derived ADSL with LISTALL. TITLE/FOOTNOTE kept from the
   author's program; BASE/COMP redirected to the two bundled ADSL tables.
   ODS RTF/PRINTTO removed so the comparison prints to the listing. */
TITLE "ADaM Dataset Validation (ADSL)";
FOOTNOTE "Validation of ADSL dataset";
PROC COMPARE BASE=base_adsl COMP=qc_adsl LISTALL;
RUN;
