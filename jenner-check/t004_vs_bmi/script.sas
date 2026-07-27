/* VS Dataset specification According to RSD
   From QC_ADSL (1).sas — VS derivation: baseline WGTB/HGTB extraction,
   split into weight (wg) and height (ht), merge, then BMI = (WGTB*703)/(HGTB**2).
   Source redirected from Rawdata.VS to the bundled mock VS. A PROC SORT
   establishes the USUBJID order the author's BY steps rely on (their onDemand
   VS arrived sorted); the derivation logic below is unchanged. */
DATA VS_ADSL (DROP=USUBJID);
	RENAME uniq=USUBJID;
	LENGTH HGTB 8. WGTB 8.;
	FORMAT WGTB 8. HGTB 8.;
	SET VS ;
	/*Reassigning Length USUBJID*/
	Uniq=INPUT(USUBJID,$20.);
	/*Specifying WGTB HGTB*/
	IF VSTESTCD="WEIGHT" AND VSBLFL="Y" THEN WGTB=VSSTRESN;
	IF VSTESTCD="HEIGHT" AND VSBLFL="Y" THEN HGTB=VSSTRESN;
RUN;

PROC SORT DATA=VS_ADSL;
	BY USUBJID;
RUN;

/*Specifying unique weight by USUBJID*/
DATA wg;
	SET VS_ADSL;
	BY usubjid;
	WHERE WGTB ne .;
	DROP HGTB;
RUN;

/*Specifying unique Height by USUBJID*/
DATA Ht;
	SET VS_ADSL;
	BY usubjid;
	WHERE HGTB ne .;
	DROP WGTB;
RUN;

/*Merging the height and weight dataset*/
DATA W_H;
	MERGE wg ht;
	BY USUBJID;
RUN;

/*Specifying BMI*/
DATA VS_ADSL2;
	LENGTH BMI 8.;
	SET W_H;
	BMI=(WGTB*703)/(HGTB**2);
	FORMAT BMI 8.;
RUN;

PROC PRINT DATA=VS_ADSL2;
	VAR USUBJID WGTB HGTB BMI;
	TITLE "ADSL VS derivation — baseline weight, height and BMI";
RUN;
