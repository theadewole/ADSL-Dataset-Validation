/* Normalizing variable based on RSD For DM Dataset
   From QC_ADSL (1).sas — PROC SQL derivation of planned treatment:
   PUT(ARM,$char50.) AS TRT01P and the CASE-WHEN arm codes TRT01PN / TRT01AN.
   Reads the bundled mock DM_ADSL; the SQL is the author's, unchanged. */
PROC SQL;
	CREATE TABLE DM_ADSL1 AS
	SELECT *,PUT(ARM,$char50.)AS TRT01P,
	/*Specifying TRT01PN*/
	CASE
	WHEN ARM='PLACEBO' 			THEN 1
	WHEN ARM='CYT001 10 MG ' 	THEN 2
	WHEN ARM='CYT001 3 MG '  	THEN 3
	ELSE .
	END AS TRT01PN,
	/*Specifying TRT01AN*/
	CASE
	WHEN ARM='PLACEBO' 			THEN 1
	WHEN ARM='CYT001 10 MG ' 	THEN 2
	WHEN ARM='CYT001 3 MG '  	THEN 3
	ELSE .
	END AS TRT01AN
	FROM DM_ADSL;
QUIT;

PROC PRINT DATA=DM_ADSL1;
	VAR USUBJID ARM TRT01P TRT01PN TRT01AN;
	TITLE "ADSL planned-treatment derivation (PROC SQL CASE)";
RUN;
