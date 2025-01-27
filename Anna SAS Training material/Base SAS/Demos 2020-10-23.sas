/**************************************************************************************************************************
|
| Program Name:     Demos 2020-10-23.sas
|
| Program Version:  1
|
| MDP/Protocol ID:  
|
| Program Purpose:  Training
|
| SAS Version:      9.4
|
| Created By:       Anna Cargill
| Date:             23/10/2020
|
|***************************************************************************************************************************
|
| Modified By:          
| Date of Modification:  
| Modification ID:
| Reason For Modification:
|
*****************************************************************************************************************************/

/* The following code will be described later in the course  */
libname train '\\pharoah\Shared Folders\Training Area\Trial 1\Data' access=readonly;
libname train2 '\\pharoah\Shared Folders\Training Area\Phastar data';
*libname exam 'C:\Data for computers\Data\Phastar\exam.xls';
option fmtsearch = (train2 train work) ;


/* This is a comment */
* This is another comment;
/*********************************
     How do I comment this?
*********************************/





/******************************************************************************************************************************
*******************************************************************************************************************************
**********************************                   CHAPTER 1               **************************************************

- Introduction to steps (data or proc) and statements
- Step boundaries 
- Diagnosing errors in your code 

*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/




/******************************************************************************************************************************

STEPS (DATA and PROC)

- Steps begin with either a Data or Proc statement
- Steps end with either a run or quit statement
- Steps are made up of a number of statements, where each statement carries a different instruction
- Every statement ends with a semi-colon  
- Data steps create SAS datasets
- Procs generally generate a report 	



PROCS 

Each proc will generate a different type of report:
Proc print              - prints your data
Proc univariate         - provides summary statistics and graphs (when requested)
Proc means/summary      - provides summary statistics

Many additional statements and options are available to customise your report/output.  
See SAS help or SAS on-line documentation.



COMMENTS

The following will assume text is a comment (as opposed to code):
a.  /*text * forward slash /  with any number of *
b.  * text ;
 
Short cut keys to achieve comments:
-  to comment text, highlight text + CTRL + /  
-  to uncomment text, highlight comment  +SHFT + CTRL + /    


ERRORS

a. Syntax error
- Red code
- Log usually shows accepted code

b. Data error
- Log will indicate the problem with the data ie. expecting a numeric variable but encounters a character variable
- May be incorrect code or a problem with the data

c. Unbalanced quotes
- Quotes come in pairs (single or double are accepted but have to match) and text within quotes are highlighted purple (windows only)
- Unbalanced quotes can be detected by looking at the colour of your code 
- If you submit the code with unbalanced quotes you need to cancel your submitted statements by clicking on the ! icon on your toolbar


FUNCTION KEYS (Tools - Options - Keys)
You can customise your function keys, I generally modify:
- F8  submit;
- F12 clear log; clear output;


SASHELP

The sashelp library contains many datasets for you to use.  The SAS help and and 
on-line documentation will use these datasets to demonstrate the use of the code.  


*********************************************************************************************************************************/




/***************************************************PROC PRINT ******************************************************************/

/*This prints your class dataset stored in the sashelp library */
proc print data = sashelp.class;
run;






/***************************************************PROC MEANS ******************************************************************/


/*This gives me default summary stats for age*/
proc means data = sashelp.class ;
  var age;
run;


/*This gives me default summary stats for age, by sex*/
proc means data = sashelp.class ; 
  class sex;
  var age;
run;




/*This gives me specified (95% confidence intervals and skewness) summary stats for age, by sex*/
proc means data = sashelp.class clm skewness mean stddev ;
  class sex;
  var age;
run;




/*Additional variables can be listed on both the class and the var statement */
proc means data = sashelp.class clm skewness;
  class sex;
  var age height;
run;




/***************************************************PROC UNIVARIATE******************************************************************/


/*This provides default summary stats for age weight and height*/
proc univariate data = sashelp.class ;
  var age weight height;
run;



/*In addition, the histogram and probplot statements provide a histogram for age and a normal probability plot
  for each variable listed on the var statement. The normal option on the histogram statement superimposes a 
  perfectly normal distribution over your histogram.  The midpoints option specifies the midpoints for each bar. */
proc univariate data = sashelp.class ;
  var age weight height;
  histogram age / normal midpoints = 10 to 16 by 1;
  probplot;
run;










/***************************************************PROC FREQ******************************************************************/


/*This provides frequencies and percents */
proc freq data = sashelp.class ;
  tables age sex height;
run;


/*This provides frequencies and percents as a two way frequency */
proc freq data = sashelp.class ;
  tables age * sex ;
run;







/******************************************************************************************************************************

DATA STEPS

- Data steps create SAS datasets from either a raw data file (infile and input statement required) or SAS dataset (set statement is required)
- Data statement assigns a name and location to the SAS dataset being created (the output dataset)
- Set statement specifies the name and location of the SAS dataset being read in (the input dataset)
- Assignments statements are used to create new variables i.e newvar = oldvar + 1;


DATASET AND VARIABLE NAMING CONVENTIONS

- Must begin with a letter or an underscore "_"
- Subsequent characters can be a mix of letters, underscores "_" or numbers (no blanks or special characters)
- 32 or less characters
- Case is irrelevant i.e ANNA = aNnA = anna = Anna

*********************************************************************************************************************************/


/* The dataset Work.new_data will be an exact copy of sashelp.class but it is stored in a different library and called a different name */
data work.new_data;
  set sashelp.class;
run;


/* An additional variable is added as all children are one year older */
data work.new_data;
  set sashelp.class;
  new_age = age + 1;
run;









/******************************************************************************************************************************

LIBRARIES

- Specify the location of datasets in a simpler and shorter way
- A library or libref is an alias for the location of where your datasets are stored 
- For instance, if my SAS datasets are stored in "C:/my projects/CZD396/....../my data" we can assign the library BOB to that location
- A libname statement assigns the library ie.  Libname BOB "C:/my projects/CZD396/....../my data";
- Closing down your SAS session de-assigns the library, therefore you must re-run your libname statement at the beginning of a new SAS session
- Libname statement is generally found at the top of your code as it's logically submitted prior to any other code  


LIBRARY/LIBREF NAMING CONVENTIONS

- Must begin with a letter or an underscore "_"
- Subsequent characters can be a mix of letters, underscores "_" or numbers (no blanks or special characters)
- 8 or less characters
- Case is irrelevant i.e ANNA = aNnA = anna = Anna

PERMANENT vs TEMPORARY LIBRARY

- Work is your only temporary library, all other libraries are permanent
- When SAS is closed down, all datasets in your work library will be deleted
- Only you can access your work library
- Permanent libraries (any you have created using a libname statement) will permanently store the data you put there
- Dataset are referenced by libref.dataset, if you fail to put the libref then SAS will assume the work library

*********************************************************************************************************************************/


libname train2 "\\pharoah\Shared Folders\Training Area\Phastar data " 
  access=readonly;



/* The dataset Work.exam_total will be an exact copy of train2.exam but it is stored in a different library and called a different name */
data work.exam_total;
  set train2.exam;
run;




/*The five assignment statements will create five new variables; 
  Total1, Total2, Total3, total4 and Total5 */

data work.exam_total;
  set train2.exam;
  total1 = test1 + test2 + test3 + test4;
  total2 = sum(test1, test2, test3, test4);
  total3 = sum(of test1-test4);
  total4 = sum(of test:);
  total5 = sum(test1-test4); 
run;






/******************************************************************************************************************************
***********************************************Exercises A*********************************************************************


Qu.1.  Create a read only library that points to your c drive.

Qu.2.  Create a read only library that points to the location of the clinical 
       trial data (stored in the folder called Data, in Trial 1 folder in the
       Training Area on P the drive) .

Qu.3.  Using the dataset called exam (stored in the train2 library), create a report that shows average of each of the four test scores.

Qu.4.  Create a new dataset from exam which includes an additional variable containing the average test score for each person (over the 
       four tests).  Use two different methods and describe the differences. 


***********************************************Solutions***********************************************************************




*********************************************************************************************************************************
*********************************************************************************************************************************/
























/******************************************************************************************************************************
*******************************************************************************************************************************
***************************************          CHAPTER 2               ******************************************************
- Data step processing i.e understanding the behind the scenes of a data step 
- Attributes of variables
- Dealing with dates
- Introduction to formats
- Missing values

*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/



/*Demonstrating the importance of data step processing*/

data work.exam_total;
  set train2.exam;
  total1 = sum(test1, test2, test3, test4);
run;







data work.exam_tot;
  total1 = sum(test1, test2, test3, test4);
  set train2.exam;
run;






/******************************************************************************************************************************

DATA STEP PROCESSING

When a data step is submitted, behind the scenes it goes through
1). Compilation (builds the descriptor portion of the data)
2). Execution (builds the data portion of the data)

COMPILATION 
a. Reads the code top to bottom looking for synatax errors
b. In the PDV (area of memory), the three important attributes to each variable (name, type, length) are set in the order in which they 
   are encountered in the code.  ONCE AN ARRIBUTE IS SET IT CANNOT BE CHANGED! 


EXECUTION 
a. At the data statement all variables in the PDV are assigned missing values (character variables to a blank, numeric variables to a .) 
b. At the set statement, the first observation from the input dataset is loaded to the PDV
c. Executes all other statements in the code
d. At the run statement, two things occur
               - output contents of PDV to new dataset
               - return to the top of the datastep code
e. At the data statement, missing values are assigned to all variables that weren't read from a SAS dataset i.e all variables created in the code
f. At the set statement, the next observation from the input dataset is loaded to the PDV
g. Continues in a loop from c to f until all observations are read from the input dataset 

See example on the whiteborad!


VARIABLE ATTRIBUTES
1. Name of the variable
2. Type - character or numeric
3. Length - numerics are 8 bytes, characters can be 1 to 32767 bytes (1 byte per character)


DATES

- Stored as a number i.e numeric variable 
- Number refers to the number of days since the 1st Jan 1960 (not sure why?)
- Formats can be used to change the way the dates are displayed in the dataset and in reports (using a format statement)



*********************************************************************************************************************************/




/* The following shows the use of the mdy function and the SAS date contant to create a date */
data work.anna;
    DOB = 7037;
    DOB1 = '08APR79'd; 
    DOB2 = "08APR1979"d;
    DOB3 = mdy(4,8,79);	
    DOB4 = mdy(4,8,1979);
    format DOB1 ddmmyyp10.
	       DOB2 ddmmyy4.
	       DOB3 date9.
	       DOB4 weekdate30.;  
run;


/* How does SAS know that '08APR79'd is 1979, not 1879 or 2079? */
options yearcutoff = 1900;













/******************************************************************************************************************************
***********************************************Exercises B***********************************************************************


Qu.1.  Using a data step, calculate how many days you have been alive.  

Qu.2.  Using a function (see documentation), determine/clarify what day of the week you were born.

***********************************************Solutions***********************************************************************




*********************************************************************************************************************************
*********************************************************************************************************************************/








/******************************************************************************************************************************

PROC CONTENTS
- Prints a report of the descriptor portion of the data displaying the important attributes to each variable, including formats and labels

INTERACTIVELY VIEWING DESCRIPTOR PORTION OF THE DATA
RMB on the dataset in the explorer window - Properties - Columns


FORMATS

- Change the way the data values are displayed
- The stored value is unchanged
- Most dates will have a format applied so check the descriptor portion of the data (using proc contents or interactively)
- Format statements apply formats to variables
- Format statements can be applied in proc's and data steps
- SAS has many formats built in ie. for dates but you may need to create your own format using PROC FORMAT


PROC FORMAT
- Creates user defined formats
- lib = specifies what library to store your created format (if you don't specift lib = then SAS assumes work)
- fmtlib produces a report of all formats in the location lib = (if you don't specift lib = then SAS assumes work)
- value statement specfies the name of the created format ($ required for formats applied to character variables, no $ if applied to numeric variables)
- keyword other is recommended for defensive programming

*********************************************************************************************************************************/


/*  What variables have formats applied? */
/*  Prints the descriptor portion of the demo dataset to see variable
    attributes, including formats etc. */
proc contents data = sashelp.class varnum;
run;




/*  Create your own formats as it doesn't exist within SAS*/
/*  Stored in work library */
proc format  ;
  value $sexfmt 'M'       = 'Male'
                'F'       = 'Female'
                 other    = 'ERROR'; 

  value age2fmt  low - 12   = 'Young'
                 12 <- high = 'Old'
                 other      = 'What have you done?';  
   
run;


/*Apply formats to variables in a dataset*/
data work.class;
  set sashelp.class;
  format sex $sexfmt.
         age age2fmt.;
run;



