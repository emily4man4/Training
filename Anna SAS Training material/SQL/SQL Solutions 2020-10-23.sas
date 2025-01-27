


/************************************************EXERCISE 1*************************************************************/
/* Qu 1.*/
proc sql;
  create table mysum_1 as
  select sum(q1) as sum_q1, mean(q1) as mean_q1
  from work.ho;
quit;

/* Qu 2.*/

proc means data=work.ho noprint;
  var q1;
  output out = mysum1 (drop= _type_ _freq_) sum = Sum_q1 mean = mean_q1;
run;


/* Qu 3.*/
proc sql;
  select sex, count(sex)
  from demo
  group by sex;
quit;


/* Qu 4.*/
proc sql;
  create table new as
  select subjid, sex, birthdt
  from lab
  order by birthdt desc;
quit;

proc sql;
  create table new1 as
  select distinct subjid, sex, birthdt
  from lab
  order by birthdt desc;
quit;



/* Qu 5.*/
proc sql;
  create table work.demo_F_SQL as
  select subjid, sex, birthdt
    from work.demo
    where sex = 'F'
    order by birthdt descending ;
quit; 



/* Qu 6.*/
proc sql;
  select subjid, sex
    from work.demo
    where screendt < '01JAN2013'd
    order by birthdt;
quit;








/************************************************EXERCISE 2*************************************************************/

/* Qu 1.*/
proc sql;
  select distinct subjid, lbtestcd
  from work.lab;
quit;


/* Qu 2.*/
proc sql;
  select subjid, lbtestcd, count(*) as count
  from work.lab 
  group by subjid, lbtestcd;
quit;











/************************************************EXERCISE 3*************************************************************/
/* Qu 1.*/
proc sql;
create table scan as
select subjid, lborresn, scan(invname, -1, ' ') as Name 
from work.lab
  where calculated Name='SMITH';
quit;

proc sql;
create table scan as
select subjid, lborresn, scan(invname, -1, ' ') as Name length = 20
from work.lab
  where calculated Name='SMITH';
quit;



/* Qu 2.*/
proc sql;
  select subjid, int((screendt-birthdt) / 365.25) as Age
    from work.demo;
quit;


/* Qu 3.*/
proc sql;
  create table work.Age_SQL as
  select subjid, int((today()-birthdt) / 365.25) as Age
    from work.demo
    where calculated age ge 65
    order by age desc;
quit;


/* Qu 4.*/
data age_SAS ;
  set work.demo;
  keep subjid age;
  age = int((today()-birthdt) / 365.25);
  if age ge 65;
run;
proc sort data = age_SAS ;
  by descending age;
run;



/* Qu 5.*/
proc sql;
  select subjid, screendt, int((today() - birthdt)/365.25) as age
  from work.demo
  where screendt > '25DEC2012'd and calculated age > 60;
quit;













/************************************************EXERCISE 4*************************************************************/

proc sql;
  create table work.g as
  select *,
    case sex
      when 'M' then 'Male'
      when 'F' then 'Female'
      else 'None'
    end as Gender
from work.demo;
quit;


data leng;
  set demo;
  if sex = 'M' then gender = 'Male';
  else if sex = 'F' then gender = 'Female';
  else gender = 'Unknown';
run;






















/************************************************EXERCISE 5*************************************************************/
/* Qu 1.*/
proc sql;
  create table full as
  select *
  from lab 
       full join 
       unitconv
  on lab.lbtestcd=unitconv.param and lab.lborresu=unitconv.ucorresu;
quit;


/* Qu 2.*/
proc sql;
  create table visits as
  select t1.subjid, 
         count(distinct t2.visit) as visits
  from demo as t1 
       left join 
       lab as t2
  on t1.subjid=t2.subjid
  group by t1.subjid;
quit;



/* Qu 3.*/

