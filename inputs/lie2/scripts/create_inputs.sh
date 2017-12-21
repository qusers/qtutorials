#!/bin/csh
if (! -e *.top) then
   echo Topology not generated: You must run first Qprep
   exit
else if ($#argv != 1) then
 echo wrong number of arguments $#argv\; expected "1": protein or water
 exit
else
set wd=`pwd`
cp ../../inputs/$1/* .
set lig_num = `grep HETATM top_?.pdb|wc|gawk '{print $1}'` # HETATM records in the complex, corresponding to the ligand
if ($1 == "protein") then
set protein_num=3307 #ATOM records in the complex, corresponding to the protein
set suffix=p
set offset=203
else 
set protein_num=0
set suffix=w
set offset=1
endif
@ complex_num = $lig_num + $protein_num
foreach name (`ls eq*.inp`)
sed s/end/$complex_num/ $name > 1
mv 1 $name
end

sed s/num/$offset/ lig.fep > lig_${suffix}.fep
set num = 1
while ($num <= $lig_num)
echo $num" "$num >> lig_${suffix}.fep
@ num = $num + 1
end
rm *~ lig.fep
