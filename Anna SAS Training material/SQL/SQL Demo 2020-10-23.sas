/***********************************************************************************************
**************************************PHASTAR SQL DEMO******************************************

PROC SQL;
 <create table ....>
  select ....
 <into: ....>
  from ....
 <where ....>
 <group by ....>
 <having ....>
 <order by ....>  ;
QUIT;

Clever 
Statisticians
Invent
Free
Wine
Get 
Hailed/Hammered
Outstanding/Often

************************************************************************************************/



/************************************************************************************
Demo 1 - Create all datasets
Run the following data steps to create all data sets 
************************************************************************************/

libname train '\\pharoah\Shared Folders\Training Area\Trial 1\Data' access=readonly;
libname train2 '\\pharoah\Shared Folders\Training Area\Phastar data';

%include 'P:\Training Area\Anna SAS Training material\SQL\Create data.sas';



/***********************************************************************************************
PROC SQL;
 <create table ....>
  select ....
 <into: ....>
  from ....
 <where ....>
 <group by ....>
 <having ....>
 <order by ....> ;
QUIT;

Clever 
Statisticians
Invent
Free
Wine
Get 
Hailed/Hammered
Outstanding/Often


* Discuss creating an abreviation in TOOLS -> ADD ABBREVIATION 



=> The main benefits of SQL (over SAS code) include:

    1) Merging:
              - many-to-many merge produces sensible results (unlike data step merge)
              - a common variable is not required in the input datasets (unlike data step merge)
              - input data sets do not have to be sorted
              - capable of performing inequality joins (unlike data step merge)
    2) Sorting observations in a dataset or a report is far easier
    3) Creating macro variables are amazing!! 
    4) Counting the number of rows
    5) Can deal with duplicates simply and effectively using distinct/unique 
    6) Can easily count the distinct levels of a variable 
    7) Can easily determine order of variables/columns in a dataset
    8) Subqueries are fantastic to avoid pre-processing data (avoiding multiple steps)
    9) Can create a new column in a report (can't in SAS code)
    10) Amount of code can be reduced i.e less steps
    11) Code can be easier to follow as it's written in 'English'




************************************************************************************************/




/************************************************************************************
Demo 2 - Create reports (listings)
************************************************************************************/


/****************************EXAMPLE 2A********************************/
/***PROC SQL***/
proc sql;
  select subjid, sex, birthdt
  from work.demo;
quit; 
 
/***Matching SAS code ***/
proc print data = work.demo noobs;
    var subjid sex birthdt;
run;



/****************************EXAMPLE 2B********************************/
/***PROC SQL***/
proc sql;
  select q1, q2, q3, q4, sum(q1, q2, q3, q4) as total
  from work.ho;
quit; 

/***Matching SAS code ***/
data total;
  set ho;
  total = sum(of q1-q4);
run;

proc print data = total;
    var q1--q4 total;
run;



* Qu - will this work?;
proc sql;
  select q1, q2, q3, q4, sum(of q1-q4)  as total
  from work.ho;
quit;

* This does not work ;



* Qu - what will this do? ;
proc sql;
  select q1, q2, q3, q4, sum(q1)  as total
  from work.ho;
quit;







/****************************EXAMPLE 2C********************************/
/***PROC SQL***/
proc sql ;
  select *
  from work.demo;
quit;
proc sql feedback;
  select *
  from work.demo;
quit; 




/***Matching SAS code ***/
proc print data = work.demo;
run;




/************************************************************************************
Demo 3 - Create reports (summary)
************************************************************************************/


/****************************EXAMPLE 3A********************************/
/***PROC SQL***/
proc sql;
  select count(subjid) as Count
  from work.lab;
quit; 
* counts non-missing subjid's;

proc sql;
  select count(*) as Count
    from work.lab;
quit; 
* counts all rows (missing and non-missing);


/***Matching SAS code - Method 1***/
data _null_;
  set lab nobs=count;
  if _N_ = 1 then call symputx('n' , count);
  stop;
run;
%put &=n;

/***Matching SAS code - Method 2***/
data count (keep = nonmissing missing_nonmissing);
  set lab end = EOF;
  missing_nonmissing + 1; *counts missing and non-missing rows;
  if subjid ne ' ' then nonmissing +1; *counts non-missing only;
  if EOF;
run;
proc print data = count;
run;







/***PROC SQL***/
proc sql;
  select avg(lborresn), min(lborresn), max(lborresn), count(lborresn), count(*)
    from work.lab;
quit; 




proc sql;
  select avg(lborresn) as my_average, 
         min(lborresn) as my_minimum,
         max(lborresn) as my_maximum,
         count(lborresn) as non_missing, 
         count(*) as missing_and_non_missing
    from work.lab;
quit; 


/***Matching SAS code ***/
proc means data = work.lab mean min max ;
    var lborresn;
run;




/***PROC SQL***/
proc sql;
  select avg(lborresn), min(lborresn), max(lborresn), country
    from work.lab;
quit; 
*"NOTE: The query requires remerging summary statistics back with the original data.";


/***PROC SQL***/
proc sql;
  select avg(lborresn), 
         min(lborresn), 
         max(lborresn), 
         count(lborresn), 
         country
  from work.lab
  group by country;
quit; 



/***Matching SAS code ***/
proc means data = work.lab mean min max ;
  var lborresn;
  class country;
run;






/************************************************************************************
Demo 4 - Creating datasets
************************************************************************************/


/***PROC SQL***/
proc sql;
  create table t1_SQL as
  select subjid, sex, birthdt 
  from work.demo;
quit; 
*advantage SQL - order of variables on select statement can order the columns in the dataset ;

/***Matching SAS code ***/
data t1_sas;
  set work.demo;
  keep sex birthdt subjid ;
run;
* order of variables on keep statement DOES NOT impact the order of the columns in the dataset ;




/*  Qu - what would you do (SAS code), if you wanted the variables in a 
         different order to the input dataset?  */


 

