/*
Author: Mallory LaRusso
Class: ST 445 (001)
Date: 2019-10-23
Purpose: ST 445 Programming Homework 5
*/

*get stored data sets and save them in the InputDS library - set fileref called RawData;
x "cd L:\st445\Data";
libname InputDS ".";
filename RawData ".";

*library of duggins' results to compare against;
x "cd L:\st445\Results";
libname duggins ".";

*create local library for my saved datasets called hw5.;
x "cd \\wolftech.ad.ncsu.edu\cos\stat\Redirect\mhlaruss\Desktop\SAS\Homework 5";
libname hw5 ".";
filename hw5 ".";

*use global options (find the formats, no date);
options fmtsearch = (hw5) nodate;

*close ods listing;
ods listing close;

*read in metro2.txt dataset with correct attributes;
data hw5.metro2 (drop = tempstate tempMortgage_Status tempMortgage_Status1 tempcitypop tempmortgage_payment
 temphh_income temphome_value);
    infile rawdata("metro2.txt") dsd;
    attrib Serial label = "Household Serial Number"
           CountyFIPS label = "County FIPS Number"
           Metro label = "Metro Status"
           CityPop label = "City Population (in 100s)" format = comma6.
           Mortgage_Payment label = "Monthly Mortgage Payment" format = dollar6.
           HH_income label = "Household Income" format = dollar10.
           Home_Value label = "Home Value" format = dollar10.
           State length = $57. label = "State, District, or Territory"
           City length = $43. label = "City Name"
           Mortgage_Status length = $45. label = "Mortgage Status"
           Ownership length = $6. label = "Ownership Status"
           tempMortgage_Status length = $45.
           tempstate length = $57.
           tempMortgage_Status1 length = $45.
           temphome_value length = $12.
           temphh_income length = $12.;
    input serial countyfips tempcitypop $ tempmortgage_payment $ temphh_income $ temphome_value $ 
    tempstate $ tempMortgage_Status $ city $ ownership &$;
    state = propcase(tempstate);
    if tempMortgage_Status = "N / A" then tempMortgage_Status1 = compress(tempMortgage_Status);
    else tempMortgage_Status1 = tempMortgage_Status;
    Mortgage_Status = propcase(tempMortgage_Status1);
    CityPop = input(tempcitypop, comma6.);
    Mortgage_Payment = input(tempmortgage_payment, dollar6.);
    HH_Income = input(temphh_income, dollar10.);
    home_value = input(temphome_value, dollar10.);
    if home_value = 9999999 then home_value = .;
    Metro = 2;
run;

*read in metro3.txt with correct attributes;
data hw5.metro3 (drop = tempstate tempMortgage_Status tempMortgage_Status1 tempcitypop tempmortgage_payment
 temphh_income temphome_value);
    infile rawdata("metro3.txt") dsd;
    attrib Serial label = "Household Serial Number"
           CountyFIPS label = "County FIPS Number"
           Metro label = "Metro Status"
           CityPop label = "City Population (in 100s)" format = comma6.
           Mortgage_Payment label = "Monthly Mortgage Payment" format = dollar6.
           HH_income label = "Household Income" format = dollar10.
           Home_Value label = "Home Value" format = dollar10.
           State length = $57. label = "State, District, or Territory"
           City length = $43. label = "City Name"
           Mortgage_Status length = $45. label = "Mortgage Status"
           Ownership length = $6. label = "Ownership Status"
           tempMortgage_Status length = $45.
           tempstate length = $57.
           tempMortgage_Status1 length = $45.
           temphome_value length = $12.
           temphh_income length = $12.;
    input serial countyfips tempcitypop $ tempmortgage_payment $ temphh_income $ temphome_value $ 
    tempstate $ tempMortgage_Status $ city $ ownership &$;
    state = propcase(tempstate);
    if tempMortgage_Status = "N / A" then tempMortgage_Status1 = compress(tempMortgage_Status);
    else tempMortgage_Status1 = tempMortgage_Status;
    Mortgage_Status = propcase(tempMortgage_Status1);
    CityPop = input(tempcitypop, comma6.);
    Mortgage_Payment = input(tempmortgage_payment, dollar6.);
    HH_Income = input(temphh_income, dollar10.);
    home_value = input(temphome_value, dollar10.);
    if home_value = 9999999 then home_value = .;
    Metro = 3;
