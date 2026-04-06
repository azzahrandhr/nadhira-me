* Load wide-format data
use "wb_cleaned_wide.dta", clear

* Detailed distribution statistics
summarize gdp, detail