/************************************************************************************************
Demo 5 - Filtering observations
*************************************************************************************************/

/***PROC SQL***/
proc sql;
  select subjid, sex, birthdt
    from work.demo
    where sex = 'F';
quit; 

/***Matching SAS code ***/
proc print data = work.demo  ;
   var subjid sex birthdt;
   where sex = 'F';
run;








/************************************************************************************************
Demo 6 - Ordering observations
*************************************************************************************************/

/***PROC SQL***/
proc sql;
  select subjid, sex, birthdt
    from work.demo
    where sex = 'F'
    order by birthdt desc;
quit; 


/***Matching SAS code ***/
proc sort data = work.demo
          out  = work.demo_sort;
  by descending birthdt ;
  where sex = 'F';
run;
proc print data = work.demo_sort;
   var subjid sex birthdt;
run;




/***PROC SQL***/
proc sql;
  select subjid, birthdt
    from work.demo
    where sex = 'F'
    order by screendt ;
quit; 
* possible to order by a variable not on the select statement;


/***Matching SAS code***/
proc sort data = work.demo
           out = demo_screen;
  by screendt;
  where sex = 'F';
run; 
proc print data = demo_screen noobs;
   var subjid birthdt;
run;



/***PROC SQL***/
proc sql;
  select subjid, q1, q2, q3, q4
  from work.ho
  order by 3 desc;
quit;
* Preference is to use variable name as opposed to position, in case the data changes;





/************************************************EXERCISE 1*************************************************************


Q1.  Using proc sql and the ho dataset, create a dataset that conatins the 
     sum and the mean of the q1 values.  


Q2.  Write equivalent SAS code for Qu 1.


Q3.  Using the demo dataset and proc sql, create a report that 
     summarises the number of males and females in the trial.  


Q4.  Using the lab dataset and proc sql, create a new dataset
     containing the variables subjid, sex and birthdt only.  Ensure 
     the youngest subjects appear at the top.


Q5.  Below is a proc sort.  Write matching proc sql code to achieve 
     the same result.

proc sort data = work.demo (keep = subjid sex birthdt)
          out  = work.demo_F_sas ;
  by descending birthdt ;
  where sex = 'F';
run;


Q6.  Create a report from demo of variables subjid and sex.  Ensure the subjects are
     sorted by birthdt (oldest to youngest).  Present only the subjids where their 
     screening date was before 1st Jan 2013.


************************************************************************************************************************/




/************************************************************************************************
Demo 7 - Selecting unique/distinct values
*************************************************************************************************/

/***PROC SQL***/
proc sql;
  select distinct country
    from work.demo;
quit; *ordered in ascending order;
proc sql;
  select unique country
    from work.demo;
quit; *ordered in ascending order;



/***Matching SAS code - Method 1***/
proc freq data = work.demo ;
  tables country / nocum nopercent;
run;*still provides frequency counts;

/***Matching SAS code - Method 2***/
proc sort data = work.demo
           out = country_unique (keep = country) nodupkey;
  by country;
run;
proc print data = country_unique noobs;
run;
  





/***PROC SQL***/
proc sql;
  select distinct country, sex
  from work.demo;
quit;



/***Matching SAS code***/
proc sort data = work.demo
           out = country_sex_unique (keep = country sex) nodupkey;
  by country sex;
run;
proc print data = country_sex_unique noobs;
run;




/***PROC SQL***/
proc sql;
  select count(distinct country) as N_country,
         count(distinct sex) as N_sex
  from work.demo;
quit;




/***Matching SAS code***/

proc freq data = work.demo nlevels;
  tables country;
run;





/* Counting the number of distinct combinations of country and sex */
proc sql;
  select count(distinct country, sex) as N_country_sex
  from work.demo;
quit;
* ERROR - only one variable can be listed within count() ;





/* Use this instead */
proc sql;
  select count(distinct country !! sex) as N_country_sex
  from work.demo;
quit;




/*****  QUIZ - RECAP MACRO VARIABLES  *********************************************

How can I create a macro variable containing the number 
of countries (use demo dataset)?

Use two different methods:
a) using PROC SQL
b) using proc freq (ods trace and ods output may help) and data step


*Answers below (don't look!)












a) using PROC SQL

proc sql;
  select count(distinct country) as N_country
  into: n_countries trimmed
  from work.demo;
quit;
%put &=n_countries;

OR

proc sql;
  select distinct country as N_country
  from work.demo;
  %let n_countries = &sqlobs; 
quit;



b) using proc freq (ods trace and ods output may help) 

*ods trace on; 
ods output nlevels = my_freq;
proc freq data = work.demo nlevels;
  tables country;
run;
*ods trace off;

data _null_;
  set my_freq;
  call symputx('mymacvar' , nlevels);
run;
%put &=mymacvar;

******************************************************/










/************************************************EXERCISE 2*************************************************************
Q1.  Produce a report from lab that lists which lab test (lbtestcd) 
     each subject had taken.  For example:
Subjid  Test
1       test1
1       test2
2       test2 


Q2.  As above, including an extra column which details the number of times this test was 
     performed on each subject.  For example:
Subjid  Test     Count
1       test1      10
1       test2      8
2       test2      3

************************************************************************************************************************/







/************************************************************************************************
Demo 8 - Creating new variables
*************************************************************************************************/

/***PROC SQL***/
proc sql;
    create table work.lab_SQL as 
    select subjid, 
           lbtestcd, 
           lborresn, 
           lborresn * 1.71 as lbstresn
    from work.lab
    where lbtestcd = 'BILT_PLC';
quit;

/***Matching SAS code***/
data lab_SAS;
  set work.lab;
  keep subjid lbtestcd lborresn lbstresn;
  where lbtestcd = 'BILT_PLC';
  lbstresn = lborresn * 1.71;
run;






/***PROC SQL***/
proc sql;
    select subjid, 
           lbtestcd, 
           lborresn, 
           lborresn * 1.71 as lbstresn
    from work.lab
    where lbtestcd = 'BILT_PLC';