/*  Recall the library (previously readonly but require write access
    for the following code) */
libname train2 "\\pharoah\Shared Folders\Training Area\Phastar data ";

/*  Store new formats in a shared location (formats have a 
    different name to illustrate)*/
proc format lib = train2 ;
  value $sfmt 'M'       = 'Male'
              'F'       = 'Female'
               other    = 'ERROR'; 
  value a2fmt  low - 12   = 'Young'
               12 <- high = 'Old'
               other      = 'What have you done?';  
run;
* Note:  Although a missing value is considered smaller than any other 
         numeric value in comparisons, it is not included in a range 
         that starts with low. That only covers non-missing values. ;



/*Apply formats to variables in a dataset*/
data work.class;
  set sashelp.class;
  format sex $sfmt.
         age a2fmt.;
run;
*ERROR - cannot find formats;


options fmtsearch = (work train2 );

*  Account for missing values ;
proc format lib = train2 ;
  value $sfmt 'M'       = 'Male'
              'F'       = 'Female'
               other    = 'Missing or ERROR'; 
  value a2fmt  . , low - 12   = 'Missing or Young'
               12 <- high     = 'Old'
               other          = 'What have you done?';  
run;

data test;
  age = .;
  sex = '';
  format sex $sfmt.
         age a2fmt.;
run;



/*What formats are available in train2?*/
proc format lib = train2 fmtlib ;
run;



/* Question - Can I only apply a format statement in a data step,
              not a proc?*/

/* Question - If I have the format age2fmt stored in work and train2,
              with different definitions, which one will be used?*/ 




/* Delete formats from a particular library to avoid confusion */

proc datasets nolist lib=work
  memtype=catalog;
  delete formats; 
quit ; 











/******************************************************************************************************************************
***********************************************Exercises C***********************************************************************


Qu.1.  Sashelp.class has height in inches and weight in lbs.  Convert to m's and kg's respectively and calculate each students BMI.  

Qu.2.  What is the average BMI for the boys and girls separately?

Qu.3.  Apply a format to BMI which shows as 'High' if BMI greater than 20, 'Low' if less than 15 and 'Normal' otherwise.

proc format  ;
  value trtfmt. '1'       = 'Treatment A';
                '2'       = 'Treatment B';
                 other    = 'No treatment'; 
  value age2.   low - 18  = 'Too Young';
                19 <- 70  = 'Fine';
                other     = 'Elderly';  
   
run;

proc freq data = train.adsl;
  tables age * trtcd / missing;
run;

Note: By default, PROC FREQ does not consider missing values while 
      calculating percent and cumulative percent. Missing option will 
      include missing values in the frequency report. 

***********************************************Solutions***********************************************************************






*********************************************************************************************************************************
*********************************************************************************************************************************/






























/******************************************************************************************************************************
*******************************************************************************************************************************
**********************************                   CHAPTER 3               **************************************************
- Selecting variables/columns in a data/proc step
- Selecting observations/rows in a data/proc step


*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/





/******************************************************************************************************************************

SELECTING VARIABLES
 
- Data step can use either:
            A) DROP/KEEP statements 
            B) DROP=/KEEP= dataset options on input dataset
            C) DROP=/KEEP= dataset options on output dataset

- DROP=/KEEP= dataset options on the input dataset filter variables BEFORE the PDV i.e only read in variables that meet the criteria)
- DROP=/KEEP= dataset options on the output dataset filter variables AFTER the PDV i.e all variables are read into the PDV, only some are read out)
- DROP/KEEP statements filter variables AFTER the PDV i.e all variables are read into the PDV, only some are read out)
- Each proc is different i.e var, tables, column etc

*********************************************************************************************************************************/



/*A - drop statement */
data work.pass1;
  set train2.exam;

  drop test1 test2 test3 test4;
  *drop test1-test4;
  *drop test1--test4;
  *drop test:;

  mean2 = mean(test1, test2, test3, test4);
  mean1 = (test1 + test2 + test3 + test4)/4;
run;


/*B - drop = dataset options on input dataset*/
data work.pass3 ;
  set train2.exam(drop = test1 test2 test3 test4);
  mean2 = mean(test1, test2, test3, test4);
  mean1 = (test1 + test2 + test3 + test4)/4;
run;









/*C - drop = dataset options on output dataset*/
data work.pass2 (drop = test1 test2 test3 test4);
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  mean1 = (test1 + test2 + test3 + test4)/4;
run;



/* Combination of the B) and C) methods */
data work.pass2 (drop = test1 test2 test3 test4);
  set train2.exam (drop = lname);
  mean2 = mean(test1, test2, test3, test4);
  mean1 = (test1 + test2 + test3 + test4)/4;
run;


/* Combination of the A) and B) methods */
data work.pass2 ;
  set train2.exam (drop = lname);
  drop test1 test2 test3 test4;
  mean2 = mean(test1, test2, test3, test4);
  mean1 = (test1 + test2 + test3 + test4)/4;
run;




/*******************************************************************************************************************************

SELECTING OBSERVATIONS

- Data step can use IF or a WHERE statement, proc step can use a WHERE only
- WHERE statement is more efficient (use it when you can) as it filters observations BEFORE the PDV i.e only reads observations in if criteria met 
- If statement filters AFTER PDV i.e all observations read into PDV but only some read out 
- WHERE can only be used on variables that exist in the input SAS dataset

MANIPULATING OPERATORS:
*		      Multiply
/		      Divide
+		      Plus
-		      Minus
**	          To the power
!! or ||	  Concatenation


COMPARISON OPERATORS
GT, >		          Greater than
GE, >=		          Greater than or equal to
LT, <		          Less than
LE, <=		          Less than or equal to
EQ, =		          Equals
NE, ^=		          Not equals
IN (val1, val2)	      In a set of values
NOT IN (val1, val2)   Not present in a set of values


LOGICAL OPERATORS
AND   &
OR    |
NOT   ¬
*********************************************************************************************************************************/


data work.pass4 (drop = test1 test2 test3 test4);
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  mean1 = (test1 + test2 + test3 + test4)/4;
  where mean1>5; /* ERROR!!! */
run;


data work.pass4 (drop = test1 test2 test3 test4);
  set train2.exam ;
  mean2 = mean(test1, test2, test3, test4);
  mean1 = (test1 + test2 + test3 + test4)/4;
  if mean1>5; /* YAY */
run;


/* Modify position of the IF */
data work.pass5 (drop = test1 test2 test3 test4);
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  if mean1>5; 
  mean1 = (test1 + test2 + test3 + test4)/4;
run;



/* < instead of > */
data work.pass5a (drop = test1 test2 test3 test4);
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  if mean1<5; 
  mean1 = (test1 + test2 + test3 + test4)/4;
run;





/* Can we make a WHERE work? */
data work.pass6 (drop = test1 test2 test3 test4);
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  mean1 = (test1 + test2 + test3 + test4)/4;
  where ((test1 + test2 + test3 + test4)/4) >5; 
run;





/* Modify position of the WHERE */
data work.pass6a (drop = test1 test2 test3 test4);
  set train2.exam;
  where ((test1 + test2 + test3 + test4)/4) >5; 
  mean2 = mean(test1, test2, test3, test4);
  mean1 = (test1 + test2 + test3 + test4)/4;
run;


/* drop = test1 -- test4 */
/* drop = test1 - test4 */


/* Multiple conditions */
data work.pass7 ;
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  if test1 ne . and mean2 > 5 ; 
run;






/* Multiple IF statements? */
data work.pass7a ;
  set train2.exam;
  if test1 ne . ;
  mean2 = mean(test1, test2, test3, test4);
  if mean2 > 5 ; 
run;





/* Combination of IF and WHERE? */
data work.pass8 ;
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  where test1 ne . ; /* where test1 is not missing/null; */
  if mean2 > 5 ;     /* if mean1 gt 5; */
run;


/* Multiple WHERE statements? */
data work.pass8a;
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  where test1 ne . ; /* where test1 is not missing/null; */
  where test2 ne . ;     
run;


* Note: https://www.pharmasug.org/proceedings/2016/TT/PharmaSUG-2016-TT06.pdf 
  compares the differences between missing(), nmiss() and cmiss().  All work on
  if or where statement:
  -> missing(var): single parameter only, 
                   missing numeric/char variable returns 1
  -> nmiss(var1, var2,..): single or multiple NUMERIC parameters
                           missing numeric variable returns 1
                           multiple parameters returns the sum i.e num of missing numerics
  -> cmiss(var1, var2,..): single or multiple NUMERIC/CHAR parameters
                           missing numeric/char variable returns 1
                           multiple parameters returns the sum i.e num of missing ;

data work.pass8a;
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  where cmiss(test1, test2, test3, test4) = 0; *cmiss sums the number of missing;
run;




/* IF/WHERE on CHARACTER variables? */
data work.genius ;
  set train2.exam;
  where lname = 'Cargill';
  *if lname = 'Cargill';
run;


/* WHERE more flexible - contains ?, between-and */
data work.genius2 ;
  set train2.exam;
  where lname contains 'Car' and test1 between 5 and 10;
run;


/* WHERE more flexible - like, between-and */
data work.genius2 ;
  set train2.exam;
  where lname like 'C%' and test1 between 5 and 10;
run;


/* WHERE= dataset option on input data */
data work.genius ;
  set train2.exam (where = (lname = 'Cargill'));
run;

/* WHERE= dataset option on output data */
data work.genius (where = (lname = 'Cargill'));
  set train2.exam ;
run;





/********************************************************************************************************************************
***********************************************Exercises D***********************************************************************

Qu.1.  Create a dataset containing all patients from demo that were alive during WWII 
       (WWII started on 1-9-1939 and ended on 2-9-1945).  
       Keep only gender, USUBJID and make your code as efficient as possible. 

Qu.2.  Create a dataset that contains the people that share the same birthday as you.
       Hint: there are many date functions that extract information from a
       SAS date value ie. year(birthdt) will extract the year from the value 

Qu.3.  Create a new dataset from the ae dataset:
         - calculate the duration of each adverse event (don't use aedur) 
         - include only the non-ongoing events (AEONGO)
         - new dataset should contain variables usubjid, age, sex, duration of ae
         - keep only durations that were less than 2 days 
         - ensure your code is as efficient as possible
         - confirm you have 321 events

***********************************************Solutions***********************************************************************



*********************************************************************************************************************************
*********************************************************************************************************************************/













/*******************************************************************************************************************************
CONDITIONAL PROCESSING

*********************************************************************************************************************************/


data work.pass9 (drop = test1 test2 test3 test4);
  set train2.exam;

  mean2 = mean(test1, test2, test3, test4);

  if mean2 > 5 then result = 'PASS';
  else if mean2 <= 5 then result = 'LOSER';
  else result = 'What have I done?';

run;







data work.pass9 (drop = test1 test2 test3 test4);
  set train2.exam;

  mean2 = mean(test1, test2, test3, test4);

  if mean2 > 5 then result = 'PASS';
  else if mean2 <= 5 then result = 'LOSER';
  else result = 'What have I done?';

  length lname fname $ 40 
         result      $ 20 ;
run;









/* Test ordering of statements */
data work.pass9 (drop = test1 test2 test3 test4);
  length lname fname  $ 40 
               result $ 20 ;

  set train2.exam;

  mean2 = mean(test1, test2, test3, test4);

  if mean2 > 5 then result = 'PASS';
  else if mean2 <= 5 then result = 'LOSER';
  else result = 'What have I done?';
  
run;


/* Test missing 'else'  */
data work.pass9a (drop = test1 test2 test3 test4);
  length lname fname $ 40 
              result $ 20 ;
  set train2.exam;
  
  mean2 = mean(test1, test2, test3, test4);

  if mean2 > 5 then result = 'PASS';

  /* else*/ if mean2 <= 5 then result = 'LOSER';
  else result = 'What have I done?';
 
run;






/* Test missing 'else'  */
data work.pass9b (drop = test1 test2 test3 test4);
  length lname fname $ 40 result $ 20 ;
  set train2.exam;
  
  mean2 = mean(test1, test2, test3, test4);

  if mean2 > 5 then result = 'PASS';
  /*else*/ if  mean2 <= 5 then result = 'LOSER';
  /*else*/ result = 'What have I done?';
 
  
run;




/* Multiple if then else   */
data work.pass9c (drop = test1 test2 test3 test4);
  length lname fname $ 40 result $ 20 ;
  set train2.exam;
  
  mean2 = mean(test1, test2, test3, test4);

  if mean2 > 5 then result = 'PASS';
  else if mean2 <= 5 then result = 'LOSER';
  else result = 'What have I done?';

  if test1 ne . and test2 ne . and test3 ne . and test4 ne . then complete = 'Y';
  else complete = 'N';

