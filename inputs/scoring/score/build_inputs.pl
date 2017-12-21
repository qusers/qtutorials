#!/usr/bin/perl
#=======

#by Martin Nervall, 2004

use Getopt::Long;
GetOptions("h|help");

#change theese variables to customize setup
$root="/ibg/courses/1MB280/workshop2005/SCORE/";
@ligs= ("adm", "adn", "cam2", "cma", "cqo", "dnc", "ebe", "tca", "tmc");  





foreach $lig (@ligs) {
    chdir("${root}");
    chdir("${lig}");
    system("pwd");
    $libFiles = "LIB_FILES /ibg/courses/1MB280/workshop2005/SCORE/lib/Qoplsaa.lib; /ibg/courses/1MB280/workshop2005/SCORE/lib/${lig}.lib; /ibg/courses/1MB280/workshop2005/SCORE/lib/heme.lib\n";    
    #Make topology
    open(INPUT, "<../chemscore_template.inp") || \
	die("<../chemscore_template.inp"); #open for reading
    open(OUTPUT, ">chemScore.inp"); #open for writing
    while(<INPUT>){
	s/ligand/${lig}/;
	print OUTPUT;
    }
    close INPUT;
    close OUTPUT;
    
     open(INPUT, "<../xscore_template.inp") || \
	die("<../xscore_template.inp"); #open for reading
    open(OUTPUT, ">XScore.inp"); #open for writing
    while(<INPUT>){
	s/ligand/${lig}/;
	print OUTPUT;
    }
    close INPUT;
    close OUTPUT;
    
    system("mv ${lig}.top tmp");
    open(INPUT, "<tmp") || \
	die("tmp"); #open for reading
    open(OUTPUT, ">${lig}.top"); #open for writing
    while(<INPUT>){
	if (/^LIB_FILES/){
	    $_ = $libFiles;
	}
	print OUTPUT;
    }
    close INPUT;
    close OUTPUT;
    system("rm tmp");
}







