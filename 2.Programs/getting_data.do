clear all
capture log close
set more off

log using "F:\Articles\Profit eff of PCFs\3.Results\getting_data.log",replace

/* =============================================================================================================
	Program: "F:\Articles\Profit eff of PCFs\2.Programs\getting_data.do"
	Task:  Getting data from the original data files of the financial sector for analysing profit efficiency
	Project:  Journal Article 1
	Author:  Nguyen Xuan Quang \ 2012-04-25
   ==============================================================================================================*/

// 	#0
// 	program setup
	version 10
	set linesize 80
	local tag "getting_data.do nxq 2012-04-25"

// 	#1
//	YEAR 2007
	use "F:\Data\Establishment census\04-Financial sector\fs2007.dta", clear
	keep if lhdn == 6
	gen year = 2007
	* Generate variables for labor
		replace ld11=0 if ld11==.
		replace ld13=0 if ld13==.
		forvalues i = 1/16 {
                    replace ldct`i'1 = 0 if ldct`i'1 ==.
                }

		* Labor by age range (year-end number)
			gen young = ldct21 + ldct31 + ldct41
			gen middle = ldct51
			gen old = ldct61 + ldct71 + ldct81
			label var young "No. of young workers, age <= 35"
			label var middle "No. of middle age workers, 35 < age <= 45"
			label var old "No. of old workers, age >= 45"

	* Generate common variables for assets and capital:
   		forvalues i = 1/23 {
                    replace ts`i'1 = 0 if ts`i'1 == .
                    replace ts`i'2 = 0 if ts`i'2 == .
                }
		* Generate:
			gen asset1 = ts11 			// Total assets at the beginning of the year
			gen asset2 = ts12			// Total assets at the end of the year
			gen loans1 = ts31+ts91			// Loans and advances to customers: beginning
			gen loans2 = ts32+ts92			// Loans and advances to customers: ending
			gen fx_as1 = ts101			// Fixed assets: beginning
			gen fx_as2 = ts102			// Fixed assets: ending
			gen o_val1 = ts121+ts151+ts181		// Original values of fixed assets: beginning
			gen o_val2 = ts122+ts152+ts182		// Original values of fixed assets: ending
			gen fn_as1 = ts11-loans1 - fx_as1 	// Financial asset: beginning
			gen fn_as2 = ts12-loans2 - fx_as2 	// Financial asset: ending
			gen funds1 = ts221			// Mobility funds (= debts): beginning
			gen funds2 = ts222			// Mobility funds (= debts): ending
			gen equit1 = ts231			// Equity capital: beginning
			gen equit2 = ts232			// Equity capital: ending

	* Generate common variables for income and expenses:
    		forvalues i = 1/64 {
                    replace thu`i' = 0 if thu`i' == .
                }
		gen int_in = thu2-thu5-thu6			// Interest income
		gen nint_in = thu9 - thu13+thu5+thu6		// Non-interest income, excluding internal interest income
		gen oth_in = thu19				// Other income
		gen int_ex = thu21-thu26+thu63			// Interest expenses (plus deposit insurance)
		gen ser_ex = thu28 - thu30			// Services expenses (exclude tele-network fee)
		gen obus_ex = thu33				// Expenses for other business activities such as foreign exchange, stock investment, etc.
		gen tax =thu37					// Taxes and other kinds of fees
		gen lab_ex = thu40 				// Labor expenses
		gen adm_ex = thu47 + thu30			// Administrative expenses
		gen ass_ex = thu58				// Asset expenses (depreciation + asset insurance)
		gen pro_ex = thu62				// Loan loss provisions
		gen oth_ex = thu64				// Other expenses
		replace thu65=thu1-thu20
		gen profit = (int_in + nint_in) - (int_ex + ser_ex + obus_ex + lab_ex + adm_ex + ass_ex) // Profit before tax, extraordinary items and loan losses

	* Keep nessesary variables: (1) Banks' specifications; (2) Characteristics; (3) Information tech; (4) Labor var.; (5) balance sheet var.; (6) Income statement var.
		keep tinh macs namsxkd ld11 ld13 ldct91 ldct101 ldct111 ldct121 ldct131 ldct141 ldct151 ldct161 young middle old so_pc co_lan pc_lan co_int pc_int co_web year asset1 asset2 loans1 loans2 fx_as1 fx_as2 o_val1 o_val2 fn_as1 fn_as2 funds1 funds2 equit1 equit2 int_in nint_in oth_in int_ex ser_ex obus_ex tax lab_ex adm_ex ass_ex pro_ex oth_ex profit
	save "F:\Articles\Profit eff of PCFs\1.Data\coop07.dta", replace