run;

*read in metro4.txt with correct attributes;
data hw5.metro4 (drop = tempstate tempMortgage_Status tempMortgage_Status1 tempcitypop tempmortgage_payment
 temphh_income temphome_value);
    infile rawdata("metro4.txt") dsd;
    attrib Serial label = "Household Serial Number"
           CountyFIPS label = "County FIPS Number"
           Metro label = "Metro Status"
           CityPop label = "City Population (in 100s)" format = comma6.
           Mortgage_Payment label = "Monthly Mortgage Payment" format = dollar6.
           HH_income label = "Household Income" format = dollar10.
           Home_Value label = "Home Value" format = dollar10.
           State length = $57. label = "State, District, or Territory"
           City length = $43. label = "City Name"
           Mortgage_Status length = $45. label = "Mortgage Status"
           Ownership length = $6. label = "Ownership Status"
           tempMortgage_Status length = $45.
           tempstate length = $57.
           tempMortgage_Status1 length = $45.
           temphome_value length = $12.
           temphh_income length = $12.;
    input serial countyfips tempcitypop $ tempmortgage_payment $ temphh_income $ temphome_value $ 
    tempstate $ tempMortgage_Status $ city $ ownership &$;
    state = propcase(tempstate);
    if tempMortgage_Status = "N / A" then tempMortgage_Status1 = compress(tempMortgage_Status);
    else tempMortgage_Status1 = tempMortgage_Status;
    Mortgage_Status = propcase(tempMortgage_Status1);
    CityPop = input(tempcitypop, comma6.);
    Mortgage_Payment = input(tempmortgage_payment, dollar6.);
    HH_Income = input(temphh_income, dollar10.);
    home_value = input(temphome_value, dollar10.);
    if home_value = 9999999 then home_value = .;
    Metro = 4;
run;

*sort the data correctly in order to interleave them;
proc sort data = inputds.metro0 out = hw5.metro00;
    by Serial State;
run;

proc sort data = inputds.metro1 out = hw5.metro01;
    by Serial State;
run;

proc sort data = hw5.metro2 out = hw5.metro02;
    by Serial State;
run;

proc sort data = hw5.metro3 out = hw5.metro03;
    by Serial State;
run;

proc sort data = hw5.metro4 out = hw5.metro04;
    by Serial State;
run;

*interleave the datasets with the correct attributes and add the metro variable for the sas datasets;
data hw5.LaRussoIpums2005;
attrib Serial label = "Household Serial Number"
           CountyFIPS label = "County FIPS Number"
           Metro label = "Metro Status"
           CityPop label = "City Population (in 100s)" format = comma6.
           Mortgage_Payment label = "Monthly Mortgage Payment" format = dollar6.
           HH_income label = "Household Income" format = dollar10.
           Home_Value label = "Home Value" format = dollar10.
           State label = "State, District, or Territory"
           City label = "City Name"
           Mortgage_Status label = "Mortgage Status"
           Ownership label = "Ownership Status";
set hw5.metro00 (in = a rename = (city=City citypop = CityPop countyfips = CountyFIPS 
    hh_income = HH_Income home_value = Home_Value mortgage_payment = Mortgage_Payment serial = Serial state = State))
    hw5.metro01 (in = b rename = (city=City citypop = CityPop countyfips = CountyFIPS 
    hh_income = HH_Income home_value = Home_Value mortgage_payment = Mortgage_Payment serial = Serial state = State)) 
    hw5.metro02 hw5.metro03 hw5.metro04;
by Serial State;
    if a = 1 then Metro = 0;
    if b = 1 then Metro = 1;
    State = propcase(State);
    if Mortgage_Status = "N / A" then Mortgage_Status = propcase(compress(Mortgage_Status));
        else Mortgage_Status = propcase(Mortgage_Status);
    if Home_Value = 9999999 then Home_Value = .;
    if Mortgage_Status = "Yes, Mortgaged/ Deed Of Trust Or Similar Debt" then Mortgage_Status = "Yes, mortgaged/ Deed of trust or similar debt";
    if Mortgage_Status = "No, Owned Free And Clear" then Mortgage_Status = "No, owned free and clear";
    if Mortgage_Status = "Yes, Contract To Purchase" then Mortgage_Status = "Yes, contract to purchase";
run;

