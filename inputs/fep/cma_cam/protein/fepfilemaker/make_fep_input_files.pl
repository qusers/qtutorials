#!/usr/bin/perl
# make_fep_input_files
#===============================================================================
# by Martin Almlof, 2004-09-24
# Make q input files for fep usage with different lambda spacing methods.
#===============================================================================

if ($#ARGV == -1){
	print "Usage:\n";
	print "make_fep_input_files template prefix l_start l_end method num_files format\n";
	print "Where:\n";
	print "  template is the filename of a template input file.\n";
	print "  prefix is the wanted filename prefix of the created input files.\n";
	print "  l_start is the starting lambda value of state 1.\n";
	print "  l_end is the final lambda value of state 2.\n";
	print "  method is the lambda spacing method:\n";
	print "      1: Linear spacing.\n";
	print "      2: Quadratic spacing with closer spacing at the end.\n";
	print "      3: Quadratic spacing with closer spacing at the start.\n";
	print "      4: S-formed spacing. (double quadratic)\n";
	print "  num_files is the wanted number of input files.\n";
	print "  format is the name format of the files:\n";
	print "      1: The files are named with sequential integers starting at 0.\n";
	print "      2: The files are named with the lambda of state 1.\n";
	print "\n";
	print 'The template file has to contain a "[lambdas]" section with dummy lambda'."\n";
	print 'values, e.g. "1.000  0.000". <- This is what this script searches for.'."\n";
	print "\n";
	exit;
}



$template=$ARGV[0];
$prefix=$ARGV[1];
$l_start=$ARGV[2];
$l_end=$ARGV[3];
$method=$ARGV[4];
$num_inputfiles=$ARGV[5];
$filenameformat=$ARGV[6];


#This pre_lambda will be used in the first input
#file for the name of the first restart file for lambda-named files
$pre_lambda = "-99";

open TEMPLATE, $template or die "Cannot open $template for read:$!";
open TMP_OUT, ">tmp_out" or die "Cannot open tmp_out for write:$!";

#make a temporary file identical to TEMPLATE to work with
while (<TEMPLATE>) {
	print TMP_OUT $_;
}
close TMP_OUT;

$current_file=0;

printf "%5s %7s %7s\n","File#","Lambda1","Lambda2";
while ($current_file < $num_inputfiles)
{

#Linear spacing
	if ($method eq 1)
	{
		$lambda = $l_start + $current_file*($l_end - $l_start)/($num_inputfiles-1);
	}

#Quadratic, closer spacing at end
	if ($method eq 2)
	{
		$lambda = -($l_end-$l_start)/(($num_inputfiles-1)*($num_inputfiles-1))*$current_file*$current_file+2*($l_end-$l_start)/($num_inputfiles-1)*$current_file + $l_start;


	}

#Quadratic, closer spacing at start
	if ($method eq 3)
	{

		$lambda = ($l_end - $l_start)/(($num_inputfiles-1)*($num_inputfiles-1))*$current_file*$current_file + $l_start;


	}

#S-curve. Actually a doubly quadratic curve. Close spacing at start and end
	if ($method eq 4)
	{
	#do method 3 on half of the files, then method 2

		$tmp_l_end = ($l_end+$l_start)/2;
		$tmp_l_start = $tmp_l_end;
		$tmp_num_files = ($num_inputfiles-1)/2;

		#print $tmp_num_files;
		$middle = sprintf("%d",$tmp_num_files);

		if ($current_file < ($tmp_num_files))
		{
			$lambda = ($tmp_l_end - $l_start)/(($tmp_num_files)*($tmp_num_files))*$current_file*$current_file + $l_start;
		}

		if ($current_file >= ($tmp_num_files))
		{
			$tmp_cur_file = $current_file - $tmp_num_files;
			$lambda = -($l_end-$tmp_l_start)/(($tmp_num_files)*($tmp_num_files))*$tmp_cur_file*$tmp_cur_file+2*($l_end-$tmp_l_start)/($tmp_num_files)*$tmp_cur_file + $tmp_l_start;
		}

	}


#Reformat the floats to 3 decimals
	$lambda = sprintf("%6.4f", $lambda);
	$lambda_2 = 1 - $lambda;
	$lambda_2 = sprintf("%6.4f", $lambda_2);

	printf "%5d   %6.4f   %6.4f\n",$current_file,$lambda,$lambda_2;



	if ($filenameformat eq 1)
		{
		$file_label = $current_file;
		$pre_file_label = $current_file - 1;
		}
	else
		{
		$file_label = 1000*$lambda;
		$file_label = sprintf("%04d", $file_label);
		$pre_file_label = sprintf("%04d", 1000*$pre_lambda);
		}

	$outfile = $prefix . $file_label . '.inp';
	open OUTFILE, ">$outfile" or die "Cannot open $outfile for write:$!";

	$current_file++;
	open TMP_IN, "tmp_out" or die "Cannot open tmp_out for read:$!";


#Write the outfile while replacing lambdas, restart file names etc. with the appropriate values
	while (<TMP_IN>)
	{
		s/\d\.\d+\s+\d\.\d+/$lambda   $lambda_2/;
		s/(trajectory.\s+).+\.dcd/\1$prefix$file_label\.dcd/;
		s/(restart.\s+).+\.re/\1$prefix$pre_file_label\.re/;
		s/(final.\s+).+\.re/\1$prefix$file_label\.re/;
		s/(energy.\s+).+\.en/\1$prefix$file_label\.en/;

		print OUTFILE $_;
	}

	close TMP_IN;

	$pre_lambda = $lambda;

}
