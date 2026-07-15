
#Data cleaning 

rename A PROV

rename B condition

rename C outcome 

rename D year

drop in 1 

destring outcome, replace 

destring PROV, replace

destring year, replace

gen rel_year = year - 2018

gen rel_year_shifted = rel_year + 5

drop rel_year

replace rel_year = 10 if year == 2024

tostring PROV, gen(PROV_str) format(%12.0g)


gen state = ""
replace state = "ARK" if substr(PROV_str, 1, 2) == "40"
replace state = "MS"  if substr(PROV_str, 1, 2) == "25"
replace state = "OK"  if substr(PROV_str, 1, 2) == "37"
replace state = "MO"  if substr(PROV_str, 1, 2) == "26"

drop if outcome == 0

drop if outcome == . 

gen post = year >= 2018


egen hosp_fe = group(PROV)


tab rel_year_shifted intervention
	
tab state intervention

#Analysis


testparm 2bn.rel_year_shifted#1bn.intervention 3bn.rel_year_shifted#1bn.intervention

reghdfe outcome ib4.rel_year_shifted##i.intervention i.cond_id, absorb(PROV) vce(cluster PROV)

tab rel_year_shifted intervention

reghdfe outcome ib4.rel_year_shifted##i.intervention, vce(cluster PROV)


reghdfe outcome ib4.rel_year_shifted##i.intervention i.cond_id, vce(cluster PROV)

margins rel_year_shifted#intervention

#Graphing

marginsplot, recast(line) noci ///
    title("Event Study: Outcome by Treatment Status Over Time") ///
    xtitle("Year") ///
    ytitle("Predicted Outcome") ///
    legend(label(1 "Control") label(2 "Treated")) ///
    xline(5, lpattern(dash)) ///
    xlabel(1 "2014" 2 "2015" 3 "2016" 4 "2017" 5 "2018" ///
           6 "2019" 7 "2020" 8 "2021" 9 "2022" 10 "2024")

marginsplot, recast(line) noci ///
    title("Outcome by Treatment Status Over Time") ///
    xtitle("Year") ///
    ytitle("ERR outcome") ///
    legend(label(1 "Control") label(2 "Treated")) ///
    xline(5, lpattern(dash)) ///
    xlabel(1 "2014" 2 "2015" 3 "2016" 4 "2017" 5 "2018" ///
           6 "2019" 7 "2020" 8 "2021" 9 "2022" 10 "2024") ///
    plotopts(lcolor(blue) lpattern(solid)) ///
    plot1opts(lcolor(gs10)) plot2opts(lcolor(blue))

		   
		 
		   
		   
gen post = rel_year_shifted >= 5
		   
		   
drop post 


reghdfe outcome i.post##i.intervention i.cond_id, vce(cluster PROV)

tab cond_id

tab cond_id

