/*
Author: Mallory LaRusso
Class: ST 445 (001)
Date: 2019-10-14
Purpose: ST 445 Programming Homework 4
*/

*get stored data sets and save them in the InputDS library - set fileref called RawData;
x "cd L:\st445\Data";
libname InputDS ".";
filename RawData ".";

*library w/ duggins' data sets;
x "cd L:\st445\Results";
libname duggins ".";

*set working directory and save results w/ libref and fileref in working directory;
x "cd \\wolftech.ad.ncsu.edu\cos\stat\Redirect\mhlaruss\Desktop\SAS\Homework 4";
libname hw4 ".";
filename hw4 ".";

*read in leadprojects.txt and clean dataset;
data hw4.leadprojects (drop = tempstname tempjobid tempregion jobid1 dateregion pol tempequipment temppersonnel);
    infile rawdata("leadprojects.txt") dsd firstobs =2 truncover;
    length dateregion $13. StName $2. Region $9. JobID 8. Date 8. PolType $4.;
    input tempstname $ tempjobid $ dateregion $ pol $ tempequipment $ temppersonnel $;
    tempregion = put(compress(dateregion,, 'ka'), $9.);
    Region = propcase(tempregion);
    StName = upcase(tempstname);
    jobid1 = tranwrd(tempjobid,'O','0');
    JobID = input(tranwrd(jobid1, 'l', '1'), 8.);
    Date = input(compress(dateregion,, 'kd'), 8.);
    PolType = put(compress(pol,, 'ka'), $4.);
    PolCode = compress(pol,, 'kd');
    Equipment = input(tempequipment, dollar11.);
    Personnel = input(temppersonnel, dollar11.);
    JobTotal = Personnel + Equipment;
    attrib StName label = "State Name"
           Date format = date9.
           PolType label = "Pollutant Name"
           PolCode label = "Pollutant Code"
           Equipment format = dollar11.
           Personnel format = dollar11.
           JobTotal format = dollar11.
    ;
    list;
run;

*read in o3projects.txt and clean dataset;
data hw4.O3Projects (drop = tempstname tempjobid tempregion jobid1 dateregion pol tempequipment temppersonnel);
    infile rawdata("O3Projects.txt") dsd firstobs =2 truncover;
    length dateregion $13. StName $2. Region $9. JobID 8. Date 8. PolType $4.;
    input tempstname $ tempjobid $ dateregion $ pol $ tempequipment $ temppersonnel $;
    tempregion = put(compress(dateregion,, 'ka'), $9.);
    Region = propcase(tempregion);
    StName = upcase(tempstname);
    jobid1 = tranwrd(tempjobid,'O','0');
    JobID = input(tranwrd(jobid1, 'l', '1'), 8.);
    Date = input(compress(dateregion,, 'kd'), 8.);
    PolType = substr(pol, 2,3);
    PolCode = substr(pol, 1,1);
    Equipment = input(tempequipment, dollar11.);
    Personnel = input(temppersonnel, dollar11.);
    JobTotal = Personnel + Equipment;
    attrib StName label = "State Name"
           Date format = date9.
           PolType label = "Pollutant Name"
           PolCode label = "Pollutant Code"
           Equipment format = dollar11.
           Personnel format = dollar11.
           JobTotal format = dollar11.
    ;
    list;
run;

*read in COProjects.txt and clean dataset;
data hw4.COProjects (drop = tempstname tempjobid tempregion jobid1 dateregion pol tempequipment temppersonnel);
    infile rawdata("COProjects.txt") dsd firstobs =2 truncover;
    length dateregion $13. StName $2. Region $9. JobID 8. Date 8. PolType $4.;
    input tempstname $ tempjobid $ dateregion $ pol $ tempequipment $ temppersonnel $;
    tempregion = put(compress(dateregion,, 'ka'), $9.);
    Region = propcase(tempregion);
    StName = upcase(tempstname);
    jobid1 = tranwrd(tempjobid,'O','0');
    JobID = input(tranwrd(jobid1, 'l', '1'), 8.);
    Date = input(compress(dateregion,, 'kd'), 8.);
    PolType = put(compress(pol,, 'ka'), $4.);
    PolCode = compress(pol,, 'kd');
    Equipment = input(tempequipment, dollar11.);
    Personnel = input(temppersonnel, dollar11.);
    JobTotal = Personnel + Equipment;
    attrib StName label = "State Name"
           Date format = date9.
           PolType label = "Pollutant Name"
           PolCode label = "Pollutant Code"
           Equipment format = dollar11.
           Personnel format = dollar11.
           JobTotal format = dollar11.
    ;
    list;
run;


