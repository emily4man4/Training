/************************************************************************************************************************
*************************************************************************************************************************
PHASTAR MACRO DEMO
Anna Cargill

*************************************************************************************************************************
************************************************************************************************************************/
libname train '\\pharoah\Shared Folders\Training Area\Trial 1\Data' access = readonly;
libname train2 "\\pharoah\Shared Folders\Training Area\Phastar data " ;
options nodate symbolgen mprint mlogic;

*  Run with libname statements as pop_demo data is used several 
   times throughout demo;
proc sort data = train.pop out = pop;
  by usubjid;
run;
proc sort data = train.demo out = demo;
  by usubjid;
run;

data pop_demo;
  merge pop  (in=A) 
        demo (in=B);
  by usubjid;
  if A and B;
run;




/************************************************************************************************************************
Demo 1 - %put
*************************************************************************************************************************/

/* %put writes text to the log and is processed by the macro processor */
%put I love PHASTAR!;

/* Writes automatic, user defined and all macro variables to the log, respectively */
%put _automatic_;
%put _user_;
%put _all_;

/* Writes specific macro variables and their values to the log */ 
%put &=sysuserid &=systime on &=sysdate9.; *new to SAS 9.3.  No spaces between &=macvar ;
%put &sysuserid started SAS at &systime on &sysdate9.;



**************************GO THROUGH MACRO PROCESSOR ON WHITE BOARD ****************************************************;







/*************************************************************************************************************************
Demo 2 - Creating Macro Variables Using %let 
*************************************************************************************************************************/

/* Using train.demo, we want to calculate summary statistics for age and height for each gender */

/* Full code, no macro*/
proc means data = train.demo;
  class sex;
  var Age;
  Title ‘Summary Statistics for Age (yrs)’;
run;
proc means data = train.demo;
  class sex;
  var Height;
  Title ‘Summary Statistics for Height (cm)’;
run;







/* Add two macro variables: 
1). variable we want the statistics of i.e age or height
2). label in the title    */
%let var    = Age;
%let label  = Age (yrs);

%let var    = height;
%let label  = Height (cm);

proc means data = train.demo;
  class sex;
  var &var;
  Title "Summary Statistics for &label";
run;














/*************************************************************************************************************************
Demo 3 - Macro Variables: Single/Double Quotes and Delimiters 
*************************************************************************************************************************/

/* Single or double quotes matter!! Error!*/
%let var    = Age;
%let label  = Age (yrs);

%let var    = height;
%let label  = Height (cm);

proc means data = train.demo;
  class sex;
  var &var;
  Title 'Summary Statistics for &label';
run;



/* Solution*/
proc means data = train.demo;
  class sex;
  var &var;
  Title "Summary Statistics for &label";
run;


/* Macro variable referenced at the beginning of text.  Error! */
%let var    = Age;
%let label  = Age (yrs);

%let var    = height;
%let label  = height (at baseline);

proc means data = train.demo nway ;
  class sex trtgrp;
  var &var;
  output out = &var_s (drop = _type_ _freq_);
  Title "Summary Statistics for &label";
run;



/* Delimiter '.' required to let SAS know it's the end of the macro variable name */
%let var    = Age;
%let label  = Age (yrs);

%let var    = height;
%let label  = Height (cm);

proc means data = train.demo;
  class sex;
  var &var;
  output out = &var._s (drop = _type_ _freq_);
  Title "Summary Statistics for &label..";
run;




/* Useful for debugging - writes to the log the values of macro variables as they are resolved */
options symbolgen;



/* Deleteing macro variables */
%symdel var;
%put &=var;






/********************************************* Exercise 1 **************************************************************

Q1) Add macro variables to the following code for:
- library
- dataset
- row variable
- column variable
- label in the title

proc freq data = train.demo;
  tables sex * trtgrp / out = sex_trtgrp_freq;
  Title 'Frequency counts for Sex by Trtgrp for train.demo';
run;

************************************************************************************************************************/



/*****UNDERSTANDING THE MACRO PROCESSOR (WHITE BOARD)*****/


%let n = 1;
%let trt1 = Placebo;
%let trt2 = Active;


* Test the values to understand the use of multiple &'s;
* 1);
%put &trt&n;  
 
* 2);
%put &&trt&n; 






/********************************************* Exercise 2 **************************************************************/
/*  We have the following statements:
Q1.
%let A = B;
%let B = C;
%let C = D;


Q1a).  How do I get from A to C (referencing only & and A's)?
Q1b).  How do I get from A to D (referencing only & and A's)?

Q2. 
%let member1=Demog; 
%let member2=Adverse; 
%let Root=member; 
%let Suffix=2; 
%put &&&Root&Suffix;


Without running the above code, what is the presented in the log from the %put statement?

************************************************************************************************************************/










/*************************************************************************************************************************
Demo 4 - Creating a Macro Program 

*************************************************************************************************************************/

/* Using train.demo, we want to calculate summary statistics for age and height for each gender */

/* Full code, no macro*/
proc means data = train.demo;
  class sex;
  var Age;
  Title ‘Summary Statistics for Age (yrs)’;
run;
proc means data = train.demo;
  class sex;
  var height;
  Title ‘Summary Statistics for Height (cm)’;
run;






/* Method 1: Create a macro program (positional parameters) to account for; 
1). variable we want the statistics of ie. age and height
2). label in the title    */

%macro means(var ,
             label);

proc means data = train.demo;
  class sex;
  var &var;
  Title "Summary Statistics for &label";
run;

%mend means;

*Note: When these statements are submitted, the macro facility performs a 
       macro compilation. This is not really a true compilation, and is 
       little more than a check on macro syntax. The compiled macro 
       definition is then written to a SAS catalog with an entry type of MACRO. 
       The default catalog is WORK.SASMACR and the entry name will be the name 
       of the macro itself.;



%means(Age      ,
       Age (yrs))

%means(height  ,
       Height (cm))

*Note: calling a macro does not require a semi-colon at the end;




/* Method 2: Create a macro program (keyword parameters) to account for; 
1). variable we want the statistics of i.e age or height
2). label in the title    */

%macro bob(var  = ,
           label=);

proc means data = train.demo;
  class sex;
  var &var;
  Title "Summary Statistics for &label";
run;

%mend bob;

%bob(var   = Age     ,
     label = Age (yrs))

%bob(var   = height    ,
     label = Height (cm))

* Order of parameters/macro variables are unimportant;
%bob(label = Age (yrs) ,
       var = Age   )
* Not all parameters/macro variables need to be specified (if code works without);
%bob(var = Age   )








/*********** Specifying default values - KEYWORD PARAMETERS ONLY ****************/

* A default parameter/macro variable value can be set in the macro definition;

%macro bob1(var  = ,
           label = ,
           split = trtgrp);

proc means data = train.demo;
  class &split;
  var &var;
  Title "Summary Statistics for &label";
run;

%put this macro is the macro stored in WORK.SASMACR;

%mend bob1;


%bob1(label = Age (yrs) ,
      var   = Age       ,
      split = sex        )


%bob1(label = Age (yrs) ,
      var   = Age        )








/*********************************************************************************
******************************METHOD 1 VS METHOD 2********************************
Method 2 (keyword parameters) recommended over method 1 (positional parameters):
 - for method 2 you don't have to specify all parameters if you don’t need them
 - for method 2 the sequence of parameters is not important
 - method 2 can have default values
 - method 2 is easier to see which value is assigned to which macro variable
**********************************************************************************/




/***************************************************
	  Contents of a macro program
***************************************************/

*1) Full statement;
%macro test1 (input=);
  set &input;
%mend test1;

data ex1;
  %test1(input=train.demo)
run;

*2) Partial statement;
%macro test2 (input=);
  &input
%mend test2;

data ex2;
  set %test2(input=train.demo);
run;






/*************************************************************************************************************************
Demo 5 - Debugging with global options  
*************************************************************************************************************************/

options symbolgen mprint mlogic;

%bob(var   = Age     ,
     label = Age (yrs))

%bob(var   = height    ,
     label = Height (cm))





/********************************************* Exercise 3 **************************************************************
Q1) Create a macro program for the following code:
proc sort data = train.pop out = pop;
  by usubjid;
run;
proc sort data = train.demo out = demo;
  by usubjid;
run;

data pop_demo;
  merge pop demo;
  by usubjid;
run;

proc freq data=pop_demo (where = (PNITT = 'Y'));
  table sex * trtgrp / out=sex_trtgrp_pnitt_frq;
run;

************************************************************************************************************************/




/*************************************************************************************************************************
Demo 6 - Storage of Macro Programs 

-  By default, compiled macros are stored in WORK.SASMACR catalog.
-  To store your macro in a permanent library, you need to submit the following:

  options mstored sasmstore = <libref>;
  %macro name(....) / store source;
	 ....
  %mend name;

-  When a macro is called, SAS will search for the macro in the following order:
     1. WORK.SASMACR
     2. stored compiled macro libraries libref.SASMACR (if defined by sasmstore)
-  CAUTION:  If we have multiple versions of the same macro stored in WORK.SASMACR 
   and libref.SASMACR then the work version will be executed due to the search order.
-  No option exists for macro like fmtsearch to define the search order (maybe soon??). 
-  See paper "Protecting Macros and Macro Variables: It Is All About Control"
   Eric Sun, Arthur L. Carpenter

*************************************************************************************************************************/


