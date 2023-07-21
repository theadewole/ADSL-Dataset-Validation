# ADSL Dataset Validation
- Program Developer : Adewole Ogunade
- Date: 10-06-2023
- Project Title: ADSL-Dataset-Validation
- Description: Validation of ADSL dataset by writing independent SAS code. 
## Inputs
    •DM.SAS7bdat (Demographics SDTM dataset)
      •EX.SAS7bdat (Exposure SDTM dataset)
        •DS.SAS7bdat (Disposition SDTM dataset)
          •VS.SAS7bdat (Vital signs SDTM dataset)
            •ADSL.SAS7bdat (Analysis data subject level)

## Output
    •Datasets: LB.sas7bdat 
      •Datasets: QC_adsl.sas7bdat 
        •Programs: QC_adsl.sas 
          •Log: QC_adsl.log 
            •Listing: QC_adsl.ls

## Tasks
	Explained in the Requirement Specification (RSD)

|Variable Name 	|Variable Label |Data Type|Length/Format 	|Algorithm|
|---------------|---------------|---------|---------------|---------|
|STUDYID|Study Identifier|Char|$20|DM.STUDYID|
|USUBJID |Unique Subject Identifier| Char|$20| DM.USUBJID|

[Spreadsheet File of the Final Dataset](https://docs.google.com/spreadsheets/d/1ruB-mbZYnjm60qy-rXbb-9KeiKL9lmns/edit?usp=sharing&ouid=117399581833546938372&rtpof=true&sd=true) 
