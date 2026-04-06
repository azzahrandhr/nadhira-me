
clear

/* a) Import CSV with proper variable types */
import delimited "wb_indicators_2015_2024.csv", varnames(1) ///
    numericcols(5 6 7 8 9 10 11 12 13 14)

/* b) Examine initial data structure. */
describe

/* c) Generate row id and remove regional aggregates. Upon eyeballing the data we observe that entries after row 1085 are regional/world aggregates */
generate id = _n
keep if id < 1086

/* d) Reshape from wide to long format and use the column name as the value for yr */
reshape long yr, i(id) j(year)
rename yr seriesvalue

/* e) Since we found several countries with some years that have null indicator, we further clean the data by keeping most recent non-missing value per country-indicator */
gsort countrycode seriescode -year
keep if seriesvalue < .
gsort seriescode seriesname countrycode countryname -year
by seriescode seriesname countrycode countryname: keep if _n == 1
sort countryname seriescode

* Save cleaned long-format data
save "wb_cleaned_long.dta", replace
