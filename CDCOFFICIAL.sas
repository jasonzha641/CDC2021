/**********************************************
Project : CDC
Program Name: CDC data.sas
Author: Jason Zhang
Date Created: 2021/09/28
Purpose: 
Revision History:

*************************************************/
%put &sysvlong;


libname x xlsx '/home/u49469744/SIBS/CAROLINADATA/countymade.xlsx';


PROC IMPORT datafile = '/home/u49469744/SIBS/CAROLINADATA/countymade.csv'
/* IMPORT imports a datafile into SAS */

	out=uninsured
	dbms= dlm replace ;
	/* dbms specifies type of document */
	delimiter =',';
	/* delimiter tells SAS when variable obs are seperated */
	/* getnames = no; 
	/* getanmes let SAS know thre are no column headings */
	getnames = yes;
	guessingrows= 1000;
	
RUN;


PROC PRINT data= work.uninsured (OBS=300);

RUN;

/* replace missing data */
/* REPLACE WITH 0 - USING ARRAY */
data work.ds_no_missing_values;
	set work.ds_missing_values;
 
	array num_array _numeric_;
	do over num_array;
		if missing(num_array) then num_array = 0;
	end;
run;


Options validVarName=any ; 

/* sample drop and add */
DATA work.v1(DROP = 'FIPS Code'n 'Other Language Spoken in HH'n 'Tagalog Spoken in HH'n
'Russian Spoken in HH'n 'Vietnamese Spoken in HH'n 'Korean Spoken in HH'n 'Chinese Spoken in HH'n
'Spanish Spoken in HH'n 'English Spoken in HH'n 'No English Speaking Adults in HH'n); 
SET work.uninsured;
where 'State Name'n = "New York";
RUN;

DATA work.v4(DROP = 'Other Language Spoken in HH'n 'Tagalog Spoken in HH'n
'Russian Spoken in HH'n 'Vietnamese Spoken in HH'n 'Korean Spoken in HH'n 'Chinese Spoken in HH'n
'Spanish Spoken in HH'n 'English Spoken in HH'n 'No English Speaking Adults in HH'n); 
SET work.uninsured;
where 'State Name'n = "New York";
RUN;

PROC PRINT data=work.v1 (OBS=100);
RUN;

DATA new2(KEEP = x3 x5 x7); 
SET old2;
RUN;

PROC IMPORT datafile = '/home/u49469744/SIBS/CAROLINADATA/countymadepercent.csv'
/* IMPORT imports a datafile into SAS */

	out=uninsuredp
	dbms= dlm replace ;
	/* dbms specifies type of document */
	delimiter =',';
	/* delimiter tells SAS when variable obs are seperated */
	/* getnames = no; 
	/* getanmes let SAS know thre are no column headings */
	getnames = yes;
	guessingrows= 1000;
	
RUN;

DATA work.v2(DROP = 'FIPS Code'n '% Other Language Spoken in HH'n '% Tagalog Spoken in HH'n
'% Russian Spoken in HH'n '% Vietnamese Spoken in HH'n '% Korean Spoken in HH'n '% Chinese Spoken in HH'n
'% Spanish Spoken in HH'n '% English Spoken in HH'n '% No English Speaking Adults in'n); 
SET work.uninsuredp;
where 'State Name'n = "New York";
RUN;

PROC PRint data= work.v2;
RUN;

/* exporting file */
proc export data=work.v1
    outfile="/home/u49469744/SIBS/CAROLINADATA/cleanedNY.csv";
    dbms=csv;
run;

proc export data=work.v2
    outfile="/home/u49469744/SIBS/CAROLINADATA/cleanedNYpercentages.csv";
    dbms=csv;
run;


proc export data=work.v4
    outfile="/home/u49469744/SIBS/CAROLINADATA/cleanedNYFIP.csv";
    dbms=dlm;
run;