quit;

/***Matching SAS code***/
data lab_SAS;
  set work.lab;
  keep subjid lbtestcd lborresn lbstresn;
  where lbtestcd = 'BILT_PLC';
  lbstresn = lborresn * 1.71;
run;
proc print data = lab_SAS noobs;
run;







/***PROC SQL***/
proc sql;
    create table work.lab_SQL_1 as 
    select *, 
           lborresn * 1.71 as lbstresn
    from work.lab
    where lbtestcd = 'BILT_PLC';
quit;

/***Matching SAS code***/
data lab_SAS_1;
  set work.lab;
  where lbtestcd = 'BILT_PLC';
  lbstresn = lborresn * 1.71;
run;
* SAS selects all columns by default;







/***PROC SQL***/
proc sql;
  create table mono_sql as 
  select subjid, 
         monotonic() as obs
  from work.lab;
quit; 


/***Matching SAS code***/
data mono_SAS;
  set work.lab;
  keep subjid obs;
  obs = _N_; *obs + 1;
run;











/************************************************************************************************
Demo 9 - Filtering on new variables
*************************************************************************************************/


/***PROC SQL***/
* Qu - why won't the code work?;
proc sql;
  create table work.lab2_sql as
    select subjid, 
           lborresn, 
           lborresn * 1.71 as lbstresn
    from work.lab
    where lbtestcd = 'BILT_PLC' and lbstresn>30;
quit;



/***PROC SQL - Method 1***/
proc sql;
  create table work.lab3_sql as
    select subjid, lborresn, lborresn * 1.71 as lbstresn
    from work.lab
    where lbtestcd = 'BILT_PLC' and (lborresn * 1.71) > 30;
quit;


/***PROC SQL - Method 2***/
proc sql;
  create table work.lab3_sql as 
    select subjid, lborresn, lborresn * 1.71 as lbstresn
    from work.lab
    where lbtestcd = 'BILT_PLC' and calculated lbstresn>30;
quit;


/***PROC SQL - Method 3***/
proc sql;
  create table work.lab3_sql as 
    select subjid, lborresn, lborresn * 1.71 as lbstresn
    from work.lab
    having lbtestcd = 'BILT_PLC' and lbstresn>30;
quit;


/***PROC SQL - Method 4***/
proc sql;
  create table work.lab4_sql as 
   select subjid, lborresn, lborresn * 1.71 as lbstresn
    from work.lab
	where lbtestcd = 'BILT_PLC' 
    having lbstresn>30;
quit;


/***Matching SAS code***/
data lab4_SAS;
  set work.lab;
  keep subjid lborresn lbstresn;
  lbstresn=lborresn * 1.71;
  if lbstresn > 30;
  where lbtestcd = 'BILT_PLC';
run;





/***PROC SQL***/
proc sql;
  select subjid, 
         lborresn, 
         lborresn * 1.71 as lbstresn,  
         put(calculated lbstresn, best12.) as lbstresc
  from work.lab;
quit;




/***Matching SAS code***/
data lab5_SAS;
  set work.lab;
  keep subjid lborresn lbstresn lbstresc;
  lbstresn=lborresn * 1.71;
  lbstresc = put(lbstresn, best12.);
run;
proc print data = lab5_SAS noobs;
run;






/************************************************EXERCISE 3*************************************************************

Q1.  Produce a report from the lab dataset, which includes the subjid, lborresn and the surname of the invname.  
     We only want the patients whose invname was Smith.   


Q2.  Produce a report from the demo dataset, which includes the subjid and their age at screening.


Q3.  Create a dataset using one proc sql step from demo which contains subjects that 
     are over 65 years old today (not screening).  The dataset needs to be in descending order of age. 


Q4.  Write the matching SAS code for Qu3.   


Q5.  Create a report of: 
-subject ID
-screen date
-age when screen date is after 25th December 2012 and age is above 60.


************************************************************************************************************************/










/************************************************************************************************
Demo 10 - Grouping data
*************************************************************************************************/

/***PROC SQL***/
proc sql number;
  select lbtestcd, 
         avg(lborresn) as Average
  from work.lab;
quit;
* Qu - how many observations in report? ;
* Qu - how would you achieve the same using the SAS code? Ideas??  Try??  ;



*  Solution 1;
proc means data = work.lab noprint;
  var lborresn;
  output out = t1 (keep = m)
         mean = m;
run;

data _null_;
  set t1;
  call symputx('avg', m);
run; 

data lab1;
  set lab;
  average = &avg;
run;


*  Solution 2;
proc means data = work.lab noprint;
  var lborresn;
  output out = t1 (keep = m)
         mean = m;
run;

data lab2;
  set lab;
  if _n_ = 1 then set t1;
run;








/***PROC SQL***/
* This won't give you what you want ;
proc sql number;
  select distinct lbtestcd, 
         avg(lborresn) as Average
    from work.lab;
quit;
* Qu - how many observations in report? ;


proc sql number;
  select lbtestcd, 
         avg(lborresn) as Average
    from work.lab
    group by lbtestcd;
quit;








/***Matching SAS code***/
proc means data = work.lab mean nonobs;
  class lbtestcd;
  var lborresn;
run;





/************************************************************************************************
Demo 11 - Filtering/ordering on grouped data
*************************************************************************************************/

/***PROC SQL***/
proc sql;
  select country, count(*) as count
    from work.demo
	where calculated count ge 2
    group by country
    order by count desc;
quit;
* Does not work!;
* "Summary functions are restricted to the SELECT and HAVING clauses only";
* ....and order by (inconsistent in the SAS documentation);

proc sql;
  select country , count(*) as count
    from work.demo
    group by country
    having count ge 2
    order by count desc;
quit;
* Order by does not require calculated keyword, and can include summary 
  functions - seems inconsistent!;






/***Matching SAS code***/
proc freq data = work.demo;
  tables country / out = N_country ;
run;
proc sort data = N_country;
  by descending count;
run;
proc print data = n_country noobs;
  where count ge 2;
  var country count;