run;




/* Multiple things to do based on on condition */
data work.pass10 (drop = test1 test2 test3 test4);
  length lname fname $ 40 
              result $ 20 ;
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  if mean2 => 5 then 
            do;
				result = 'PASS';
				action = 'Pay rise';
		    end;
  else if mean2 <= 5 then 
             do;
                result = 'LOSER';
				action = 'SACKED';
		     end;
  else do;
                 result = 'What have I done?';
				 action = 'RE-DO CODE!';
	   end;
run;



data work.sacked   
     work.payrise 
     work.aahhhhh;
  drop test1 test2 test3 test4;
  length lname fname $ 40 result $ 20 ;
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  if mean2 > 5 then 
            do;
				result = 'PASS';
				action = 'Pay rise';
				output payrise;
		    end;
  else if mean2 <= 5 then 
             do;
                result = 'LOSER';
				action = 'SACKED';
				output sacked;
		     end;
  else do;
                 result = 'What have I done?';
				 action = 'PARTY';
				 output aahhhhh;
	   end;

run;




/* What will this do? */
data work.sacked   
     work.payrise 
     work.aahhhhh;
  drop test1 test2 test3 test4;
  length lname fname $ 40 result $ 20 ;
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  if mean2 > 5 then 
            do;
				result = 'PASS';
				action = 'Pay rise';
				output payrise;
				output payrise;
		    end;
  else if mean2 <= 5 then 
             do;
                result = 'LOSER';
				action = 'SACKED';
				output sacked;
		     end;
  else do;
                 result = 'What have I done?';
				 action = 'PARTY';
				 output aahhhhh;
	   end;
  output;
run;





/***************DEFENSIVE PROGRAMMING******************/


/* Customise comment - What would happen to obs with mean2 = 4 or 5? */
data defensive;
  drop test1 test2 test3 test4;
  length lname fname $ 40 
              result $ 20 ;
  set train2.exam;

  mean2 = mean(test1, test2, test3, test4);

  if mean2 > 5 then result = 'PASS';
  else if mean2 < 4 then result = 'LOSER';	     
  else put "Check your conditional statements as" 
           "I don't fit into any condition " 
            lname= fname= mean2=;

run;



/* Print red error in code*/
data defensive;
  drop test1 test2 test3 test4;
  length lname fname $ 40 result $ 20 ;
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  if mean2 > 5 then result = 'PASS';
  else if mean2 < 4 then result = 'LOSER';	     
  else put "ERROR: Check your conditional statements as " 
           "I don't fit into any condition " 
            lname= fname= mean2=;

run;


/* Print green warning in code*/
data defensive;
  drop test1 test2 test3 test4;
  length lname fname $ 40 result $ 20 ;
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  if mean2 > 5 then result = 'PASS';
  else if mean2 < 4 then result = 'LOSER';	     
  else put "WARNING: Check your conditional statements as " 
           "I don't fit into any condition " 
            lname= fname= mean2=;

run;




/* When we search for the word warning in the log, we 
   don't want the syntax in the data step getting a hit*/
data defensive;
  drop test1 test2 test3 test4;
  length lname fname $ 40 result $ 20 ;
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  if mean2 > 5 then result = 'PASS';
  else if mean2 < 4 then result = 'LOSER';	     
  else put "WAR" "NING: Check your conditional statements as " 
           "I don't fit into any condition  "
            lname= fname= mean2=;

run;






/* Correction */
data defensive;
  drop test1 test2 test3 test4;
  length lname fname $ 40 result $ 20 ;
  set train2.exam;
  mean2 = mean(test1, test2, test3, test4);
  if mean2 => 5 then result = 'PASS';
  else if mean2 < 5 then result = 'LOSER';	     
  else put "WAR" "NING: Check your conditional statements as " 
           "I don't fit into any condition " 
            lname= fname= mean2=;

run;




/* in operator */
data in;
  set train2.exam (keep = fname);
  if fname in('Anna' , 'Wendy') then party = 'Y';
  else if fname not in('Anna' , 'Wendy') then party = 'N';  
  else put "WAR" "NING: Check your conditional statements as " 
           "I don't fit into any condition " 
            fname= ;

run;




/*******************************************************************************************************************************
CONTROLLING WHEN TO OUTPUT

*********************************************************************************************************************************/

/* What does this do?  */

data demo_tot;
  set train.demo;
  output;
  trtgrp = 'Total';
  output;
run;



proc means data = train.demo mean;
	class trtgrp;
	var age;
run;



proc means data = demo_tot mean;
	class trtgrp;
	var age;
run;







/*************************************ACTIVITY*****************************************************

Understanding the differences between if (subsetting if) and conditional if statements.

Investigate the differences (if any) in the output between the following data steps, A vs B and C vs D:

*Example A;
data A;
  set train.demo;
  if sex = 'F';
run;

*Example B;
data B;
  set train.demo;
  if sex = 'F' then output;
run;


*Example C;
data C;
  set train.demo;
  if sex = 'F';
  salary = 'High';
run;

*Example D;
data D;
  set train.demo;
  if sex = 'F' then output;
  salary = 'High';
run;

***************************************************************************************************/




/********************************************************************************************************************************
***********************************************Exercises E***********************************************************************

Qu.1.  In demo, create a flag (new variable) which says ALIVE or NOT ALIVE based on whether the patient was 
       alive during WWII.  If they were alive, create a variable which states their age when the war ended (if 
       they weren't alive leaving age when the war ended as missing). 
       Keep only the following variables in your new dataset: USUBJID, new flag and age when war ended.


Qu.2.  Use pop dataset to create five new datasets.  One dataset needs to contain patients 
       that are in the randomised population (contain only usubjid and randomised flag), 
       one dataset for the safety population (contain only usubjid and safety flag),
       one dataset for the ITT population (contain only usubjid and ITT flag) and one 
       dataset to contain the per protocol population (contain only usubjid and per 
       protocol flag).  Ensure if a patient isn't in any population, they get written to 
       a separate dataset (defensive programming) listing all population flags.  
        


Qu.3. Spot the errors in the following code.


data train2.sacked   
     train2.payrise;
  set train2.exam (drop = test1 test2 test3 test4);
  mean2 = mean(test1, test2, test3, test4);
  if mean2 > 5 then 
            do
				result = 'PASS'
				action = 'Pay rise'
				output payrise;

  if mean2 <= 5 then 
             do
                result = 'LOSER'
				action = 'SACKED'
				output sacked;

  else do
                 result = 'What have I done?'
				 action = 'PARTY
				 output aahhhhh;
   length lname fname $ 40 result $ 20 ;
run;


Qu.4. From the demo dataset, produce a report to show how many patients are in each treatment group (including the total)? 

Qu.5. Create two datasets from demo, where each dataset contains either  males or females.

Qu.6. Investigate the use of ifc and ifn in the SAS documentation.  


***********************************************Solutions***********************************************************************



*********************************************************************************************************************************
*********************************************************************************************************************************/






/******************************************************************************************************************************
*******************************************************************************************************************************
***********************************                   CHAPTER 4               **************************************************
- Sorting data
- Concatenating datasets
- Merging datasets


*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/


/****************************************************
            SORTING DATA
****************************************************/
proc sort data = train.demo
          out  = work.demo ;
  by usubjid;
run;

proc sort data = train.demo 
          out  = demo ;
  by descending usubjid ;
run;


/*proc sort data = train.demo;
  by usubjid;
run;*/


proc sort data = train.ae
          out  = ae ;
  by usubjid AESTDT;
run;


proc sort data = train.ae (keep=usubjid)
          out  = ae 
          nodupkey;
  by usubjid ;
run;



proc sort data = train.ae (keep=usubjid aestdt)
          out  = ae 
          nodupkey;
  by usubjid aestdt;
run;





/************************************************
       CONCATENATING DATASETS
************************************************/

/* Recall from last exercise */
data males    
     females  
     unknown  ;
  set train.demo (keep = usubjid birthdt sex);
  drop sex;

  if sex = 'M' then output males;
  else if sex = 'F' then output females;
  else output unknown;

run;


/* Append the datasets with the same variable names!*/
data full;
  set males    
      females 
      unknown  ;
run; 


/* Use dataset option IN= to preserve which dataset the observations were read from */
data full_gender;
  set males    (in = A)  
      females  (in = B) 
      unknown  (in = C) ;
  what_A = A;
  what_B = B;
  what_C = C;
run;



data full_gender;
  set males    (in = A)  
      females  (in = B) 
      unknown  (in = C) ;
  if A=1 then gender = 'Male            ';
  else if B then gender = 'Female';
  else if C then gender = 'Not really sure';
  else put 'My message';
run; 




/** DIFFERENT VARIABLE NAMES! **/

data males_1   (keep = usubjid rename = (usubjid = m_usubjid)) 
     females_1 (keep = usubjid rename = (usubjid = f_usubjid))
     unknown_1 (keep = usubjid rename = (usubjid = u_usubjid));
  set train.demo;
  if sex = 'M' then output males_1;
  else if sex = 'F' then output females_1;
  else output unknown_1;
run;




/* Append the datasets with different variable names!*/
data full_1;
  set males_1    
      females_1 
      unknown_1  ;
run; 



/* Use dataset option RENAME= to let SAS know which variables should be stacked */
data full_gender_1;
  set males_1    (rename = (m_usubjid = patient) in=A)  
      females_1  (rename = (f_usubjid = patient) in=B)   
      unknown_1  (rename = (u_usubjid = patient) in=C) ;
  if A then gender = 'Male               ';
  else if B then gender = 'Female';
  else if C then gender = 'Not really sure';
run; 



/****************************************************
            MERGING DATA
****************************************************/

data EXP;
  infile datalines dlm=',';
  input usubjid $ trt $;
  datalines;
1, A
7, B
2, A 
;
run;



data AE;
  infile datalines delimiter=',';
  input usubjid $ Num_AEs ;
  datalines;
1, 3
7, 1
;
run;


data AE_ERROR;
  infile datalines delimiter=',';
  input usubjid $ Num_AEs ;
  datalines;
1, 3
7, 1
8, 1
;
run;


data EXP_MANY;
input USUBJID $ TRT $ TRTSDT: ddmmyy10. TRTEDT: ddmmyy10. ;
format TRTSDT TRTEDT date9.;
datalines;
1 A 21-03-2012 27-03-2012 
1 B 28-03-2012 21-05-2012 
2 A 29-03-2012 10-04-2012 
2 B 11-04-2012 24-04-2012 
7 A 30-03-2012 17-04-2012 
7 B 18-04-2012 04-05-2012 
;
run;

data AE_MANY;
input usubjid $ AESEQ AEPT $ AESDT: ddmmyy10.  ;
format AESDT date9.;
datalines;
1 1 Fatigue 01-04-2012 
1 2 Nausea 16-05-2012 
1 3 Headache 20-05-2012 
7 1 Nausea 30-03-2012 
;
run;



/*******************************************************************************************************************************

1) ONE-TO-ONE MERGE

********************************************************************************************************************************/

proc sort data = exp
           out = exp_sort;
  by usubjid;
run;

proc sort data = ae
           out = ae_sort;
  by usubjid;
run;



/************************************
1a) ONE-TO-ONE MERGE
- include matches and non-matches
*************************************/

data one_to_one_1a;
  merge exp_sort  
        ae_sort ;
  by usubjid;
run;


/************************************
1b) ONE-TO-ONE MERGE
- include matches only
*************************************/
data one_to_one_1b;
  merge exp_sort  (in= A)
        ae_sort   (in= B);
  by usubjid;
  if A = 1 and B = 1; *if A and B;
run;





/*******************************************************************************************************************************

2) ONE-TO-MANY MERGE

********************************************************************************************************************************/
proc sort data = exp 
           out = exp_sort;
  by usubjid;
run;

proc sort data = ae_many 
           out = ae_many_sort;
  by usubjid;
run;


/************************************
2a) ONE-TO-MANY MERGE
- include matches and non-matches
*************************************/
data one_to_many_2a ;
  merge exp_sort       (in= A)
        ae_many_sort   (in= B);
  by usubjid;
run;



/************************************
2b) ONE-TO-MANY MERGE
- include matches only
*************************************/
data one_to_many_2b ;
  merge exp_sort       (in= A)
        ae_many_sort   (in= B);
  by usubjid;
  if A = 1 and B = 1; *if A and B;
run;





/*******************************************************************************************************************************

3) MANY-TO-MANY MERGE

********************************************************************************************************************************/

proc sort data = EXP_many  out = EXP_many_sort ;
  by usubjid; 
run;

proc sort data = AE_many out = AE_many_sort ;
  by usubjid; 
run;


