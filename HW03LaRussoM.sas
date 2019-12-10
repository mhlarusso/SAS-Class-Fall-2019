/*
Author: Mallory LaRusso
Class: ST 445 (001)
Date: 2019-09-23
Purpose: ST 445 Programming Homework 3
*/

*get stored data sets and save them in the InputDS library;
x "cd L:\st445\Data";
libname InputDS ".";
filename RawData ".";

*refrence SasCars.textfile read in with a filename statement for later use;
filename cars "SasCars.textfile";

*set working directory and save results w/ libref and fileref in working directory;
x "cd \\wolftech.ad.ncsu.edu\cos\stat\Redirect\mhlaruss\Desktop\SAS\Homework 3";
libname hw3 ".";
filename hw3 ".";

*close ods listing and create PDF and RTF;
ods listing close;
ods pdf file = "HW3 Cars.pdf" style = journal;
ods rtf file = "HW3 Cars.rtf" style = sapphire;

*clear all titles and footnotes;
title;
title2;
footnote;
footnote2;

*options statement get no dates printed, set the specified linesize and the libraries to search for permanent formats;
options fmtsearch = (InputDS, hw3) NODATE linesize = 110;

*select position and sortedby tables in proc contents of sashelp.cars to pdf and rtf;
ods exclude EngineHost Attributes;
title "Selected Descriptor Portion of Sashelp.Cars";
proc contents data = sashelp.cars varnum;
run;
title;


*read in the data with correct informats and formats to hw3 library;
data hw3.carsval;
    infile cars firstobs = 9 dlm = '09'x;
    length Make $13 Model $40 Type $8 Origin $6 DriveTrain $5;
    input  Make : Model char40. +4 Invoice dollar8. MSRP dollar8. Type quote8. +2 Origin 6. DriveTrain : quote7.
           @100 MPG_City MPG_Highway Weight comma5. EngineSize Cylinders
           Horsepower Wheelbase Length;
    attrib MSRP format = dollar8.
           Invoice format = dollar8.
           EngineSize label = "Engine Size (L)"
           MPG_City label = "MPG (City)"
           MPG_Highway label = "MPG (Highway)"
           Weight label = "Weight (LBS)" format = comma5.
           Wheelbase label = "Wheelbase (IN)"
           Length label = "Length (IN)"
    ;
    list;
;

*sort the data by make, type, drivetrain and model;
proc sort data = hw3.carsval;
    by Make Type DriveTrain Model;
run;


* proc compare my data set w/ Dr. Duggins Data set and write to pdf and rtf;
title "Investigating Descriptor Portion Comparison between";
title2 "InputDS.Cars and Jonathan's Cars File";

proc compare base = inputds.sascars compare = hw3.carsval method = absolute criterion = 1E-10;
run;

title;
title2;


*print out fmtlib table to rtf for $makecat format provided in inputds library;
ods pdf exclude all;
title "Details of Provided Format";
proc format library = InputDS fmtlib;
    select $makecat;
run;
title;

*make custom format, save in hw3 library;
proc format library = hw3;
    value mpg(fuzz=0) low - 25 = "Low"
                  25 <- 35 = "Moderate"
                  35 <- high = "High"
                  ;
    value wt(fuzz=0)  low - 3000 = "Light"
                  3000 <- high = "Heavy"
;
run;

*make frequency tables using make, weight, mileage, and origin;
ods pdf exclude none;
title "Frequency Analysis Using Combinations of Make, Weight, Mileage, and Origin Variables";
proc freq data = hw3.carsval;
    table make;
    table make*weight / nocol norow;
    table make*mpg_city make*mpg_highway;
    table origin*make*weight / nopercent nocol;
    format make $makecat. weight wt. mpg_highway mpg. mpg_city mpg.;
run;
title;

*means procedure, find means of msrp and invoice using classes type and weight;
title "Confindence Interval for Mean Cost and Percentiles of Raw Cost Values";
proc means data = hw3.carsval nonobs n lclm mean uclm p10 p50 p90 alpha = .10;
    class type weight;
    var invoice msrp;
    format weight wt.;
run;
title;


*close pdf and rtf;
ods rtf close;
ods pdf close;

*restore ods listing;
ods listing;

*quit program;
quit;