/* Prints all macro programs stored in work.sasmacr */
proc catalog cat = work.sasmacr;
  contents;
run;
quit;



/* Store macro progams in permanent library, storing source code with it */

* The following code will store macro program bob1 in train2 library;

/* Note: Only one library can be given on sasmstore.  If you want SAS to look in
  more than one permanent library then use:
  libname concat 'location1' 'location2' ;*/

options mstored sasmstore = train2;
%macro bob1(var  = ,
           label = ,
           split = trtgrp) / store source;
   
proc means data = train.demo;
  class &split;
  var &var;
  Title "Summary Statistics for &label";
run;
%put this macro is the macro stored in TRAIN2.SASMACR;

%mend bob1;


* Store bob1 in work;
%macro bob1(var  = ,
           label = ,
           split = trtgrp);

proc means data = train.demo;
  class &split;
  var &var;
  Title "Summary Statistics for &label";
run;
%put this macro is the macro stored in WORK.SASMACR;

%mend bob1;
* NOTE:  bob1 macro is stored in work library and train2 library;




/* QUIZ:  Which macro version will be used if I call the macro bob1?*/


%bob1(label = Age (yrs) ,
      var   = Age        )




/* To ensure correct version of macro is called, delete the macro program from work.sasmacr catalog */
%sysmacdelete bob1 ; /* New to SAS 9.3 */ 

/* Prints all macro programs stored in work.sasmacr */
proc catalog cat = work.sasmacr;
  contents;
run;
quit;

%bob1(label = Age (yrs) ,
      var   = Age        )




/* Checks if the macro program exists in work.sasmacr catalog only.  Note that if you have a
macro catalog stored in the SASMSTORE= location, those macro catalogs are not searched */
%put %sysmacexist(bob1);  /* New to SAS 9.3 */ 





/* View macro program source code using %copy.  
   - out = specifies a file to write the source code to (written to the log otherwise)
   - lib = specifies which catalog to search for the stored compiled macro (if no 
     library specified, the libref specified on SAMSTORE = is used (cannot be WORK).  */
%copy means / source lib = train2; 
%copy means / source lib = train2 out = 'C:\users\my_source_code.sas';












/*************************************************************************************************************************
Demo 7 - SQL Method 1
*************************************************************************************************************************/


/* SQL INTRODUCTION */

* Order of clause :
  Clever
  Statisticians
  Invent
  Free 
  Wine
  Get 
  Hammered
  Often ;



proc sql;
 select country 
 from train.demo;
quit;



proc sql;
 select distinct country 
 from train.demo;
quit;


proc sql;
 select country, count(*)
 from train.demo
 group by country;
quit;


proc sql;
 select distinct country, count(*)
 from train.demo
 group by country;
quit; * distinct is unnecessary with group by;



proc sql;
 select distinct country, count(*)
 from train.demo;
quit;





proc sql;
 select max(age)
 from train.demo;
quit;





proc sql;
 select trtgrp , max(age)
 from train.demo;
quit;





proc sql;
 select trtgrp , avg(age)
 from train.demo
 group by trtgrp ;
quit;






/**************Method 1: ********************
Picks up the top row of report only!

select var1,
       var2, ..., 
       varn 
into   :mvar1,
       :mvar2, ..., 
       :mvarn    
from  table;
*********************************************/
 
/* Example A - using %let to trim value in macro variable */

proc sql;
  select count(usubjid)
  from train.pop 
  where pnitt='Y';
quit;

/* Put value in report in a maro variable */
proc sql;
  select count(usubjid)
  into :itt_n 
  from train.pop 
  where pnitt='Y';
quit;
%put "&itt_n";       /* Leading and trailing blanks are present  */
%let itt_n=&itt_n;   /* %let strips out leading and trailing blanks  */
%put "&itt_n";       




/* Example B - using trimmed option on into: to trim value in macro variable */
%symdel itt_n;
proc sql ;
  select count(usubjid) 
  into :itt_n trimmed
  from train.pop 
  where pnitt='Y';
quit;
%put "&itt_n";



/* Example C - creating multiple macro variables */
/* Need to merge pop and demo so we have the populations with demo*/
proc sort data = train.demo
           out = demo;
  by usubjid;
run;
proc sort data = train.pop
           out = pop;
  by usubjid;
run;
data pop_demo; /* Need to have population information in demo dataset */
  merge demo (in = in_demo) 
        pop  (in = in_pop); 
  by usubjid;
  if in_demo = in_pop;
run;
/* Create multiple macro variables */
proc sql ;
  select avg(age) as my_mean, 
         min(age) as my_min, 
         max(age) as my_max
  into :age_mean trimmed, 
       :age_min  trimmed, 
       :age_max  trimmed
  from pop_demo 
  where pnitt='Y';
quit;
%put &=age_mean 
     &=age_min 
     &=age_max ;
%put &age_mean 
     &age_min 
     &age_max ;

 


/* Example D - making it more flexible for different populations.*/
%let pop = PNSAFE;
proc sql ;
  select avg(age), 
         min(age), 
         max(age) 
  into :age_mean_&pop. trimmed, 
       :age_min_&pop.  trimmed, 
       :age_max_&pop.  trimmed
  from pop_demo
  where &pop.='Y';
quit;



* I am the macro processor! ;
proc sql ;
  select avg(age), 
         min(age), 
         max(age) 
  into :age_mean_pnsafe trimmed, 
       :age_min_pnsafe  trimmed, 
       :age_max_pnsafe  trimmed
  from pop_demo
  where pnsafe='Y';
quit;


%put &age_mean_&pop. 
     &age_min_&pop. 
     &age_max_&pop.;

%put &&age_mean_&pop. 
     &&age_min_&pop. 
     &&age_max_&pop.;

%put mean = "&age_mean_&pop." 
      min = "&age_min_&pop." 
      max = "&age_max_&pop.";

%put mean = "&&age_mean_&pop." 
      min = "&&age_min_&pop." 
      max = "&&age_max_&pop.";

*works but gives a warning in the log ... need multiple & to avoid the warning ;


/*QUIZ - what are the values of the macro variables created?*/

*A);
proc sql;
 select distinct country 
 into :a
 from train.demo;
quit;

%put &=a;



*B);
proc sql;
 select country, count(*)
 into :b
 from train.demo
 group by country;
quit;

%put &=b;


proc sql;
 select country, count(*)
 into :b1,
      :b2
 from train.demo
 group by country;
quit;

%put &=b1 &=b2;


proc sql;
 select country, count(*)
 into :b1,
      :b2,
	  :b3
 from train.demo
 group by country;
quit;

%put &=b1 &=b2 &=b3;



*C);
proc sql;
 select max(age)
 into :c
 from train.demo;
quit;

%put &=c;




*D);
proc sql;
 select trtgrp , max(age)
 into :d
 from train.demo;
quit;

%put &=d;


*E);
proc sql;
 select trtgrp , max(age)
 into :e
 from train.demo
 group by trtgrp ;
quit;

%put &=e;



*F);
proc sql;
 select max(age), min(age)
 from train.demo 
 into :f
 group by trtgrp ;
quit;

%put &=f;


proc sql;
 select max(age), min(age)
 into :f
 from train.demo 
 group by trtgrp ;
quit;

%put &=f;




/********************************************* Exercise 4 **************************************************************
Q1) Using PROC SQL, create macro variables (using method 1 only) containing the minimum and
    maximum age values for females only.
 
    Ensure your code can be applied to different values of gender.

    Write a suitable put statement to check all the values.


Q2) Using PROC SQL, create a macro variable (using method 1 only) containing the number of subjects 
    per treatment group, per population.  For example n_trt1_itt, n_trt1_pp, n_trt2_itt etc.

    Write a suitable put statement to check all the values.

************************************************************************************************************************/













/*************************************************************************************************************************
Demo 8 - Method 2
*************************************************************************************************************************/
/**************Method 2: ********************
select   var1, 
         var2, … ,
         varn
into    :var1_1–:var1_i,  
        :var2_1–:var2_i, …,
        :varn_1–:varn_i   
from   table;

*********************************************/


/* Example A - Create treatment group n's         */
/*           - Proc freq to calculate n's         */
/*           - Proc sql to create macro variables */


/* Create data set with one row per treatment group */
proc freq data = pop_demo (where = (pnitt = 'Y')) ;
  tables trtgrp / out = ITT_N;
run;

%symdel trt_1 trt_2 trt_3 n_1 n_2 n_3;
proc sql ;
  select   trtgrp, 
           count
  into    :trt_1-:trt_3,  
          :n_1-:n_3   /* Trimmed is no longer required - When a series of macro variables are created,*/
                      /* SAS automatically removes leading and trailing blanks */
  from    ITT_N;