*read in SO2Projects.txt and clean dataset;
data hw4.SO2Projects (drop = tempstname tempjobid tempregion jobid1 dateregion pol tempequipment temppersonnel);
    infile rawdata("SO2Projects.txt") dsd firstobs =2 truncover;
    length dateregion $13. StName $2. Region $9. JobID 8. Date 8. PolType $4.;
    input tempstname $ tempjobid $ dateregion $ pol $ tempequipment $ temppersonnel $;
    tempregion = put(compress(dateregion,, 'ka'), $9.);
    Region = propcase(tempregion);
    StName = upcase(tempstname);
    jobid1 = tranwrd(tempjobid,'O','0');
    JobID = input(tranwrd(jobid1, 'l', '1'), 8.);
    Date = input(compress(dateregion,, 'kd'), 8.);
    PolType = substr(pol, 2,4);
    PolCode = substr(pol, 1,1);
    Equipment = input(tempequipment, dollar11.);
    Personnel = input(temppersonnel, dollar11.);
    JobTotal = Personnel + Equipment;
    attrib StName label = "State Name"
           Date format = date9.
           PolType label = "Pollutant Name"
           PolCode label = "Pollutant Code"
           Equipment format = dollar11.
           Personnel format = dollar11.
           JobTotal format = dollar11.
    ;
    list;
run;

*read in TSPProjects.txt and clean dataset;
data hw4.TSPProjects (drop = tempstname tempjobid tempregion jobid1 dateregion pol tempequipment temppersonnel);
    infile rawdata("TSPProjects.txt") dsd firstobs =2 truncover;
    length dateregion $13. StName $2. Region $9. JobID 8. Date 8. PolType $4.;
    input tempstname $ tempjobid $ dateregion $ pol $ tempequipment $ temppersonnel $;
    tempregion = put(compress(dateregion,, 'ka'), $9.);
    Region = propcase(tempregion);
    StName = upcase(tempstname);
    jobid1 = tranwrd(tempjobid,'O','0');
    JobID = input(tranwrd(jobid1, 'l', '1'), 8.);
    Date = input(compress(dateregion,, 'kd'), 8.);
    PolType = put(compress(pol,, 'ka'), $4.);
    PolCode = compress(pol,, 'kd');
    Equipment = input(tempequipment, dollar11.);
    Personnel = input(temppersonnel, dollar11.);
    JobTotal = Personnel + Equipment;
    attrib StName label = "State Name"
           Date format = date9.
           PolType label = "Pollutant Name"
           PolCode label = "Pollutant Code"
           Equipment format = dollar11.
           Personnel format = dollar11.
           JobTotal format = dollar11.
    ;
    list;
run;

*sort all of the data sets by region, stname, and descending jobtotal;
proc sort data = hw4.leadprojects;
    by region stname descending jobtotal;
run;

proc sort data = hw4.o3projects;
    by region stname descending jobtotal;
run;

proc sort data = hw4.coprojects;
    by region stname descending jobtotal;
run;

proc sort data = hw4.so2projects;
    by region stname descending jobtotal;
run;

proc sort data = hw4.tspprojects;
    by region stname descending jobtotal;
run;

*interleave the datasets;
data hw4.LaRussoProjects;
    set hw4.leadprojects hw4.o3projects hw4.coprojects hw4.tspprojects hw4.so2projects;
    by region stname descending jobtotal;
run;


*compare content portion of my data set to Dr. Duggins';
ods trace on;
proc compare base = duggins.hw4dugginsprojects compare = hw4.LaRussoProjects out = hw4.differentcontent
    method = absolute criterion = 1E-10 outbase outcompare outdiff outnoequal;
run;

*make dataset w/ descriptor portion of my dataset;
ods trace on;
ods select position;
proc contents data = hw4.larussoprojects varnum;
    ods output position = hw4.larussodesc (drop = Member);
run;

*compare descriptor portions of my data set w/ Dr. Duggins';
proc compare base = duggins.hw4dugginsdesc compare = hw4.larussodesc out = hw4.differentdesc
    method = absolute criterion = 1E-10 outbase outcompare outdiff outnoequal;
run;

*get data for the graph;
proc means data = hw4.larussoprojects nonobs p90;
    class region poltype;
    var jobtotal;
    ods output summary = hw4.graph1data;
run;

*ods listing;
ods listing;

*set new destination output;
ods graphics on;
ods graphics / imagename = "Hw4Graph1" imagefmt = png;

*make the first graph;
proc sgplot data = hw4.graph1data;
    hbar region / response = jobtotal_p90 group = poltype groupdisplay = cluster 
    categoryorder = respdesc;
    xaxis label = "90th Percentile of Total Job Cost" values = (0 to 100000 by 20000) valueshint
          valuesformat = dollar11. grid;
    keylegend / location = outside position = right title = 'Pollutant Name';
run;

*get data for graph 2;
ods trace on;
proc freq data = hw4.larussoprojects;
    tables region*poltype / norow nofreq nopercent;
    ods output crosstabfreqs = hw4.graph2data;
run;


*set destination for new graph;
ods graphics / imagename = "Hw4Graph2" imagefmt = png;

*make the second graph;
proc sgplot data = hw4.graph2data;
    vbar poltype / response = colpercent group = region groupdisplay = cluster
    categoryorder = respdesc;
    styleattrs datacolors = (red yellow green orange purple blue);
    xaxis label = "Pollutant Name" labelattrs = (size = 16pt) valueattrs = (size = 14pt);
    yaxis label = "Region Percentage within Pollutant" grid gridattrs = (thickness = 3 color = graycc)
    values = (0 to 40 by 2.5) labelattrs = (size = 16pt) valueattrs = (size = 12pt);
    keylegend / location = inside position = topright across = 3 down = 2 title = 'Region' opaque;
    where colpercent is not missing; 
run;

*turn off ods graphics;
ods graphics off;

*quit program;
quit;