/************************************
3a) MANY-TO-MANY MERGE
- include matches and non-matches
*************************************/
data many_to_many_3a;
  merge EXP_many_sort  (in= A)  
        AE_many_sort   (in= B);
  by usubjid;
run;


/************************************
3b) MANY-TO-MANY MERGE
- include matches and non-matches
*************************************/
data many_to_many_3a;
  merge EXP_many_sort  (in= A)  
        AE_many_sort   (in= B);
  by usubjid;
  if A = 1 and B = 1; *if A and B;
run;








/********************************************************************************************************************************
***********************************************Exercises F***********************************************************************

Qu.1. Concatenate/append the exam and new starters data. Create a new variable to preseve the information that describes 
      whether there are a new starter or not.

Qu.2. Merge demo and pop.  Create two datasets (in the same step): 
      - one containing patients in the ITT pop that appear in both demo and pop
      - the other to contain patients that are in one dataset but not the other (hopefully zero observations)

Qu.3. Merge demo and ae.  Keep only the patients that had an ae.  Ensure your programming is defensive i.e are there any patients in
      ae that aren't in demo.

Qu.4. As Qu 3 above but keep only the patients that had an ae and are in the safety pop. Ensure your programming is defensive i.e are 
      there any patients in ae that aren't in demo.  Your answer should require one data step.


***********************************************Solutions***********************************************************************






*********************************************************************************************************************************
*********************************************************************************************************************************/























/******************************************************************************************************************************
*******************************************************************************************************************************
**********************************                   CHAPTER 5               **************************************************

- Accumulating variables
- By group processing


*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/








/******************************************************************************************************************************

CALCULATING ACCUMULATING TOTALS

RETAIN STATEMENT i.e retain total 5;
- Specifies that a variable should not be set to missing across iterations of the data step code
- An initial value can also be set for the first interation of the data step code (if a value is not specified a value of . is assumed)

SUM STATEMENTS i.e newvar + expression;
- Create variable newvar
- Initial value of 0
- Ignores missing values i.e 4 + . = 4
- Adds the value of the expression to newvar
- Automatically retains newvar across loops of the data step code

*********************************************************************************************************************************/




/* Method 1 - Using data step to calculate a running_count to count the number of patients.  This doesn't work! Why? */
data count;
  set train.demo (keep = usubjid);
  running_count = running_count + 1;
run;



data count1;
  set train.demo (keep = usubjid);
  running_count = sum(running_count, 1);
run;


/* Method 2 - Using data step to calculate a running_count to count the number of patients.  This works! */
data count2;
  set train.demo (keep = usubjid);
  retain running_count 0;
  running_count = running_count + 1;
run;



/* Method 3 - Using data step to calculate a running_count to count the number of patients.  This works! */
data count3;
  set train.demo (keep = usubjid);
  running_count + 1; /* This is a sum statement */
run;




data count4 (keep = running_count);
  set train.demo (keep = usubjid ) end = last_row ;
  running_count + 1; /* This is a sum statement */
  if last_row = 1;
run;


/* What happens here when you reverse the order? */
data count4 (keep = running_count);
  set train.demo (keep = usubjid) end = last_row;
  if last_row = 1;
  running_count + 1; /* This is a sum statement */
run;




/********************************************************************************************************************************
***********************************************Exercises G***********************************************************************

Qu.1. Using the ae dataset, write some data step code with an accumulating 
      variable to calculate how many ae's were recorded. 
 

Qu.2. Modify the code above to determine how many patients experienced an ae. 


CHALLENGE:

Qu.3. Use only one data step to count the number of patients that experienced
      an ae.  Your data will need to be sorted 
      by usubjid, but do not use the nodupkey option.   
      HINT:  one solution could include the lag function (but not essential)  

***********************************************Solutions***********************************************************************




*********************************************************************************************************************************
*********************************************************************************************************************************/







/******************************************************************************************************************************
BY GROUP PROCESSING
- When a by statement is used in data step code, two new variables are automatically created in the PDV 
      1. first.byvar (if it's the first time the byvalue has been seen then first.byvar = 1, 0 otherwise)
      2. last.byvar  (if it's the last time the byvalue has been seen then last.byvar = 1, 0 otherwise)
- For example, by gender; creates first.gender and last.gender to be used for processing
- To use a by statement, your input data needs to be sorted on the by variable i.e gender in above example)

*********************************************************************************************************************************/




/* Demonstrating by group processing with accumulated variables 
   - create total score for each person
   - preserve whether they are new starters or not                 
   - calculate accumulated test scores for total */
/* Simply creating a dataset that I can demonstrate a by statement */
data everyone;
  length lname $ 20;
  set train2.exam      
      train2.newstarters ( in = A rename = (firstname = fname) ); 
  total = sum(of test1 - test4);
  New = A;
run;


/****** Building up your code, step by step ****/

/*Step 1 - calculate accum_total*/
data everyone1 (keep= new accum_total); 
  set everyone; 
  accum_total + total;
run;

/*Step 2 - set accum_total to 0 at the beginning of each group*/
data everyone1 (keep= new accum_total); 
  set everyone; 
  by new;
  if first.new then accum_total = 0;
  accum_total + total;
run;


/*Step 3 - only write an observation if it's the last observation in that group*/

data everyone1 (keep= new accum_total); /* we only want two variables */
  set everyone; 
  by new;
  if first.new then accum_total = 0;
  accum_total + total;
  if last.new; /* only output the PDV if it's on the last of a group */
run;


/* Is the order of the executable statements important?*/
data everyone1 (keep= new accum_total); 
  set everyone; 
  by new;
  accum_total + total;
  if first.new then accum_total = 0;
  if last.new; 
run;



/******* WHAT IF WE HAVE MULTIPLE GROUPS? ****************/

proc sort data = work.multiple_grps ;
  by trtgrp sex;
run;

data work.multiple_grps;
  set work.multiple_grps;
  by trtgrp sex;

  first_trtgrp = first.trtgrp;
  last_trtgrp = last.trtgrp;

  first_sex = first.sex;
  last_sex = last.sex;

run;




/********************************************************************************************************************************
***********************************************Exercises H***********************************************************************

Qu.1. Primarily using data step and sum statements, calculate the number of patients that experienced an ae for each treatment group.  

Qu.2. Accumulate age for each trtgrp, using demo dataset.  Output only one observation per treatment group, which 
      includes the final accumulated age.  
 
Qu.3. Calculate the number of adverse events per usubjid by calculating an accumulating total.  Write out one observation per subject.
      What was the maximum number of ae's experienced by a patient?

Qu.4. Using the vitals dataset, calculate the average weight across all visits, for each patient.  The new dataset needs to contain one 
      observation per patient.  If there are any missing weights, ensure the count is only for non-mising weights.  Variables to include 
      usubjid, number of weights taken, total weight and average weight. 

Qu.5. Using data step and the sum statement, calculate the mean age for each treatment group.  Ensure 
      your code accounts for any missing age values.
      HINT: You may find it easier to use your solution from Q2 and modify it.

Qu.6. Using data step, calculate the number of males and females in each treatment group.


***********************************************Solutions***********************************************************************


*********************************************************************************************************************************
*********************************************************************************************************************************/























/******************************************************************************************************************************
*******************************************************************************************************************************
**********************************                   CHAPTER 6               **************************************************
- Do Loops
- Arrays


*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/


/******************************************************************************************************************************
DO LOOPS

*********************************************************************************************************************************/


 
* Qu. How many iterations of the data step code are performed?
* Qu. For each iteration, how many times will it go through the do loop?; 
* Qu. How many variables and observations are in mydata?; 
* Qu. What are/is the values of the index variable?; 
data mydata;
   iteration = _N_; * Just demonstrating number of iterations through data step code; 
   do usubjid = 1 to 40 by 1;
     output;
   end;
run;


* Qu. How many iterations of the data step code are performed?
* Qu. For each iteration, how many times will it go through the do loop?; 
* Qu. How many variables and observations are in mydata1?; 
* Qu. What are/is the values of the index variable?; 
data mydata1;
   iteration = _N_; * Just demonstrating number of iterations through data step code; 
   do i = 1 to 40 by 10;
     output;
   end;
run;






* Qu. How many iterations of the data step code are performed?
* Qu. For each iteration, how many times will it go through the do loop?; 
* Qu. How many variables and observations are in mydata3?; 
* Qu. What are/is the values of the index variable?; 
data mydata3;
   set train.demo (keep = usubjid age) ;
   iteration = _N_; * Just demonstrating number of iterations through data step code; 
   do i = 1 to 10;
       newage = age + i; 
   end;
   output;
run;



* Qu. How many iterations of the data step code are performed?
* Qu. For each iteration, how many times will it go through the do loop?; 
* Qu. How many variables and observations are in mydata2?; 
* Qu. What are/is the values of the index variable?; 
data mydata2;
   set train.demo (keep = usubjid age) ;
   iteration = _N_; * Just demonstrating number of iterations through data step code; 
   do i = 0 to 10 by 2;
       newage = age + i;
	   output;
   end;
run;


* Qu. How many iterations of the data step code are performed?
* Qu. For each iteration, how many times will it go through the do loop?; 
* Qu. How many variables and observations are in mydata4?; 
* Qu. What are/is the values of the index variable?; 
data mydata4;
   set train.demo (keep = usubjid age) ;
   iteration = _N_; * Just demonstrating number of iterations through data step code; 
   do i = -11 to -10;
       newage = age + i;   
       output; 
   end;
run; * For a positive increment, start value must be the lower bound; 


* Qu. How many iterations of the data step code are performed?
* Qu. For each iteration, how many times will it go through the do loop?; 
* Qu. How many variables and observations are in mydata5?; 
* Qu. What are/is the values of the index variable?; 
data mydata5;
   set train.demo (keep = usubjid age) ;
   iteration = _N_; * Just demonstrating number of iterations through data step code; 
   do i = 1, 3, 2;
       newage = age + i;   
       output; 
   end;
run; 



* Qu. How many iterations of the data step code are performed?
* Qu. For each iteration, how many times will it go through the do loop?; 
* Qu. How many variables and observations are in mydata6?; 
* Qu. What are/is the values of the index variable?; 
data mydata6;
   iteration = _N_; * Just demonstrating number of iterations through data step code; 
   do name = 'Anna', 'Rose', 'George', 'Florence';
         fullname = name !! ' ' !! 'KEMP';   
         output; 
   end;
run; 



data mydata6_correction;
   length name $ 20;
   iteration = _N_; * Just demonstrating number of iterations through data step code; 
   do name = 'Anna', 'Rose', 'George', 'Florence';
         fullname = name !! ' ' !! 'KEMP';   
         output; 
   end;
run; 


data mydata6_correction;
   length name $ 20;
   iteration = _N_; * Just demonstrating number of iterations through data step code; 
   do name = 'Anna', 'Rose', 'George', 'Florence';
         fullname = trim(name) !! ' ' !! 'KEMP';   
         output; 
   end;
run; 


* Qu. How many iterations of the data step code are performed?
* Qu. For each iteration, how many times will it go through the do loop?; 
* Qu. How many variables and observations are in mydata7?; 
* Qu. What are/is the values of the index variable?; 
data mydata7;
   set train.demo (keep = usubjid country sex);
   iteration = _N_; * Just demonstrating number of iterations through data step code; 
   do i = country, sex ;
         newvar = i;   
         output; 
   end;
run; 





/* Question 1 - Compare 2.5% yearly interest to 0.8% monthly interest.  
   If I have £1000, which will make me richer after 12 months? */




data interest;
	yearly = 1000 * 1.025;
	monthly = 1000;
	monthly = monthly * 1.008;
	monthly = monthly * 1.008;
	monthly = monthly * 1.008;
	monthly = monthly * 1.008;
	monthly = monthly * 1.008;
	monthly = monthly * 1.008;
	monthly = monthly * 1.008;
	monthly = monthly * 1.008;
	monthly = monthly * 1.008;
	monthly = monthly * 1.008;
	monthly = monthly * 1.008;
	monthly = monthly * 1.008;
run;


data interest1;
	yearly = 1000 * 1.025;
	monthly = 1000;
	do month = 1 to 12 by 1;
		monthly = monthly * 1.008;
		output;
	end;
	*output;       /* Not necessary but just to show when month gets incremented */
run;


/* Question 2 - If I put £1000 in my bank with a 2.5% yearly interest, 
   how many years will it take to be a millionaire? */
data millionaire_while;
	money = 1000;
	do while (money<1000000);
	    year + 1;
		money + (money*0.025);
		output;
	end;
run;


data millionaire_until;
	money = 1000;
	do until (money=>1000000);
	    year + 1;
		money + (money*0.025);
		output;
	end;
run;






/* Question - How many variables and observations are in the following two data steps? */
data quiz_while;
  do while(n<3);
    output;
	n + 1;
  end;