quit;
%put trt_1 = "&trt_1"
     trt_2 = "&trt_2" 
     trt_3 = "&trt_3" 
     n_1   = "&n_1"
     n_2   = "&n_2"
     n_3   = "&n_3";



/* Example B - Create treatment group n's                        */
/*           - Proc sql to create n's and create macro variables */
%symdel trt_1 trt_2 trt_3 n_1 n_2 n_3;
proc sql ;
  select   trtgrp, 
           count(*)
  into    :trt_1-:trt_3,  
          :n_1-:n_3   
  from    pop_demo
  where PNITT = 'Y'
  group by trtgrp;
quit;
%put trt_1 = "&trt_1"
     trt_2 = "&trt_2"
     trt_3 = "&trt_3" 
     n_1   = "&n_1"
     n_2   = "&n_2"
     n_3   = "&n_3";





/* Example C - Create treatment group n's                        */
/*           - Proc freq to calculate n's                        */
/*           - Proc sql to create macro variables                */
/*           - Prevent hard coding number of treatment groups    */
	 
/* Create data set with one row per treatment group */
proc freq data = pop_demo (where = (pnitt = 'Y')) noprint;
  tables trtgrp / out = ITT_N;
run;

proc sql ;
  select count(*)
  into: number_trt trimmed
  from ITT_N; /* Query calculates the number of rows in dataset i.e number of treatment groups */

  %put number_trt = "&number_trt"; /* test without trimmed option*/

  select   trtgrp, 
           count
  into    :trt_1-:trt_&number_trt,  
          :n_1-:n_&number_trt   
  from   ITT_N;
quit;
%put trt_1 = "&trt_1"
     trt_2 = "&trt_2"
     trt_3 = "&trt_3" 
     n_1   = "&n_1"
     n_2   = "&n_2"
     n_3   = "&n_3";



/* Example D - Create treatment group n's                        */
/*           - Proc sql to create n's and create macro variables */
/*           - Prevent hard coding number of treatment groups    */	

%symdel trt_1 trt_2 trt_3 n_1 n_2 n_3;

proc sql ;
  select count(distinct trtgrp)
  into: number_trt trimmed
  from pop_demo; 
  *Query calculates the number of rows in dataset i.e number of treatment groups ;
  %put number_trt = "&number_trt"; /* test without trimmed option*/

  select   trtgrp, 
           count(*)
  into    :trt_1-:trt_&number_trt,  
          :n_1-:n_&number_trt   
  from    pop_demo
  where PNITT = 'Y'
  group by trtgrp;
quit;
%put trt_1 = "&trt_1"
     trt_2 = "&trt_2"
     trt_3 = "&trt_3" 
     n_1   = "&n_1"
     n_2   = "&n_2"
     n_3   = "&n_3";



/* Example E - Create treatment group n's                        */
/*           - Proc sql to create n's and create macro variables */
/*           - Prevent hard coding number of treatment groups    */

	 
%symdel trt_1 trt_2 trt_3 n_1 n_2 n_3;
proc sql ;
  select distinct trtgrp
  from ITT_N; /* Query result has 3 rows, therefore &SQLOBS = 3 */
  %put sqlobs = "&sqlobs";

  select   trtgrp, 
           count(*)
  into    :trt_1-:trt_&sqlobs,  
          :n_1-:n_&sqlobs   
  from    pop_demo
  where PNITT = 'Y'
  group by trtgrp;
quit;
%put trt_1 = "&trt_1"
     trt_2 = "&trt_2"
     trt_3 = "&trt_3" 
     n_1   = "&n_1"
     n_2   = "&n_2"
     n_3   = "&n_3";






/* Example F - Create treatment group n's for each population    */
/*           - Proc sql to create n's and create macro variables */
/*           - Prevent hard coding number of treatment groups    */

%let pop = PNITT;	 
%symdel trt_1 trt_2 trt_3 n_1 n_2 n_3;
proc sql ;
  select distinct trtgrp 
  from pop_demo
  where &pop. = 'Y'; /* Query result has 3 rows, therefore &SQLOBS = 3 */
  %put sqlobs = "&sqlobs";

  select   trtgrp, 
           count(*)
  into    :&pop._trt_1-:&pop._trt_&sqlobs,  
          :&pop._n_1-:&pop._n_&sqlobs  
  from    pop_demo
  where &pop = 'Y'
  group by trtgrp;
quit;

%put &pop._trt_1 = "&&&pop._trt_1"
     &pop._trt_2 = "&&&pop._trt_2"
     &pop._trt_3 = "&&&pop._trt_3"
     &pop._n_1   = "&&&pop._n_1"
     &pop._n_2   = "&&&pop._n_2"
     &pop._n_3   = "&&&pop._n_3";






/* Example G - Create treatment group n's for each population     */
/*           - Proc sql to create n's and create macro variables  */
/*           - Not required to specify number of treatment groups */

%symdel trt_1 trt_2 trt_3 n_1 n_2 n_3;
%let pop = PNITT;
proc sql ;
  select trtgrp, 
         count(*)
  into    :&pop._trt_1- ,
          :&pop._n_1-
  from    pop_demo
  where &pop = 'Y'
  group by trtgrp;
quit;
%put &pop._trt_1 = "&&&pop._trt_1"
     &pop._trt_2 = "&&&pop._trt_2"
     &pop._trt_3 = "&&&pop._trt_3"
     &pop._n_1   = "&&&pop._n_1"
     &pop._n_2   = "&&&pop._n_2"
     &pop._n_3   = "&&&pop._n_3";









/********************************************* Exercise 5 **************************************************************
Q1) Create a series of macro variables that contain the treatment code (1, 2 or 3), 
	 with a separate series of macro variables containing the treatment name (Placebo etc).

	 Hard code the number of treatments.
	 

Write a suitable put statement to check the values.


Q2) As Q1 but don't hard code the number of treatments.  	 

Write a suitable put statement to check the values.

************************************************************************************************************************/



/*************************************************************************************************************************
Demo 9 - SQL Method 3
*************************************************************************************************************************/
/**************Method 3: ********************
select var1,       
       var2,    …  , 
       varn 
into    :mvar1 separated by ‘delimiter’,  
        :mvar2 separated by ‘delimiter’    , … , 
        :mvarn separated by ‘delimiter’    
from   table;
*********************************************/


/* Generates a list of treatments in a macro variable to prevent hard coding (use in Title/Footnote etc) */
proc sql ;
  select distinct trtgrp
  into   :trt_list separated by ', '    
  from   pop_demo
  where pnitt = 'Y';
quit;
%put Treatments include: &trt_list ;



/* What does this give you? */
proc sql ;
  select distinct trtgrp
  into   :trt_list     
  from   pop_demo
  where pnitt = 'Y';
quit;
%put Treatments include: &trt_list ;


/* Generates a dynamic list to use in an in operation */
proc sql ;
  select distinct trtgrp
  into   :t separated by '", "'    
  from   pop_demo
  where pnitt = 'Y';
quit;



%let t = ("&t");
%put &t;


proc print data = train.ae;
  where trtgrp in &t;
  var subjid age sex race;
  Title "Patients With Adverse Events for Treatments: &trt_list";
run;


/* Will this work? */
proc print data = train.ae;
  where trtgrp in ("&t");
  var subjid age sex race;
  Title "Patients With Adverse Events for Treatments: &trt_list";
run;




/********************************************* Exercise 6 ***************************************************************
 
Q1) The following footnote needs to be presented at the bottom of an output:
"Patients are from n different countries: country list".

Create a macro variable for the number of countries and also the country list.

************************************************************************************************************************/





/*************************************************************************************************************************
Demo 10 - Use of Call Symput to create macro variables containing Big N's 
*************************************************************************************************************************/

proc sort data = train.pop out = pop;
  by usubjid;
run;
proc sort data = train.demo out = demo;
  by usubjid;
run;

data pop_demo;
  merge pop (in=A) demo (in=B);
  by usubjid;
  if A and B;
run;

/* Calculate Big N's */
proc freq data = pop_demo (where = (pnitt = 'Y'));
   tables trtcd * trtgrp  / out = Big_N (drop = percent);
run;


/* Attempt 1 - hard coding required therefore not recommended! */
/* DO NOT USE */
%let trt_n_1 = 479;
%let trt_n_2 = 480;
%let trt_n_3 = 470;




/* Attempt 2 - avoid hard coding using %let.  Will this work?   */
/* DO NOT USE */
data _null_;
  set Big_N;
  if trtcd = 1 then 
     do;
        %let trt_n_1 = count;
     end;
  else if trtcd = 2 then 
     do;
        %let trt_n_2 = count;
     end;
  else if trtcd = 3 then 
     do;
        %let trt_n_3 = count;
     end;
run;
%put &=trt_n_1  &=trt_n_2 &=trt_n_3;


*  What does the SAS compiler see?;
data _null_;
  set Big_N;
  if trtcd = 1 then 
     do;
      
     end;
  else if trtcd = 2 then 
     do;
      
     end;
  else if trtcd = 3 then 
     do;
      
     end;
