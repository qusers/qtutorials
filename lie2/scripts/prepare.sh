#!/bin/csh -f
#
# Script to prepare the protein 2BAN for calculations in Q with a docked ligand
#
## Hugo G. de Teran 2008
if ($#argv != 2) then
   echo wrong number of arguments $#argv\; expected "2"
   echo Usage:    prepare.sh ligand_code docking_pose
   exit
else
set  wd=`pwd`
## Shrink a sphere of residues with at least one atom within 20A of the ligand 
echo "ligand "$1 "docking pose " $2
cat << eof > prepare.pml
load 2ban.pdb
sel prot_20A, br. not resn 357 within 20 of resn 357 
save prot.pdb, prot
q
eof
pymol prepare.pml
## Substitute TER by GAP
gawk '{if ($1=="TER" || $1=="END") print "GAP"; else print $0}' prot.pdb > 1
## Eliminate chain ID
sed 's/ A /   /' 1 | sed 's/ B /   /' > prot.pdb
## HISTIDINES and titrable residues protonation
sed 's/HIS/HID/' prot.pdb | sed 's/ASP/ASH/' | sed 's/GLU/GLH/' | sed 's/ARG/ARN/' | sed 's/LYS/LYN/' > 1
## Now "mutate" incomplete residues in the PDB, far from the ligand, to ALA
sed 's/LYN   220/ALA   220/' 1 | sed 's/HID   221/ALA   221/'| sed 's/GLN   222/ALA   222/' | sed 's/LYN   323/ALA   323/'> prot.pdb
## Turn on charges of residues within the sphere
sed 's/LYN   101/LYS   101/' prot.pdb | sed 's/LYN   102/LYS   102/' | sed 's/LYN   103/LYS   103/'| sed 's/LYN   172/LYS   172/' > 1
sed 's/ASH   192/ASP   192/' 1 | sed 's/ASH   186/ASP   186/' | sed 's/ASH   237/ASP   237/'| sed 's/GLH   138/GLU   138/' > prot.pdb
rm 1
#
## Now prepare the ligand
if (-e lig${1}_dk${2}) then 
rm -rf lig${1}_dk${2}
endif
mkdir lig${1}_dk${2}
perl scripts/adk${1}2Q.pl -l lig${1}_dk${2}.pdb -o lig${1}_dk${2}/lig_w.pdb
## Prepare the complex
mkdir lig${1}_dk${2}/protein
cat prot.pdb lig${1}_dk${2}/lig_w.pdb > lig${1}_dk${2}/protein/lig_p.pdb
## run Qprep
cd lig${1}_dk${2}/protein
cp ../../inputs/protein/maketop_p.inp .
#Qprep5 < maketop_p.inp > maketop_p.log
##prepare inputs
#tcsh ../../scripts/create_inputs.sh protein
#
# Prepare the water run
cd ../
mkdir water
cp lig_w.pdb water
cd ./water
# Run Qprep
cp ../../inputs/water/maketop_w.inp .
#Qprep5 < maketop_w.inp > maketop_w.log
##prepare inputs
#tcsh ../../scripts/create_inputs.sh water