run;








/***PROC SQL***/
proc sql;
  create table dup_SQL as
  select x, count(x) as count
  from work.three
  group by x
  having count>1;
quit;






/***Matching SAS code***/
/* Method 1*/
proc freq data = work.three;
   tables x / out = dup_SAS1 (where = (count > 1)) ;
run;

/* Method 2*/
proc sort data   = work.three 
          out    = work.three_unique nodupkey
          dupout = dup_SAS2;
  by x;
run;







*  Qu - What do we mean by a summary function?;
proc sql;
  select country , mean(birthdt, screendt) as average
    from work.demo
	where calculated average ge 2;
quit;
* This is fine as the function works per obs, so not what
  they mean by 'SUMMARY FUNCTION';

proc sql;
  select country , mean(birthdt) as average
    from work.demo
	where calculated average ge 2;
quit;
* This is NOT fine as the function works per variable, so
  is classed as a 'SUMMARY FUNCTION' ;




/************************************************QUIZ******************************************************************
Which syntax will select subject IDs having lbstresn greater than 22?

a. select subjid, lborresn*1.71 as lbstresn
	from work.bilt_plc
	where calculated lbstresn > 22;

b.  select subjid, lborresn*1.71 as lbstresn
	from work.bilt_plc
	having lbstresn > 22;

c.  Both of the above

d.  Neither of the above

***********************************************************************************************************************/




/************************************************************************************************
Demo 12 - Conditional processing 
*************************************************************************************************/

/***PROC SQL***/
 /* Method 1 */
proc sql;
  select subjid,
    case
      when Country = 'United States' then 'North America'
      when Country = 'Australia' then 'Oceania'
      else 'None'
    end as Region
from work.demo;
quit;

/* Method 2 */
proc sql number;
  select subjid,
    case Country
      when 'Australia' then 'Oceania' 
      when 'United States' then 'North America'
      else 'None'
    end as Region
from work.demo;
quit;
* The option number on the proc sql statement adds the row number 
  to the report; 
* Length of Region is 13 if creating a data set (even reveresing 
  order of your case expressions);


/***Matching SAS code***/
data country;
  set demo;
  if country = 'United States' then region = 'North America';
  else if country = 'Australia' then region = 'Oceania';
  else region = 'None';
run;

proc print data = country noobs;
  var subjid region;
run;




/***PROC SQL***/
 /* If then do equivalent */
proc sql;
  select subjid,
    case
      when Country = 'United States' then 'North America'
      when Country = 'Australia' then 'Oceania'
      else 'None'
    end as Region,

    case
      when Country = 'United States' then 'English'
      when Country = 'Australia' then 'English'
      else 'None'
    end as Language

from work.demo;
quit;

/***Matching SAS code***/
data country;
  set demo;
  if country = 'United States' then 
    do;
       region = 'North America';
	   language = 'English';
	end;
  else if country = 'Australia' then 
    do;
        region = 'Oceania';
		language = 'English';
	end;
  else 
    do;
      region = 'None';
      language = 'None';
	end;
run;

proc print data = country noobs;
  var subjid region;
run;




/************************************************EXERCISE 4*************************************************************
Q1.  Create a new variable in demo which shows 'Male' or 'Female'.  

************************************************************************************************************************/






/************************************************************************************************
Demo 13 - SQL Joins (cartesian product)
*************************************************************************************************/

/***PROC SQL-cartesian product (as no where clause)***/
proc sql number;
  select *
  from one, two;
quit;

/***Equivalent SAS code very complicated***/


/***PROC SQL-cartesian product (as no where clause)***/
proc sql;
  create table test as 
  select *
  from one, two;
quit;
* WARNING: Variable x already exists on file WORK.TEST.;
* Qu - Which dataset do the x values come from?;


/***Equivalent SAS code very complicated***/




/************************************************************************************************
Demo 14 - SQL Joins - Inner join

Method 1:

 select *
  from one inner join two
  on one.x=two.x;


Method 2:

 select *
  from one, two
  where one.x=two.x;

- CAUTION: Data step and SQL joins produce different results for 
  many-to-many merges (same otherwise)
*************************************************************************************************/


/************************************************************
  ONE-TO-ONE
- Data step and SQL joins produce same results
*************************************************************/


/**************** CREATE DATASET ****************************/
/***PROC SQL***/

/*Method 1*/
proc sql;
 create table t_sql as 
 select *
 from one 
      inner join 
      two
 on one.x=two.x;
quit;

* WARNING: Variable x already exists on file WORK.T_SQL;
* Takes x value from first dataset but as inner join, values 
  are identical;



proc sql;
 create table t_sql as 
 select one.x, A, B
 from one 
      inner join 
      two
 on one.x=two.x;
quit;
* Removes warning;
* Takes x value from first dataset but as inner join, values 
  are identical;



/*Method 2*/
proc sql;
 create table t_sql as 
 select one.x, A, B
 from one, two
 where one.x=two.x;
quit;




/***Matching SAS code***/
proc sort data = one;
  by x;
run;
proc sort data = two;
  by x;
run;
data t_SAS;
  merge one (in= one)
        two (in= two);
  by x;
  if one and two;
run;







/************************************************************
  ONE-TO-MANY
- Data step and SQL joins produce same results
*************************************************************/



/**************** CREATE DATASET ****************************/


/***PROC SQL***/
/*Method 1*/
proc sql;
 create table t_sql as 
 select one.x, one.A,  three.A
 from one 
      inner join 
      three
 on one.x=three.x;
quit;
* WARNING: Variable A already exists on file WORK.T_SQL;


/*Method 2*/
proc sql;
 create table t_sql as 
 select one.x, one.A,  three.A
 from one, three
 where one.x=three.x;
quit;
* WARNING: Variable A already exists on file WORK.T_SQL;





/***Matching SAS code***/
proc sort data = one;
  by x;
run;
proc sort data = three;
  by x;
