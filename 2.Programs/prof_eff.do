clear all
capture log close
set more off

log using "F:\Articles\Profit eff of PCFs\3.Results\prof_eff.log",replace

/* =============================================================================================================
	Program: "F:\Articles\Profit eff of PCFs\2.Programs\prof_eff.do"
	Task:  Analyse the profit efficiency of the People Credit Funds (the cooperative banks) in Vietnam during 2003-2007
	Project:  Journal Article 1
	Author:  Nguyen Xuan Quang \ 2012-04-25
   ==============================================================================================================*/

// 	#0
// 	program setup
	version 10
	set linesize 80
	local tag "prof_eff.do nxq 2012-04-25"

// 	#1
// 	Create panel data
	use "F:\Articles\Profit eff of PCFs\1.Data\coop03.dta", clear
	append using "F:\Articles\Profit eff of PCFs\1.Data\coop04.dta"
	append using "F:\Articles\Profit eff of PCFs\1.Data\coop05.dta"
	append using "F:\Articles\Profit eff of PCFs\1.Data\coop06.dta"
	append using "F:\Articles\Profit eff of PCFs\1.Data\coop07.dta"
	duplicates drop year tinh macs, force

//	#2
//	Create variables
	gen roa = profit*2/(asset1+asset2)
	label var roa "Returns on assets"

	* Output and output price
		gen y1 = (loans1 + loans2)/2		// Loans and advances to customers
		gen y2 = (fn_as1+fn_as2)/2		// Other financial assets
		label var y1 "Loans and advances to customers"
		label var y2 "Other financial assets"

	* Inputs and input prices
		gen x1 = (funds1+funds2)/2		// Deposits
		gen x2 = (ld11+ld13)/2			// Labors
		gen x3 = (fx_as1 + fx_as2)/2		// Physical capital (net value of fixed assets)
		gen w1 = int_ex/x1			// Price of mobilized funds
		gen w2 = lab_ex/x2			// Price of labor
		gen w3 =  ass_ex/x3			// Price of Physical capital
		gen z = (equit1 + equit2)/2		// Fixed netput (Equity capital)
		label var x1 "Deposits"
		label var x2 "Average number of workers"
		label var x3 "Physical capital"
		label var w1 "Price of deposits"
		label var w2 "Price of labor"
		label var w3 "Price of physical capital"
		label var z "Average equity"

	* Clean data
		drop if y1 == 0				// Remove all banks without lending activities
		drop if w1 == 0 | w2 == 0 | w3 == 0	// Remove all banks with zero input prices
		drop if x3 == 0				// Remove all banks with no fixed assets
		gen check = (x1*2)/(asset1+asset2)	// Ratio of deposits over average assets
		drop if check == 1|check == 0		// Remove banks if they don't have deposits or their deposits equal to total asset

		sum w1 w2 w3
		drop if w1 > 1				// Interest expenses greater than mobility funds
		drop if w2 < 6				// Average labor income smaller than 6 millions or monthly labor income is below 500.000VND
		drop if w3 > 1				// Asset expenses is greater than the value of fixed assets

	* Deflate variables using CPI, base year = 2003
		gen cpi = 1
		replace cpi = 1.0771 if year == 2004
		replace cpi = 1.16639159 if year == 2005
		replace cpi = 1.253637681 if year == 2006
		replace cpi = 1.357689608 if year == 2007
		replace profit = profit/cpi
		replace y1 = y1/cpi
		replace y2 = y2/cpi
		replace z = z/cpi
		replace w2 = w2/cpi

	* Cross terms
		gen y11 = (y1^2)/2
		gen y12 = y1*y2
		gen y22 = (y2^2)/2

		gen w11 = (w1^2)/2
		gen w12 = w1*w2
		gen w13 = w1*w3
		gen w22 = (w2^2)/2
		gen w23 = w2*w3
		gen w33 = (w3^2)/2

		gen y1w1 = y1*w1
		gen y1w2 = y1*w2
		gen y1w3 = y1*w3
		gen y2w1 = y2*w1
		gen y2w2 = y2*w2
		gen y2w3 = y2*w3

		gen z2  = (z^2)/2
		gen y1z = y1*z
		gen y2z = y2*z
		gen w1z = w1*z
		gen w2z = w2*z
		gen w3z = w3*z

                gen t = 1				// Generate a time trend variable with value = 1, 2, ..., 5
                forvalues i = 4/7 {
                    replace t = `i'- 2 if year == 200`i'
                }
		gen t2  = (t^2)/2
		gen ty1 = t*y1
		gen ty2 = t*y2
		gen tw1 = t*w1
		gen tw2 = t*w2
		gen tw3 = t*w3
		gen tz  = t*z

