/*Establsihing Library*/
LIBNAME	Rawdata "/home/u63305936/Internship Series/ADaM Dataset Validation (ADSL)/Work/02data_raw";
RUN;

/*Generating Log*/
PROC PRINTTO LOG="/home/u63305936/My Log/QC_adsl.Log" New;

/*DM Dataset specification  According to RSD*/
DATA DM_ADSL (DROP=USUBJID ARM);
	RENAME uniq=USUBJID;
	LENGTH STUDYID $20 Uniq $20 SUBJID $20 SITEID $20 AGE 8. AGEU $15 SEX $1 SEXN 8. RACE $50 
	COUNTRY $8. REGION $20 Arml $50. ARMCD $20.;
	FORMAT Age 8. Ageu $15. SEXN 8.;
	SET Rawdata.DM;
	/*Specifying SEXN, reassignig length to USUBJID and ARM*/
	RENAME uniq=USUBJID	Arml=ARM;
	Uniq=INPUT(USUBJID,$20.);
	Arml=INPUT(ARM,$50.);
	/*Specifying SEXN*/
	IF Sex="M" THEN SEXN=1;
	IF Sex="F" THEN SEXN=2;
	/*Specifying Country*/
	IF country in('CAN','USA') THEN region='NORTH AMERICA';
	ELSE IF  country in ('AUT','BEL','DNK','ITA','NLD','NOR','SWE','FRA','ISR','ESP') THEN region='WESTERN EUROPE'; 
	ELSE IF country in ('BLR','BGR','HUN','POL','ROU','RUS','SVK','UKR','TUR') THEN region='EASTERN EUROPE';
	ELSE IF country in ('DEU','HRV','SCG') THEN region='CENTRAL EUROPE';
	ELSE IF country in ('AUS','CHN','HKG','IND','MYS','SGP','TWN','THA') THEN region='ASIA'; 
	ELSE IF country in ('ARG','CHL','COL','MEX','PER') THEN region='LATIN AMERICA';
	ELSE IF country='ZAF' THEN region='SOUTHERN AFRICA';
	ELSE IF country='GBR' THEN region='NORTHERN EUROPE';
	FORMAT Age 8. Ageu $15. SEXN 8.;
RUN;

/*Normalizing variable based on RSD For Dm Dataset*/
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
RUN;

/*Normalizing variable based on RSD For Dm Dataset*/
DATA DM_ADSL2;
	LENGTH  TRT01PN 8. TRT01P  $50. TRT01AN 8. ARFSTDT 8.;
	FORMAT TRT01PN 8. TRT01AN 8. ARFSTDT date9.;
	SET DM_ADSL1;
	/*Specifying ARFSTDT ARFSTDT ARFENDT*/
	ARFSTDT=INPUT(RFSTDTC,??yymmdd10.);
	RFENDTC1=INPUT(RFENDTC,??yymmdd10.); 
RUN;


/*EX Dataset specification  According to RSD*/
DATA EX_ADSL (DROP=USUBJID);
	RENAME uniq=USUBJID;
	LENGTH ACTARM $50. ACTARMCD $20.TRT01SDT 8. TRT01EDT 8. TRTEDT 8. TRTSDT 8. TRT01A  $50. ;
	FORMAT  ACTARM $50. ACTARMCD $20.TRTSDT date9. TRTEDT date9. TRT01SDT date9. TRT01EDT date9. TRT01A  $50.;
	SET Rawdata.EX;
	/*Specifying TRTSDT TRTEDT ACTARM TRT01A TRT01SDT TRT01EDT and reassigning length to USUBJID*/
	Uniq=INPUT(USUBJID,$20.);
	A=INPUT(EXSTDTC,??yymmdd10.);
	B=INPUT(EXENDTC,??yymmdd10.);
	TRTSDT=MIN(A);
	IF B NE . THEN TRTEDT=MAX(B);
	ACTARM=EXTRT;
	TRT01A=EXTRT;
	EXSTDTC1=INPUT(EXSTDTC,??yymmdd10.);
	TRT01SDT=TRTSDT;
	TRT01EDT=TRTEDT; 
	/*Specifying ACTARMCD*/
	IF EXTRT='PLACEBO' THEN ACTARMCD='PLAC';
	IF EXTRT='CYT001 10 MG ' THEN ACTARMCD='CYT00110'; 
	IF EXTRT='CYT001 3 MG ' THEN ACTARMCD='CYT0013';