run;
data t_SAS;
  merge one   (in= one)
        three (in= three);
  by x;
  if one and three;
run;
* No notes/warnings - what are the values of variable A? ; 






















/************************************************************
  MANY-TO-MANY
- Data step and SQL joins produce different results
*************************************************************/


/**************** CREATE DATASET ****************************/

/***PROC SQL***/

/*Method 1*/
proc sql;
 create table m_m as 
 select three.x, A, B
 from three 
      inner join 
      four
 on three.x=four.x;
quit;

/*Method 2*/
proc sql;
 create table m_m as 
 select three.x, A, B
 from three , four
 where three.x=four.x;
quit;




/***Matching SAS code***/
proc sort data = three;
  by x;
run;
proc sort data = four;
  by x;
run;
data m_m_SAS;
  merge three (in= three)
        four  (in= four);
  by x;
  if three and four;
run;





/***PROC SQL***/
proc sql;
  create table inner_sql as
  select *
  from lab, unitconv
  where lab.lbtestcd=unitconv.param and lab.lborresu=unitconv.ucorresu;
quit;*can match on variables with different names;


/***NO equivalent SAS code***/




/************************************************************************************************
Demo 15 - SQL Joins - Outer join
*************************************************************************************************/

/***PROC SQL-left join***/
proc sql;
create table left_sql as
  select one.x, A, B
  from one 
       left join 
       two
  on one.x = two.x;
quit;


/***Matching SAS code***/
proc sort data = one;
  by x;
run;
proc sort data = two;
  by x;
run;
data left_SAS;
  merge one (in= one)
        two (in=two);
  by x;
  if one ;
run;




/***PROC SQL-right join***/
proc sql;
create table right_sql as
  select two.x, A, B
  from one 
       right join 
       two
  on one.x = two.x;
quit;


/***Matching SAS code***/
proc sort data = one;
  by x;
run;
proc sort data = two;
  by x;
run;
data right_SAS;
  merge one (in= one)
        two (in=two);
  by x;
  if two ;
run;


/***PROC SQL-full join***/
proc sql;
create table full_sql as
  select two.x, A, B
  from one 
       full join 
       two
  on one.x = two.x;
quit;



proc sql;
create table full_sql as
  select coalesce(one.x,two.x) as x, a, b
  from one 
       full join 
       two
  on one.x=two.x;
quit;



/***Matching SAS code***/
proc sort data = one;
  by x;
run;
proc sort data = two;
  by x;
run;
data full_SAS;
  merge one (in= one)
        two (in=two);
  by x;
run;



/************************************************************************************************
Demo 16 - David's example - many-to-many merger
*************************************************************************************************/
data ae;
input usubjid $ AESPID AEDECOD $ AESDT: ddmmyy10.  AEEDT: ddmmyy10.;
format AESDT AEEDT date9.;
datalines;
E0001 4 Fatigue 01-04-2014 02-05-2014
E0001 5 Headache 16-04-2014 17-04-2014
;
run;
data trt;
input USUBJID $ AEDOS1 $ TRTSDT: ddmmyy10. TRTEDT: ddmmyy10.  ;
format TRTSDT TRTEDT date9.;
datalines;
E0001 50mg 21-03-2014 27-03-2014 
E0001 100mg 28-03-2014 04-04-2014 
E0001 150mg 05-04-2014 30-05-2014 
;
run;

/* Combines the tables to allow you to determine which treatment the ae is 
   assigned to */
proc sql ;
create table aedos1 as 
    select a.* , b.aedos1, b.TRTSDT, b.TRTEDT
    from ae as a 
         inner join 
         trt as b 
    on a.usubjid=b.usubjid;
quit;



/* Combines and selects which treatment the ae is assigned to */
proc sql ;
create table aedos1 as 
    select a.* , b.aedos1, b.TRTSDT, b.TRTEDT
    from ae as a 
         inner join 
         trt as b 
    on a.usubjid=b.usubjid
    where a.aesdt between b.TRTSDT and b.TRTEDT;
quit;




/***Below gives different merge completely *****/
data aedos2;
   merge ae  (in=A)
         trt (in=B);
   by usubjid;
   if A and B and TRTSDT<=aesdt <= TRTEDT;
run;




/************************************************************************************************
Demo 17 - Creating a table alias
*************************************************************************************************/

/***PROC SQL***/

proc sql ;
create table full_sql as
  select coalesce(one.x,two.x) as x, a, b
  from one as A 
       full join 
       two as B
  on A.x=B.x;
quit;








/************************************************************************************************
Qu - Help ... I have many variables in each dataset so I don't want to type out each variable.
     Using * on select will cause issues with the common variable, so what can 
     I do?
*************************************************************************************************/

proc sql;
  create table qu (drop=sub) as 
  select A.*,
         B.* 
  from A
       inner join
       B  (rename =(usubjid = sub))
  on A.usubjid = B.sub;
quit;








/************************************************EXERCISE 5*************************************************************

Q1.  Merge lab and unitconv datasets using proc sql and keep all matching and non-matching rows.  
     The rows need to be matched on the following two conditions:
     - variable lbtestcd from lab to param in the unitconv dataset 
     - variable lborresu from lab to ucorresu in the unitconv dataset 


Q2.  Merge demo and lab datasets on subjid using proc sql.  Keep all subjects present in demo, and only the matching
     subjects in lab.  Within the same select clause, create another column which holds the information as to the
     number of visits for each subject.   Keep only the subjid and the number of visists.


Q3.  Merge lab and unitconv datasets using proc sql and keep only the matching such that the rows 
     lborresn is greater than lbornrhi  
     The rows need to be matched on the following two conditions:
     - variable lbtestcd from lab to param in the unitconv dataset 
     - variable lborresu from lab to ucorresu in the unitconv dataset 


***********************************************************************************************************************/