run;

data quiz_until;
  do until(n<3);
    output;
	n + 1;
  end;
run;



/********************************************************************************************************************************
***********************************************Exercises I***********************************************************************

Qu.1. The demo data set contains one row per subject.  We want 1 row per subject per week for each of the 4 weeks of the trial.  
      Create a new variable called WEEK taking the values 1, 2, 3 or 4 (or Week 1, Week 2, Week 3 or Week 4).   
      Create the resulting dataset using do loops.  Keep only usubjid, trtgrp and week (new variable).  

Qu.2. What are the dates of every Friday for the following year (starting this Friday)? 
      Create a dataset containing one observation per Friday.

Qu.3. As question 2 but do not hard code the date of the first Friday of the month.
 
***********************************************Solutions***********************************************************************




*********************************************************************************************************************************
*********************************************************************************************************************************/







/******************************************************************************************************************************
ARRAYS

*********************************************************************************************************************************/


/* Introduction to arrays  */

data no_array;
	set train2.exam;
	
	result1 = (test1 => 5);
	result2 = (test2 => 5);
	result3 = (test3 => 5);
	result4 = (test4 => 5);
run;





data no_array;
	set train2.exam;
	do i = 1 to 4 by 1;
		resulti = (testi => 5);
    end;
run;


   

data this_is_my_array;
	set train2.exam;

	array exam{*} test1 - test4 ;
	array pass{4} result1 - result4 ;

	do i = 1 to 4;
	   pass{i} = (exam{i} => 5);
	   *put i= exam{i}=  pass{i}=;
	end;
run;




*  Include character array ;
data this_is_my_array;
	set train2.exam;
	
    array exam{*}  test1 - test4;
	array pass{4} result1 - result4;
    array party(4) $ 12 ;
	*array party(4) $ 12 party1 party2 party3 party4;

	do i = 1 to dim(exam);
	   pass{i} = (exam{i} => 5);

       if (exam{i} => 5) then party{i} = 'PARTY';
	   else if (exam{i} < 5) and exam{i} ne . then 
                            party{i} = 'NO PARTY';
	   else put 'WAR' 'NING: My defensive programming!' fname= exam{i}=;
	end;
run;

*  Array name ie pass cannot be a function name, or the same name as 
   a variable in your dataset;





*  Use of arrays;
data h_w (drop=avist);
  set train.vitals (keep = usubjid height weight avisit);
  where avisit = 'Screening';
run;
  
* Method 1 - works!;
data m1 (keep = avg:);
  set h_w end = eof;
  
  array var{2} height weight;
  array tot{2} t_height t_weight;
  array n{2}   n_height n_weight;
  array avg{2} avg_height avg_weight;

  do i=1 to 2;
     tot{i} + var{i};
	 if var{i} ne . then n{i}+1;
  end;

  if eof;
  do j=1 to 2;
     avg{j} = (tot{j}/n{j});
  end;
run;




* Method 2 - works!;
data m2 (keep = avg:);
  set h_w end = eof;
  
  array var{2} height weight;
  array tot{2} t_height t_weight;
  array n{2}   n_height n_weight;
  array avg{2} avg_height avg_weight;

  do i=1 to 2;
     tot{i} + var{i};
	 if var{i} ne . then n{i}+1;
  end;

  if eof then do;
    do j=1 to 2;
       avg{j} = (tot{j}/n{j});
    end;
    output;
  end;
run;



* Method 3 - works!;
data m3 (keep = avg:);
  set h_w end = eof;
  
  array var{2} height weight;
  array tot{2} t_height t_weight;
  array n{2}   n_height n_weight;
  array avg{2} avg_height avg_weight;

  do i=1 to 2;
     tot{i} + var{i};
	 if var{i} ne . then n{i}+1;
     if eof then avg{i} = (tot{i}/n{i});
  end;
  if eof ;
run;



* Method 4 - does not work!  Why?  ;
data m4 (keep = avg:);
  set h_w end = eof;
  
  array var{2} height weight;
  array tot{2} t_height t_weight;
  array n{2}   n_height n_weight;
  array avg{2} avg_height avg_weight;

  do i=1 to 2;
     tot{i} + var{i};
	 if var{i} ne . then n{i}+1;
     if eof;* This is your problem;
     avg{i} = (tot{i}/n{i});
  end;
  
run;





/********************************************************************************************************************************
***********************************************Exercises J***********************************************************************

Qu.1.  Modify the following code by applying an array instead.

data no_array1;
	set train2.exam;
	
	if test1 => 5 then result1 = "PASS";
    else result1 = 'FAIL';

	if test2 => 5 then result2 = "PASS";
    else result2 = 'FAIL';

    if test3 => 5 then result3 = "PASS";
    else result3 = 'FAIL';

	if test4 => 5 then result4 = "PASS";
    else result4 = 'FAIL';
	
run;


Qu.2 We currently have the dataset (BP) below.  

data BP;
  infile datalines delimiter=','; 
  input subjid $ baseline visit1 visit2 visit3 visit4 visit5 visit6 visit7 visit8;
  datalines;
  Pat1, 110, 106, 98, 68, 36, 120, 111, 99, 106,
  Pat2, 97, 78, 102 , 39, 98, 102, 101, 88,110,
  Pat3, 102, , 115, 89, 112, 100, 101, 77, 88,
  ;
run;

      Calculate change from baseline and transpose the data so we have one row per 
      subjid, per change from baseline measurement.  Our new dataset should look similar to:  
      
      subjid  visit  CFB
      Pat1      1     x
      Pat1      2     x
      Pat1      3     x
      Pat1      4     x
      Pat1      5     x
      Pat1      6     x
      Pat1      7     x
      Pat1      8     x
      Pat2      1     x
       ..       .     .



Qu.3  Similar to Exercises H qu.4, use the vitals dataset (and arrays) to calculate:
      - the average weight
      - average systolic BP 
      - average diastolic BP
      Output only one observation per subject.
      Note: If any measurements are missing, we want the average to also be missing.


Qu.4  Arrays and do loops can create lots of data very quickly.  With one 
      data step, use arrays and do loops to create the following data 
      containing 20 patients and 8 visit variables:

      usubjid  visit1  visit2 visit3 visit4 .... visit8
         1      x         x      x      x           x
         2      x         x      x      x           x
         3      x         x      x      x           x
         4      x         x      x      x           x 
         5      x         x      x      x           x
        ...

      Note: all 'x' values for visit can be randomly calculated using 
      the following:
      visit1 = round((ranuni(j)*100 ), 1)


CHALLENGE:

Qu.5  Use an array to transpose the ae data.  We want 1 row per subjid, with each column containing the date of ae.
      Your new dataset should look similar to:

      usubjid  ae_date1  ae_date2 ae_date3 ae_date4 .....
      Pat1        x         x         x        x
      Pat2        x         x         x        x
      Pat3        x         x         x        x
      ...


Qu.6  Use arrays to transpose vitals dataset for weight only  (ignore visits of "early withdrawal follow-up"). 
      Your new dataset should look similar to:

      usubjid    wgt1     wgt2      wgt3     wgt4.....  wgt10
      Pat1        x         x         x        x          x
      Pat2        x         x         x        x          x
      Pat3        x         x         x        x          x
      ...



***********************************************Solutions***********************************************************************



*********************************************************************************************************************************
*********************************************************************************************************************************/


















/******************************************************************************************************************************
*******************************************************************************************************************************
**********************************                   CHAPTER 7               **************************************************
- Functions


*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/



/****************************************
Investigate functions
           - date functions
           - round()
           - ceil()
           - floor()
           - int()
           - trim()
           - left()
           - right()
           - compress()
           - cat()
           - catx()
           - substr()
           - scan()
           - index()
           - upcase()
           - propcase()
           - lowcase()
           - tranwd()
           - input()/put()
           - datdif()
           - yrdif()
           - intnx()
           - intck()
           
****************************************/

/***********************************************************************************
                               Numeric functions
***********************************************************************************/
data _null_;
  int1 = int(6.27837);
  floor1 = floor(6.27837);
  ceil1 = ceil(6.27837);
  round1a = round(6.27837, 1);
  round1b = round(6.27837, 0.0001);
  put int1    = 
      floor1  = 
      ceil1   = 
      round1a =
      round1b =; 
run;




data _null_;
  int2 = int(-6.27837);
  floor2 = floor(-6.27837);
  ceil2 = ceil(-6.27837);
  round2a = round(-6.27837, 1);
  round2b = round(-6.27837, 0.0001);
  put int2    = 
      floor2  = 
      ceil2   = 
      round2a =
      round2b = ;
run;



/**********************************************************************************
                             Character functions
**********************************************************************************/

/*********************************
Functions/operators to concatenate
*********************************/

*data _null_;
data cat;

  fname = 'Anna';
  mname = 'Teresa';
  lname = 'Cargill';

  fullname1 = fname !! mname !! lname;
  fullname2 = fname !! ' ' !! mname !! ' ' !! lname;

  fullname3 = cat(fname, ' ' , mname, ' ', lname);
  fullname4 = catx(' ' , fname, mname, lname);

run;
* See length of variables;



data cat2;

  fname = 'Anna              ';
  mname = 'Teresa            ';
  lname = 'Cargill           ';

  fullname1 = fname !! mname !! lname;
  fullname2 = fname !! ' ' !! mname !! ' ' !! lname;

  fullname3 = cat(fname, ' ' , mname, ' ', lname);
  fullname4 = catx(' ' , fname, mname, lname);
  fullname5 = cats(fname, ' ', mname, ' ', lname);

run;


/*********************************
Functions for leading/trailing blanks
*********************************/
data blanks;

  fname = 'Anna              ';
  mname = 'Teresa            ';
  lname = '       Cargill    ';

  
  fullname1 = left(fname) !! ' ' !! left(mname) !! ' ' !! left(lname);
  fullname2 = compress(left(fname)) !! ' ' !! compress(left(mname)) !! ' ' !! compress(left(lname));
  fullname3 = trim(left(fname)) !! ' ' !! trim(left(mname)) !! ' ' !! trim(left(lname));
  fullname4 = strip(fname) !! ' ' !! strip(mname) !! ' ' !! strip(lname);
  fullname5 = compbl(fname !! ' ' !! mname !! ' ' !! lname);
  fullname6 = catx( ' ', fname, mname, lname);
  name      = compress(fname);

run;


/*********************************
Scan function
*********************************/

data scan;

  fullname = 'Anna Teresa Cargill';

  fname = scan(fullname , 1, ' ');
  mname = scan(fullname , 2, ' ');
  lname = scan(fullname , 3, ' ');

  *length fname lname mname $ 30;

  test1 = scan(fullname, -1, ' ');
  test2 = scan(fullname, 4, ' ');
  test3 = scan(fullname, 2);
  test4 = scan(fullname, 2, 'n');
  test5 = scan(fullname, 2, 'a');
  test6 = scan(fullname, 2, 'rl');
  test7 = scan(fullname, 2, 'anr'); 

run;


/*********************************
Length function
*********************************/

data length;

  fullname = 'Anna Teresa Cargill';

  fname = scan(fullname , 1, ' ');
  mname = scan(fullname , 2, ' ');
  lname = scan(fullname , 3, ' ');

  length_fname = length(fname);
  length_mname = length(mname);
  length_lname = length(lname);
  length_null  = length(' ');

run;


/*********************************
Index function
*********************************/
	  
data index;

  fullname = 'Anna Teresa Cargill';

  fname = scan(fullname , 1, ' ');
  mname = scan(fullname , 2, ' ');
  lname = scan(fullname , 3, ' ');

  index1 = index(fname, 'a');
  index2 = index(mname, 'a');
  index3 = index(lname, 'a');
  index4 = index(fname, 'c');
  index5 = index(fullname, 'a'); * option for last occurence;

run;



/*********************************
Substr function
*********************************/
data substr;

  fullname = 'Anna Teresa Cargill';

  fname = scan(fullname , 1, ' ');
  mname = scan(fullname , 2, ' ');
  lname = scan(fullname , 3, ' ');

  substr1 = substr(lname, 6);
  substr2 = substr(lname, 6, 2);
  substr3 = substr(lname, 6, 3);
  substr4 = substr(lname, -1);

run;



/*********************************
Tranwrd function
*********************************/
data tranwd;
  fullname = 'Anna Teresa Cargill';
  tranwrd1 = tranwrd(fullname, 'Anna' , 'Annabelle');
run;






/*********************************
Examples of character functions
to calculate usubjid
*********************************/
data test;
	set train.demo (keep = subjid studyid);
	leng = length(subjid);
	usubjid1 = studyid !! '.' !! (subjid);
	usubjid2 = studyid !! '.' !! compress(subjid);
	USUBJID3=compress(studyid)||'.'||compress(put(subjid,z7.));
