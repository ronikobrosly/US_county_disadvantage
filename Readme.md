**OVERVIEW:**

This R script creates a US map that visualizes socioeconomic disadvantage. The data source was the 2005 US Census (publicly available here: http://www.census.gov/statab/ccdb/ccdbstcounty.html). A factor analysis was used to combine the following socioeconomic indicators into one "disadvantage measurement":

* Net 5-year population change
* % non-white residents
* % residents with less than a bachelor's degree
* % households with below $75,000 annual income
* % residents living at or below the poverty line
* Infant deaths per 1,000 live births
* Medicare recipients per 100,000 residents
* % residents that own their dwelling
* Unemployment rate

The file paths must be customized by the user but otherwise the script works.


**REQUIRED LIBRARIES**

Caret, corrplot, maps, mapproj
