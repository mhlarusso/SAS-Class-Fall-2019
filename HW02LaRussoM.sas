*/
Name: Mallory LaRusso
Course: ST 445 (001)
Date: 2019-09-16
Description: ST 445 Programming Homework 2 */

*Set libraries, get baseball file;

x "cd L:\ST445\data";
libname InputDS ".";
filename baseball "baseball.dat";

*To get all of the formats in InputDS library;

options FMTSEARCH = (InputDS) NODATE;

*set working directory and library to save files;
x "cd \\wolftech.ad.ncsu.edu\cos\stat\Redirect\mhlaruss\Desktop\SAS\Homework 2";
libname hw2lib ".";
filename hw2file ".";

*close ods and write to pdf and rtf;
ods listing close;
ods rtf file = "HW 2 Baseball Report.rtf" style = Sapphire;
ods pdf file = "HW 2 Baseball Report.pdf" style = Journal;

*clear all titles and footnotes;
title;
title2;
footnote;
footnote2;

*read in data (save to hw2 library, use fileref, add lables and formats);
data hw2lib.baseball;
    infile baseball firstobs = 12 dlm = "2C09"x;
    length FName $9 LName $11 Team $13;
    input LName $ FName $ Team $ nAtBat 50-54 nHits 55-59 nHome 60-64 nRuns 65-69 nRBI 70-74 nBB 75-79
          YrMajor 80-84 CrAtBat 85-89 CrHits 90-94 CrHome 95-99 CrRuns 100-104 CrRbi 105-109 CrBB 110-114 League $115-122 Division $124-127
          Position $129-130 nOuts 133-137 nAssts 138-142 nError 143-147 Salary;
    attrib  FName label= "First Name"
            LName label= "Last Name"
            Team label= "Team at the end of 1986"
            nAtBat label= "# of At Bats in 1986"
            nHits label= "# of Hits in 1986"
            nHome label= "# of Home Runs in 1986"
            nRuns label= "# of Runs in 1986"
            nRBI label= "# of RBIs in 1986"
            nBB label= "# of Walks in 1986"
            YrMajor label= "# of Years in the Major Leagues"
            CrAtBat label= "# of At Bats in Career"
            CrHits label= "# of Hits in Career"
            CrHome label= "# of Home Runs in Career"
            CrRuns label= "# of Runs in Career"
            CrRbi label= "# of RBIs in Career"
            CrBB label= "# of Walks in Career"
            League label= "League at the end of 1986"
            Division label= "Division at the end of 1986"
            Position label= "Position(s) Played"
            nOuts label= "# of Put Outs in 1986"
            nAssts label= "# of Assists in 1986"
            nError label= "# of Errors in 1986"
            Salary label= "Salary (Thousands of Dollars)" format= dollar10.3
            ;

run;


*run proc contents, add to rtf and not pdf;
ods trace on;
ods pdf exclude all;
ods rtf exclude EngineHost;
ods rtf exclude Attributes;
title "The SAS System";
proc contents data = hw2lib.baseball varnum;
run;

*import the correct format for salary from the InputDS library;
proc format library = InputDS fmtlib;
    select salary;
run;


*put 5 number summaries based on league, division, and salary category on rtf and pdf;

title "Five Number Summaries of Selected Batting Statistics";
title2 h=10pt "Grouped by League (1986), Division (1986), and Salary Category (1987)";
ods pdf exclude none;
proc means data = hw2lib.baseball min p25 p50 p75 max nolabels maxdec = 2;
    class league division salary / missing;
    var nHits nHome nRuns nRBI nBB;
    format salary salary.;
run;
title;
title2;

*find the breakdown of positions and a two way table of position and salary;
title "Breakdown of Players by Position and Position by Salary";
proc freq data = hw2lib.baseball;
    tables position position*salary / missing;
    format salary salary.;
run;
title;

* sort the data so proc print will work;
proc sort data = hw2lib.baseball out = hw2lib.sortedbaseball;
    by league division team descending salary;
run;

*print 1986 players who made at least a million dollars or who played for Chicago Cubs;
title "Listing of Selected 1986 Players";
footnote j= l h = 8pt "Included: Players with Salaries of at least $1,000,000 or who played for the Chicago Cubs";
proc print data = hw2lib.sortedbaseball  label;
    where (Team in ("Chicago") and League in ("National")) or (Salary ge 1000);
    id LName FName Position;
    var league division team salary nHits nHome nRuns nRBI nBB;
    sum salary nHits nHome nRuns nRBI nBB;
    format salary dollar12.3 nHits comma5. nRuns comma5. nRBI comma5. nBB comma5.;
run;
title;
footnote;

*close pdf and rtf;
ods rtf close;
ods pdf close;

*restore listing;
ods listing;

*quit program;
quit;
