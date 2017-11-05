********************************************************************************
********************************************************************************
*** MEASURING EARNINGS AMONG 740 OBSERVATIONS AND ANALYSIS OF RELATIONSHIP AMONG VARIABLES ***
						* created: OCTOBER, 28TH 2017 *
						* Last update: OCTOBER, 29th 2017 *
				* Coded by: BALA KRISHNA REDDY KESARI *
		                 * kkesari@results.org *
			             * bkesari@outlook.com *
			
			
			
				   
*Outline:  ********************************************************************************
*---------



* Data Description

* Dataset owner: Oxford University Press
* Data source: http://global.oup.com/uk/orc/busecon/economics/dougherty5e/student/datasets/eawe/stata/
* Datafile: Subset1 
* File Name: EAWE01.dta



* DO FILE Data Description

** Summary:
/* Measuring Earnings among 740 observations aged from 27 and 31 and professional education.
	Information of the Ethinicity, Urban, Age and Verbal proficiency was included. The data is evaluated as in the file EAWE01.dta
	

	
/* Overall Data Analysis Strategy

	/*
	1- Data Preperation
		a- Excel Preperation Brief
		b- Browsing data to check for labels and variables type
		c- Checking for Missing Data
		d- Imputing missing data with simple regression
		e- Classifying Not applicable variables
		
    /* Questions Analysis wants to Answer: w/ interpretation of results
	
	2- Calculate the linear correlation coefficient between the variables Earnings and Professional Education, as well as its 95% Confidence Interval
		
	3- Display the totality of the numerical data in the form of scatterplots, that is 49 graphs arranged in the form of a "dispersion Matrix"
	
	4- Calculate all of the Pearson and Spearman correlations between the selected numerical variables
	
	5- Construct a regression model, including earnings centered on thier professional eduction and their age and Verbal skills. 
	
	6- Graphical representation of two-factor ANOVA & adjusted Predictions of Professional Education and Urban living, still considering earning (EARNINGS) as a response variable with 95 % CI
	
	
	
	

																			*/
* --------------------------------------------------------------------------------             
* Setting Directory: 
* -----------------
*/ 
*/ */

cd "/Users/Balu/Downloads"

capture log close

log using "log\Log.log", replace 

use "/Users/Balu/Downloads/EAWE01.dta"

set more off

describe




********************************************************************************
*****************************1- Data Preperation *******************************
********************************************************************************

* Intial Data Screening, check for variables, labels & missing data
*/

browse

summarize 

mi set mlong

mi misstable summarize, all

* Imputing JOBS variable using linear Regression 

generate lnJOBS = ln(JOBS)
mi register imputed lnJOBS
mi impute regress lnJOBS AGE ETHBLACK ETHWHITE ETHHISP URBAN VERBAL, add(20) rseed(1234)

*/ 
* Imputed 12 missing values using linear Regression
* Convering log values to exponentials and replacing JOBS with imputed data

quietly mi passive: replace JOBS = exp(lnJOBS)



********************************************************************************
*****************************2- Data Analysis **********************************
********************************************************************************
*1- 
* Descriptive Statistics
* Selected variables Earnings, professional education, age, verbal, urban
list EARNINGS EDUCPROF AGE VERBAL URBAN in 1/5
* Checking data frequencies and descriptive statistics
tabulate EDUCPROF, summarize(EARNINGS)
tabulate AGE, summarize(EARNINGS)
tabulate URBAN, summarize(EARNINGS)

* Analysis of variance to understand distribution of individual data, build counts. 
* Peformed one-way (fixed-effect) ANOVA 
oneway EARNINGS URBAN, tabulate
oneway EARNINGS EDUCPROF, tabulate
oneway EARNINGS AGE, tabulate
* Noted table stats for defining further analysis



********************************************************************************
*------------------- 3- linear Correlation coefficients------------------------*
********************************************************************************

* 2- Calculate the linear correlation coefficient between the variables Earnings and Professional Education, as well as its 95% Confidence Interval


* Pearson correlation coefficient is carried out to measure the linear correlation between EARNINGS and EDUCPROF 
correlate EARNINGS EDUCPROF
* Interpretation of Results: 
*There is a positive correlation between Earnings and Professional Education


* Testing for statistical significacne between two variables against the Hypothesis H0 : ρ  = 0, 
pwcorr EARNINGS EDUCPROF, sig
* Interpretation of Results: 
* To test the hypothesis about the linear relationship between your variables in the population - tested the level of statistical significance
* The level of statistical significance (p-value) of the correlation coefficient is .0001, 
* which means that there is a statistically significant relationship between the two variables : Earnings and Professional Education

* 3 - To display the totality of the scatterplot among the otehr variables 
graph matrix EARNINGS EDUCPROF ETHBLACK ETHWHITE ETHHISP URBAN VERBAL
* Interpretation of graph:
* Graphed to observe coorelation among other variables

* 4- The correlations for each pair of variable is obtained below
pwcorr EARNINGS EDUCPROF ETHBLACK ETHWHITE ETHHISP URBAN VERBAL
* Interpretation of Results:
* There is a postive correlation among Earnings, Professional Education, Hispanic Ethnicity, Urban living and verbal skills 

* Measuring spearman correlations, to measure non-parametric relationship between the variables
spearman EARNINGS EDUCPROF ETHBLACK ETHWHITE ETHHISP URBAN VERBAL, stats(rho)
* Interpreation of Results:
* As spearman correlations increases the magnitude as EARNINGS and other variables to monotone function
* there is a postive spearman correlation among Earnings,Professional Education, Hispanic Ethnicity, Urban living and verbal skills
  
  

  
********************************************************************************
*------------------------- 4 - Regression Analysis ----------------------------*
********************************************************************************

* 5- Constructing a regression model, including earnings centered on thier professional eduction and their age and Verbal skills
regress EARNINGS AGE VERBAL i.EDUCPROF, noheader
* Interpretation of Results:
* Regression Coefficient - Expected change in the dependent variable observed
  * For one unit increase in verbal skills has 1.084 units increase in earnings  
  * For one unit increase in Professional education has 10.6 units increase in earnings 
 * P < 0.05, in our case Verbal skills and Professional education have a statistically significant relationship with the likelihood of Earnings.  

 
 
********************************************************************************
*-------------- 5 - Adjusted Predictions using two-factor ANOVA---------------*
********************************************************************************

* 6- Adjusted Predictions of Professional Education and Urban living, still considering earning (EARNINGS) as a response variable with 95 % CI
anova EARNINGS URBAN#EDUCPROF
* The anova table below outputs two main effects and the interaction effect between Urban living and Professional Education 
anova EARNINGS URBAN##EDUCPROF
* Numerical statistics built on EARNINGS (mean, sd and count) 
table URBAN, by(EDUCPROF) contents(mean EARNINGS sd EARNINGS count EARNINGS)
* Graphical Representation of adjusted prediction values of Preofessional Education and Urabn Living
quietly: margins URBAN#EDUCPROF
marginsplot
* two-factor ANOVA and Interaction diagram interpretation:
* p <0.05 show the interaction (URBAN#EDUCPROF) is statistically significant
* The predictors explain 20.1% of the variations in the response (R-squared), where as adjust R-squared is 14.7%, which is a decrease of 5%
* The low predicted R-squared value indicates that the model doesnot predict new observations as well as it fits the sample data. Thus it is not recommended for generalizations beyond the observations. 
  
********************************************************************************

*Close log file	
log close
clear