run;

/* Attempt 3 - Using Call Symput: value is placed using best12. format ie. value right alligned with leading blanks */
/* DO NOT USE */
data _null_;
  set Big_N;
  if trtcd = 1 then call symput('trt_n_1' , count);
  else if trtcd = 2 then call symput('trt_n_2' , count);
  else if trtcd = 3 then call symput('trt_n_3' , count);
run;
* CAUTION: see note in the log;
%put trt_n_1=***&trt_n_1***;
%put trt_n_2=***&trt_n_2***;
%put trt_n_3=***&trt_n_3***;



/* Attempt 4 - Using Call Symput: dealing with the leading and trailing blanks using trim() and left()*/
/* DO NOT USE */
data _null_;
  set Big_N;
  if trtcd = 1 then call symput('trt_n_1' , trim(left(count)));
  else if trtcd = 2 then call symput('trt_n_2' , trim(left(count)));
  else if trtcd = 3 then call symput('trt_n_3' , trim(left(count)));
run;
* CAUTION: see note in the log;
%put trt_n_1=***&trt_n_1***;
%put trt_n_2=***&trt_n_2***;
%put trt_n_3=***&trt_n_3***;



/* Attempt 5 - Using Call Symput: dealing with the note in the log regarding numeric to character conversion */
/* OKAY TO USE BUT THERE ARE EASIER WAYS */
%symdel trt_n_1 trt_n_2 trt_n_3;
data _null_;
  set Big_N;
  if trtcd = 1 then      call symput('trt_n_1' , trim(left(put(count, 5.))));
  else if trtcd = 2 then call symput('trt_n_2' , trim(left(put(count, 5.))));
  else if trtcd = 3 then call symput('trt_n_3' , trim(left(put(count, 5.))));
run;
%put trt_n_1=***&trt_n_1***;
%put trt_n_2=***&trt_n_2***;
%put trt_n_3=***&trt_n_3***;




/* Attempt 6 - Using Call Symput: making it more dynamic */
/* DO NOT USE */
data _null_;
  set Big_N;
  call symput('trt_n_'||trtcd, trim(left(put(count, 5.))));
run; *Why won't this work?;



/* Attempt 7 - Using Call Symput: making it more dynamic */
/* OKAY TO USE BUT THERE ARE EASIER WAYS */
data _null_;
  set Big_N;
  call symput('trt_n_'||put(trtcd,1.), trim(left(put(count, 5.))));
run;
%put trt_n_1=***&trt_n_1***;
%put trt_n_2=***&trt_n_2***;
%put trt_n_3=***&trt_n_3***;



/* Attempt 8 - Using Call Symputx: removes leading and trailing blanks.  New to SAS 9 */
/* THE HOLY GRAIL!! */
data _null_;
  set Big_N;
  call symputx('trt_n_'||put(trtcd,1.), count);
run;


%put trt_n_1=***&trt_n_1***;
%put trt_n_2=***&trt_n_2***;
%put trt_n_3=***&trt_n_3***;






/* Referencing macro variables in the same data step */
data _null_;
  set Big_N;
  call symputx('trt_bign_'||put(trtcd,1.), count );
  call symputx('trtname_'||put(trtcd,1.), trtgrp );
   /* Just comparing placebo and 2mg */
  if &trt_bign_1 > &trt_bign_2 then call symputx('largest_big_N', "&trtname_1");
  else if &trt_bign_1 < &trt_bign_2 then call symputx('largest_big_N',  "&trtname_2");
  else call symputx('largest_big_N', "Tie");

run;
%put trt_bign_1=***&trt_bign_1***;
%put trt_bign_2=***&trt_bign_2***;
%put trtname_1=***&trtname_1***;
%put trtname_2=***&trtname_2***;
%put largest_big_N=***&largest_big_N***;






/* Must create macro variables before referencing them */
data _null_;
  set Big_N;
  call symputx('trt_bign_'||put(trtcd,1.), count );
  call symputx('trtname_'||put(trtcd,1.), trtgrp );
run;


data _null_;
  if &trt_bign_1 > &trt_bign_2 then call symputx('largest_big_N', "&trtname_1");
  else if &trt_bign_1 < &trt_bign_2 then call symputx('largest_big_N',  "&trtname_2");
  else call symputx('largest_big_N', "Tie");
run;
%put trt_bign_1=***&trt_bign_1***;
%put trt_bign_2=***&trt_bign_2***;
%put trtname_1=***&trtname_1***;
%put trtname_2=***&trtname_2***;
%put largest_big_N=***&largest_big_N***;


/********************************************* Exercise 7 **************************************************************

Q1) The following footnotes are required on an ae output:  

Footnote1 "&trt_ae_1 patients experienced an adverse event on &trt_1";  
Footnote2 "&trt_ae_2 patients experienced an adverse event on &trt_2";
Footnote3 "&trt_ae_3 patients experienced an adverse event on &trt_3";
Footnote4 "More patients experienced adverse events on: &most_ae"; 

Using data step, create macro variables containing the number of patients experiencing 
adverse events(&trt_ae_?) for each treatment group (&trt_?).  Create an additional 
macro variable (&most_ae) which contains the name of the treatment group with the 
most number of patients experiencing adverse events.

Q2) Create macro variables using one data step.  The macro variables
    should contain the Big N's for each population and each treatment group.


************************************************************************************************************************/






/*************************************************************************************************************************
Demo 11 - Use of Symget to retrieve the value of a macro variable 
*************************************************************************************************************************/
/*Call symput used to create three macro variables */
%symdel trt_1 trt_2 trt_3;
data _null_;
  set train.demo;
  if index(trtgrp, 'mg') > 0 then 
       call symputx('trt_'||put(trtcd, 1.) , 'Active: '!! trtgrp);
run;

%put trt_1=***&trt_1***;
%put trt_2=***&trt_2***;
%put trt_3=***&trt_3***;


/*Symget */
data treatment_active (keep = usubjid trtcd trtgrp treatment);
  set pop_demo;
  where pnitt = 'Y' and index(trtgrp, 'mg') > 0;
  Treatment = symget('trt_'||put(trtcd, 1.));
run;


/* Above is equivalent to the following */
data treatment_active1 (keep = usubjid trtcd trtgrp treatment);
  set pop_demo;
  length treatment $ 30;
  where pnitt = 'Y' and index(trtgrp, 'mg') > 0;
  /* There is no &trt1 */
  if trtcd = 2 then Treatment = "&trt_2";
  else if trtcd = 3 then Treatment = "&trt_3";
run;









/*************************************************************************************************************************
Demo 12 - Character Macro Functions

- SAS functions are executed in the SAS compiler where data/proc steps are executed
- Macro functions are dealt with in the macro processor prior to the SAS compiler (before data/proc steps are executed)
- Macro functions allow SAS functions to work in the macro processor on macro variables
- Quotes around arguments are not needed as the macro processor treats it all as text
*************************************************************************************************************************/



/* %upcase - Example 1a */
%let name = upcase(Anna);
%put &=name;

%let name = %upcase(Anna);
%put &=name;

%let name = %sysfunc(upcase(anna));
%put &=name;





* %propcase does not exist!;
%let name = %propcase(anna);
%put &=name;

%let name = %sysfunc(propcase(anna));
%put &=name;




/* %upcase - Example 1b */
%macro funct1(pop = ,
              sex = );
proc means data = pop_demo;
  where &pop. = 'Y' and sex = "%upcase(&sex.)";
run; 
%mend funct1;

%funct1(pop = pnitt,
        sex = m)


* I am the macro processor!;
proc means data = pop_demo;
  where pnitt = 'Y' and sex = "M";
run;


/* upcase - Example 1c */
%macro funct1(pop = ,
              sex = );
proc means data = pop_demo;
  where &pop. = 'Y' and sex = upcase("&sex.");
run; 
%mend funct1;

%funct1(pop = pnitt,
        sex = m)


* I am the macro processor!;
proc means data = pop_demo;
  where pnitt = 'Y' and sex = upcase("m");
run;


* Quiz - What (if any) are the differences between 1b and 1c?;


/* upcase - Example 1d */
%macro funct1(pop = ,
              sex = );
proc means data = pop_demo;
  where &pop. = 'Y' and sex = upcase('&sex.');
run; 
%mend funct1;

%funct1(pop = pnitt,
        sex = m)










/* %scan */
%macro funct2(treatment = placebo!2mg rsg XR!8mg RSG XR,
              trt_num   = ); /* Qu - is there a way of avoiding typing the 
			                         list of treatments? */

proc means data = pop_demo;
  where pnitt = 'Y' and trtcd = &trt_num ;
  var age;
  Title " Summary of Age for %scan(%upcase(&treatment), &trt_num, ! )";
run;
%put %scan(&treatment, &trt_num, ! );

%mend;

%funct2(treatment = placebo!2mg rsg XR!8mg RSG XR, 
        trt_num   = 2) 


%funct2(treatment = placebo!2mg rsg XR!8mg RSG XR, 
        trt_num   = 1)