// 	#2
// 	YEAR 2006
	use "F:\Data\Establishment census\04-Financial sector\fs2006.dta", clear
	keep if lhdn==6
	gen year = 2006
	* Labor
		replace ld11=0 if ld11==.
		replace ld13=0 if ld13==.
	* Generate common variables for assets and capital:
                forvalues i = 1/23 {
                replace ts`i'1 = 0 if ts`i'1 == .
                replace ts`i'2 = 0 if ts`i'2 == .
                }
                gen asset1 = ts11 			// Total assets at the beginning of the year
                gen asset2 = ts12			// Total assets at the end of the year
                gen loans1 = ts31+ts91			// Loans and advances to customers: beginning
                gen loans2 = ts32+ts92			// Loans and advances to customers: ending
                gen fx_as1 = ts101			// Fixed assets: beginning
                gen fx_as2 = ts102			// Fixed assets: ending
                gen o_val1 = ts121+ts151+ts181		// Original values of fixed assets: beginning
                gen o_val2 = ts122+ts152+ts182		// Original values of fixed assets: ending
                gen fn_as1 = ts11-loans1 - fx_as1 	// Financial asset: beginning
                gen fn_as2 = ts12-loans2 - fx_as2 	// Financial asset: ending
                gen funds1 = ts221			// Mobility funds (= debts): beginning
                gen funds2 = ts222			// Mobility funds (= debts): ending
                gen equit1 = ts231			// Equity capital: beginning
                gen equit2 = ts232			// Equity capital: ending

	* Generate common variables for income and expenses:
    		forvalues i = 1/63 {
			replace thu`i' = 0 if thu`i' == .
		}

		gen int_in = thu2-thu5-thu6		// Interest income
		gen nint_in = thu9 - thu13+thu5+thu6	// Non-interest income, excluding internal interest income
		gen oth_in = thu19			// Other income
		gen int_ex = thu21-thu25+thu61		// Interest expenses
		gen ser_ex = thu27-thu29		// Services expenses
		gen obus_ex = thu32			// Expenses for other business activities such as foreign exchange, stock investment, etc.
		gen tax =thu36				// Taxes and other kinds of fees
		gen lab_ex = thu39 			// Labor expenses
		gen adm_ex = thu46+thu29		// Administrative expenses
		gen ass_ex = thu56			// Asset expenses (depreciation + asset insurence)
		gen pro_ex = thu59-thu61		// Provision for loan loss
		gen oth_ex = thu62			// Other expenses
		replace thu63=thu1-thu20
		gen profit = (int_in + nint_in) - (int_ex + ser_ex + obus_ex + lab_ex + adm_ex + ass_ex) // Profit before tax, extraordinary items and loan losses


	* Keep nessesary variables: (1) Banks' specifications; (2) Characteristics; (3) Information tech; (4) Labor var.; (5) balance sheet var.; (6) Income statement var.
		keep tinh macs madn ld11 ld12 ld13 ld14 year asset1 asset2 loans1 loans2 fx_as1 fx_as2 o_val1 o_val2 fn_as1 fn_as2 funds1 funds2 equit1 equit2 int_in nint_in oth_in int_ex ser_ex obus_ex tax lab_ex adm_ex ass_ex pro_ex oth_ex profit

	save "F:\Articles\Profit eff of PCFs\1.Data\coop06.dta", replace
	clear

