/*
Author: Mallory LaRusso
Class: ST 445 (001)
Date: 2019-11-15
Purpose: ST 445 Programming Homework 7
*/

*get stored data sets and save them in the InputDS library - set fileref called RawData;
x "cd L:\st445\Data";
libname InputDS ".";
filename RawData ".";

*library w/ duggins' data sets;
x "cd L:\st445\Results";
libname Results ".";

*set working directory and save results w/ libref and fileref in working directory;
x "cd \\wolftech.ad.ncsu.edu\cos\stat\Redirect\mhlaruss\Desktop\SAS\Homework 7";
libname hw7 ".";
filename hw7 ".";

*transpose the inputds.pm10 dataset (we will need to use these variable names for the other datasets we are reading in);
proc transpose data = inputds.pm10 out = hw7.pm10 name = OldNames;
    by siteid aqscode poc;
    id Metric;
run;

*read in EPA Data.csv;
data hw7.epadata1 (drop =date2 mean1 aqi1 count1);
    infile RawData("Epa Data.csv") firstobs = 7 dlm = ',' truncover;
    input siteid aqsCode poc
          / date2 $
          / mean1 $
          / aqi1 $
          / count1 $
    ;
    count = input(compress(count1,,'kd'),8.);
    date1 = input(compress(date2,,'kd'),8.);
    mean = input(compress(mean1,'Max'),8.);
    aqi = input(compress(aqi1,,'kd'),8.);
run;

*read in EPA Data (1).csv;
data hw7.epadata2;
    infile RawData("EPA Data (1).csv") firstobs = 2 dlm = ',';
    input date2 mmddyy8. siteid poc mean aqi count AqsCode;
run;


*read in EPA Data (2).csv;
data hw7.epadata3;
    infile RawData("EPA Data (2).csv") firstobs = 6 dlm = ',' truncover dsd;
    input siteid AqsCode poc @;
    do date1 = 1 to 244;
        input mean aqi count @;
        output;
       * if count eq . then i = i + 1;
    end;
run;

*combine the datasets without SAS dates;
data hw7.concat (drop = i month day date1 year OldNames date2 rename = (mean = aqs));
    set hw7.epadata3 (in = a) hw7.epadata1 (in = b) hw7.pm10 (in = c) hw7.epadata2 (in = d);
        length aqsabb $4.;
        if a = 1 then aqsabb = "CO";
        if b = 1 then aqsabb = "SO2";
        if c = 1 then aqsabb = "PM10";
        if d = 1 then aqsabb = "O3";
        if c = 1 then date1 = input(compress(OldNames,,'kd'),8.);
        year = 2019;
            if (date1 <= 31) then month = 1;
                else if (32 <= date1 <= 59) then month = 2;
                else if (60 <= date1 <= 90) then month = 3;
                else if (91 <= date1 <= 120) then month = 4;
                else if (121 <= date1 <= 151) then month = 5;
                else if (152 <= date1 <= 181) then month = 6;
                else if (182 <= date1 <= 212) then month = 7;
                else if (213 <= date1 <= 243) then month = 8;
                else if (244 <= date1 <= 273) then month = 9;
                else if (274 <= date1 <= 304) then month = 10;
                else if (305 <= date1 <= 334) then month = 11;
                else if (335 <= date1 <= 365) then month = 12;
            if  (date1 <= 31) then day = date1;
                else if (32 <= date1 <= 59) then day = date1 - 31;
                else if (60 <= date1 <= 90) then day = date1 - 59;
                else if (91 <= date1 <= 120) then day = date1 - 90;
                else if (121 <= date1 <= 151) then day = date1 - 120;
                else if (152 <= date1 <= 181) then day = date1 - 151;
                else if (182 <= date1 <= 212) then day = date1 - 181;
                else if (213 <= date1 <= 243) then day = date1 - 212;
                else if (244 <= date1 <= 273) then day = date1 - 243;
                else if (274 <= date1 <= 304) then day = date1 - 273;
                else if (305 <= date1 <= 334) then day = date1 - 304;
                else if (335 <= date1 <= 365) then day = date1 - 334;
        do i = 1 to 1505;
            date = mdy(month, day, year);
        end;
        if date eq . then date = date2;
        where count is not missing;
        StCode = input(substr(siteid, 4, 2),8.);
        CountyCode = input(substr(siteid, 6,3),8.);
        SiteNum = input(substr(siteid, 9,4),8.);
    run;


