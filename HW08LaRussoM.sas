/*
Author: Mallory LaRusso
Class: ST 445 (001)
Date: 2019-11-25
Purpose: ST 445 Programming Homework 8
*/

*get stored data sets and save them in the InputDS library - set fileref called RawData;
x "cd L:\st445\Data";
libname InputDS ".";
filename RawData ".";

*library w/ duggins' data sets;
x "cd L:\st445\Results";
libname Results ".";

*set working directory and save results w/ libref and fileref in working directory;
x "cd \\wolftech.ad.ncsu.edu\cos\stat\Redirect\mhlaruss\Desktop\SAS\Homework 8";
libname hw8 ".";
filename hw8 ".";

*read in blood dataset;
data hw8.blood;
    infile RawData("blood.txt") firstobs = 2;
    input Subject BloodGroup $ AgeGroup $ WBC RBC CHOL;
    BloodGroup = upcase(BloodGroup);
    if (BloodGroup = "") then Review = "M";
        else if (AgeGroup = "") then Review = "M";
        else if (WBC = .) then Review = "M";
        else if (RBC = .) then Review = "M";
        else if (CHOL = .) then Review = "M";
        else if BloodGroup not in ("AB" "B" "A" "O") then Review = "Y";
        else if AgeGroup not in ("Young" "Old") then Review = "Y";
        else if (WBC < 4000 or WBC > 11000) then Review = "Y";
        else if (RBC < 4.0 or RBC > 6.1) then Review = "Y";
        else Review = "";
run;

*set options for the report;
options date;

*close ods listing;
ods listing close;

*set the outpit for the first report;
ods rtf file = "HW8 LaRusso Report 1.rtf";

*create the first report;
footnote "Header (n=5) of bloodwork data set.";
footnote2 "Only using records in need of a review.";

proc report data = hw8.blood (obs = 5) split = '*';
    columns subject wbc rbc chol review;
        define subject / display "Subject*Number";
        define wbc /display "White*Blood*Cells" format = comma5.;
        define rbc / display "Red*Blood*Cells" format = 3.1;
        define chol / display "Cholesterol*Level";
        define review / display "Review*Code";
run;
 
footnote;
footnote2;
title;
*close the rtf;
ods rtf close;

*create summary statistics for the secod report using ods output;
proc means data = hw8.blood mean median min max;
    ods output summary = hw8.summarystats;
    class bloodgroup;
    var wbc chol;
run;


*create rtf for report 2;
ods rtf file = "HW8 LaRusso Report 2.rtf";


*create report 2 using summary data;
title "WBC and Cholesterol Summarized by Blood Group";
title2 "(Ignoring Rhesus Factor)";

proc report data = hw8.summarystats (obs = 5) split = '*';
    columns bloodgroup wbc_mean wbc_median wbc_min wbc_max
            chol_mean chol_median chol_min chol_max;
    define bloodgroup / group "Blood*Group*(Ignoring*Rhesus*Factor)";
    define wbc_mean / display "Mean*White*Blood*Cell*Count" format = 7.2;
    define wbc_median / display "Median*White*Blood*Cell*Count" format = 6.1;
    define wbc_min / display "Minimum*White*Blood*Cell*Count";
    define wbc_max / display "Maximum*White*Blood Cell*Count";
    define chol_mean / display "Mean*Cholesterol*Level" format = 6.2;
    define chol_median / display "Median*Cholesterol*Level" format = 5.1;
    define chol_min / display "Minimum*Cholesterol*Cell Count";
    define chol_max / display "Maximum*Cholesterol*Cell Count";
run;

title;
title2;

*close the rtf for report 2;
ods rtf close;

*transpose the summary data using a data step and array statement;
data hw8.summarystats1 (drop = NObs);
    set hw8.summarystats;
    where BloodGroup in ("A" "AB" "B" "O" "BB");
    attrib variable length = $4.;
    array meano[*] wbc_mean chol_mean;
    array mediano[*] wbc_median chol_median;
    array min[*] wbc_min chol_min;
    array max[*] wbc_max chol_max;
    array vars[*] VName_:;
    
    do i = 1 to dim(meano);
        Means = meano[i];
        Medians = mediano[i];
        Minimum = min[i];
        Maximum = max[i];
        Variable = vars[i];
        output;
    end;
    drop wbc_mean wbc_median wbc_min wbc_max chol_mean chol_median chol_min chol_max VName_: i;
run;

*new options for report 3;
options nodate;

*create rtf for report 3;
ods rtf file = "HW8 LaRusso Report 3.rtf";

*create report 3 using proc report;
title "WBC and Cholesterol Summarized by Blood Group";
footnote "Note: Rhesus factor was not considered";

proc report data = hw8.summarystats1 split = '*';
    columns bloodgroup variable means medians minimum maximum;
    define bloodgroup / order "Blood*Group*(Ignoring*Rhesus*Factor)";
    define variable / display "Test Code";
    define means / display "Mean" format = 7.2;
    define medians / display "Median" format = 6.1;
    define minimum / display "Minimum" format = 6.1;
    define maximum / display "Maximum" format = 7.1;
run;

title;
footnote;


*close rtf for report 3;
ods rtf close;

*open the pdf for report 4;
ods pdf file = "HW8 LaRusso Report 4.pdf" columns = 4;

*create the three reports used for report 4;
title "Selected Summaries of WBC and Cholestorol";

proc report data = hw8.blood split = "*";
    columns subject wbc chol;
    where Review ne "";
    define subject / display "Subject*Number";
    define wbc / display "White*Blood*Cells" format = comma5.;
    define chol / display "Cholesterol*Level";
run;

*fix the columns and page number;
ods pdf columns = 1;
options pageno = 1;

*2nd report for report 4;

proc report data = hw8.summarystats (obs = 5) split = '*';
    columns bloodgroup wbc_mean wbc_median wbc_min wbc_max
            chol_mean chol_median chol_min chol_max;
    define bloodgroup / group "Blood*Group*(Ignoring*Rhesus*Factor)";
    define wbc_mean / display "Mean*White*Blood*Cell*Count" format = 7.2;
    define wbc_median / display "Median*White*Blood*Cell*Count" format = 6.1;
    define wbc_min / display "Minimum*White*Blood*Cell*Count";
    define wbc_max / display "Minimum*White*Blood*Cell*Count";
    define chol_mean / display "Mean*Cholesterol*Level" format = 6.2;
    define chol_median / display "Median*Cholesterol*Level" format = 5.1;
    define chol_min / display "Minimum*Cholesterol*Level";
    define chol_max / display "Maxiumum*Cholesterol*Level";
run;

*3rd report for report 4;

proc report data = hw8.summarystats1 split = '*';
    columns bloodgroup variable means medians minimum maximum;
    define bloodgroup / order "Blood*Group*(Ignoring*Rhesus*Factor)";
    define variable / display "Test Code";
    define means / display "Mean" format = 7.2;
    define medians / display "Median" format = 6.1;
    define minimum / display "Minimum" format = 6.1;
    define maximum / display "Maximum" format = 7.1;
run;


*close the pdf;
ods pdf close;

*quit the program;
quit;