// 	#3
// 	YEAR 2005
	use "F:\Data\Establishment census\04-Financial sector\fs2005.dta", clear
	keep if lhdn==6 		// drop firms owned by one person which could not be banks or other kinds of credit institutions
	gen year = 2005
	replace ld11=0 if ld11==.
	replace ld13=0 if ld13==.
	* Generate common variables for assets and capital:
		* Replace missing values with zero values:
    			forvalues i = 1/20 {
                            replace ts`i'1 = 0 if ts`i'1 == .
                            replace ts`i'2 = 0 if ts`i'2 == .
			}
		* Generate:
			gen asset1 = ts11 			// Total assets at the beginning of the year
			gen asset2 = ts12			// Total assets at the end of the year
			gen loans1 = ts31			// Loans and advances to customers: beginning
			gen loans2 = ts32			// Loans and advances to customers: ending
			gen fx_as1 = ts131			// Fixed assets: beginning
			gen fx_as2 = ts132			// Fixed assets: ending
			gen o_val1 = ts151			// Original values of fixed assets: beginning
			gen o_val2 = ts152			// Original values of fixed assets: ending
			gen fn_as1 = asset1-loans1 - fx_as1 	// Financial asset: beginning
			gen fn_as2 = asset2-loans2 - fx_as2 	// Financial asset: ending
			gen funds1 = ts191			// Mobility funds (= debts): beginning
			gen funds2 = ts192			// Mobility funds (= debts): ending
			gen equit1 = ts201			// Equity capital: beginning
			gen equit2 = ts202			// Equity capital: ending

	* Generate common variables for income and expenses:
    		forvalues i = 1/62 {
                    replace thu`i' = 0 if thu`i' == .
		}
		gen int_in = thu2 - thu5 - thu6			// Interest income
		gen nint_in = thu9 - thu13+thu5+thu6		// Non-interest income, excluding internal interest income
		gen oth_in = thu19				// Other income
		gen int_ex = thu21-thu25+thu61			// Interest expenses
		gen ser_ex = thu27-thu29			// Services expenses
		gen obus_ex = thu32				// Expenses for other business activities such as foreign exchange, stock investment, etc.
		gen tax =thu36					// Taxes and other kinds of fees
		gen lab_ex = thu39 				// Labor expenses
		gen adm_ex = thu46+thu29			// Administrative expenses
		gen ass_ex = thu56				// Asset expenses (depreciation + asset insurence)
		gen pro_ex = thu59-thu61			// Provision for loan loss
		gen oth_ex = thu62				// Other expenses
		replace thu63=thu1-thu20
		gen profit = (int_in + nint_in) - (int_ex + ser_ex + obus_ex + lab_ex + adm_ex + ass_ex) // Profit before tax, extraordinary items and loan losses


	* Keep nessesary variables: (1) Banks' specifications; (2) Characteristics; (3) Information tech; (4) Labor var.; (5) balance sheet var.; (6) Income statement var.
		keep tinh macs madn ncap4 ld11 ld12 ld13 ld14  so_pc co_lan pc_lan co_int pc_int co_web co_dsdv year asset1 asset2 loans1 loans2 fx_as1 fx_as2 o_val1 o_val2 fn_as1 fn_as2 funds1 funds2 equit1 equit2 int_in nint_in oth_in int_ex ser_ex obus_ex tax lab_ex adm_ex ass_ex pro_ex oth_ex profit

	save "F:\Articles\Profit eff of PCFs\1.Data\coop05.dta", replace

// 	#4
// 	YEAR 2004
	use "F:\Data\Establishment census\04-Financial sector\fs2004.dta", clear
	keep if lhdn==6
	gen year = 2004
	replace ld11=0 if ld11==.
	replace ld13=0 if ld13==.
	* Generate common variables for assets and capital:
		* Replace missing values with zero values:
    			forvalues i = 1/20 {
                            replace ts`i'1 = 0 if ts`i'1 == .
                            replace ts`i'2 = 0 if ts`i'2 == .
                        }
		* Generate:
			gen asset1 = ts11 			// Total assets at the beginning of the year
			gen asset2 = ts12			// Total assets at the end of the year
			gen loans1 = ts31			// Loans and advances to customers: beginning
			gen loans2 = ts32			// Loans and advances to customers: ending
			gen fx_as1 = ts131			// Fixed assets: beginning
			gen fx_as2 = ts132			// Fixed assets: ending
			gen o_val1 = ts151			// Original values of fixed assets: beginning
			gen o_val2 = ts152			// Original values of fixed assets: ending
			gen fn_as1 = asset1-loans1 - fx_as1 	// Financial asset: beginning
			gen fn_as2 = asset2-loans2 - fx_as2 	// Financial asset: ending
			gen funds1 = ts191			// Mobility funds (= debts): beginning
			gen funds2 = ts192			// Mobility funds (= debts): ending
			gen equit1 = ts201			// Equity capital: beginning
			gen equit2 = ts202			// Equity capital: ending

	* Generate common variables for income and expenses:
		forvalues i = 1/62 {
                    replace thu`i' = 0 if thu`i' == .
                }

		gen int_in = thu2 - thu5			// Interest income
		gen nint_in = thu8 - thu12 + thu5		// Non-interest income, excluding internal interest income
		gen oth_in = thu18+ thu19			// Other income
		gen int_ex = thu21-thu25+thu60			// Interest expenses
		gen ser_ex = thu27-thu29			// Services expenses
		gen obus_ex = thu32				// Expenses for other business activities such as foreign exchange, stock investment, etc.
		gen tax =thu36					// Taxes and other kinds of fees
		gen lab_ex = thu39 				// Labor expenses
		gen adm_ex = thu46+thu29			// Administrative expenses
		gen ass_ex = thu55				// Asset expenses (depreciation + asset insurence)
		gen pro_ex = thu58-thu60			// Provision for loan losses
		gen oth_ex = thu61+thu62			// Other expenses
		replace thu63=thu1-thu20
		gen profit = (int_in + nint_in) - (int_ex + ser_ex + obus_ex + lab_ex + adm_ex + ass_ex) // Profit before tax, extraordinary items and loan losses

	* Keep nessesary variables: (1) Banks' specifications; (2) Characteristics; (3) Information tech; (4) Labor var.; (5) balance sheet var.; (6) Income statement var.
		keep tinh macs madn ncap4 ld11 ld12 ld13 ld14 so_pc co_lan pc_lan co_int pc_int co_web co_dsdv year asset1 asset2 loans1 loans2 fx_as1 fx_as2 o_val1 o_val2 fn_as1 fn_as2 funds1 funds2 equit1 equit2 int_in nint_in oth_in int_ex ser_ex obus_ex tax lab_ex adm_ex ass_ex pro_ex oth_ex profit

	save "F:\Articles\Profit eff of PCFs\1.Data\coop04.dta", replace

