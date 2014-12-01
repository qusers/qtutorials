#!/bin/perl
use Math::Complex;

open(OUT,">plot.txt") || die"Cannot open: plot.txt\n";

my @temp;
my $lig;
my $previous;
my %experimental = (adm => -5.9,
		 adn => -7.4,
		 cam2 => -7.9,
		 cma => -5.91,
		 cqo => -6.54,
		 dnc => -5.57,
		 ebe => -5.52,
		 tca => -7.53,
		 tmc => -5.93); 
my %chemScore_top;
my %XScore_top;
my %chemScore_mean;
my %XScore_mean;
my %top;
my %mean;

my @ligs = ("adm", "adn", "cam2", "cma", "cqo", "dnc", "ebe", "tca", "tmc");

#foreach $lig (keys %experimental) { will not give right order!!
foreach $lig (@ligs) {
    chdir("$lig");
    print("extracting data from ligand ${lig}\n");
    open(IN,"<chemScore.log") || die"Cannot open: chemScore.log\n";
      while(<IN>) {
	  if (/^topology/){
	      (@temp) = split /\s+/;
	      $chemScore_top{$lig} = @temp[2]/4.184;
	  }
	  if (/^mean/){
	      (@temp) = split /\s+/;
	      $chemScore_mean{$lig} = @temp[2]/4.184;
	  }
      }
    close IN;
    open(IN,"<XScore.log") || die"Cannot open: XScore.log\n";
      while(<IN>) {
	  if (/Help for reading coordinate files/){
	      (@temp) = split(/\s+/, $previous);
	      $XScore_top{$lig} = -0.001988*300*ln(10**@temp[7]);
	  }
	  if (/^processed frames:/){
	      $_ = <IN>;
	      (@temp) = split(/\s+/);
	      $XScore_mean{$lig} = -0.001988*300*ln(10**@temp[7]);
	  }
	  $previous = $_;
      }
    close IN;
    chdir("..");
    $top{$lig} = ($chemScore_top{$lig} + $XScore_top{$lig})/2;    
    $mean{$lig} = ($chemScore_mean{$lig} + $XScore_mean{$lig})/2;

    print OUT  $experimental{$lig}," ", $top{$lig}," ", $mean{$lig},"\n"
}
print "done!\n"

