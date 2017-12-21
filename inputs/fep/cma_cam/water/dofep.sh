#!/bin/bash
#set -x
#trap read debug
case "$1" in
(clean)
################################################################################
# CLEAN: A clean function to remove .dcd, .out, .en, and all other files which 
# need to be removed for a rerun.
################################################################################  
rm -f *.dcd *.out *.en *.re *.log
exit 1
;;


(run)
################################################################################
# The path to Q binaries are setup in the next line.
################################################################################
export bindir=/Users/esguerra/software/qsource/development/esguerra/bin

################################################################################
# TOPOLOGY: Generate topology using qprep.
################################################################################
$bindir/qprep < generate.inp > generate.log
#$bindir/qprep < qprep_post_proq.inp > qprep_post_proq.log
#$bindir/qprep < qprep_masked.inp > qprep_masked.log

################################################################################
# HEATING AND EQUILIBRATION
################################################################################
for i in $(seq -w 1 1 5)
do
    echo "Running equilibration step "$i
    time mpirun -np 8 $bindir/qdynp eq$i.inp > eq$i.log
    echo " "
done


################################################################################
# FEP-US. Notice that the lambda-step is smaller at the tails.
################################################################################
for j in $(seq 0 1 30)
do
    echo "Running FEP window "$j
    time mpirun -np 8 $bindir/qdynp fepstep$j.inp > fepstep$j.log
done

echo "Analyzing FEP results"
time $bindir/qfep < qfep.inp > qfep.log

################################################################################
# Transform dcd format to concatenated pdb format using catdcd
################################################################################
#catdcd -o fepstep30.pdb -otype pdb -s cma_prepped_final.pdb -stride 1 fepstep30.dcd



    exit 0
    ;;
  (*)
    echo "Usage: $0 {clean|run}"
    exit 2
    ;;
esac