RUN;

/*SV Dataset specification  According to RSD*/
DATA SV_ADSL (DROP=USUBJID);
	RENAME uniq=USUBJID;
	LENGTH AP01SDT 8.;
	FORMAT AP01SDT 8.;
	SET Rawdata.SV;
/*Specifying AP01SDT and reassigning length USUBJID*/
	Uniq=INPUT(USUBJID,$20.);
	C=INPUT(SUBSTR(svstdtc,1,10),??yymmdd10.);
	IF C NE . THEN AP01SDT=MIN(C);
RUN;


/*DS Dataset specification  According to RSD*/
DATA DS_ADSL (DROP=USUBJID);
	RENAME uniq=USUBJID;
	LENGTH DTHDT 8. DTHFL $1. RANDFL $1. RANDDT 8.  DTHFL $1. EOSCODE  $50. EOS $50. EOSDT 8. EOSFL $1.;
	FORMAT DTHFL $1. RANDDT date9. RANDFL $1. DTHDT date9. EOSFL $1. EOSDT date9. EOS $50. EOSCODE $50.;
	SET Rawdata.DS;
	/*Reassigning Length USUBJID*/
	Uniq=INPUT(USUBJID,$20.);
	DSSTDTC1=INPUT(DSSTDTC,Anydtdte32.);
	/*Specifying DTHFL*/
	IF DSDECOD="DEATH" AND DSCAT="DISPOSITION EVENT" THEN DTHFL="Y";
	/*Specifying RANDDT*/
	IF DSDECOD ='RANDOMIZED' THEN RANDDT=DSSTDTC1; 
	/*Specifying RANDFL*/
	IF RANDDT NE . THEN RANDFL="Y";
	/*Specifying RANDFL*/
	IF DSDECOD="DEATH" AND DSCAT="DISPOSITION EVENT" THEN DTHDT=DSSTDTC1; 
	/*Specifying EOSFL */
	IF DSSCAT = 'END OF STUDY' THEN EOSFL="Y";
	ELSE IF DSSCAT NE 'END OF STUDY' THEN EOSFL="N";
	/*Specifying RANDFL*/
	IF DSDECOD="DEATH" AND DSCAT="DISPOSITION EVENT" THEN EOSDT=DSSTDTC1;
	/*Specifying EOS EOSCODE*/
	IF DSCAT="DISPOSITION EVENT" AND DSDECOD="COMPLETED" THEN DO;
	EOS="COMPLETED";
	EOSCODE="COMPLETED";
	END;
	ELSE IF DSCAT="DISPOSITION EVENT" THEN DO;
	EOS=DSTERM;
	EOSCODE=DSDECOD;
	END;
RUN;

/*VS Dataset specification  According to RSD*/
DATA VS_ADSL (DROP=USUBJID);
	RENAME uniq=USUBJID;
	LENGTH HGTB 8. WGTB 8.;
	FORMAT WGTB 8. HGTB 8.;
	SET Rawdata.VS ;
	/*Reassigning Length USUBJID*/
	Uniq=INPUT(USUBJID,$20.);
	/*Specifying WGTB HGTB*/
	IF VSTESTCD="WEIGHT" AND VSBLFL="Y" THEN WGTB=VSSTRESN;
	IF VSTESTCD="HEIGHT" AND VSBLFL="Y" THEN HGTB=VSSTRESN;
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


/*Sorting all the dataset*/
PROC SORT DATA=DM_ADSL2 OUT=DM1;
	BY USUBJID;
RUN;

PROC SORT DATA=DS_ADSL OUT=DS1;
	BY USUBJID;
RUN;

PROC SORT DATA=EX_ADSL OUT=EX1;
	BY USUBJID;
RUN;

PROC SORT DATA=SV_ADSL OUT=SV1;
	BY USUBJID;