// 	#5
// 	YEAR 2003
	use "F:\Data\Establishment census\04-Financial sector\fs2003.dta", clear
	tab lhdn
	keep if lhdn==6
	gen year = 2003
	replace ld11=0 if ld11==.
	replace ld13=0 if ld13==.
	* Generate common variables for assets and capital:
		* Replace missing values with zero values:
			forvalues i = 1/16 {
                            replace ts`i'1 = 0 if ts`i'1 ==.
                            replace ts`i'2 = 0 if ts`i'2 ==.
                        }
		* Generate:
			gen asset1 = ts11 			// Total assets at the beginning of the year
			gen asset2 = ts12			// Total assets at the end of the year
			gen loans1 = ts31			// Loans and advances to customers: beginning
			gen loans2 = ts32			// Loans and advances to customers: ending
			gen fx_as1 = ts101			// Fixed assets: beginning
			gen fx_as2 = ts102			// Fixed assets: ending
			gen o_val1 = ts111			// Original values of fixed assets: beginning
			gen o_val2 = ts112			// Original values of fixed assets: ending
			gen fn_as1 = asset1-loans1 - fx_as1 	// Financial asset: beginning
			gen fn_as2 = asset2-loans2 - fx_as2 	// Financial asset: ending
			gen funds1 = ts151			// Mobility funds (= debts): beginning
			gen funds2 = ts152			// Mobility funds (= debts): ending
			gen equit1 = ts161			// Equity capital: beginning
			gen equit2 = ts162			// Equity capital: ending

	* Generate common variables for income and expenses:
		forvalues i = 1/66 {
                    replace thu`i' = 0 if thu`i' ==.
                }
		gen int_in = thu2+thu8				// Interest income
		gen nint_in = thu7-thu8 + thu12			// Non-interest income, excluding internal interest income
		gen oth_in = thu20				// Other income
		gen int_ex = thu22-thu26+thu63			// Interest expenses
		gen ser_ex = thu28-thu30			// Services expenses
		gen obus_ex = thu33				// Expenses for other business activities such as foreign exchange, stock investment, etc.
		gen tax =thu37					// Taxes and other kinds of fees
		gen lab_ex = thu40 				// Labor expenses
		gen adm_ex = thu47+thu30			// Administrative expenses
		gen ass_ex = thu58				// Asset expenses (depreciation + asset insurence)
		gen pro_ex = thu62				// Provision for loan losses
		gen oth_ex = thu64+thu65			// Other expenses
		replace thu66=thu1-thu21
		gen profit = (int_in + nint_in) - (int_ex + ser_ex + obus_ex + lab_ex + adm_ex + ass_ex) // Profit before tax, extraordinary items and loan losses

	* Keep nessesary variables: (1) Banks' specifications; (2) Characteristics; (3) Information tech; (4) Labor var.; (5) balance sheet var.; (6) Income statement var.
		keep tinh macs madn ld11 ld12 ld13 ld14 so_pc co_lan pc_lan co_int pc_int co_web co_dsdv year asset1 asset2 loans1 loans2 fx_as1 fx_as2 o_val1 o_val2 fn_as1 fn_as2 funds1 funds2 equit1 equit2 int_in nint_in oth_in int_ex ser_ex obus_ex tax lab_ex adm_ex ass_ex pro_ex oth_ex profit

	save "F:\Articles\Profit eff of PCFs\1.Data\coop03.dta", replace
	clear
log close