proc sql number;
  select subjid, lbtestcd, lborresn /*, unitconv.lbornrhi*/
    from lab 
         inner join 
         unitconv
    on lab.lbtestcd=unitconv.param 
       and lab.lborresu=unitconv.ucorresu
    where lab.lborresn>unitconv.lbornrhi ;
quit;

/* OR */
proc sql number;
  select subjid, lbtestcd, lborresn /*, unitconv.lbornrhi*/
    from lab 
         inner join 
         unitconv
    on lab.lbtestcd=unitconv.param 
       and lab.lborresu=unitconv.ucorresu 
       and lab.lborresn>unitconv.lbornrhi ;
quit;






/************************************************EXERCISE 6*************************************************************/

/*Q1a. */

proc sql;
  create table ex6_qu1a as
  select x
  from one as T1
  intersect
  select x
  from two as T2;
quit;


/*Q1b. */
proc sql;
  create table ex6_qu1b as
  select x
  from one as T1
  except
  select x
  from two as T2;
quit;



/*Q2a. */
proc sql;
  create table ex6_qu2a as
  select coalesce(T1.x, T2.x)
  from one as T1 inner join two as T2 
  on T1.x = T2.x;
quit;



/*Q2b. */
proc sql;
  create table ex6_qu2b as
  select coalesce(T1.x, T2.x)
  from one as T1 full outer join two as T2 
  on T1.x = T2.x
  where T2.x is null;
quit;









/************************************************EXERCISE 7*************************************************************/
proc sql;
 insert into lab  (country)
  values ('TOTAL');
quit;



/************************************************EXERCISE 8*************************************************************/


/*Q1. */
proc sql;
  create table q1 as
  select T1.*
  from train.demo as T1 
  where usubjid in (select distinct usubjid 
                    from train.ae as T2
                    where aesoc = 'Cardiac disorders');
quit; 


/*Q2. */
proc sql;
  select T1.usubjid,
         T1.trtgrp
  from train.demo as T1
  where usubjid in (select usubjid
                    from train.vsanal as T2
                    where VSTESTCD = 'WEIGHT' and base='Y' and VSORRESN = (select max(VSORRESN) 
                                                                           from train.vsanal as T2
                                                                           where VSTESTCD = 'WEIGHT' and base='Y'));
quit;





/************************************************EXERCISE 9*************************************************************/

/*Q1a.*/
proc sql;
  describe table dictionary.tables;
quit;

proc sql;
  select memname, 
		 nobs 
  from dictionary.tables
  where nobs in (select max(nobs) 
		         from dictionary.tables
                 where libname = 'WORK');
quit; 

/*Q1b.*/
proc sql;
  select memname, 
		 nvar 
  from dictionary.tables
  where nvar in (select max(nvar) 
		         from dictionary.tables
                 where libname = 'WORK');
quit; 




/*Q2.*/

proc sql;
  select name    as variable, 
         length  as old_length, 
         (select max(length) 
          from sashelp.vcolumn
          where libname="WORK" and 
                memname in ("CLASSFIT" "DEMOGRAPHICS") and 
                upcase(name)="NAME" ) as new_length
  into :var  trimmed,
       :old_len trimmed,
	   :new_len trimmed
  from sashelp.vcolumn
  where libname="WORK" and 
        memname in ("CLASSFIT" "DEMOGRAPHICS") and 
        upcase(name)="NAME"
  having old_length ne calculated new_length;
quit;
%put &=var &=old_len &=new_len;

%macro len_chg_cat(ds1=,ds2=,var1=,len=);

data &ds1. (keep = &var1);
  set sashelp.&ds1. (rename=(&var1.=_&var1.));
  length &var1. $ &len.;
  &var1. = strip(_&var1.);
run;

data &ds2.;
  set sashelp.&ds2. (keep = &var1);
run;

data mashup2;
  set &ds1. &ds2.;
run;

%mend len_chg_cat;

options mprint;
%len_chg_cat(ds1=classfit,ds2=demographics,var1=&var,len=&new_len);

%*MASHUP has 19+197=216 observations;




