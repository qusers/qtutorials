#!/bin/csh
perl extract.pl
gnuplot <<EOF 
set pointsize 2
set xlabel "Experimental values (kcal/mol)" 
set ylabel "Scored values, average of ChemScore and X-Score (kcal/mol)" 
plot [-8:-5] x notitle
replot "plot.txt" using 1:2 title "X-ray structure" , "plot.txt" using 1:3 title "MD trajectory" 

pause 10000
EOF



