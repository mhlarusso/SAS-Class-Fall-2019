/*
Author: Mallory LaRusso
Class: ST 445 (001)
Date: 2019-10-30
Purpose: ST 445 Programming Homework 6
*/

*get stored data sets and save them in the InputDS library - set fileref called RawData;
x "cd L:\st445\Data";
libname InputDS ".";
filename RawData ".";

*library w/ duggins' data sets;
x "cd L:\st445\Results";
libname Results ".";

*create a library for hw5 so we can use the metro format later;
x "cd \\wolftech.ad.ncsu.edu\cos\stat\Redirect\mhlaruss\Desktop\SAS\Homework 5";
libname hw5 ".";

*set working directory and save results w/ libref and fileref in working directory;
x "cd \\wolftech.ad.ncsu.edu\cos\stat\Redirect\mhlaruss\Desktop\SAS\Homework 6";
libname hw6 ".";
filename hw6 ".";

*close ods listing so results don't appear anywhere;
ods listing close;

*global options so the date doesn't appear on our output;
options fmtsearch =(hw5) nodate;

*read in cities.txt correctly;
data hw6.cities (drop = city1);
    infile RawData("cities.txt") firstobs = 2 dlm = '09'x;
    attrib city1 length = $40. city length = $40.;
    input city1 citypop :comma6.;
    city = tranwrd(city1, '/', '-');
run;

*read in states.txt correctly;
data hw6.states;
    infile RawData("states.txt") firstobs = 2 dlm = '2009'x truncover;
    length state $40. city $40.;
    input Serial State $& City $28-73;
run;

*read in contract.txt correctly;
data hw6.contract;
    infile RawData("contract.txt") firstobs = 2 dlm = '09'x;
    input Serial Metro CountyFIPS $ MortPay :dollar6. HHI :dollar10. HomeVal :dollar10.;
run;

*read in mortgaged.txt correctly;
data hw6.mortgaged;
    infile RawData("mortgaged.txt") firstobs = 2 dlm = '09'x;
    input Serial Metro CountyFIPS $ MortPay :dollar6. HHI :dollar10. HomeVal :dollar10.;
run;

*stack mortaged, contract, inputds.freeclear and inputds.renters;
data hw6.combineddata;
    length MortStat $45.;
    set hw6.contract (in = c) inputds.freeclear hw6.mortgaged
        inputds.renters (in = r rename = (FIPS = CountyFIPS));
         if (r = 1) then ownership = "Rented";
            else ownership = "Owned";
        if (HomeVal = 9999999) then HomeVal = .R;
        if (c = 1) then MortStat = "Yes, contract to purchase";
            else if (HomeVal = .R) then MortStat = "N/A";
            else if (HomeVal ne .R and MortPay = 0) then MortStat = "No, owned free and clear";
            else if (MortPay > 0) then MortStat = "Yes, mortgaged/ deed of trust or similar debt";
run;


*sort the data correctly for merging;
proc sort data = hw6.combineddata out = hw6.combineddata0;
    by serial;
run;

proc sort data = hw6.cities out = hw6.cities0;
    by city;
run;

proc sort data = hw6.states out = hw6.states0;
    by city;
run;

*merge cities dataset and states dataset together (because cities dataset doesn't have serial variable);
data hw6.citystate;
    merge hw6.cities0 hw6.states0;
    by city;
run;

*sort the new dataset by serial;
proc sort data= hw6.citystate out = hw6.citystate0;
    by serial;
run;

*merge all datasets together with correct formats;
data hw6.larussoipums2005;
    attrib Serial label = "Household Serial Number"
           CountyFIPS label = "County FIPS Code" length = $3.
           Metro label = "Metro Status Code" 
           MetroDesc label = "Metro Status Description" length = $32.
           CityPop label = "City Population (in 100s)" format = comma6.
           MortPay label = "Monthly Mortgage Payment" format = dollar6.
           HHI label = "Household Income" format = dollar10.
           HomeVal label = "Home Value" format = dollar10.
           State label = "State, District, or Territory" length = $40.
           City label = "City Name" length = $40.
           MortStat label = "Mortgage Status" length = $45.
           Ownership label = "Ownership Status" length = $6.;
    merge hw6.citystate0 hw6.combineddata0;
    by serial;
        metrodesc = put(metro, $met.); *using met format from hw5 library;
   run;


*get dataset with my descriptor portion of hw6.larussoipums2005;
ods trace on;
ods select position;
proc contents data = hw6.larussoipums2005 varnum;
    ods output position = hw6.larussoipums2005desc (drop = Member);
run;
ods trace off;

*compare the descriptor portion of my dataset to Dr. Duggins' data set;
proc compare base = results.hw6dugginsdesc compare = hw6.larussoipums2005desc out = hw6.differentdesc
    outdiff outbase outcompare outnoequal method = absolute criterion = 1E-9;
run;


*compare the content portion of my data set to Dr. Duggins' data set;
proc compare base = results.hw6dugginsipums2005 compare = hw6.larussoipums2005 out = hw6.differentcontent
    outdiff outbase outcompare outnoequal method = absolute criterion = 1E-9;
run;

*open pdf;
ods pdf file = "HW6LaRussoReport.pdf" startpage = never;

*turn ods graphics on and change the width to 5.5 inches;
ods graphics on;
ODS GRAPHICS / WIDTH= 5.5in;

*get listing of households in NC w/ household income greater than 500,000 using proc report;
title "Listing of Households in NC with Incomes over $500,000";

proc report data = hw6.larussoipums2005;
    columns city metro mortstat hhi homeval;
    where hhi > 500000 and state = "North Carolina";
run;

title;

*proc univariate -- get specific output tables and graphs onto pdf for certian variables;
ods trace on;
proc univariate data = hw6.larussoipums2005;
    ods select Univariate.CityPop.BasicMeasures Univariate.CityPop.Quantiles 
               Univariate.CityPop.Histogram.Histogram
               Univariate.MortPay.Quantiles Univariate.HHI.BasicMeasures
               Univariate.HHI.ExtremeObs Univariate.HomeVal.BasicMeasures
               Univariate.HomeVal.ExtremeObs Univariate.HomeVal.MissingValues;
        var citypop mortpay hhi homeval;
        histogram citypop / kernel;
run;

*get a new page;
ods pdf startpage = now;

*create the first graph on page 6;


proc sgplot data = hw6.larussoipums2005;
    title "Distribution of City Population";
    title2 "(For Households in a Recognized City)";
    footnote j = left "Recognized cities have a non-zero value for City Population.";

    histogram citypop / scale = proportion;
    density citypop / type = kernel lineattrs = (color = orange thickness = 3);
    where citypop ne 0;

    keylegend / location=inside position=topright across=1;
    yaxis valuesformat = percent7. display = (nolabel);


run;


title;
title2;
footnote;


*make the second graph;
proc sgpanel data = hw6.larussoipums2005 NOAUTOLEGEND;
    title "Distribution of Household Income Stratified by Mortgage Status";
    footnote "Kernel estimate parameters were determined automatically.";
    panelby mortstat / NOVARNAME;
    histogram hhi /scale = proportion;
    density hhi / type = kernel lineattrs = (color = green);
    rowaxis display = (nolabel) valuesformat = percent7.;
run;

title;
footnote;

*close pdf;
ods pdf close;

*quit program;
quit;