run;






/********************************************************************************************************************************
***********************************************Exercises K***********************************************************************

Qu.1  From the demo dataset using usubjid only, create:
      - a variable containing patient_no
      - a variable containing study_info 

Qu.2  From the treatment name in demo, create a new variable 
      which provides the number of mg of the active treatment
       a) Ensure it works for the data we have now ie. 2mg..., 8mg 
       b) Ensure your code is as flexible as possible to ensure
          it works if there were 1000 different doses in different
          positions i.e 2mg ..., 8mg ..., 1000mg ... , BID 250mg ..

Qu.3  Using the ae dataset, create a new variable which contains a 
      value of 0 or 1, where 1 means the leg was mentioned in AELLT.
      Ensure your code will work with any case (upper or lower or mixed).

Qu.4  What is the maximum number of characters in the variables 
      AESOC and AEPT?
        a) Use a data step then proc to determine the lengths
        b) Use a data step only
        c) As b) but add additional flexibility to your code to
           allow it to work on more than just aesoc and aept (aellt,
           aeterm and aemodify), without making your code really 
           long
           

Qu.5  Replace the following in the dataset below:
               -  for character variables, replace data values to be all uppercase 
               -  for numerics, replace all occurrences of 999 with a missing value

      Note:  you may find the keyword _numeric_ and _character_ useful   

data replace;
   input usubjid 
         x 
         y      $ 
         z1-z3 
         z      $;
datalines;
1 2 x 3 4 5 Y
2 999 Yes 999 1 999 J
999 999 R 999 999 999 X
1 2 yes 4 5 6 No
;
run;



***********************************************Solutions***********************************************************************



*********************************************************************************************************************************
*********************************************************************************************************************************/























/****************************************
Using proc transpose to transpose data
- ignore early withdrawal follow-up
****************************************/
proc sort data = train.vitals (where = (visit='EARLY WITHDRAWAL FOLLOW-UP'))
           out = vitals (keep = usubjid atrtgrp visit weight);
  by usubjid ;
run;


proc transpose data = vitals 
                out = vitals2 (drop = _name_
                                      _label_) 
                prefix=my_prefix_;
    by usubjid;
	var weight;
	id visit;
run;
	






/***********************
Proc means
************************/

proc means data = train.demo;
run;


proc means data = train.demo;
  var age;
run;


proc means data = train.demo  mean ;
	class trtcd trtgrp ;
	var age;
run;


proc means data = train.demo  mean;
	class sex trtgrp;
	var age;
	output out = age_stats 
             n = N1 
        median = Median1 
          Mean = Mean1 
           min = Minimum1 
           Max = Maximum1 
           std = STD1 ;
run;




proc means data = train.demo  nway;
	class trtcd trtgrp;
	var age;
	output out = age_stats 
             n = N1 
        median = Median1 
          Mean = Mean1 
           min = Minimum1 
           Max = Maximum1 
           std = STD1 ;
run;

proc means data = train.demo nway mean;
	class trtcd trtgrp;
	var age;
	output out = age_stats(drop =  _type_ _freq_) 
             n = N1 
        median = Median1 
          Mean = Mean1 
           min = Minimum1 
           Max = Maximum1 
           std = STD1 ;
run;



/* What did Omar do? */
proc means data = train.demo nway mean;
	class trtcd trtgrp;
	var age;
	output out = omar_stats
           ;
run;











/* What Omar should have done? */
proc means data = train.demo nway noprint;
	class trtcd trtgrp;
	var age;
	output out = omar_stats
           mean = my_mean ;
run;





/***********************************************************************************
       PROC FREQ
***********************************************************************************/


* Frequencies of trtgrp and sex ;
proc freq data = train.demo;
  tables trtgrp  sex ;
run;



* Number of distinct values of trtgrp and sex ;
proc freq data = train.demo nlevels ;
  tables trtgrp  sex ;
run;



* Frequencies of trtgrp by sex ;
proc freq data = train.demo nlevels;
  tables trtgrp * sex ;
run;


* Create a dataset of frequencies of trtgrp by sex ;
proc freq data = train.demo;
  tables trtgrp * sex / out = freq;
run;


* Create a dataset of frequencies of trtgrp by sex ;
proc freq data = train.demo noprint;
  tables trtgrp * sex / out = freq1 (drop = percent);
run;


* Create a dataset of frequencies of trtgrp by sex, include MISSING values
  in report (automatically included in dataset);
data demo;
  set train.demo;
  if _N_ =1 then sex = '';
run;

proc freq data = demo ;
  tables trtgrp * sex / out = freq2 (drop = percent);
run;

proc freq data = demo;
  tables trtgrp * sex / missing out = freq3 (drop = percent);
run;




/**************NOTE: Useful for AE table ************/

/* Sorting your data - ascending order */

/* Sorting your data and deleting observations with repeated by values using the nodupkey option */
proc sort data = train.ae (keep = usubjid trtgrp) 
           out = ae_unique nodupkey;
  by usubjid;
run;


/* Calculate the number of patients with ae's in each treatment group.  The output statement puts the information in a SAS dataset called ae_by_trtgrp */

proc freq data = ae_unique ;
 tables trtgrp / out = num_sub_by_trtrg ;
run; 



proc freq data = train.ae ;
 tables trtgrp / out = numae_by_trtrg ;
run; 



/********************************************************************************************************************************
***********************************************Exercises L***********************************************************************

Qu.1.  Transpose the dataset age_stats (created by the proc means below), to achieve 
       the treatment groups in columns and stats in rows. 


proc means data = train.demo nway noprint;
	class trtcd trtgrp;
	var age;
	output out = age_stats(drop =  _type_ _freq_) 
             n = N1 
        median = Median1 
          Mean = Mean1 
           min = Minimum1 
           Max = Maximum1 
           std = STD1 ;
run;



Qu.2.  Create a dataset that shows the number of patients in each
       country for each treatment group (for the ITT population only).  
       Ensure the treatment group is presented in the columns, with 
       country presented in the rows.  


Qu.3.  As Qu2 above, including the percentages.  Note: the correct 
       denominator for the percentages is the number in each treatment
       group, for that population (ITT).  Avoid hard coding the denominator.
       The dataset should be structured as follows (where count is a 
       whole number and percents are to 1 dp): 


Country     Statistic    TrtA  TrtB ....

Australia   Count          x     x
Australia   Percent        x     x
Belgium     Count          x     x
Belgium     Percent        x     x  



***********************************************Solutions***********************************************************************






*********************************************************************************************************************************
*********************************************************************************************************************************/



proc means data = train.demo nway noprint;
	class trtcd trtgrp;
	var age;
	output out = age_stats(drop =  _type_ _freq_) 
             n = n1 
        median = median1 
          mean = mean1 
           min = minimum1 
           max = maximum1 
           std = std1 ;
run;


/* Formatting */

data age_stats2;
  set age_stats;
  *length n mean std median minimum maximum $ 12;

  n=put(n1,4.0);
  mean=put(mean1,6.1);
  std=put(std1,7.2);
  median=put(median1,6.1);
  minimum=put(minimum1,4.0);
  maximum=put(maximum1,4.0);

  keep n mean std median minimum maximum trtcd trtgrp;
run;


proc transpose data = age_stats2  out = age_stats3 ;
	id trtcd;
	var n mean std median minimum maximum;
run;

* Purely to confirm alignmemt of dp;
proc print data = age_stats3;
run;








/********************************************************************************************************************************
***********************************************Exercises M***********************************************************************

Qu.1.  Amend the data step code above to put the decimal point in position 10.   

Qu.2.  Create the following statistics for age and ensure the decimal point is aligned:
       - mean (3 dp)
       - SD   (5 dp)
       - Lower 95% CI (4 dp)
       - Upper 95% CI (4 dp)

***********************************************Solutions***********************************************************************





*********************************************************************************************************************************
*********************************************************************************************************************************/









/***************************************************************************
                OUTPUT DELIVERY SYSTEM (ODS)
****************************************************************************/




/*******************************************************************************
1) ODS LISTING;
- If you have kept all the defaults (not amended Tools->Options->Preferences), 
  the default ODS destination for 9.3 onwards is HTML (LISTING otherwise).  
  I changed my preferences to be LISTING which is equivalent to the code below.
********************************************************************************/

ods listing;
proc freq data = train.demo nlevels;
  tables sex * trtgrp;
run;




/*******************************************************************************
2) ODS HTML;
- the output will go to two destinations: LISTING and HTML
- all output will go to both destinations until you close the destination
********************************************************************************/

 
ods html;
proc freq data = train.demo nlevels;
  tables sex * trtgrp;
run;

proc univariate data = train.demo;
  var age;
run;
ods html close;



/*******************************************************************************
3) ODS HTML path = ' ' file=' .xls';
********************************************************************************/

ods html path = 'P:\Training Area\Trial 1\2018 outputs\' file='my excel.xls';
proc freq data = train.demo nlevels;
  tables sex trtgrp;
run;
ods html close;
* The view from within remote desktop is different to outside remote desktop 
  - always view from outside remote desktop due to differences in software;




/*******************************************************************************
4) ODS rtf path = ' ' file=' .doc';
********************************************************************************/


ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='my doc.doc';
proc freq data = train.demo nlevels;
  tables sex trtgrp;
run;
ods rtf close;
* The view from within remote desktop is different to outside remote desktop 
  - always view from outside remote desktop due to differences in software;





/*******************************************************************************
5) ODS PDF path = ' ' file=' .pdf';
********************************************************************************/

ods pdf path = 'P:\Training Area\Trial 1\2018 outputs\' file='my pdf.pdf';
*ods pdf file = 'P:\Training Area\Trial 1\2018 outputs\my pdf.pdf';
proc freq data = train.demo nlevels;
  tables sex trtgrp;
run;
ods pdf close;
* The view from within remote desktop is different to outside remote desktop 
  - always view from outside remote desktop due to differences in software;



/*******************************************************************************
6) ODS TRACE;
- All output is made up of separate output objects (i.e each table within a PROC UNIVARIATE/REG/GLM/FREQ)
- Each output object has a different name
- ODS TRACE ON; can be used to print the name of each output object in the log    

********************************************************************************/
ods trace on;
proc freq data = train.demo nlevels;
  tables sex trtgrp;
run;
ods trace off;



/*******************************************************************************
7) ODS OUTPUT name-of-output-object = new-SAS-dataset; 
- Once you know the name of each output object using ods trace, you can use the 
  ODS output destination to create a SAS dataset of the output object 

********************************************************************************/

ods output nlevels =my_new_dataset;
proc freq data = train.demo nlevels;
  tables sex trtgrp;
run;








/*******************************************PROC REPORT*****************************/


/******************************************
 Types of report - Listing or Summary?
NOTE: NOWD option is now default
*******************************************/

* Listing report - one line per observation ;
proc report data = train.demo nowd list;
  column usubjid trtgrp;
run;
* LIST option shows the full proc report code executed;
* Note width of trtgrp variable;
* Note usage of all variales;


proc report data = train.demo nowd list;
  column usubjid trtgrp;
  define trtgrp / width = 20;
run;



* Listing report - one line per observation ;
proc report data = train.demo nowd list;
  column usubjid trtgrp age;
  define trtgrp / width = 20;
run;


* Summary report - one line per multiple observations ;
proc report data = train.demo nowd list;
  column age bmi;
run;

* NOTE: default summary will be sum;






/************************
   LISTING REPORTS
************************/
* Listing report - one line per observation ;
proc report data = train.demo nowd;
  column usubjid trtgrp;
  define usubjid / display;
  define trtgrp  / display width = 20;
run;


* Listing report - one line per observation ;
*Qu - what will the report look like below?;
proc report data = train.demo nowd;
  column usubjid trtgrp age;
  define usubjid / display;
  define trtgrp  / display width=20;
  define age     / analysis; 
run;

* Usage of analysis for age is ignored as usubjid and trtgrp are defined as
  display usage.  If any variable is defined as display, the report will
  be a listing report;



* Listing report - one line per observation ;
*Qu - what will the report look like below?;
proc report data = train.demo nowd;
  column usubjid trtgrp age;
  define trtgrp  / order  width=20;
  define age     / display;
  define usubjid / display; 
run; 
* NOTE: order of the define statements is unimportant.  The column statement 
        determines the order in the report;











/************************
   SUMMARY REPORTS
************************/

* Summary report - one line per multiple observations ;
*Qu - what will the report look like below?;
proc report data = train.demo nowd;
  column age bmi;
  define bmi / analysis;
  define age  / analysis;
run;



