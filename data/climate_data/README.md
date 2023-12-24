### Note 
At the moment, the data used in this project is undergoing continuous updates and refinement.  
As a result, we have not included it in the current version of this repository.  
We are committed to open science and will make the data publicly available in this repository as soon as the ongoing processes are finalized and validated.  


## METEOROLOGICAL DATA
Get data at http://www.data.jma.go.jp/gmd/risk/obsdl/index.php  

## Data description
| Variable          	| Units   	|
|:----------------------------|:-----------------:|
| Date              	|         	|
| Average temperature	| °C     		|
| Maximum temperature	| °C     		|
| Minimum temperature	| °C     		|
| Total precipitation	| milimeter	|
| Daylight hours              | hours        	|	
| Total solar radiation       | MJ/㎡        	|
| Average wind speed         	| m/s   		|
| Maximum wind speed          | m/s      	|
| Average cloud cover         | 10 minute ratio 	|
| Average humidity            | %  		|

## Information of meteorological stations
|Station	|Latitude		|Longitude	|Lat	|Long	|Altitude (meter)	|
|:--------|:------------------|:------------------|:--------|:--------|:------------------|
|Nagasaki	|N 32°44.0'	|E 129°52.0'	|32.7333	|129.8667	|26.9		|
|Omura	|N 32°55.0'	|E 129°54.8'	|32.9167	|129.9002	|3.0		|
|Shimabara|N 32°45.6'	|E 130°21.7'	|32.7502	|130.3502	|14.0		|
|Unzen	|N 32°44.2'	|E 130°15.7'	|32.7334	|130.2502	|677.5		|

## Note
- 2021-08-27: data from 2017-04-01 to 2018-05-31 --> calculate 30-day prior to collection date  
- 2022-05-09: calculate maximum 135 days prior to collection date  
+ data from 2017-01-01 to 2017-08-31  
+ data from 2018-01-01 to 2018-05-31  

## Air TEMP of Japan: (meteorological station)
1. http://www.jma.go.jp/jma/index.html
2. http://www.data.jma.go.jp/gmd/risk/obsdl/index.php
3. choose section 2.2 (choose gg translate "search and download past weather data")
4. select Nagasaki Pref
5. click on chosen station
6. click on section 2 on the menu bar to choose "Daily Average TEMP"
7. click on section 3 to choose display period
8. click on "CSV sth." (right-side)

- Altitude: https://www.maps.ie/coordinates.html

*Formula:* siteTemp = (staElev -siteElev)* (0.6/100) + staTemp