/************************************************************************************************
Demo - 18  Appending datasets (SELF STUDY)

-> Appending datasets (combining datasets vertically) in PROC SQL require the following code:

PROC SQL;
  SELECT column_names
  FROM A
  set-operator <ALL> <CORR/CORRESPONDING>
  SELECT column_names
  FROM B
;
QUIT;

-> Different set operators include:

   1). OUTER UNION 
       - appends all observations regardless of dataset they are from 
       - no column alignment
   2). UNION 
       - appends observations dropping duplicate rows 
       - matches by column position, not variable name
   3). EXCEPT 
       - appends observations, preserving unique rows which appear in the first SELECT clause,
         but not in the second
       - matches by column position, not variable name
   4). INTERSECT 
       - appends observations keeping unique observations found in both datasets
       - matches by column position, not variable name

-> ALL keyword selects all rows, regardless of duplication
-> CORRESPONDING (CORR) keyword overlays columns by name instead of by position

- SAS data step mimics the behaviour of an OUTER UNION CORRESPONDING
- SAS data step has no mechanism for aligning variables by position (PROC SQL does) 
- Details of the different set operators can be seen at:
  http://www2.sas.com/proceedings/sugi31/242-31.pdf
*************************************************************************************************/



/* Create datasets to demonstrate set opertors */
data ITT   (keep = usubjid pnitt )
     PP    (keep = usubjid pnpp  );
  set train.pop ;
  if  pnitt = 'Y' then output ITT; 
  if  pnpp = 'Y' then output PP;   
run; 
* 1429 subjects are in itt;
* 1094 subjects are in pp;
* 1485 observations in total;
* if in pp then they are in itt;


data itt_a;
  length usubjid $ 30;
  set itt;
run; 



/***********************************************************************************************************************

1. OUTER UNION 

a) OUTER UNION 
- no column alignment 
- unaligned columns are kept
- keeps all rows (regardless)

b) OUTER UNION CORR 
- column alignment by name 
- unaligned columns are kept
- keeps all rows (regardless)


- no column alignment by default (if 3 variables in one dataset, 2 in the other, result will have 5 variables)
- CORR keyword matches by column name 
- ALL keyword is not required as by default, the operator includes all observations from both datasets
- using CORR, the common variables in both datasets will be first, followed by the columns which appear only in the 
  first SELECT, followed by the columns which appear only in the second SELECT (the DATA step places 
  the variables from the first data set first, followed by the variables which are found only in the second data set)


***********************************************************************************************************************/

/***************************
 1a). OUTER UNION 
- no column alignment 
- unaligned columns are kept
- keeps all rows (regardless)
***************************/

* How many variables? How many obs?;
proc sql number;
  select *
  from itt as T1
  outer union
  select *
  from pp as T2;
quit; 


* 4 variables, 2523 observations;


* How many variables? How many obs?;
proc sql;
  create table app_1a as
  select *
  from itt as T1
  outer union
  select *
  from pp as T2;
quit; 

* see warning in log;
* Not ideal as no usubjid's printed from T2!!;

* 3 variables, 2523 observations;



/***************************
 1b). OUTER UNION CORR 
- column alignment by name 
- unaligned columns are kept
- keeps all rows (regardless)
***************************/

* How many variables? How many obs?;
proc sql;
  create table app_1b as
  select *
  from itt as T1
  outer union corr
  select *
  from pp as T2;
quit; 
* variables with the same name/type will be overlaid;
* If differing length of common variable, the longest length of the variable 
  will be used in the new dataset (irrelevant of the order of select clauses); 
* unaligned columns are kept;
* usubjid's printed from T2!!;

* 3 variables, 2523 observations;


/******************* Matching SAS code **********************
data SAS_app;
  set itt
      pp;
run;
*************************************************************/



/***********************************************************************************************************************

2. UNION 

a) UNION 
- matches by column position (not name) 
- drops duplicate rows

b) UNION CORR 
- matches by column name (not position) 
- unaligned columns deleted (only common variables kept)
- drops duplicate rows

c) UNION ALL 
- matches by column position (not name) 
- keeps duplicate rows

d) UNION CORR ALL 
- matches by column name (not position) 
- unaligned columns deleted (only common variables kept)
- keeps duplicate rows


- CORR keyword matches by column name instead of column position
- ALL keyword will include all observations from both datasets
- variable names/attributes are assigned from the first select clause 
- select * assumes a similar structure to both datasets being combined 
  (if one dataset has 3 variables, the other has 2 variables, the 
   resulting dataset will have 3 variables if aligning by position)

***********************************************************************************************************************/


/***************************
 2a). UNION 
- matches by column position (not name) 
- drops duplicate rows
***************************/

* How many variables? How many obs?;
proc sql;
  create table app_2a as
  select *
  from  itt as T1
  union
  select *
  from pp as T2;
quit;
* Variable names are assigned from the first select clause i.e usubjid, pnitt; 
* Observations sorted by default as a product of how it processes duplicates;


* 2 variables, 1429 observations;


/******************* Matching SAS code **********************
data SAS_app_2a;
  set itt
      pp (rename = (pnpp = pnitt));
run;

proc sort data = SAS_app_2a
           out = SAS_app_2a nodupkey;
  by usubjid;
run;
*************************************************************/




/***************************
 2b). UNION CORR 
- matches by column name (not position) 
- unaligned columns deleted (only common variables kept)
- drops duplicate rows
***************************/

* How many variables? How many obs?;
proc sql;
  create table app_2b as
  select *
  from itt as T1
  union corr
  select *
  from pp as T2;
quit;


* 1 variable, 1429 observations;


/******************* Matching SAS code **********************
data SAS_app_2b;
  set itt
      pp ;
  keep usubjid;
run;

proc sort data = SAS_app_2b
           out = SAS_app_2b nodupkey;
  by usubjid;
run;
*************************************************************/



/***************************
 2c). UNION ALL 
- matches by column position (not name) 
- keeps duplicate rows
***************************/


* How many variables? How many obs?;
proc sql;
  create table app_2c as
  select *
  from itt as T1
  union all
  select *
  from pp as T2;
quit;