* Summary report - one line per multiple observations ;
*Qu - what will the report look like below?;
proc report data = train.demo nowd;
  column age bmi;
  define bmi / analysis max;
  define age  / analysis mean;
run;


* Summary report - one line per multiple observations ;
*Qu - what will the report look like below?;
proc report data = train.demo nowd;
  column age bmi trtgrp;
  define bmi   / analysis max;
  define age    / analysis mean;
  define trtgrp / group width=20;
run;








/**********************************PROC REPORT - CUSTOMISING**********************/


/***********************************************************************
a) Ordering observations 
b) labels
************************************************************************/
* Listing report - one line per observation ;
proc report data = train.demo nowd;
  column usubjid trtgrp age;
  define usubjid / display;
  define trtgrp  / display  'Treatment Group' width=20;
  define age     / order    'Age in ascending order';
run;


* Listing report - one line per observation ;
proc report data = train.demo nowd;
  column usubjid trtgrp age;
  define usubjid / display;
  define trtgrp  / display            'Treatment Group' width=20;
  define age     / order descending   'Age in descending order';
run;


/*
If you require the output to be ordered differently to ascending or descending,
use the following:
• ORDER=FORMATTED Sorts by a variable’s formatted values (DEFAULT)
• ORDER=DATA Sorts in the order that the variable values are encountered in the data set
• ORDER=INTERNAL Sorts by a variable’s unformatted values
• ORDER=FREQ Sorts by frequency counts of the variable values

See http://support.sas.com/resources/papers/proceedings11/090-2011.pdf
for detailed description of the differences between order=data and order=internal

*/


/***********************************************************************
c) Formats
************************************************************************/
* Listing report - one line per observation ;
proc report data = train.demo nowd;
  column usubjid trtgrp age;
  define usubjid / display;
  define trtgrp  / display            'Treatment Group' width=20;
  define age     / order descending   'Age in descending order' format = 5.2;
run;



/***********************************************************************
d) Width
************************************************************************/

********METHOD 1 - LISTING DESTINATION ONLY ***********;
* Listing report - one line per observation ;
proc report data = train.demo nowd;
  column usubjid country sex birthdt age bmi trtgrp ;
  define usubjid / display;
  define trtgrp  / display            'Treatment Group'         width = 8;
  define age     / order descending   'Age in descending order' width = 15 format = 5.2;
  define bmi     / order descending   'BMI in descending order'  width = 15 format = 7.2;
run; 
* CAUTION: No warning given in the log about trtgrp truncation.;
* Default width for character columns is equal to the variables length, 
  default width for numerics is 8;  


*NOTE: BREAK, SKIP, HEADLINE, HEADSKIP, DOL, DUL, OL, UL, WIDTH, FLOW, PANEL, SPACING,
       LS, PS and BOX are the "LISTING" only options of PROC REPORT. This means that 
       when writing to other ODS destinations, such as RTF, PDF or HTML, these options
       will be ignored.;


 

********METHOD 2 - ODS RTF/PDF/HTML *******************;
* Listing report - one line per observation ;
title ' ';
ods listing close;
ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='report 1a.doc';
proc report data = train.demo nowd 
    style(report)={width=100%};
  column usubjid age bmi trtgrp ;
  define usubjid / display
                   style(column)={just=l cellwidth=25% asis=on } 
                   style(header)={just=l} ;
  define trtgrp  / display            
                   'Treatment Group'         
                   style(column)={just=l cellwidth=15% asis=on } 
                   style(header)={just=l} ;
  define age     / order descending   
                   'Age in descending order' 
                   format = 5.2
                   style(column)={just=c cellwidth=15% asis=on } 
                   style(header)={just=c};
  define bmi    / order descending   
                   'BMI in descending order' 
                   format = 7.2
                   style(column)={just=c cellwidth=15% asis=on } 
                   style(header)={just=c};
run; 

ods rtf close;
ods listing ;


* PROC REPORT statement uses STYLE(REPORT)= to set the width from the margins;
* PROC REPORT statement uses STYLE(COLUMN)= to set attributes of all columns;
* PROC REPORT statement uses STYLE(HEADER)= to set attributes of all headers;
* DEFINE statement STYLE(COLUMN/HEADER)= to define the styles of that 
  particular variable;
