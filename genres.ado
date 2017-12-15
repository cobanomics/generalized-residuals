*==================================================================================================================*
*											COMMAND: GENRES
*==================================================================================================================*

*! 	Version 1.0	18January2017
*!	Mustafa Coban, Department of Economics, University of Wuerzburg
*!	Compute Generalized Residuals after Probit or Ordered Probit Models
*!	Compute Residuals after OLS
*!	C.f. Vella (1993, 1998)

capture program drop genres
program define genres, rclass
	
	syntax newvarlist(max=1 numeric gen) [if] [in]
	
	marksample 	touse, novarlist
	
	tempvar xb
	tempname B C T
	
	replace `varlist' = 0
	
	local command 	= e(cmd)
	local depvar 	= e(depvar)
	
	
	/*		OLS CASE		*/
	
	
	if `"`command'"' == "regress"{
		
		tempvar olsres
		
		predict `olsres', res
		replace `varlist' = `olsres'
		
	}
	*
	
	
	
	
	
	
	/*		PROBIT CASE		*/
	
	if `"`command'"' == "probit"{
		
		predict `xb' 						if `touse', xb	
		replace `xb' = `xb' - _b[_cons]		if `touse'
		
				//	Linear Prediction without Threshold / Intercept
		
		qui: sum `depvar'
		local prmin = `r(min)'
		local prmax = `r(max)'
		
		
		replace `varlist' = cond(`depvar' == `prmax', normalden(`xb')/normal(`xb'), -normalden(`xb')/(1-normal(`xb')))
		
	}
	*
		

	
	
	
	/*		ORDERED PROBIT CASE		*/
	
	if `"`command'"' == "oprobit"{
		
		predict `xb' if `touse', xb		
			
				//	Linear Prediction without Thresholds / Intercepts
	
		mat `B' 	= e(b)
		mat `C'		= e(cat)
	
		local ncat 	= e(k_cat)
		local k		= colsof(`B') - `ncat' + 1
	
		mat `T'		= `B'[1,`k'+1..colsof(`B')]
	
	
	
		forvalue x = 1(1)`ncat'{
			tempvar d`x'
			gen `d`x'' = `depvar' == `C'[1,`x'] 	if `depvar' < .
		}
		*	
	
		
	
	
		/*		GENERALIZED RESIDUALS		*/
	
	
		local j = 1
	
		while `j' <= `ncat'{
		
			tempvar u`j'
		
		
			***		LOWEST CATEGORY		***
		
			if `j' == 1{
			
				qui: gen `u1' = (-1) * (normalden(`T'[1,1] - `xb')) / normal(`T'[1,1] - `xb')
			
			}
			*
		
		
			***		INTERMEDIATE CATEGORIES		***
		
			if `j' > 1 & `j' < `ncat'{
			
				qui: gen `u`j'' = 	(normalden(`T'[1,`j'-1] - `xb') - normalden(`T'[1,`j'] - `xb')) ///
									/ ///
									(normal(`T'[1,`j'] - `xb') - normal(`T'[1,`j'-1] - `xb'))
			}
			*
	
	
			***		HIGHEST CATEGORY		***
		
			if `j' == `ncat'{
			
				qui: gen `u`j'' = normalden(`T'[1,`j'-1] - `xb') / (1 - normal(`T'[1,`j'-1] - `xb'))
			}
			*
		
			local j = `j' + 1
		}
		*
	
		local j = 1
	
		while `j' <= `ncat'{
		
			replace `varlist' = `varlist' + `d`j'' * `u`j''
		
			local j = `j' + 1
		
		}
		*
	}
	*
end