%funct2(trt_num   = 3)


*  This won't work!;
%funct2(3)



/*QUIZ - What is the value of the following macro variables?*/
%let test1 = %scan(Anna Cargill, 1 );
%put &=test1;
%let test2 = %scan(Anna Cargill, 2 );
%put &=test2;
%let test3 = %scan(Anna!Cargill, 2 );
%put &=test3;






/* %substr */
proc print data = train.vsanal;
  var subjid ;
  where vsdt between "01%substr(&sysdate9, 3)"d 
        and "&sysdate9"d; 
  title "Subjects with visits so far this month to &sysdate9";
run;

* No visits are expected!;


* I am the macro processor!;
proc print data = train.vsanal;
  var subjid ;
  where vsdt between "01OCT2020"d 
        and "14OCT2020"d; 
  title "Subjects with visits so far this month to 14OCT2020";
run;





/*QUIZ - What is the value of the macro variable below?*/
%let test1 = %substr("Anna", 2, 1);
%put &=test1;









/* %length */
%let fullname = Anna Teresa Cargill;
%let firstname = %scan(&fullname, 1);
%let surname = %scan(&fullname, 3);

%put Length of fullname is %length(&fullname); 
%put Length of firstname is %length(&firstname); 
%put Length of surname is %length(&surname); 





/* %index */
%let fullname = Anna Teresa Cargill;
%let pos=%index(&fullname,"Cargill");
%put Cargill appears at position &pos;



%let pos=%index(&fullname,Cargill);
%put Cargill appears at position &pos;


* Why are we not using quotes like we do for non macro functions?;








/*************************************************************************************************************************
Demo 13 - Evaluation Macro Functions
*************************************************************************************************************************/

/* Macro processor will not automatically perform arithmetic calculations */
%put 1 + 5 + 7;


/* %eval instructs macro processor to perform arithmetic calculations (integers only) */
%put %eval(1 + 5 + 7);
%put %eval(1.7 + 5.4 + 7);

%put %eval(5 > 2);
%put %eval(5 > 7);


/* %sysevalf instructs macro processor to perform arithmetic calculations (integers and non-integers) */
%put %sysevalf(1 + 5 + 7);
%put %sysevalf(1.7 + 5.4 + 7);
%put %sysevalf(1.7 + 5.4 + 7 , integer);
%put %sysevalf(1.7 + 5.4 + 7 , ceil);
%put %sysevalf(1.7 + 5.4 + 7 , floor);









/*************************************************************************************************************************
Demo 14 - Quoting Macro Functions
*************************************************************************************************************************/


/* Why do we need quoting functions? %str, %nrstr, %bquote and %superq */
%let big_n_prog = data _null_;  set Big_N;  call symputx('trt_n_'||left(trtgrpn) , count); run; ;
%put &=big_n_prog;





/* 1) %str - masks special characters (excluding macro triggers & and %) when STORING/COMPILING macro */
%let big_n_prog = %str(data _null_;  set Big_N;  call symputx('trt_n_'||left(trtgrpn) , count); run;);
%put &=big_n_prog;



/* 2) %nrstr - masks special characters (including macro triggers & and %) when STORING/COMPILING macro */
%let big_n_prog_1 = %nrstr(data _null_;  set Big_N;  call symputx('trt_n_'||left(trtgrpn) , count); run;);
%put &=big_n_prog_1;

* NOTE: %str() and %nrstr() would be different if the contents containg macro triggers;



/*  We want text to say "Using &sysdate9, gives the date as 18OCT2016" */
%put Using &sysdate9, gives the date as &sysdate9 ; 
* What needs protecting?;
%put Using %str(&sysdate9), gives the date as &sysdate9 ;
%put Using %nrstr(&sysdate9), gives the date as &sysdate9 ;
%put Using '&sysdate9', gives the date as &sysdate9 ;



/*  We want text to say "%sysmacexist(abc)=1/0", to determine whether macro program
    abc exists or not */

%put %str(%sysmacexist(abc))=%sysmacexist(abc);
%put %nrstr(%sysmacexist(abc))=%sysmacexist(abc);
%macro abc; 
  %put this is abc; 
%mend;
%abc
%put %nrstr(%sysmacexist(abc))=%sysmacexist(abc);






/* 3) %bquote - masks special characters (excluding macro triggers & and %) when RESOLVING/EXECUTING macro */
%let which_visit = %upcase(visit 1, visit 2, visit 3, visit 4, 
           visit 5, visit 6, visit 7, visit 8, visit 9, visit 10);
%let which_visitnum = 8;


/*a)*/ %put %scan(&which_visit, &which_visitnum, , );
/*b)*/ %put %scan(&which_visit, &which_visitnum, %str(,) );
/*c)*/ %put %scan(%str(&which_visit), &which_visitnum, %str(,) );
/*d)*/ %put %scan(%bquote(&which_visit), &which_visitnum, %str(,));



/* 4) %superq (similar to %nrbquote) - masks special characters (including macro triggers & and %) when RESOLVING/EXECUTING macro */

%let Treat = T1&T2;
%put Treatment phase is : %superq(Treat);


%let Treat = %nrstr(T1&T2);
%put Treatment phase is : &Treat ;

*Find another example;






/*************************************************************************************************************************
Demo 15 - Other Macro Functions
*************************************************************************************************************************/


%put _automatic_;
* Qu - What is the problem with this?;
proc freq data = pop_demo (where = (pnitt = 'Y'));
  tables trtgrp ;
  title "Subjects in the ITT population at &systime. on &sysdate9.";
run;



* Qu - What is the problem with this?;
proc freq data = pop_demo (where = (pnitt = 'Y'));
  tables trtgrp ;
  title "Subjects in the ITT population at time() on today()";
run;


/* %sysfunc - allows the use of data step functions outside of data step */
* Qu - What is the problem with this?;
proc freq data = pop_demo (where = (pnitt = 'Y'));
  tables trtgrp ;
  title "Subjects in the ITT population at %sysfunc(time()) on 
         %sysfunc(today())";
run;







proc freq data = pop_demo (where = (pnitt = 'Y'));
  tables trtgrp ;
  title1 "Subjects in the ITT population at %sysfunc(time(), time5.)";
  title2 " on %sysfunc(today(), date9.)";
run;









/********************************************* Exercise 8 **************************************************************

Q1. What are the values of the macro variables below?
%let A =  2 + 1;
%let B = eval(2 + 1);
%let C = %sysevalf(2 + 1);
%let D = %sysevalf(2.1 + 1.3);
%let E = %eval(2.1 + 1.3);
%let F = %sysevalf(2.1 + 1.3, integer);
%let G = sum(2.1, 1.3);
%let H = %sysfunc(sum(2.1, 1.3));


Q2.  Complete the following two %let statements so the resulting value
     of the macro variables contain the average of 60, 72 and 79.  Use
     two different methods.

%let av_weight1 = ;
%let av_weight2 = ;


Q3. Using the macro variable &trt_list and the %scan function, write a footnote that displays:
    "Treatments include: Trt1, Trt2 and Trt3."
%let trt_list = trt1 trt2 trt3;


Q4. Using the macro variable &trt_list, write a footnote that displays:
    "Treatments include: Trt1, Trt2 and Trt3."
%let trt_list = trt1, trt2, trt3;


************************************************************************************************************************/






/*************************************************************************************************************************
Demo 16 - Conditional processing using %if %then %do
- until very recently, must be used within a macro program
- can now be used anywhere (but not nested %if %then %do)!!!!!!
- can be used to conditionally execute:
    a) steps
    b) statements
    c) partial statements
- determines which code is sent to the SAS compiler for execution
*************************************************************************************************************************/


/***************************************************************
Example 1: %if %then %do to check if parameter values are valid 
****************************************************************/

%macro mymeans1(pop = ) / minoperator ;

%if %upcase(&pop) in PNITT PNSAFE %then %do;
	proc means data = pop_demo;
   		where &pop = 'Y'; 
   		var age;
	run;
%end;
%else %do;
	%put %sysfunc(cat(ER, ROR:)) Specified parameter %nrstr(&pop) = &pop 
         is not a valid population;
%end;

%mend;



%mymeans1(pop = pnitt)

%mymeans1(pop = pnit)


*  How to create a fake macro program with no parameters;
%macro anna;
  %put this is an example;
%mend;

%anna




*  New developments ... very exciting!;
*  mlogic info not shown outside of macro program;
options minoperator ;
%let pop = pnit;
%let pop = pnSafe;


%if %upcase(&pop) in PNITT PNSAFE %then %do;
	proc means data = pop_demo;
   		where &pop = 'Y'; 
   		var age;
	run;
%end;
%else %do;
	%put %sysfunc(cat(ER, ROR:)) Specified parameter %nrstr(&pop) = &pop 
         is not a valid population;
%end;




*  This won't work in open code but will in a macro program;

options minoperator;
%let pop = pnit;
%let pop = pnSafe;


%if %upcase(&pop) in PNITT PNSAFE %then %do;
	proc means data = pop_demo;
   		where &pop = 'Y'; 
   		var age;
	run;
