#!/bin/csh -f
if (! -e log.pml) then
echo "You must run structures.sh first, in order to create a pymol session. Doing that"
tcsh ../../../scripts/structures.sh 46
endif
cp log.pml log_resimp.pml
if (! -e res_Q.log) then
echo "You must run Qcalc first, doing that"
Qcalc5 < res_Q.inp > res_Q.log
tail -202 res_Q.log > res_Q.txt
endif
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
