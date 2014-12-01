#!/bin/csh -f
#
# Script to analyze calculations in Q with a docked ligand
#
# Hugo G- de Teran 2008
#
# Usage analyze.sh <ligand> <1st md_run> <2nd md_run>
#
# Energies of interaction for the LIE equation
#
perl ../../scripts/resultat.pl $2 $3
#
# Average structures
#
cp ../../inputs/protein/ave?.inp .
Qcalc5 < ave1.inp
Qcalc5 < ave2.inp 
cp ../../inputs/protein/rmsd.inp .
Qcalc5 < rmsd.inp
cat <<eof > rmsd.plt
set ylabel "rmsd"
set xlabel "time"
plot "Entropy.out" not w l
eof
gnuplot < rmsd.plt
#
# Non bonded monitor
#
cp ../../inputs/protein/res_Q.inp .
Qcalc5 < res_Q.inp > res_Q.log
tail -202 res_Q.log > res_Q.txt
cp ../../scripts/log_$1.pml ./log_resimp.pml
# Electrostatic interactions
echo "sel el, none" >> log_resimp.pml
gawk '{if ($3 < -3 || $3 > 3) print "sel el, el or resi "$1}' res_Q.txt >> ./log_resimp.pml
echo "show sticks, el" >> ./log_resimp.pml
# vdW interactions
echo "sel vdw, none" >> log_resimp.pml
gawk '{if ($2 < -3 || $2 > 3) print "sel vdw, vdw or resi "$1}' res_Q.txt >> ./log_resimp.pml
echo "show sticks, vdw" >> ./log_resimp.pml
echo 'cmd.disable("vdw")' >> log_resimp.pml
echo 'cmd.delete("top")' >> log_resimp.pml
echo 'cmd.hide("(complex and hydro)")' >> log_resimp.pml
echo "show dots, vdw" >> log_resimp.pml
echo 'util.cba(6,"el")' >> log_resimp.pml

pymol log_resimp.pml