%end;
%else %if %upcase(&pop) in PNPP PNRAND %then %do;
    data &pop;
	  set pop_demo;
	  where &pop = 'Y';
	run;
%end;
%else %do;
   %put Not valid %nrstr(&pop) = &pop;
%end;







/*********************************************************************************
Example 2: %if %then %do to execute full statements and steps based on a condition 
**********************************************************************************/
%macro stats1(in_lib = ,
              in_dt  = ,
              var    = ,
              split  =     
             );

proc means data = &in_lib..&in_dt nway;
       %if &split ne   %then %do; * if &split value present;
          %put NOTE: Value for %nrstr(&split) has been specified!; 
          class &split;
       %end;

       %else %do;  * if &split value missing;
          %put WARNING: No value for %nrstr(&split) has been specified!; 
       %end;
  var &var;
  output out = &var._s (drop = _type_ _freq_);
run;

      %if &split ne   %then %do;  * if &split value present;
	      proc sort data = &var._s;
  		     by &split;
	      run;
      %end;


proc transpose data = &var._s
                out = &var._t; 
  var &var;
  id _stat_;

      %if &split ne   %then %do;  * if &split value present;
              by &split;
      %end;
run;

%mend;


* I am the macro processor!;


*Code executed if &split value missing;

proc means data = &in_lib..&in_dt nway;
  %put WARNING: No value for %nrstr(&split) has been specified!; 
  var &var;
  output out = &var._s (drop = _type_ _freq_);
run;

proc transpose data = &var._s
                out = &var._t; 
  var &var;
  id _stat_;
run;

*Code executed if &split value present;

proc means data = &in_lib..&in_dt nway;
  %put NOTE: Value for %nrstr(&split) has been specified!; 
  class &split;
  var &var;
  output out = &var._s (drop = _type_ _freq_);
run;
proc sort data = &var._s;
  	by &split;
run;
      
proc transpose data = &var._s
                out = &var._t; 
  var &var;
  id _stat_;
  by &split;
run;


options mprint symbolgen mlogic minoperator;
%stats1(in_lib = train,
        in_dt  = demo,
        var    = age,
        split  =     
        )





%stats1(in_lib = train,
        in_dt  = demo,
        var    = age,
        split  = trtgrp
        )






/*****************************************************************************
Example 3: %if %then %do to execute partial statements 
*****************************************************************************/

%macro freq1(rows = , 
             cols = ) ;
proc freq data = train.demo;
   tables 
      %if &rows ne  %then %do;
          &rows  * 
	  %end;
   &cols ;
run;
%mend freq1;

%freq1(rows = trtgrp,
       cols = sex )

%freq1(rows =  ,
       cols = sex )






/**********************************************************************************
Example 4: %if %then %do to check if parameter values are valid 
***********************************************************************************/

%macro means2(trt = ) ;
* Uppercase &trt ;
%let trt = %upcase(&trt); 
* Create a list of all values of trtgrp and place in a macro variable ;
proc sql ;
   select distinct upcase(trtgrp)
   into :trt_list separated by ','
   from pop_demo
   where pnitt = 'Y';
quit;

*%put &trt_list;

* Check if value specified for &trt exists in &trt_list ;
%if %index(%bquote(&trt_list), &trt) > 0 %then %do;
	proc means data = train.demo;
  		where upcase(trtgrp) = "&trt";
		var age;
	run;
%end;
%else %do;
	%put %sysfunc(cat(ER, ROR:)) %nrstr(&trt) = &trt is not a valid treatment;
	%put %sysfunc(cat(ER, ROR:)) Valid values of %nrstr(&trt) include: &trt_list;
%end; 
  
%mend;

%means2(trt = Placebo)
%means2(trt = placbo) /* Spelling mistake! */



/* %superq works as well as %bquote (protects commas in resolved of &trt_list) */
%macro means2(trt = ) ;
* Uppercase &trt ;
%let trt = %upcase(&trt); 
* Create a list of all values of trtgrp and place in a macro variable ;
proc sql ;
   select distinct upcase(trtgrp)
   into :trt_list separated by ','
   from pop_demo
   where pnitt = 'Y';
quit;

*%put &trt_list;

* Check if value specified for &trt exists in &trt_list ;
%if %index(%superq(trt_list), &trt) > 0 %then %do;
	proc means data = train.demo;
  		where upcase(trtgrp) = "&trt";
		var age;
	run;
%end;
%else %do;
	%put %sysfunc(cat(ER, ROR:)) %nrstr(&trt) = &trt is not a valid treatment;
	%put %sysfunc(cat(ER, ROR:)) Valid values of %nrstr(&trt) include: &trt_list;
%end; 
  
%mend;

%means2(trt = Placebo)
%means2(trt = placbo) /* Spelling mistake! */









/********************************************* Exercise 9 **************************************************************
Q1. A footnote is required on the following output. 
     
title "Number of Patients With Adverse Events in the Safety Population";
proc freq data = ae_pats ;
 tables trtgrp;
run;
    
    The ae_pats dataset contains a unique list patients who experienced an ae.
    The footnote required depends on the total number of patients experiencing
    adverse events.  
    For less than 100 patients with ae's the footnote should read:
    Footnote1 "A small number of patients (&pop_pats_ae) experienced adverse events";
    Between 100 to 200 (inclusive) patients with ae's the footnote should read:
    Footnote1 "An expected number of patients (&pop_pats_ae) experienced adverse events";
    For more than 200 patients with ae's the footnote should read:
    Footnote1 "A large number of patients (&pop_pats_ae) experienced adverse events";

   Create the macro variable &pats_ae which contains the total number of patients 
   experiencing ae's and ensure the correct footnote is displayed.


Q2.  Calculate the big N's for each treatment group and place them in macro variables.
     Perform a check on the differences in the big N's for the ITT population. 

     If the differences in the Big N's are greater than 10, write the 
     following error to the log: 
     ERROR: &trt_1 (&trt_n_1) has over 10 patients more than 
            &trt_2 (&trt_n_2) or &trt_3 (&trt_n_3) 
     Otherwise write a note to the log:
     NOTE: Randomisation technique is working!


************************************************************************************************************************/











/*************************************************************************************************************************
Demo 17 - Iterative processing Using %do macvar_i 
*************************************************************************************************************************/

/* Method 1a): %do macvar_i  */

/* Create macro variables containing treatment info */
proc sql ;
  select distinct trtcd, 
                  trtgrp
  into :trt_code_1- ,
       :trt_name_1-
  from pop_demo
  where pnitt='Y';
  %let num_trts = &sqlobs;
quit;

%put trt_code_1 = "&trt_code_1" 
     trt_code_2 = "&trt_code_2" 
     trt_code_3 = "&trt_code_3" 
     trt_name_1 = "&trt_name_1"
     trt_name_2 = "&trt_name_2"
     trt_name_3 = "&trt_name_3";
* Qu - What is the purpose of the quotes around the macro value?;
* Qu - Could we use &=trt_code_1?;


/* To check value of macro variables */

%macro treatments_a; 
%do i = 1 %to &num_trts;
    %put trt_code_&i = "&&trt_code_&i"  
         trt_name_&i = "&&trt_name_&i" ; 
%end;
%mend;

%treatments_a


*  Qu - what is the purpose of the quotes in the put statement?;
*  Qu - Could we use &=trt_code_&i?;



/* Method 1b): %do macvar_i  */

/* Create macro variables containing treatment info */
proc sql ;
  select distinct trtcd, trtgrp
  into :trt_code_1-,
       :trt_name_1-
  from train.demo 
  where pnitt='Y';
  %let num_trts = &sqlobs;
quit;
*%put trt_code_1 = "&trt_code_1" 
     trt_code_2 = "&trt_code_2"
     trt_code_3 = "&trt_code_3" 
     trt_name_1 = "&trt_name_1"
     trt_name_2 = "&trt_name_2"
     trt_name_3 = "&trt_name_3";

%macro treatments_b;
%do i = 1 %to &num_trts;
    %put trt_code_&i = "&&trt_code_&i"  trt_name_&i = "&&trt_name_&i"; 
    Title "For &&trt_name_&i";
	proc means data = train.demo;
  		var age;
  		where trtgrp = "&&trt_name_&i";
	run;
%end;
%mend;

%treatments_b












/********************************************* Exercise 10 **************************************************************

Q1.  We want to create a dataset containing the average age for 
     each country:
 
     Country    Avg_age 
     Australia     x
     Belgium       x
       .... 

     In your solution, use a do loop that will run a proc means 
     (without the use of a class or by statement) for each value 
     of country, creating a separate dataset each time.   
     From this, create your final dataset above.

     Note: Do not use a class statement. 
          
************************************************************************************************************************/











/*************************************************************************************************************************
Demo 18 - Iterative processing Using %do %while or %until 
*************************************************************************************************************************/


%macro mac_until();

proc sql;
  select distinct trtgrp
  into :trt_list separated by '!'
  from pop_demo
  where pnitt = 'Y';
  %let num_trt = &sqlobs; 
