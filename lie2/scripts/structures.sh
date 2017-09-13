#!/bin/csh -f
# requires argument lig_name
if ($#argv != 1) then
   echo wrong number of arguments $#argv\; expected "1"
   echo Usage:    structures.sh ligand_code
   exit
else
set  wd=`pwd`
cp ../../inputs/protein/re2pdb.inp .
Qprep5 < re2pdb.inp
cp ../../scripts/log_$1.pml ./log.pml
pymol log.pml

