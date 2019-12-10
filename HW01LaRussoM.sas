/*
Author: Mallory LaRusso
Class: ST 445 (001)
Date: 2019-09-11
Purpose: ST 445 Programming Homework 1
*/

*Create a library called InputDS that points to the provided data sets in the L drive.;
x "cd L:\st445";
libname InputDS "Data";

*Create HW1 library and save datasets created in here;

x "cd \\wolftech.ad.ncsu.edu\cos\stat\Redirect\mhlaruss\Desktop\SAS\Homework 1";
libname HW1 ".";

* close listing;
ods listing close;

* clear all titles and footnotes that may have previously existed;
title;
title2;
footnote;
footnote2;

* set output destination;
ods pdf file = "HW01LaRussoM.pdf" style = meadow;

* add proc contents results of inputds.projects the pdf before sorting the data;
title "Descriptor Information Before Sorting";
proc contents data = inputds.projects varnum;
    ods exclude enginehost;
run;
title;

* sort projects and save to new hw1 library;
proc sort data = inputds.projects out = hw1.sortedprojects;
    by region descending pol_type stname;
run;


* add sorted projects proc contents to pdf;
title "Descriptor Information After Sorting";
proc contents data = hw1.sortedprojects varnum;
    ods exclude enginehost;
run;
title;

*print out the sorted table by region and polutant type with correct labels and formats;

title1 "Listing of Project-Level Costs";
title2 h=8pt "Including Region and Region by Polutant Totals";
proc print data = hw1.sortedprojects label noobs;
    by region pol_type;
    id region pol_type;
    var stname jobid date equipmnt personel jobtotal;
    label region = "Region"
        pol_type = "Polutant"
        stname = "State"
        date = "Date"
        equipmnt = "Equipment Cost"
        personel = "Personnel Cost"
        jobtotal = "Total Cost";
    format date yymmdd10. equipmnt dollar12. personel dollar12. jobtotal dollar12.;
    sum equipmnt personel jobtotal;
run;
title;

* make equipmnt numeric variable into categorical variable;

proc format;
    value equip(fuzz = 0) low - 10000 = "Tier 1"
                            10000 <- 15000 = "Tier 2"
                            15000 <- 30000 = "Tier 3"
                            30000 <- high = "Excessive"
;
run;

* means procedure on sorted data by region, pol_type, & equipmnt;

title "Selected Numerical Summaries of Personnel and Total Costs";
title2 h = 8pt "by Region, Polutant, and Equipment Cost Classification";
footnote j = left "Excluding Alaska and Hawaii";
footnote2 j  = left"Tier 1=Up to $10k, Tier 2=Up to $15k, Tier 3=Up to $30k, Excessive=Over $30k";

proc means data = hw1.sortedprojects n min q1 median q3 max maxdec = 2;
    class region pol_type equipmnt;
    var personel jobtotal;
    where stname not in ("AK" "HI");
    format equipmnt equip.;
run;

title;








* freq procedure on sorted data by region, region by polutant and region by equipment (3 seperate tables);

title "Frequency Breakdown of Regions, Region by Polutant";
title2 "and Region by Equipment Classification";
proc freq data = hw1.sortedprojects;
    tables region;
    tables region*pol_type;
    tables region*equipmnt / nocol;
    format equipmnt equip.;
    where stname not in ("AK" "HI");
    label region = "Region"
          pol_type = "Polutant"
          equipmnt = "Equipment Cost";
run;
title;


* close pdf and restore the listing;

ods pdf close;
ods listing;

*end program;

quit;