quit;

%put &=trt_list &=num_trt;

%let i = 1;
%do %until (%scan(&trt_list, &i, !) eq   );
	    %let trt_name = %scan(&trt_list, &i, !);
		%put &=trt_name;
		proc means data = train.demo;
  			where trtgrp = "&trt_name";
  			var age;
		run;
	%let i = %eval(&i + 1);
%end;

%mend;
%mac_until()



%macro mac_while();

proc sql;
  select distinct trtgrp
  into :trt_list separated by '!'
  from pop_demo
  where pnitt = 'Y';
  %let num_trt = &sqlobs; 
quit;

%put &=trt_list &=num_trt;

%let i = 1;
%do %while (%scan(&trt_list, &i, !) ne   );
	    %let trt_name = %scan(&trt_list, &i, !);
		%put &=trt_name;
		proc means data = train.demo;
  			where trtgrp = "&trt_name";
  			var age;
		run;
	%let i = %eval(&i + 1);
%end;

%mend;
%mac_while()







**** QU - Anna, in 'real life', how do we know we need macro %do?***;

***STEP 1***;
*  Write code long hand:
   - realisation there's repetitive code
   - same proc means is executed three times, but for 
     different values of trtgrp;
Title "For Placebo";
proc means data = train.demo;
  var age;
  where trtgrp = "Placebo";
run;

Title "For 2mg RSG XR";
proc means data = train.demo;
  var age;
  where trtgrp = "2mg RSG XR";
run;

Title "For 8mg RSG XR";
proc means data = train.demo;
  var age;
  where trtgrp = "8mg RSG XR";
run;


***STEP 2***;
*  Avoiding repetitive code, options include:
    - data step do loops (won't work as data step only)
    - arrays (won't work as data step only)
    - macro variables/programs;

%macro m(trt=);
Title "For &trt";
proc means data = train.demo;
  var age;
  where trtgrp = "&trt";
run;
%mend m;

%m(trt=Placebo)
%m(trt=2mg RSG XR)
%m(trt=8mg RSG XR)


***STEP 3***;
*  Automating:
    - avoid errors (spelling wrong treatment group)
a) Create a series of macro variables and one loop per 
   treatment group (iterative %do)
b) Create a list of all treatments in one macro variable,
   use scan function to loop through each treatment group
   (iterative %do)
c) Create a list of all treatments in one macro variable,
   use scan function to loop through each treatment group
   (%do %while/%until);


*a) Create a series of macro variables and one loop per 
   treatment group (iterative %do) ;

%macro m_auto_a();

proc sql;
  select distinct trtgrp
  into: trt_1-
  from train.demo;
quit;
%let num_trt = &sqlobs;


%do i=1 %to &num_trt;

  Title "&trt_&i";
  proc means data = train.demo;
    var age;
    where trtgrp = "&trt_&i";
  run;

%end;

%mend m_auto_a;

%m_auto_a()


*b) Create a list of all treatments in one macro variable,
   use scan function to loop through each treatment group
   (iterative %do);

%macro m_auto_b();

proc sql;
  select distinct trtgrp
  into: trt_list separated by '!'
  from train.demo;
quit;
%let num_trt = &sqlobs;


%do i = 1 %to &num_trt;

  %let trt = %scan(&trt_list, &i, !);
  Title "&trt";
  proc means data = train.demo;
    var age;
    where trtgrp = "&trt";
  run;

%end;

%mend m_auto_b;

%m_auto_b()




*c) Create a list of all treatments in one macro variable,
   use scan function to loop through each treatment group
   (%do %while/%until);

%macro m_auto_c();

proc sql;
  select distinct trtgrp
  into: trt_list separated by '!'
  from train.demo;
quit;

%let i = 1;
%do %until(%scan(&trt_list, &i, !) eq );

  %let trt = %scan(&trt_list, &i, !);
  Title "&trt";
  proc means data = train.demo;
    var age;
    where trtgrp = "&trt";
  run;
  %let i = %eval(&i + 1);

%end;

%mend m_auto_c;

%m_auto_c()






/********************************************* Exercise 11 **************************************************************

Q1.  Create one macro variable that lists all countries.  Use this to create one dataset containing the
     average age for each country.  Ensure your final dataset contains a variable naming the country.

     Note: Do not use a class statement.
     Note: If using a %do %while/%until, the value of country = UK - CMD will cause problems due to the 
           meaning of the hyphen.  It can be resolved easily. 

          
************************************************************************************************************************/






/*************************************************************************************************************************
Demo 19 - Global vs Local Symbol Tables (SELF STUDY)

- Macro variables are stored in either the Global or Local symbol tables

- Macro variable is stored in GLOBAL symbol table when created outside 
  of macro program using: 
          a) %let
          b) data step with call symput
          c) proc sql into:
          d) %global macvar1 macvar2 ....;

- Macro variable is stored in LOCAL symbol when created within a macro 
  programs using: 
          a) %let (macro execution)
          b) data step with call symput (macro execution)
          c) proc sql into: (macro execution)
          d) %local macvar1 macvar2 ....; (only used within a macro program)
          e) macro parameters (macro invocation)

- All local macro variables are only available during the macro execution and 
  are deleted after execution of the macro

- Local macro variables can only be referenced within the macro program

- A macro program contains the following: 

   %macro name();
      %let macvar = bob;
   %mend name;

- When %name() is called/executed the following questions are asked to 
  determine whether macvar is put in the global or local table:
   1)  Does macvar exist in local table?  
       - YES then update value of macvar in local table
       - NO then 2)
   2)  Does macvar exist in global table?   
       - YES then update value of macvar in global table
       - NO then create macvar in local table

- CAUTION: Macro collisions can occur if a macro program creates a macro variable 
 (using a %let, data step or proc sql) with the same name as a global macro variable

 
- When macvar is resolved the following questions are asked to 
  determine whether macvar is retrieved from the global or local table:
   1)  Does macvar exist in local table?  
       - YES then retrieve from local table
       - NO then 2)
   2)  Does macvar exist in global table?   
       - YES then retrieve from global table
       - NO then then warning to log 'Apparent symbolic reference not resolved'
 

*************************************************************************************************************************/


*  Why do I need to know this????;

%macro q2(pop=pnitt);

  proc sort data = train.pop
             out = pop_s;
    by trtgrp; 
  run;

  data _null_;
    set pop_s;
	by trtgrp;

    if first.trtgrp then &pop._N = 0;

	if &pop = 'Y' then &pop._N + 1;

	if last.trtgrp then
	     call symputx("trt_&pop._N_"!!put(trtcd, 1.), &pop._N);
  run;
  
  %put &&trt_&pop._N_1 &&trt_&pop._N_2 &&trt_&pop._N_3;
%mend q2;

%q2(pop=pnitt)
%q2(pop=pnsafe)

%put &&trt_&pop._N_1 &&trt_&pop._N_2 &&trt_&pop._N_3;
*  Qu - Why doesn't the %put recognise the macro variables?



*  Macro variables are stored in the local symbol table,
   therefore not available outside of the macro call.
   If global, they would have been available outside 
   the macro. ;





/*************************************************************************
Example 1 - referencing a global macro variable inside and outside a macro program 
***************************************************************************/

* QU - is macvar put in global or local symbol table? ;
%let mypop1 = PNITT;

* QU - Will the reference be resolved outside the macro program?;
proc means data = pop_demo;
    where &mypop1. = "Y";
    class trtgrp;
    var age;
	title "For &mypop1.";
run;

%put _local_;
%put _global_;



* QU - Will the reference be resolved inside the macro program?;
%macro example1;
proc means data = pop_demo;
    where &mypop1. = "Y";
    class trtgrp;
    var age;
	title "For &mypop1.";
run;
%put _local_;
%put _global_;
%mend;
%example1




* mypop1 stored in global;
* mypop1 retrieved from global during macro call/execution;
* mypop1 retrieved from global outside of macro call;


/*********************************************************************************
Example 2 - referencing a local macro variable inside and outside a macro program 
**********************************************************************************/

* QU - is macvar put in global or local symbol table? ;
%macro example2 ;
%let mypop2 = PNITT;
proc means data = pop_demo;
    where &mypop2. = "Y";
    class trtgrp;
    var age;
	title "For &mypop2.";
run;
%put _local_;
%put _global_;
%mend example2;
%example2


* QU - Will the reference be resolved outside the macro program?;
proc means data = pop_demo;
    where &mypop2. = "Y";
    class trtgrp;
    var age;
run;



* mypop2 stored in local;
* mypop2 retrieved from local during macro call/execution;
* mypop2 not resolved outside of macro call/execution;



/*******************************************************************************
Example 3 - referencing a local macro variable inside and outside a macro program  
*********************************************************************************/

* QU - is macvar put in global or local symbol table? ;
%macro example3(mypop3 = );
proc means data = pop_demo;
    where &mypop3. = "Y";
    class trtgrp;
    var age;
    title "For &mypop3.";
run;
%put _local_;
%put _global_;
%mend;
%example3(mypop3=PNITT)