//	#3
//	Run the frontier model & calculate efficiency scores
		local rhs y1 y2 y11 y12 y22 w1 w2 w3 w11 w12 w13 w22 w23 w33 y1w1 y1w2 y1w3 y2w1 y2w2 y2w3 z z2 y1z y2z w1z w2z w3z t t2 ty1 ty2 tw1 tw2 tw3 tz
		frontier profit `rhs', dist(exponential)
		predict u, u
		gen eff = profit/(profit+u)
		label var eff "Alternative profit efficiency score"
		replace eff = (profit+u)/profit if (profit+u) < 0	// for case of negative actual profit and potential profit
		replace eff = profit/u if profit < 0 & (profit+u) > = 0 	// for case of negative actual profit and positive potential profit

//	#4
//	Analyse the results
	* Generate geographical regions
		gen region = "Red River Delta"
		replace region = "Northeast" if tinh=="02"|tinh=="04"|tinh=="06"|tinh=="08"|tinh=="19"|tinh=="20"|tinh=="22"|tinh=="24"|tinh=="25"
		replace region = "Northwest" if tinh=="10"|tinh=="11"|tinh=="12"|tinh=="14"|tinh=="15"|tinh=="17"
		replace region = "North Central Coast" if tinh=="38"|tinh=="40"|tinh=="42"|tinh=="44"|tinh=="45"|tinh=="46"
		replace region = "South Central Coast" if tinh=="48"|tinh=="49"|tinh=="51"|tinh=="52"|tinh=="54"|tinh=="56"|tinh=="58"|tinh=="60"
		replace region = "Central Highlands" if tinh=="62"|tinh=="64"|tinh=="66"|tinh=="67"|tinh=="68"
		replace region = "Southeast" if tinh=="70"|tinh=="72"|tinh=="74"|tinh=="75"|tinh=="77"|tinh=="79"
		replace region = "Mekong River Delta" if tinh=="80"|tinh=="82"|tinh=="83"|tinh=="84"|tinh=="86"|tinh=="87"|tinh=="89"|tinh=="91"|tinh=="92"|tinh=="93"|tinh=="94"|tinh=="95"|tinh=="96"

	* Table 4.1: The allocation of cooperative banks in the sample, 2003-07
		table region year, col row

	* Table 4.2: Means and standard deviations (in brackets) of variables
		forvalues i = 1/5 {
			sum profit if t==`i'
			scalar meanpi`i' = r(mean)
			scalar sdpi`i' = -r(sd)
			sum y1 if t ==`i'
			scalar meany1`i' = r(mean)
			scalar sdy1`i' = -r(sd)
			sum y2 if t == `i'
			scalar meany2`i' = r(mean)
			scalar sdy2`i' = -r(sd)
			sum w1 if t == `i'
			scalar meanw1`i' = r(mean)
			scalar sdw1`i' = -r(sd)
			sum w2 if t == `i'
			scalar meanw2`i' = r(mean)
			scalar sdw2`i' = -r(sd)
			sum w3 if t == `i'
			scalar meanw3`i' = r(mean)
			scalar sdw3`i' = -r(sd)
			sum z if t == `i'
			scalar meanz`i' = r(mean)
			scalar sdz`i' = -r(sd)
			}
		matrix VARSUM =(meanpi1, meanpi2, meanpi3, meanpi4, meanpi5 \ ///
				sdpi1, sdpi2, sdpi3, sdpi4, sdpi5 \ ///
				meany11, meany12, meany13, meany14, meany15 \ ///
				sdy11, sdy12, sdy13, sdy14, sdy15 \ ///
				meany21, meany22, meany23, meany24, meany25 \ ///
				sdy21, sdy22, sdy23, sdy24, sdy25 \ ///
				meanw11, meanw12, meanw13, meanw14, meanw15 \ ///
				sdw11, sdw12, sdw13, sdw14, sdw15 \ ///
				meanw21, meanw22, meanw23, meanw24, meanw25 \ ///
				sdw21, sdw22, sdw23, sdw24, sdw25 \ ///
				meanw31, meanw32, meanw33, meanw34, meanw35 \ ///
				sdw31, sdw32, sdw33, sdw34, sdw35 \ ///
				meanz1, meanz2, meanz3, meanz4, meanz5 \ ///
				sdz1, sdz2, sdz3, sdz4, sdz5 )
		matrix rownames VARSUM = Profit sd(prof) y1 sd(y1) y2 sd(y2) w1 sd(w1) w2 sd(w2) w3 sd(w3) z sd(z)
		matrix colnames	VARSUM = 2003 2004 2005 2006 2007
		* Table 4.2: Means and standard deviations (in brackets) of variables
			matrix list VARSUM

	* Table 4.3: Summary statistics for alternative profit efficiency
		tabstat eff, by(year) stat(n mean sd min max)

	* Table 4.4: Alternative profit efficiency by age of bank
		keep tinh macs t ld11 ld13 ldct91 ldct101 ldct111 ldct121 ldct131 ldct141 ldct151 ldct161 asset1 asset2 equit1 equit2 namsxkd young middle old roa eff region
		replace t = t+2		// t = 3, ..., 7
		reshape wide ld11 ld13 ldct91 ldct101 ldct111 ldct121 ldct131 ldct141 ldct151 ldct161 asset1 asset2 equit1 equit2 namsxkd young middle old roa eff region, i(tinh macs) j(t)
		forvalues i=3/7 {
                    gen age`i' = (200`i' - namsxkd7 + 1) if eff`i' !=.
                    label var age`i' "Bank's age"
                    }

		forvalues i = 3/7 {
                    gen r_young`i' = young7/ld13`i' if eff`i' != .	// The ratio of young workers over total No. of workers at year-end
                    gen ts`i' = ldct917/ld13`i' if eff`i'!=.		// Ratio of workers with doctoral degree
                    gen ths`i' = ldct1017/ld13`i' if eff`i' !=.		// ~ master
                    gen dh`i' = ldct1117/ld13`i' if eff`i' !=.		// ~ bachelor
                    gen cd`i' = ldct1217/ld13`i' if eff`i' !=.		// ~ 3-year bachelor
                    gen trc`i' = ldct1317/ld13`i' if eff`i' !=.		// ~ 2-year college
                    gen dnd`i' = ldct1417/ld13`i' if eff`i' !=.		// ~ long-term vocational training
                    gen dnn`i' = ldct1517/ld13`i' if eff`i' !=.		// ~ short-term vocational training
                    gen uedu`i' = ldct1617/ld13`i' if eff`i' !=.	// Uneducated workers
                }

		reshape long ld11 ld13 asset1 asset2 equit1 equit2 namsxkd young middle old ldct91 ldct101 ldct111 ldct121 ldct131 ldct141 ldct151 ldct161 ts ths dh cd trc dnd dnn uedu roa eff region age r_young, i(tinh macs) j(t)
		drop if eff == .

		* Table 4.4: Alternative profit efficiency by age of bank
		tabstat eff, by(age) stat(n mean sd)			// how mean efficiency changes according to age
		sum eff if age > 15 & age!=.

	* Table 4.5: Mean alternative profit efficiency by years and geographical regions
		tabstat eff if t==3, by(region)
		tabstat eff if t==4, by(region)
		tabstat eff if t==5, by(region)
		tabstat eff if t==6, by(region)
		tabstat eff if t==7, by(region)

	* Factors affecting profit efficiency
		tabulate region, gen(REG)		// Create dummy variables for regions
		gen lnasset = log((asset1+asset2)/2)	// Proxy for banks' size
		replace t = t-2				// t = 1, ..., 5
		gen edu1 = cd+dh+ths+ts
		gen edu2 = trc
		gen edu = edu1+edu2
		local location REG1 REG2 REG3 REG4 REG5 REG6 REG7
		* Tobit regression
			tobit eff `location' lnasset age t, ll(-1) ul(1)
			tobit eff `location' lnasset age edu1 r_young if t==5, ll(-1) ul(1)
			tobit eff `location' lnasset age edu2 r_young if t==5, ll(-1) ul(1)
			tobit eff `location' lnasset age edu r_young if t==5, ll(-1) ul(1)
		* Truncated regression
			truncreg eff `location' lnasset age t, ll(-1) ul(1)
			truncreg eff `location' lnasset age edu r_young if t==5, ll(-1) ul(1)

log close