*get a dataset with my descriptor portion;
ods trace on;
ods select position;
proc contents data = hw5.larussoipums2005 varnum;
    ods output position = hw5.larussoipums2005desc (drop = Member);
run;
ods trace off;

*compare the descriptor portion of my dataset to Dr. Duggins' data set;
proc compare base = duggins.hw5dugginsdesc compare = hw5.larussoipums2005desc out = hw5.differentdesc
    outdiff outbase outcompare outnoequal method = absolute criterion = 1E-9;
run;


*compare the content portion of my data set to Dr. Duggins' data set;
proc compare base = duggins.hw5dugginsipums2005 compare = hw5.larussoipums2005 out = hw5.differentcontent
    outdiff outbase outcompare outnoequal method = absolute criterion = 1E-9;
run;

*set new formats for the graphs;
proc format library = hw5;
    value met (fuzz = 0)
        0 = "Indeterminable"
        1 = "Not in a Metro Area"
        2 = "In Central/Principal City"
        3 = "Not in Central/Principal City"
        4 = "Central/Principal Indeterminable"
    ;

    value pop (fuzz=0) 
        0 -< 1000 = "Under 100k"
        1000 -< 5000 = "100k to 500k"
        5000 -< 10000 = "500k to 1M"
        10000 - high = "1M and Over"
    ;
quit;


*get data for the citypop graph;
ods trace on;
proc freq data = hw5.larussoipums2005;
    tables citypop*ownership / nocol nopercent nofreq;
    ods output crosstabfreqs = hw5.larussometrographdata;
    format citypop pop.;
run;
ods trace off;

*set the new output destinations for a pdf file, rtf file, and png;
ods graphics on;
ods listing;
ods rtf file = "HW5LaRussoReport.rtf";
ods pdf file = "HW5LaRussoReport.pdf";

*make the metro plot;
ODS GRAPHICS / RESET = INDEX IMAGENAME = "HW5LaRussoMetro" imagefmt = png;

footnote j = left "Metro classifications based on 2005 American Community Survey obtained from IPUMS";
proc sgplot data = hw5.larussoipums2005;
    hbar metro / response = hh_income group = ownership groupdisplay = cluster 
    stat = median;
        xaxis label = "Median Household Income" labelattrs = (size = 14pt) 
            values = (0 to 75000 by 15000) valuesformat = dollar10. offsetmax = 0
            grid gridattrs = (thickness = 3 color = gray55) valueattrs = (size = 12pt);
        yaxis display = (nolabel);
        keylegend / location = inside position = topright title = "Ownership Status" down = 2;
    format metro met.;
run;

footnote;

*make the citypop graph;
ODS GRAPHICS / RESET = INDEX IMAGENAME = "HW5LaRussoCityPop" imagefmt = png;

footnote j = left "City population categories include the left boundary value and exclude the right boundary value.";
proc sgplot data = hw5.larussometrographdata;
    vbar citypop / response = RowPercent group = ownership groupdisplay = stack;
    styleattrs datacolors = (lightpurple lightorange);
    xaxis label = "City Population (k=Thousand, M=Million)" labelattrs = (size = 16pt);
    yaxis label = "Ownership Percentage within Population Size" labelattrs = (size = 16pt) grid
        gridattrs = (thickness = 3 color = graydd) values = (0 to 100 by 10) valueattrs = (size = 14pt)
        offsetmax = .1;
    keylegend / title = "Ownership Status" titleattrs = (size = 12pt) 
        valueattrs = (size = 12pt) location = inside position = top down = 1;
    format citypop pop.;
run;
footnote;



*close pdf and rtf;
ods rtf close;
ods pdf close;

*restore listing;
ods listing;

*turn ods graphics off;
ods graphics off;

*quit program;
quit;


*differences in the results within the PDF, RTF, and PNG:
    All three of the output destinations have different fonts. 
    Because of the different fonts, the spacing is different.
    The RTF font seems to be Times New Roman. 
    The PDF font looks like Arial.
    The box around the graphs have different thickness and variation in shades of black
        (for example, the PNG has a consistent black border the whole time, whereas in the RTF the border is darker black for the x and y 
         axis, but more gray for the other two parts of the box that aren't lined up with an axis.
    It looks like the values on the x and y axis on the pdf are in bold, whereas on the png and rtf, these values do not seem to be bold.
;