* Variable names are assigned from the first select clause i.e usubjid, TEPARKFL;
* When you know that there are no duplicate rows, coding ALL can speed up processing by avoiding the search for duplicates;

* 2 variables, 2523 observations;


/******************* Matching SAS code **********************
data SAS_app_2c;
  set itt
      pp (rename = (pnpp = pnitt));
run;
*************************************************************/



/***************************
 2d). UNION CORR ALL 
- matches by column name (not position) 
- unaligned columns deleted (only common variables kept)
- keeps duplicate rows
***************************/


* How many variables? How many obs?;
proc sql;
  create table app_2d as
  select *
  from itt as T1
  union corr all
  select *
  from pp as T2;
quit;
* Unaligned columns are deleted i.e only common variables (USUBJID) are kept ;

* 1 variable, 2523 observations;


/******************* Matching SAS code **********************
data SAS_app_2d;
  set itt
      pp ;
  keep usubjid;
run;
*************************************************************/








/***********************************************************************************************************************

3. EXCEPT 
- appends observations, preserving unique rows which appear in the first SELECT clause,
  but not in the second
- matches by column position, not variable name

***********************************************************************************************************************/

* Create new dataset which is copy of demo with:
- one observation added
- age amended for another subject;
data updated_demo;
  set train.demo (keep = usubjid age trtgrp) end = EOF;
   if usubjid = 'AVA102670.0010751' then age = 40;
   output;
  if EOF = 1 then 
   do;
     usubjid = '1';
     age = 25;
	 trtgrp = 'Placebo';
     output;
  end;
run;


* What rows were changed/added in the updated dataset?;
proc sql;
  create table app_3 as
  select *
  from updated_demo as T1
  except
  select usubjid, age, trtgrp 
  from train.demo as T2;
quit;

* 3 variables, 2 observations;

/* If column position causes issues, you can always explicity list the columns on the select clause*/
proc sql;
  create table app_3 as
  select usubjid, age, trtgrp
  from updated_demo as T1
  except
  select usubjid, age, trtgrp 
  from train.demo as T2;
quit;




/******************* Matching SAS code **********************
proc sort data = train.demo (keep = usubjid age trtgrp)
           out = demo1;
   by usubjid age trtgrp;
run;
proc sort data = updated_demo 
           out = demo2;
   by usubjid age trtgrp;
run;

data SAS_app_3;
  merge demo1 (in = A)
        demo2 (in = B);
  by usubjid age trtgrp ;
  if A = 0 and B = 1;
run;
*************************************************************/




/***********************************************************************************************************************

4. INTERSECT 
- appends observations keeping unique observations found in both datasets
- matches by column position, not variable name

***********************************************************************************************************************/

* What rows are unchanged/identical in the updated dataset (which observations appear in both datasets)?;
proc sql;
  create table app_4 as
  select usubjid, age, trtgrp
  from updated_demo as T1
  intersect
  select usubjid, age, trtgrp
  from train.demo as T2;
quit;


* 3 variables, 1484 observations;


/******************* Matching SAS code **********************
proc sort data = train.demo (keep = usubjid age trtgrp)
           out = demo1;
   by usubjid age trtgrp;
run;
proc sort data = updated_demo 
           out = demo2;
   by usubjid age trtgrp;
run;

data SAS_app_4;
  merge demo1 (in = A)
        demo2 (in = B);
  by usubjid age trtgrp ;
  if A = 1 and B = 1;
run;
*************************************************************/





/************************************************EXERCISE 6*************************************************************

Q1.  Using the two datsets one and two as input, write proc sql 
     code with an appropriate set operator to find observations where x :

a)  appear in both datasets
b)  appear in dataset one but not in dataset two

Q2.  Using the two datsets one and two as input, find an alternative
     proc sql method for Q1 a) and b) that does not involve a set operator.

************************************************************************************************************************/










/************************************************************************************************
Demo - 19  Adding obs to a dataset (SELF STUDY)
*************************************************************************************************/

data demo_SQL;
  set demo;
run;


/***PROC SQL***/
/* Method A */
proc sql;
  insert into demo_SQL
  set subjid= 'A101', sex='F', birthdt='01MAR1957'd, country='France', invname='Martin'
  set subjid= 'A102', sex='M', birthdt='29FEB1984'd, country='France', invname='Dupond';
quit;


/* Method B */
proc sql;
*Note: it is important to specify all columns present in demo_SQL.  For example
we don't want anything in screendt but still have to specify it;
 insert into demo_SQL
  values ('A103', 'France','Martin','F','01MAR1957'd, .)
  values ('A104', 'France','Dupond','M','29FEB1984'd, .);
quit;


/* Method C */
proc sql;
 insert into demo_SQL (subjid, country, invname, sex, birthdt)
  values ('A105', 'France', 'Martin', 'F', '01MAR1957'd)
  values ('A106', 'France', 'Dupond', 'M', '29FEB1984'd);
quit;

/***Matching SAS code for Method A, B and C ***/
data demo_sas_ABC;
  set demo end = EOF;
  output;
  if EOF = 1 then do;
       subjid= 'A101'; sex='F'; birthdt='01MAR1957'd; country='France';invname='Martin'; screendt = .; output;
	   subjid= 'A102'; sex='M'; birthdt='29FEB1984'd; country='France';invname='Dupond'; screendt = .; output;
  end; *do I need to specify a value for screendt?;
run;




/* Method D */
proc sql;
insert into demo_SQL(subjid, country, invname, sex, birthdt)
  select distinct subjid, 'France', 'Martin','F', '01MAR1957'd
  from work.demo; 
quit;

/***Matching SAS code for Method D ***/
proc sort data = demo
           out = demo_unique (keep = subjid) nodupkey;
  by subjid;
run;

data demo_sas_D;
  set demo demo_unique (in = B);
  if B then do;
     sex='F'; birthdt='01MAR1957'd; country='France';invname='Martin'; screendt = .; 
  end;
run;






