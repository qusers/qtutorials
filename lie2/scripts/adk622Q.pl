#!/usr/bin/perl
#lig2q_1m
#=======

#by Martin Nervall, 2004

#Translate from GOLD solution to Q compatible format


#usage
#lig2q_1m

#-l=<filename>         :ligand from gold file name
#-m=<filename>         :macro molecule file name
#-o=<filename>         :outfile name
#-h                    :help


$endhelp = __LINE__-1;
($mypath) = __FILE__ =~/(.*)\/resultat/;

use Getopt::Long;
GetOptions("h|help", "l=s", "m=s", "o=s");
$root=`pwd`;

if(defined($opt_h)) {
    system("head -$endhelp $0");
    exit;
}
if (!defined(${opt_o})){ #if -o not defined  .....
  print "Error: Outfile not defined!"; 
  exit;
}

if (defined(${opt_m})){ #if macro molecule defined  .....
open(OUTFILE,">${opt_o}") || die "Cannot open : ${opt_o}!\n";  
open(TMP,">tmp")|| die "Cannot open : tmp!\n";
}
else{
  open(TMP,">${opt_o}") || die "Cannot open : ${opt_o}!\n";  
}
open(INFILE,"<$opt_l") || die "Cannot open : ${opt_l}!\n";

#----------------------------------------------------------
# TH1 2-isopropyl-4-methyl(N-Methyl)amide-1,3-thiazol
#----------------------------------------------------------
while (<INFILE>){
$found=0;
$found += s/C1' 357 d    /C1  NKC   191/;
$found += s/C6B 357 d    /C2  NKC   191/;
$found += s/C5B 357 d    /C3  NKC   191/;
$found += s/C4' 357 d    /C4  NKC   191/;
$found += s/C3B 357 d    /C5  NKC   191/;
$found += s/C8' 357 d    /C51 NKC   191/;
$found += s/C2B 357 d    /C6  NKC   191/;
$found += s/C7' 357 d    /CL  NKC   191/;
$found += s/C4  357 d    /C7  NKC   191/;
$found += s/C5  357 d    /C8  NKC   191/;
$found += s/C10 357 d    /C81 NKC   191/;
$found += s/C11 357 d    /C82 NKC   191/;
$found += s/C6  357 d    /C9  NKC   191/;
$found += s/C7  357 d    /C91 NKC   191/;
$found += s/N1  357 d    /N10 NKC   191/;
$found += s/C2  357 d    /C11 NKC   191/;
$found += s/O8  357 d    /O11 NKC   191/;
$found += s/C3  357 d    /C12 NKC   191/;
if ($found) {print(TMP);}
}
seek(INFILE,0,0); #rewinnd

#----------------------------------------------------------
# VAL valine
#----------------------------------------------------------
while (<INFILE>){
$found=0;
$found += s/N1' 357 d    /N12 S62   192/;
$found += s/C2' 357 d    /C1  S62   192/;
$found += s/C3' 357 d    /C2  S62   192/;
$found += s/O4' 357 d    /O3  S62   192/;
$found += s/C5' 357 d    /C4  S62   192/;
$found += s/C6' 357 d    /C5  S62   192/;
if ($found) {print(TMP);}
}
seek(INFILE,0,0); #rewinnd

#Merge macro molecule and ligand
if (defined(${opt_m})){ #if macro molecule defined  .....
open(MACRO, "<${opt_m}") || die "Cannot open : ${opt_m}!\n";
$wat=0;
while (<MACRO>){
  $wat += /WAT|HOH/;
  if (${wat} == 0) {print(OUTFILE);}
}


if ($wat>0) {
  $_ = "GAP\n";
  print(OUTFILE);
  close(TMP);
  open(TMP, "<tmp"|| die "Cannot open : tmp!\n"); #open for reading
  while (<TMP>) {
    print(OUTFILE);
  }
  seek(MACRO,0,0);
  $wat=0;  
  while (<MACRO>){
    $wat += /WAT|HOH/;
    if (${wat} > 0) {print (OUTFILE);}
  }
}

system("rm -f tmp");
close(MACRO);
close(TMP);
}

close(INFILE);
close(OUTFILE);



