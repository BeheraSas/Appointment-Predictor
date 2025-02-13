/*Importing data into SAS */

Proc import datafile="/home/u64112026/Clinial_Data.csv"  
    out==EDA_PROJECT  
    dbms==CSV  
    replace;  
    getnames==YES;  
RUN;

/* Data Wrangling */

Proc contents data=eda_project varnum;
run;

/*Checking missing values in the data set*/
proc means data=eda_project nmiss;
run;

/*Data Cleaning */
/*Changing the name of variable ‘No-show’ to ‘Show’ and changing the label from No-Show to Show.*/
data apt_data2;
    set apt_data1;
    
    label 'No-Show'n = 'Show';
    if Show = 'Yes' then Show = 1;
    else if Show = 'No' then Show = 0;
    
    scheduled_day = DATEPART(scheduledday);
    appointment_day = DATEPART(appointmentday);
    
    day_diff = appointment_day - scheduled_day;
    
    FORMAT scheduled_day appointment_day DATE9.;
RUN;

/*Printing the first 100 rows to verify the changes */
PROC PRINT DATA=apt_data2(obs=100);
RUN;

/*Exploratory Data Analysis*/

ods graphics on;
proc freq data=apt_data2;
tables show/ nocum plots=freqplot(type=bar scale=percent);
run;
ods graphics off;

ods graphics on;
proc freq data=apt_data2;
tables show*gender/ plots=freqplot(twoway=stacked orient=Horizontal);
run;
ods graphics off;

/*Analysis for patients who don't receive SMS to miss their appointment*/
ods graphics on;
proc freq data=apt_data2;
tables show*sms_received/ plots=freqplot(twoway=stacked orient=Horizontal);
run;
ods graphics off;

/*Analysis of the time difference between the scheduling and appointment dates related to whether a patient will show up for an appointment*/
data day_cat;
    set apt_data2;
    length apt_name $ 16;
    if day_diff <= 0 then day_diff2 = 'Same Day';
    else if day_diff <= 4 then day_diff2 = 'Few Days';
    else if day_diff > 4 and day_diff <= 15 then day_diff2 = 'More than 4';
    else day_diff2 = 'More than 15';
run;

proc freq data=day_cat;
    tables day_diff2 / nocum;
run;

/*Creating two-way bar plot with Show vs day_diff2 */
ods graphics on;
proc freq data=day_cat;
    tables show*day_diff2 / plots=freqplot(twoway=grouphorizontal orient=vertical);
run;
ods graphics off;

/*Analysing on which weekdays people don’t show up most often*/
data apt_data1 (rename=('No-Show'n = Show));
set eda_project;
label 'No-Show'n='Show';
run;

data apt_data2;
set apt_data1;
if show = 'No' then Show = 1;
else if show = 'Yes' then Show = 0;
run;

/*Getting the date only part out of datetime values of scheduledday and 
appointmentday in data.*/

data EDA (drop=patientid appointmentid);
set apt_data2 (rename=(Hipertension=Hypertension));
drop scheduledday appointmentday;
Schld_date = datepart(scheduledday); 
Apt_date = datepart(Appointmentday); 
format schld_date apt_date date9.; 
day_diff = (apt_date - schld_date);
run;

/*Changed the date to weekday to check which dates the patients missed most of their 
appointments, 
Also changed the numeric weekdays to weekday names using if then statement*/

data weekdays;
set eda;
apt_day =weekday(apt_date);
if apt_day = 1 then week_day = 'Sun';
else if apt_day = 2 then week_day = 'Mon';
else if apt_day = 3 then week_day = 'Tues';
else if apt_day = 4 then week_day = 'Wed';
else if apt_day = 5 then week_day = 'Thurs';
else if apt_day = 6 then week_day = 'Fri';
else week_day = 'Sat';
run;

title "Weekdays On Which Most of the Appointments Were Missed ";
proc sgplot data = weekdays;
    vbar week_day/ group=show groupdisplay=cluster stat=freq  ;
run;

/*Logistic Regression (Predicting No-Shows)*/

proc logistic data=weekdays;
    class gender sms_received week_day / param=ref;
    model show(event='1') = age sms_received day_diff week_day / selection=stepwise;
    output out=predictions p=prob_show;
run;
