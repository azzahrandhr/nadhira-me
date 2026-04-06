clear

* Set seed for reproducibility
set seed 12345

* Create village-level data
set obs 100
generate village_id = _n
generate treatment = (village_id <= 50)

* Expand to woman-level (10 women per village)
expand 10
bysort village_id: generate woman_id = _n

* Expand to panel (before and after)
expand 2
bysort village_id woman_id: generate period = _n - 1
label define period_lbl 0 "Before (2022)" 1 "After (2023)"
label values period period_lbl

* Generate outcome with DiD structure
* Base: 2 visits on average
* Treatment villages slightly lower at baseline: -0.2
* Time trend for everyone: +0.3
* Treatment effect: +0.8 visits

generate prenatal_visits = 2 + ///
    (-0.2) * treatment + ///
    (0.3) * period + ///
    (0.8) * treatment * period + ///
    rnormal(0, 0.8)

* Round to integers (can't have fractional visits)
replace prenatal_visits = round(prenatal_visits, 1)
replace prenatal_visits = 0 if prenatal_visits < 0

save "did_simulation.dta", replace

describe