/************************************************EXERCISE 7*************************************************************

Q1.  Using the lab dataset and proc sql, add a row at the bottom of the dataset where the country has 
     a value of TOTAL and all other remaining variables are blank.
************************************************************************************************************************/






/************************************************************************************************
Demo - 20  Subqueries
*************************************************************************************************/


/************Example 1*********/

* We want the average weight (calculated from vsanal) to be an additional variable in demo;
proc sql;
   create table sub1 as
   select T1.*, 
          (select avg(VSORRESN) 
           from train.vsanal as T2
		   where VSTESTCD = 'WEIGHT' and base='Y') as avg_weight
   from train.demo as T1; 
quit;




/**************************** PROCESSING OF ABOVE SUBQERY ********************************/
*STEP 1: Inner query is evaluated first and gives ... ;
proc sql;
  select avg(VSORRESN) 
  from train.vsanal as T2
  where VSTESTCD = 'WEIGHT' and base='Y'; 
quit;

*STEP 2: Outer query is evaluated using the results of the inner query ... ;
proc sql;
   create table sub1 as
   select T1.*, 
          69.19865 as avg_weight
   from train.demo as T1; 
quit;






/************Example 2*********/
* We want to identify usubjid's who are in demo but didn't experience an ae;
proc sql;
   create table no_ae as
   select usubjid 
   from train.demo
   where usubjid not in (select distinct usubjid 
                         from train.ae); 
quit;



* Resolves to ... ;
proc sql;
   create table no_ae as
   select usubjid 
   from train.demo
   where usubjid not in ('AVA102670.0004495' 'AVA102670.0004496' ...... ); 
quit;






/************************************************EXERCISE 8*************************************************************

Q1.  Using a subquery, create a dataset that shows all subjects in demo that experienced a cardiac disorder
     (using the real clinical trial data in train library)

Q2.  Using a subquery, create a report from demo which shows the usubjid and treatment group of the subject(s) 
     that have the maximum baseline weight in vsanal.

************************************************************************************************************************/







/************************************************************************************************
Demo 21 - Use of dictionary tables

-> Dictionary tables and SAS help views contain SAS session metadata
-> The information is created at initialisation, updated automatically and limited to read-only
-> The dictionary tables/SAS help views include (amongst others):
    1. DICTIONARY.MEMBERS (or SASHELP.VMEMBER)  - contains library information
    2. DICTIONARY.TABLES (or SASHELP.VTABLE)    - contains dataset information 
    3. DICTIONARY.COLUMNS (or SASHELP.VCOLUMN)  - contains variables information
    4. DICTIONARY.CATALOGS (or SASHELP.VCATALG) - contains catalog information
    5. DICTIONARY.OPTIONS (or SASHELP.VOPTION)  - contains current settings for SAS system options
    6. DICTIONARY.MACROS (or SASHELP.VMACRO)     - contains macro variable information
    7. DICTIONARY.TITLES (or SASHELP.VTITLE)    - contains title information

- PROC SQL can access either dictionary. or sashelp. 
- SAS code can access only sashelp. 
- libname contains library 
- memname contains dataset name
- memlabel contains dataset label
- nobs contains the number of observations in the dataset
- nvar contains the number of variables in the dataset 
*************************************************************************************************/

* Following code writes the variable attributes to the log ;
proc sql;
  describe table dictionary.columns;
quit;

proc sql ; 
  select name 
  into :varlist separated by ' ' 
  from dictionary.columns 
  where upcase(libname) = 'SASHELP' and 
        upcase(memname) = 'CLASS' and 
        upcase(type) = 'CHAR'; 
  %let num_vars_char = &sqlobs;
  %put &=num_vars_char &=varlist;
quit;





/************************************************EXERCISE 9*************************************************************

Q1.  Which dataset in your work library has the:
     a)  largest number of observations
     b)  largest number of variables


Q2.  From Matt Metherell: 

In the SASHELP library there are a number of useful datasets.

data birthwgt;
  set sashelp.birthwgt;
run;

data classfit;
  set sashelp.classfit;
run;

data demographics;
  set sashelp.demographics;
run;

sashelp.VTABLE or dictionary.tables lists all of the datasets in 
a given library with useful metadata.

data vtable;
  set sashelp.vtable;
  where libname="WORK";
run;

sashelp.VCOLUMN or dictionary.columns lists all of the datasets 
in a given library with useful metadata

data vcolumn;
  set sashelp.vcolumn;
  where libname="WORK";
run;

You may find a log issue where two concatenated datasets have 
differing lengths for a certain variable

data mashup;
  set classfit demographics;
run;

VCOLUMN can help with this;

data vcolumn;
  set sashelp.vcolumn;
  where libname="WORK" and 
    memname in ("CLASSFIT" "DEMOGRAPHICS") and 
    upcase(name)="NAME";
run;

It can be used to summarise the necessary changes with the 
following program (that contains errrors):

proc sql;
  create table fix as
  select distinct memname as dataset, 
         name as variable, 
         length as old_length, 
         max(length) as new_length
  from sashelp.vcolumn
  where libname="WORK" and 
        memname in ("CLASSFIT" "DEMOGRAPHICS") and 
        name="NAME"
  having length ne calculated new_length;
quit;

Now we know the issue, so how can we fix it?

The following code contains three errors - can you get it working?;
How many variables would you expect in your final dataset?;

%macro len_chg_cat(ds1=,ds2=,var1=,len=);

%*DS1 is the dataset that needs to change a length;
%*DS2 is the dataset that does not need to change;
%*VAR1 is the variable in DS1 which needs a change of length;
%*LEN is the new length for VAR1;

data &ds1. (drop=_:);
  set sashelp.&ds1. (rename=(&var1.=_&var1.);
  length &var1. $&len.;
  &var1. = strip(_&var1.);
run;

data &ds2.;
  set sashelp.&ds2.
run;

data mashup2;
  data &ds1. &ds2.;
run;

%mend len_chg_cat;

%len_chg_cat(ds1=,ds2=,var1=,len=)


************************************************************************************************************************/