*sort the dataset for merging;
proc sort data = hw7.concat out = hw7.concat1;
    by stcode countycode sitenum;
run;

proc sort data = inputds.methods out = hw7.methods1;
    by aqscode;
run;


*horizontally combine the other dataset by aqscode;
data hw7.combined;
    merge hw7.concat1 (in = a) inputds.aqssites (in = b);
    by stcode countycode sitenum;
    if a = 1 and b = 1;
run;

*sort the data again;
proc sort data = hw7.combined out = hw7.combined1;
    by aqscode;
run;

*horizontally combine the next data set and get the complete descriptor portion;
data hw7.FinalLaRusso (drop = StCode CountyCode SiteNum CBSAName);
    attrib date format = yymmdd10. label = "Observation Date"
           siteid label = "Site ID"
           poc label = "Parameter Occurance Code (Instrument Number within Site and Parameter)"
           aqscode label = "AQS Parameter Code"
           parameter length = $50. label = "AQS Parameter Name"
           aqsabb length = $4. label = "AQS Parameter Abbreviation"
           aqsdesc length = $40. label = "AQS Measurement Description"
           aqs label = "AQS Observed Value"
           aqi label = "Daily Air Quality Index Value"
           aqidesc length = $30. label = "Daily AQI Category"
           count label = "Daily AQS Observations"
           percent label = "Percent of AQS Observations (100*Observed/24)"
           mode length = $50. label = "Measurement Mode"
           collectdescr length = $50. label = "Description of Collection Process"
           analysis length = $50. label = "Analysis Technique"
           mdl label = "Federal Method Detection Limit"
           localName length = $50. label = "Site Name"
           lat label = "Site Latitude"
           long label = "Site Longitude"
           stabbrev length = $50. label = "State Abbreviation"
           countyname length = $50. label = "County Name"
           cityname length = $50. label = "City Name"
           estabdate format = yymmdd10. label = "Site Established Date"
           closedate format = yymmdd10. label = "Site Closed Date"
           ;
    merge hw7.combined1 (in = a) hw7.methods1 (in = b);
    by aqscode;
        if a = 1 and b = 1;
        if aqsabb = "CO" then aqsdesc = "Daily Max 8-hour CO Concentration";
        if aqsabb = "SO2" then aqsdesc = "Daily Max 1-hour SO2 Concentration";
        if aqsabb = "O3" then aqsdesc = "Daily Max 8-hour Ozone Concentration";
        if aqsabb = "PM10" then aqsdesc = "Daily Mean PM10 Concentration";
        if aqi le 50 then aqidesc = "Good";
        if aqi gt 50 then aqidesc = "Moderate";
        cityname = scan(CBSAName, 1, ',');
        stabbrev = scan(CBSAName, 2, ',');
        percent = round((100*count)/24);
        collectdescr = propcase(collectdescr);
        analysis = propcase(analysis);
run;

*get the subset of the data where percent is 100;
data hw7.FinalLaRusso100;
    set hw7.FinalLaRusso;
    where percent = 100;
run;

*make dataset of my descriptor portion of finallarusso;
ods trace on;
ods select position;
proc contents data = hw7.FinalLaRusso varnum;
    ods output position = hw7.FinalLaRussodesc;
run;
ods trace off;


*compare the descriptor portion of Duggin's dataset to mine;
proc compare base = results.hw7dugginsdescnew (drop = member) compare = hw7.FinalLaRussodesc (drop = member) out = hw7.differentdesc
    outdiff outbase outcompare outnoequal method = absolute criterion = 1E-9;
run;

*compare the content portion of Duggins' dataset to mine;
proc compare base = results.hw7FinalDugginsnew compare = hw7.FinalLaRusso out = hw7.differentcontent
    outdiff outbase outcompare outnoequal method = absolute criterion = 1E-9;
run;

*quit the program;
quit;