* QU - Will the reference be resolved outside the macro program?;
proc means data = pop_demo;
    where &mypop3. = "Y";
    class trtgrp;
    var age;
	title "For &mypop3.";
run;


* mypop3 stored in local;
* mypop3 retrieved from local during macro call/execution;
* mypop3 not resolved outside of macro call/execution;




/**********************************************************************************************
Example 4 - creating a global version of your local macro variable to use outside a macro program
***********************************************************************************************/

* QU - is macvar put in global or local symbol table? ;
%macro example4(mypop4 = );
%global mypopglb;
%let mypopglb=&mypop4 ; 
proc means data = pop_demo;
    where &mypop4. = "Y";
    class trtgrp;
    var age;
	title "For &mypop4.";
run;
%put _local_;
%put _global_; 
%mend;
%example4(mypop4=PNITT)


* QU - Will the reference be resolved outside the macro program?;
proc means data = pop_demo;
    where &mypop4. = "Y";
    class trtgrp;
    var age;
	title "For &mypop4.";
run;


* QU - Will the reference be resolved outside the macro program?;
proc means data = pop_demo;
    where &mypopglb. = "Y";
    class trtgrp;
    var age;
	title "For &mypopglb.";
run;



* mypop4 stored in local;
* mypopglb stored in global (same value as mypop4);
* mypop4 retrieved from local during macro call/execution;
* mypop4 not resolved outside of macro call/execution;




/**********************************************************************************************
Example 5 - Same macvar in global and local symbol table ....macro collision?
***********************************************************************************************/


* QU - is macvar put in global or local symbol table? ;
%let mypop5 = PNITT;
%macro example5;
%let mypop5 = PNSAFE;
proc means data = pop_demo;
    where &mypop5. = "Y";
    class trtgrp;
    var age;
    title "For &mypop5.";
run;
%put _local_;
%put _global_;
%mend example5;
%example5

proc means data = pop_demo;
    where &mypop5. = "Y";
    class trtgrp;
    var age;
    title "For &mypop5.";
run;


* mypop5 stored in global (PNSAFE);
* mypop5 retrieved from global during macro call/execution (PNSAFE);
* mypop5 retrieved from global outside of macro call/execution (PNSAFE);



/*************************************************************************************
Explanation:
 - During macro invocation, the macro parameters will be stored as local macro varable
 - For example5 there are no parameters, therefore no local symbol table exists at invocation
 - During macro execution, the %let mypop5 = PNSAFE is executed and SAS 
   decides to put mypop5 in either the global or local symbol table using: 

   1)  Does mypop5 exist in local table?  
       - YES then update value of macvar in local table  !FALSE!
       - NO then 2)  !TRUE!
   2)  Does macvar exist in global table?   
       - YES then update value of macvar in global table !TRUE!
       - NO then create macvar in local table;  !FALSE!

 - We get a global version of mypop5 and no local version of mypop5
***********************************************************************************/


 


/**********************************************************************************************
Example 6 - Same macvar in global and local symbol table ....macro collision?
***********************************************************************************************/


* QU - is macvar put in global or local symbol table? ;
%let mypop6 = PNITT;
%macro example6(mypop6 =);
proc means data = pop_demo;
    where &mypop6. = "Y";
    class trtgrp;
    var age;
    title "For &mypop6.";
run;
%put _local_;
%put _global_;
%mend example6;

%example6(mypop6 = PNSAFE)


proc means data = pop_demo;
    where &mypop6. = "Y";
    class trtgrp;
    var age;
    title "For &mypop6.";
run;

%put _user_;



* mypop6 stored in global (PNITT) and local ;
* mypop6 retrieved from local during macro call/execution (PNSAFE);
* mypop6 retrieved from global outside of macro call/execution (PNITT);


 

/*************************************************************************************
Explanation:
 - During macro invocation, the macro parameters will be stored as local macro varable
 - For example6, mypop6 is stored in the local symbol table at invocation
 - During macro execution, mypop6 = PNSAFE (local tables are deleted after execution)
 - We get a global version of mypop6 = PNITT and local version of mypop6 = PNSAFE 
   (only availabe during the macro execution)
***********************************************************************************/





/*************************************************************************************************************************
Demo 20 - Call Execute (SELF STUDY)

- See paper Call Execute: Let Your Program Run Your Macro, Artur Usov
- Allows you to execute SAS code generated by the data step 
- Very useful when the a variable contains the values of the macro parameters
*************************************************************************************************************************/


%macro freq_trt_sex(pop = ) ;

title "For &pop";
proc freq data=pop_demo;
  tables trtcd * sex;
  where &pop = 1;
run;
title ;

%mend freq_trt_sex;


*  Create a dataset containing a variable that holds the values I
   am using to call a macro with.;
data allpop (keep = name);
  set sashelp.vcolumn;
  where libname = 'TRAIN' and
        memname = 'POP' and 
	    upcase(type)    = 'NUM'  and
        upcase(label) contains 'POPULATION' and 
        name like 'PN%CD';
run;


*  Call execute writes and submits code to the SAS compiler;
data _null_;
  set allpop;
  call execute(  
                '%freq_trt_sex(pop=' !! strip(name) !!  ')'   
               );
run;








/******************************************************************
Demo 21 - Deleting GLOBAL Macro Variables (SELF STUDY)

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



/*******************************************************************
- Two datasets contain a list of macro variables:

    1).  dictionary.macros accessed via PROC SQL
    2).  sashelp.vmacro accessed via data step 

- The scope variable indicates whether the macro variable is 
  global or automatic

- Some global macro variables are created when certain proc's are used, these
  and we do not want to delete these.  These variables start 
  with ‘SYS’, ‘SQL’, ‘AF’, ‘FS’

*******************************************************************/


/************************* Method 1 ***********************************/

%let test=Anna;
%let test1=Anna1;


* Following code writes the variable attributes to the log ;
proc sql;
  describe table dictionary.columns;
quit;
proc sql;
  describe table dictionary.macros;
quit;


proc sql;
  select name 
  into: macvar_global separated by ' '
  from Dictionary.Macros
  where  upcase(scope) eq 'GLOBAL' 
         and upcase(name) not like 'SYS%' 
         and upcase(name) not like 'SQL%' 
         and upcase(name) not like 'AF%' 
         and upcase(name) not like 'FSBP%';
quit;

* Check value of macvar_global;
%put &=macvar_global;

* Delete all global macro variables;
%symdel &macvar_global ;

* Check all use defined global variables were deleted;
%put _global_;







/************************* Method 2 ***********************************/

%let test=Anna;
%let test1=Anna1;

data mymacvar2  (keep = name scope value);
  set sashelp.vmacro ;
  where upcase(scope) eq 'GLOBAL' 
         and upcase(name) not like 'SYS%' 
         and upcase(name) not like 'SQL%' 
         and upcase(name) not like 'AF%' 
         and upcase(name) not like 'FSBP%';
run ;

* Delete all global macro variables;
data _null_ ;
  set mymacvars2 ;
  call Symdel(name) ;
run ;

* Check all use defined global variables were deleted;
%put _global_;





/************************* Method 3 ***********************************/
%let test=Anna;
%let test1=Anna1;

data mymacvars3;
  set sashelp.vmacro;
  where  upcase(scope) eq 'GLOBAL' 
         and upcase(name) not like 'SYS%' 
         and upcase(name) not like 'SQL%' 
         and upcase(name) not like 'AF%' 
         and upcase(name) not like 'FSBP%';
 run;

data _null_;
  set mymacvars3;
  call execute('%symdel '||trim(left(name))||';');
run;


* Check all use defined global variables were deleted;
%put _global_;






 
/************************* Method 4 ***********************************/

%let test=Anna;
%let test1=Anna1;

data _null_;
  set sashelp.vmacro;
  where upcase(scope) eq 'GLOBAL' 
         and upcase(name) not like 'SYS%' 
         and upcase(name) not like 'SQL%' 
         and upcase(name) not like 'AF%' 
         and upcase(name) not like 'FSBP%';
  call symput (name,' ');
run;

%put _global_;

* Not as good as Method 1, 2 or 3 as it only sets the values of GLOBAL macro 
  variables to missing; 









/******************************************************************
Demo 22 - Deleting/over writing Macro Programs/Definitions (SELF STUDY)

- You cannot remove a macro from your work library, but it is 
  possible to recreate or over write it to avoid confusion
- Use dataset dictionary.catalogs to over write macros

*******************************************************************/

* Create dataset containg macro programs;
proc sql;
   create table macprogs as
   select objname
   from dictionary.catalogs
   where libname = 'WORK' and objtype = 'MACRO';
quit;


* If there are any macros in the work library, you can overwrite
  the macro by;
data _null_;
  set macprogs;
  call execute( ' %macro '||strip(objname) 
                          ||'; %put macro '
                          || strip(objname) 
                          ||' in work has been over written; %mend ; ' );
run;

* The %put executes and the following is written to the log:
'macro BOB in work has been over written';

%bob(var   = Age     ,
     label = Age (yrs))