* Useful style attributes include:

    1.  CELLHEIGHT =/HEIGHT = Height of cells in a table
    2.  CELLWIDTH =/WIDTH = Width of cells in a table (can define the column size as a percentage of the table size) 
    3.  CELLPADDING = Space between text and all four borders
    4.  CELLSPACING = Space between cells
    5.  FONT_FACE = Specify what font to use (can be ‘TIMES’, ‘COURIER’, ‘ARIAL’, …)
    6.  FONT_SIZE = Font size
    7.  FONT_STYLE = ‘ITALIC’ or ‘ROMAN’
    8.  FRAME = Frame style (FRAME=VOID produces table with no borders)
    10. RULES = Controls lines for the whole table (ALL: lines between all rows and columns COLS: between all
    11. ASIS = on specifies that leading spaces and line breaks will be honoured allowing for user controlled indentation;


/********************************************************************************************
 I (Cynthia SAS Super Freq) find that cellwidth is frequently trial 
 and error -- if you don't use cellwidth on -every- variable or 
 report item, then the other report items -can- shift in width.

 ODS calculates the cellwidth of the cells based on a variety of 
 factors: first and foremost, the destination, then the font being 
 used for the headers versus the font being used for the data cells,
 the number of characters in the header and data cells (in some 
 destinations), the cellpadding being used for the table, any style
 changes that need to be applied. There is no formula that will 
 save you eyeballing the report and making adjustments. 

Qu - Dealing with wide tables, to fit all columns on one page. If your destination 
     of choice is RTF or PDF (not listing/HTML), then some things to
     try are:

1) options orientation=landscape;
2) options orientation=landscape nocenter;
3) reduce the cellpadding style attribute value 
   (cellpadding is the white space -inside- the cell walls)
4) reduce the font_size and/or change the font_face to a "narrow" font
5) fiddle with the margins;

*********************************************************************************************/



/******** Reduce overall width of table, reduce width of usubjid **************/
ods listing close;
title ' ';
ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='report 1b.doc';
proc report data = train.demo nowd style(report)={width=80%};
  column usubjid age bmi trtgrp ;
  define usubjid / display
                   style(column)={just=l cellwidth=10% asis=on } 
                   style(header)={just=l} ;
  define trtgrp  / display            
                   'Treatment Group'         
                   style(column)={just=l cellwidth=15% asis=on } 
                   style(header)={just=l} ;
  define age     / order descending   
                   'Age in descending order' 
                   format = 5.2
                   style(column)={just=c cellwidth=10% asis=on } 
                   style(header)={just=c};
  define bmi    / order descending   
                   'BMI in descending order' 
                   format = 7.2
                   style(column)={just=c cellwidth=10% asis=on } 
                   style(header)={just=c};
run; 

ods rtf close;
ods listing;




/******** Reduce overall width of table, reduce width of usubjid **************/
ods listing close;
title ' ';
ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='report 1c.doc';
proc report data = train.demo nowd style(report)={width=80%};
  column usubjid age bmi trtgrp ;
  define usubjid / display
                   style(column)={just=l width=10% asis=on } 
                   style(header)={just=l} ;
  define trtgrp  / display            
                   'Treatment Group'         
                   style(column)={just=l width=15% asis=on } 
                   style(header)={just=l} ;
  define age     / order descending   
                   'Age in descending order' 
                   format = 5.2
                   style(column)={just=c width=10% asis=on } 
                   style(header)={just=c};
  define bmi    / order descending   
                   'BMI in descending order' 
                   format = 7.2
                   style(column)={just=c width=10% asis=on } 
                   style(header)={just=c};
run; 

ods rtf close;
ods listing;




/******** Amend units of width ****************************************************/
ods listing close;
title ' ';
ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='report 1c.doc';
proc report data = train.demo nowd style(report)={width=80%};
  column usubjid age bmi trtgrp ;
  define usubjid / display
                   style(column)={just=l width=5cm asis=on } 
                   style(header)={just=l} ;
  define trtgrp  / display            
                   'Treatment Group'         
                   style(column)={just=l width=5cm asis=on } 
                   style(header)={just=l} ;
  define age     / order descending   
                   'Age in descending order' 
                   format = 5.2
                   style(column)={just=c width=5cm asis=on } 
                   style(header)={just=c};
  define bmi    / order descending   
                   'BMI in descending order' 
                   format = 7.2
                   style(column)={just=c width=5cm asis=on } 
                   style(header)={just=c};
run; 

ods rtf close;
ods listing;




/***********************************************************************
e) Flow
************************************************************************/

* Listing report - one line per observation ;
proc report data = train.demo nowd;
  column usubjid country sex birthdt age bmi trtgrp ;
  define usubjid / display;
  define trtgrp  / display            'Treatment Group'         width = 8 flow;
  define age     / order descending   'Age in descending order' width = 10 format = 5.2;
  define bmi    / order descending   'BMI in descending order' width = 10 format = 7.2;
run; 


*NOTE: BREAK, SKIP, HEADLINE, HEADSKIP, DOL, DUL, OL, UL, WIDTH, FLOW, PANEL, SPACING,
       LS, PS and BOX are the "LISTING" only options of PROC REPORT. This means that 
       when writing to other ODS destinations, such as RTF, PDF or HTML, these options
       will be ignored.;


 
* NOTE: ODS RTF automatically flow the text;



/***********************************************************************
f) Wrapping text
************************************************************************/

* Listing report - one line per observation ;
proc report data = train.demo nowd split = '~';
  column usubjid country sex birthdt age bmi trtgrp ;
  define usubjid / display;
  define trtgrp  / display            'Treatment ~Group'          width = 11 flow;
  define age     / order descending   'Age in ~descending ~order' width = 10 format = 5.2;
  define bmi    / order descending   'BMI in ~descending ~order' width = 10 format = 7.2;
run; 
* NOTE: If the split character is seen in the data values, the data value will be wrapped 
        at that point;



/***********************************************************************
g) Spacing between columns
************************************************************************/

* Listing report - one line per observation ;
proc report data = train.demo nowd split = '~';
  column usubjid country sex birthdt age bmi trtgrp ;
  define usubjid / display ;
  define trtgrp  / display            'Treatment ~Group'       ;
  define age     / order descending   'Age in ~descending ~order' ;
  define bmi    / order descending   'BMI in ~descending ~order' ;
  define birthdt  / spacing = 10; 
run; 


*NOTE: BREAK, SKIP, HEADLINE, HEADSKIP, DOL, DUL, OL, UL, WIDTH, FLOW, PANEL, SPACING,
       LS, PS and BOX are the "LISTING" only options of PROC REPORT. This means that 
       when writing to other ODS destinations, such as RTF, PDF or HTML, these options
       will be ignored.;



/***********************************************************************
h) Linesize and Pagesize
- linesize/ls controls the number of characters per line
- pagesize/ps controls the number of lines to a page
************************************************************************/

* Listing report - one line per observation ;
proc report data = train.demo nowd split = '~' ls = 150;
  column usubjid country sex birthdt age bmi trtgrp ;
  define usubjid / display ;
  define trtgrp  / display            'Treatment ~Group'         ;
  define age     / order descending   'Age in ~descending ~order';
  define bmi    / order descending   'BMI in ~descending ~order' ;
  define birthdt  / ' '; 
run; 


*NOTE: BREAK, SKIP, HEADLINE, HEADSKIP, DOL, DUL, OL, UL, WIDTH, FLOW, PANEL, SPACING,
       LS, PS and BOX are the "LISTING" only options of PROC REPORT. This means that 
       when writing to other ODS destinations, such as RTF, PDF or HTML, these options
       will be ignored.;




/***********************************************************************
i) Spanning header
************************************************************************/

* Listing report - one line per observation ;
proc report data = train.demo nowd split = '~' ls = 150;
  column usubjid country sex birthdt ('_Descending_order_' age bmi ) trtgrp ;
  define usubjid / display ;
  define trtgrp  / display            'Treatment ~Group'         ;
  define age     / order descending   'Age' ;
  define bmi    / order descending   'BMI' ;
  define birthdt  / ' '; 
run; 



/***********************************************************************
j) Adding blank lines
- a blank line can only be applied when the value of an 
  order or group variable changes
- method 1 only works for the listing destination, therefore method 2
  is required for ods destinations such as RTF, PDF or HTML
************************************************************************/

********METHOD 1 - LISTING DESTINATION ONLY ***********;
* Listing report - one line per observation ;
proc report data = train.demo nowd split = '~' ls = 150;
  column usubjid trtgrp ('_Descending_order_' age bmi )  ;
  define usubjid / display ;
  define trtgrp  / order              'Treatment ~Group' width=20;
  define age     / order descending   'Age' ;
  define bmi    / order descending   'BMI' ;
  break after trtgrp / skip;
run; 


********METHOD 2 - ODS RTF/PDF/HTML *******************;
* Listing report - one line per observation ;
ods listing close;
ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='report 2.doc';
proc report data = train.demo nowd split = '~' ;
  column usubjid trtgrp ('_Descending_order_' age bmi )  ;
  define usubjid / display ;
  define trtgrp  / order              'Treatment ~Group'    ;
  define age     / order descending   'Age' ;
  define bmi    / order descending    'BMI' ;
  compute after trtgrp;
      line ' ';
  endcomp;
run; 

ods rtf close;
ods listing;


*NOTE: BREAK, SKIP, HEADLINE, HEADSKIP, DOL, DUL, OL, UL, WIDTH, FLOW, PANEL, SPACING,
       LS, PS and BOX are the "LISTING" only options of PROC REPORT. This means that 
       when writing to other ODS destinations, such as RTF, PDF or HTML, these options
       will be ignored.;



ods listing close;
ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='report 2a.doc';
proc report data = train.demo nowd split = '~' ;
  column usubjid trtgrp ('_Descending_order_' age bmi )  ;
  define usubjid / display ;
  define trtgrp  / order              'Treatment ~Group' ;
  define age     / order descending   'Age' ;
  define bmi    / order descending    'BMI' ;

  compute after trtgrp;
      line ' ';
  endcomp;
/* Extra code added here */
  compute before;
	  line '';
  endcomp;
run; 

ods rtf close;
ods listing;



/***********************************************************************
k) Missing
- for variables with a usage of order or group, missing values 
  are excluded from the reports by default
************************************************************************/
* Listing report - one line per observation ;
proc report data = train.demo nowd split = '~' ls = 130;
  column usubjid CHDPOT ;
  define usubjid  / display ;
  define CHDPOT / order width = 20;
run; 
* CHDPOT is either text or missing value.  
  Missing values are by default excluded from the report.
  See top of the report, first value of CHDPOT i.e Post-menopausal;


* Listing report - one line per observation ;
proc report data = train.demo nowd split = '~' ls = 130 missing;
  column usubjid CHDPOT ;
  define usubjid  / display ;
  define CHDPOT / order width = 20;
run; 
* CHDPOT is either text or missing value.  
  Missing option prints observations with missing CHDPOT value.
  See top of the report, first value of CHDPOT i.e ' ';



/***********************************************************************
l) Line under heading and skip a line
************************************************************************/

********METHOD 1 - LISTING DESTINATION ONLY ***********;
* Listing report - one line per observation ;

proc report data=age_stats3 split='~' headline headskip center missing nowindows;
column  _name_ _1 _2 _3;
define _name_        /   display    width=11 spacing=2  ' '       ;
define _1            /   display    width=20 spacing=2  'This is Treatment ~ 1'          ;
define _2            /   display    width=12 spacing=2            ;
define _3            /   display    width=12 spacing=2            ;
run;


*NOTE: BREAK, SKIP, HEADLINE, HEADSKIP, DOL, DUL, OL, UL, WIDTH, FLOW, PANEL, SPACING,
       LS, PS and BOX are the "LISTING" only options of PROC REPORT. This means that 
       when writing to other ODS destinations, such as RTF, PDF or HTML, these options
       will be ignored.;





********METHOD 2 - ODS RTF/PDF/HTML *******************;
* Listing report - one line per observation ;

ods listing close;
ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='report 3.doc';
title ' ';
proc report data=age_stats3 split='~'  center missing nowindows ;
column  _name_ _1 _2 _3;
define _name_        /   display    ' ' ;
define _1            /   display    'This is Treatment ~ 1' ;
define _2            /   display  ;
define _3            /   display  ;

  compute before;
      line ' ';
  endcomp;
run; 
ods rtf close;
ods listing;



/***********************************************************************
m) Centre report
************************************************************************/

* Listing report - one line per observation ;
proc report data = train.demo nowd split = '~' ls = 130 missing headline headskip center;
  column usubjid CHDPOT ;
  define usubjid  / display ;
  define CHDPOT / order width = 20;
run; 



/***********************************************************************
n) Adding an ID variable
************************************************************************/

* Listing report - one line per observation ;
proc report data = train.demo nowd split = '~';
  column usubjid country sex birthdt ('_Descending_order_' age bmi ) trtgrp ;
  define usubjid / display id;
  define trtgrp  / display            'Treatment ~Group'         width = 11 flow;
  define age     / order descending   'Age' width = 20 format = 5.2;
  define bmi    / order descending   'BMI' width = 20 format = 7.2;
  define birthdt  / spacing = 10 width = 20; 
run; 



/***********************************************************************
o) Using the NOPRINT option
************************************************************************/

* Listing report - one line per observation ;
proc report data = train.demo nowd split = '~';
  column age usubjid country sex birthdt  trtgrp ;
  define usubjid / display id;
  define trtgrp  / display            'Treatment ~Group'         width = 11 flow;
  define age     / order descending   noprint;
  define birthdt  / spacing = 10; 
  break after age /skip;
run; 




/***********************************************************************
p) Page X of Y (proc report ods rtf)
- not applicable to ods listing 
- see Paper 263-2011 ODS RTF: the Basics and Beyond Lauren Haworth
************************************************************************/

ods listing close;
ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='report 4.doc';
ods escapechar = '^';
*title j = l "On the left"   j=r "Page ^{thispage} of ^{lastpage}" ; *Equivalent statements;
title j = l "On the left"   j=r 'Page ^{pageof}';

proc report data = train.demo nowd;
  column usubjid trtgrp;
run;

ods rtf close;
ods listing;





/***********************************************************************
q) Specifying page breaks (proc report ods rtf)
  - not applicable to ods listing (use break after var / page)
  - ODS RTF ...... STARTPAGE=NOW/NEVER/YES=ON/NO=OFF;

  ods rtf ... startpage = yes/on; 
  - New proc on a new page
  - By statement will force byvalue on a new page (for some proc's but not proc report)

   ods rtf ... startpage = no/off; 
  - No new pages at the start of each proc and within the proc (by statement)
  - New pages will be created only when necessary to avoid overflowing pages, and as
    requested by the STARTPAGE=NOW option

  ods rtf ... startpage = now ; 
  - Forces the new page right now
  - This is useful only when the current state is STARTPAGE=NO/OFF, since otherwise
    each new procedure would force a new page anyway

  ods rtf ... startpage = never ; 
  - No page breaks

* SAS 9.2 introduced changes to startpage=; 

************************************************************************/

data test;
     a= "aaaa"; b = 0; output;
     a= "bbbb"; b = 0; output;
     a= "cccc"; b = 1; output;
     a= "dddd"; b = 1; output;
 run ;


/***************Example 1************/

title ;
ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='Example 1.doc' startpage = no;
* Puts all procs on same page ;
proc report data=test;
 column a b;
 where b=0;
run ;

proc report data=test;
 column a b;
 where b=1;
run ;

proc freq data=test;
 table a b ;
run ;

ods rtf close;





/***************Example 2************/

title ;
ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='Example 2.doc' startpage = yes;
* Puts all procs on separate pages ;

proc report data=test;
 column a b;
 where b=0;
run ;

proc report data=test;
 column a b;
 where b=1;
run ;

proc freq data=test;
 table a b ;
run ;

ods rtf close;




/***************Example 3************/
title ;
ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='Example 3.doc' startpage = no;

proc report data=test;
 column a b;
 where b=0;
run ;


proc report data=test;
 column a b;
 where b=1;
run ;

ods startpage = now;

proc freq data=test;
 table a b ;
run ;

ods rtf close ;









/***********************************************************************
r) Special characters (proc report ods rtf)
  - not applicable to ods listing 

************************************************************************/

data bmi;
 units1 =  "BMI (kg/m^2)";
 units2 =  "BMI (kg/m~{super 2})";
run; 

* All as expected in listing window;
proc report data=bmi;
 column units1 units2;
 define units1 / width = 20;
 define units2 / width = 20;
run ;


* Unit1 fails to show the ^2 as ^ was specified previously as escapechar;
ods listing close;
ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='report 8.doc' ; 
proc report data=bmi;
 column units1 units2;
run ;
ods rtf close; 
ods listing;

* text that follows specified escapechar ~ has a function ;
ods listing close;
ods rtf path = 'P:\Training Area\Trial 1\2018 outputs\' file='report 9.doc' ; 
ods escapechar ='~';
proc report data=bmi;
 column units1 units2;
run ;
ods rtf close;
ods listing;




/***********************************************************************
s) THE ORACLE - THIS IS A REALLY USEFUL TEMPLATE FOR YOUR TFL EXERCISES 
   Additional Bells and Whistles (proc report ods rtf)
   - Frames
   - Fonts
   - Orientation 

************************************************************************/


ods listing close;
options nodate nonumber orientation = landscape;
ods escapechar = '^';

title1 justify = left color = BLACK font =  COURIER height = 10pt 'Protocol: AVA102670' 
       j       =r                                                 'Page ^{pageof}'  ;
title2 justify = left color = BLACK font =  COURIER height = 10pt 'Population: Check RAP/SAP' ;
title4 color = BLACK  font =  COURIER height = 10pt "Table X.XX Check RAP/SAP";
title5 color = BLACK  font =  COURIER height = 10pt 'Check RAP/SAP';
title6 "     " ;
title7  "      ";
footnote1 justify = left color = BLACK  font =  COURIER height = 10pt "USER ID: /PROGRAM PATH/ PROGRAM DATE TIME";

ods rtf path = 'P:\Training Area\Trial 1\2018 outputs' file='My fancy report.doc'; 
proc report data = final nowd split = '~' 
                     style(report)={width=70% 
                                    font_face= 'COURIER' 
                                    frame = void 
                                    rules = none 
                                    background = _undef_}
                    style(header) = {borderbottomcolor = black
                                     borderbottomwidth = 2
                                     background = _undef_};
  column X Y Z ;

  define X            / order 
                      'My X label'
					  style(column)={just=l          
                                     width=9% 
                                     asis=on 
                                     font_size = 10pt 
                                     font_face= 'COURIER'
                                     vjust = top 
                                     }
                      style(header)={just=l 
                                     font_size = 10pt 
                                     background = _undef_
                                     font_weight = light
                                     font_face= 'COURIER'
                                     } ;

  define Y           / display 
                     'My Y label'
					 style(column)={just=c 
                                    width=6% 
                                    asis=on 
                                    font_size = 10pt 
                                    font_face= 'COURIER'}
                     style(header)={just=c 
                                    font_size = 10pt 
                                    background = _undef_
                                    font_weight = light
                                    font_face= 'COURIER'} ;

  define Z          / display 
                     'My Z label'
					 style(column)={just=c
                                    width=6% 
                                    asis=on 
                                    font_size = 10pt 
                                    font_face= 'COURIER'}
                     style(header)={just=c 
                                    font_size = 10pt
                                    background = _undef_
                                    font_weight = light
                                    font_face= 'COURIER'} ;


  compute after X;
      line ' ';
  endcomp;
  compute before;
      line ' ';
  endcomp;

run;
ods rtf close;
ods listing;









/***********************************************************************************
                     CREATING TFL's - EXTRAS
************************************************************************************/

/* Include your header (see separate file) */

/****************************
   Tidying up work library
****************************/
/* Deletes all datasets in the specified library */
proc datasets library=work kill nolist nodetails;
run;
quit;





/**********************************************************************
Deleting all variable labels, formats, informats and dataset label
***********************************************************************/

proc datasets lib = work nolist;
   modify age (label = ' ');
   attrib _all_ label    = ' ';
   attrib _all_ format   =    ;
   attrib _all_ informat =    ;
quit;





**************************************************************;
************************ VALIDATION ONLY *********************;
** Compare dataset created in STEP 4 to productions version **;
** of the dataset using PROC COMPARE:                       **;
** - The ID statement specifies the variable(s) that the    **;
**   procedure uses to match observations on. Requires that **;
**   both datasets will be sorted by ID variables.          **;
** - If ID statement is not specified, PROC COMPARE matches **;
**   the first observation in the base data set with the    **;
**   first observation in the comparison data set, the      **;
**   second with the second, and so on.                     **;
** - LISTALL option lists all variables and observations    **;
**   found in only one data set                             **;
** - CRITERION option specifies the criterion for judging   **; 
**   the equality of numeric values (default = 0.00001)     **;
** - MAXPRINT option specifies the maximum number of        **;
**   differences to print (default = 500)                   **;
**************************************************************;

proc compare base= production compare=validation criterion = 0.0000000001 listall;
  id var1 var2 ..;  
run;




















































































