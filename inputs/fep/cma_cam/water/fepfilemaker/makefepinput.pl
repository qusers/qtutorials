#!/usr/bin/perl
# makefepinput
# =======
# by Martin Almlof, 2004-10-24, small updates by Mauricio Esguerra 2015/05/24
# Make q input files for fep usage with different lambda spacing methods.

#print $#ARGV;

if ($#ARGV == -1){
  print "Usage:\n";
  print " makefepinput template prefix start end method num_files format [flex]\n";
  print " \n";
  print "Where:\n";
  print "   template:  the filename of a template input file.\n";
  print "   prefix:    the desired filename prefix of the created input files.\n";
  print "   start:     the starting lambda value of state 1.\n";
  print "   end:       the ending lambda value of state 1.\n";
  print "   method:    the lambda spacing method:\n";
  print "            1: Linear lambda spacing.\n";
  print "            2: Quadratic lambda spacing with closer spacing at the end.\n";
  print "            3: Quadratic lambda spacing with closer spacing at the start.\n";
  print "            4: S-formed lambda spacing. (double quadratic)\n";
  print "            If 'flex' is given then this will be the inflexion point of method 4\n";
  print "   num_files: the desired number of input files.\n";
  print "   format:    the extension name for the files:\n";
  print "       1: Files are named with sequential integers starting at 0.\n";
  print "       2: Files are named with the lambda of state 1.\n";
  print " \n";
  print ' The template file has to contain a "[lambdas]" section with dummy lambda'."\n";
  print ' values, e.g. "1.000  0.000". <- This is what this script searches for.'."\n";
  print " \n";
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

printf "%5s %9s %9s\n","File#","Lambda1","Lambda2";
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
                $tmp_num_files1 = ($num_inputfiles-1)/2;
                $tmp_num_files2 = $tmp_num_files1;

                if ($#ARGV == 7) {
                        $tmp_l_end = $ARGV[7];
                        $tmp_l_start = $tmp_l_end;
                        $tmp_num_files1 = ($num_inputfiles-1)*(1-$tmp_l_end);
                        $tmp_num_files2 = $num_inputfiles-$tmp_num_files1-1;
                }

                #print $tmp_num_files;
                #$middle = sprintf("%d",$tmp_num_files);

                if ($current_file < ($tmp_num_files1))
                {
                        $lambda = ($tmp_l_end - $l_start)/(($tmp_num_files1)*($tmp_num_files1))*$current_file*$current_file + $l_start;
                }

                if ($current_file >= ($tmp_num_files1))
                {
                        $tmp_cur_file = $current_file - $tmp_num_files1;
                        $lambda = -($l_end-$tmp_l_start)/(($tmp_num_files2)*($tmp_num_files2))*$tmp_cur_file*$tmp_cur_file+2*($l_end-$tmp_l_start)/($tmp_num_files2)*$tmp_cur_file + $tmp_l_start;
                }

        }

#Reformat the floats to 6 decimals
        $lambda = sprintf("%9.7f", $lambda);
        $lambda_2 = 1 - $lambda;
        $lambda_2 = sprintf("%9.7f", $lambda_2);

        printf "%5d   %9.7f   %9.7f\n",$current_file,$lambda,$lambda_2;



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
                s/^\s*\d\.\d+\s+\d\.\d+\s*$/$lambda   $lambda_2/;
                s/(trajectory.\s+).+\.dcd/\1$prefix$file_label\.dcd/;
                s/(restart.\s+).+\.re/\1$prefix$pre_file_label\.re/;
                s/(final.\s+).+\.re/\1$prefix$file_label\.re/;
                s/(energy.\s+).+\.en/\1$prefix$file_label\.en/;

                print OUTFILE $_;
        }

        close TMP_IN;

        $pre_lambda = $lambda;

}
