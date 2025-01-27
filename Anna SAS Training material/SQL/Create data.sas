
data demo;
length subjid $4. country $40. invname $40.;
  do i=1 to 100;
    id=i;
	subjid='A'!!put(i,z3.);
	rand=ranuni(33);
	if rand>0.5 then sex='F';
	else sex='M';
	birthdt=floor(-5000+(5991-3279)*rand);
	format birthdt date9.;	
	

	rand3=ranuni(6);
	if rand3<0.25 then country='United States';
	else if rand3<0.5 then country='Australia';
	else country='United Kingdom';

	rand4=ranuni(7);
	if rand3<0.25 then invname='JOHN SMITH';
	else if rand3<0.5 then invname='LIZ TAYLOR';
	else if rand3<0.74 then invname='MARIA MENA';
	else invname='DAVID PAUL';

	screendt=input('01DEC2012',date9.)+floor(ranuni(8)*60);
	format screendt date9.;
	output;
 end;
 keep subjid sex birthdt  country invname screendt;
run;

data lab0;
  set demo;
  do i=1 to 5;
    visit='VISIT '!!put(i,1.);
	lborresn=10*(round(rannor(2)*0.5+2,0.1));
	if lborresn <0 then lborresn=lborresn*-1;
	lbtestcd='BILT_PLC';
	lborresu='MG/L';
	output;
  end;
run;

data lab;
length lborresu $5;
  set lab0;
  output;
  lbtestcd='BILD_PLC';
  lborresn=(lborresn/40);
  lborresu='MG/DL ';
  output;
run;

data unitconv;
length ucorresu $5;
  param='BILD_PLC';
  ucorresu='MG/DL';
  lbstresu='UMOL/L';
  lbornrlo=0;
  lbornrhi=1.2;
  output;
  param='BILT_PLC';
  ucorresu='MG/L';
  lbstresu='UMOL/L';
  lbornrlo=0;
  lbornrhi=30;
  output;
  param='ALBU_PLC';
  ucorresu='G/DL';
  lbornrlo=480;
  lbornrhi=550;
  lbstresu='g/L';
  output;
run;



%macro qi(i=);
  if ran&i <0.2 then q&i.=0;
  else if ran&i. <0.4 then q&i. = 1;
  else if ran&i.<0.6 then q&i. = 2;
  else if ran&i.<0.8 then q&i. = 3;
  else q&i.=4;
%mend;

data ho;
  set demo;
  ran1=ranuni(52); ran2=ranuni(53); ran3=ranuni(54); ran4=ranuni(55);
  %qi(i=1);
  %qi(i=2);
  %qi(i=3);
  %qi(i=4);
  drop ran1 ran2 ran3 ran4;
run;

data one;
  x=1; A='a '; output;
  x=4; A='d '; output;
  x=2; A='b '; output;
run;

data two;
  x=2; B='x'; output;
  x=3; B='y'; output;
  x=5; B='v'; output;
run;

data three;
  x=1; A='a1'; output;
  x=1; A='a2'; output;
  x=2; A='b1'; output;
  x=2; A='b2'; output;
  x=4; A='d'; output;
run;

data four;
  x=2; B='x1'; output;
  x=2; B='x2'; output;
  x=3; B='y'; output;
  x=5; B='v'; output;
run;
/*
data alpha;
  x=1; A='x'; output;
  x=1; A='y'; output;
  x=3; A='z'; output;
  x=4; A='v'; output;
  x=5; A='z'; output;
run;

data beta;
  x=1; B='x'; output;
  x=2; B='y'; output;
  x=3; B='z'; output;
  x=3; B='v'; output;
  x=5; B='v'; output;
run;*/

data alpha;
  x=1; A='a'; output;
  x=1; A='a'; output;
  x=1; A='b'; output;
  x=2; A='c'; output;
  x=3; A='v'; output;
  x=4; A='e'; output;
  x=6; A='g'; output;
run;

data beta;
  x=1; B='x'; output;
  x=2; B='y'; output;
  x=3; B='z'; output;
  x=3; B='v'; output;
  x=5; B='w'; output;
 run;

 data gamma;
  x=1; A='x'; output;
  x=1; A='y'; output;
  x=3; A='z'; output;
  x=4; A='v'; output;
  x=5; A='w'; output;
 run;
 
 data delta;
  x=1; B='x'; output;
  x=2; B='y'; output;
  x=3; B='z'; output;
  x=3; B='v'; output;
  x=5; B='v'; output;
run;

data aaa;
  set alpha;
run;

data bbb;
  x=1; B='a'; output;
  x=1; B='a'; output;
  x=2; B='z'; output;
  x=3; B='z'; output;
  x=5; B='v'; output;
  x=5; B='w'; output;
run;


