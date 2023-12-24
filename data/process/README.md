### Note 
At the moment, the data used in this project is undergoing continuous updates and refinement.  
As a result, we have not included it in the current version of this repository.  
We are committed to open science and will make the data publicly available in this repository as soon as the ongoing processes are finalized and validated.  


## DATA DESCRIPTION
| Variable          | Units   | Note	|
|:------------------|:-------:|:--------|
| ID                |         |
| Site_name         |         |
| ID_name           |         |
| samplingDate   	|         | Collection_date|
| Month             |         |
| Year              |         |
| Lat	          |         | Latitude|
| Long	          |         | Longitude|
| Location          |         |
| Elevation         | meter   |
| climateStation	|	| Climate monitoring Station|
| siteTemp	| °C      | (airTEMP) average, x-day prior to sampling date|
| Rain		|milimeter| total rainfall of x-day prior to sampling date|
| Wind		| m/s	| average wind speed of x-day prior to sampling date|
| Chla              | µg/L    | Chlorophyll-a|
| PC                | cps/mL  | PC (phycocyanin) gene|
| mcyB              | cps/mL  | mcyB gene|
| mlrA              | cps/mL  | mlrA gene|
| TSS               | mg/L    |
| TN                | mg/L    |
| NO~2~             | mg/L    |
| NO~3~             | mg/L    |
| PO~4~             | mg/L    |
| NH~4~             | mg/L    |
| TP                | mg/L    |
| SD_*		|	|

## Note
* `naga_data01.csv`:  
	* climate variable: airTemp (average temperature of 30-day prior to sampling date)  
	* used in data analysis before 2021-08-26  
	* `.csv` version of `Naga_data01.xlsx`  
* `naga_data*.csv`:  
	* climate variable: siteTemp, rain, wind  
	* used in data analysis after 2021-08-26 (issue #3, issue #28)  
	* `*`: 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 days prior to sampling date  

* DNA detection limit: 8.81 x 10^0 cps/uL = 8810 cps/mL (of standard genomic DNA)


