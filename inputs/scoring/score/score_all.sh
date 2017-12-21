#!/bin/csh 
foreach lig (adm adn cam2 cma cqo dnc ebe tca tmc)
cd $lig
echo "Processing ligand $lig"
Qcalc5 < chemScore.inp > chemScore.log
Qcalc5 < XScore.inp > XScore.log
cd ..
end