RUN;

PROC SORT DATA=VS_ADSL2 OUT=VS1;
	BY USUBJID;
RUN;

/*Merging the dataset*/
DATA QC;
	MERGE DM1 DS1 EX1 SV1 VS1;
	BY USUBJID;
RUN;

/*specifying variable that requires condition from more than one dataset*/
DATA QC1;
	LENGTH ARFENDT 8. AP01EDT 8. SAFFL $1. STYDURD 8;
	FORMAT ARFENDT date9. AP01EDT date9. SAFFL $1. STYDURD 8.;
	SET QC;
	RFENDTC1=INPUT(RFENDTC,??yymmdd10.);
	IF TRT01EDT NE . THEN AP01EDT=TRT01EDT+28; 
	/*Specifying ARFENDT*/
	IF RFENDTC1 NE . THEN ARFENDT=RFENDTC1;
	/*Specifying SAFFL*/
	IF RANDDT NE . AND EXSTDTC1 NE . THEN SAFFL="Y";
	/*Specifying STYDURD */
	IF ARFSTDT AND ARFENDT NE . THEN STYDURD=ARFENDT-(ARFSTDT+1);
RUN;

/*Sorting the merged dataset and removing duplicate*/
PROC SORT DATA=QC1 OUT=QC2 NODUPKEYS;
	BY USUBJID;
RUN;

/*Creating  QC_adsl.sas Dataset*/
PROC SQL;
	CREATE TABLE QC_ADSL AS
	SELECT 
	STUDYID 					"Study Identifier",
	USUBJID						"Unique Subject Identifier",
	SUBJID 						"Subject Identifier for the Study",
	SITEID 						"Study Site Identifier",
	AGE							"Age",
	AGEU						"Age Units",
	SEX							"Sex",
	SEXN						"Sex (N)",
	RACE 						"Race",
	COUNTRY 					"Country",
	REGION 						"REGION",
	ARM 						"Description of Planned Arm",
	ARMCD 						"Planned Arm Code",
	ACTARM						"Description of Actual Arm",
	ACTARMCD 					"Actual Arm Code",
	TRT01P						"Planned Treatment for Period 01",
	TRT01PN 					"Planned Treatment for Period 01 (N)",
	TRT01A 						"Actual Treatment for Period 01",
	TRT01AN						"Actual Treatment for Period 01 (N)",
	ARFSTDT						"Analysis Ref Start Date",
	ARFENDT 					"Analysis Ref End Date",
	TRTSDT 						"Date of First Exposure to Treatment",
	TRTEDT 						"Date of Last Exposure to Treatment",
	TRT01SDT 					"Date of First Exposure in Period 01",
	TRT01EDT 					"Date of Last Exposure in Period 01",
	AP01SDT 					"Period 01 start date",
	AP01EDT 					"Period 01 end date",
	RANDDT 						"Date of Randomization",
	SAFFL 						"Safety Population Flag",
	RANDFL 						"Randomized Population Flag",
	DTHFL 						"Subject Death Flag",
	DTHDT 						"Date of Death",
	STYDURD 					"Total Study Duration (Days)",
	EOSFL 						"End of Study Flag",
	EOSDT 						"End of Study Date",
	EOS 						"Reason for ending study",
	EOSCODE 					"Reason For Ending study Code",
	WGTB 						"Weight at BL (kg)",
	HGTB 						"Height at BL (cm)",
	BMI 						"BMI at BL (kg/m^2)" 
	FROM QC2;
QUIT;

/*Creating  QC_adsl.sas7bdat*/
PROC COPY IN=Work OUT=MYSNIP;
	SELECT  QC_adsl;
RUN;

/*Creating  Listing for comparing the dataset*/
TITLE "ADaM Dataset Validation (ADSL)";
FOOTNOTE "Validation of ADSL dataset";
ODS LISTING CLOSE;
ODS RTF FILE="/home/u63305936/My Log/QC_adsl.RTF";
PROC COMPARE BASE=Analysis.Adsl COMP=Work.QC_adsl LISTALL;
RUN;
ODS RTF CLOSE;
