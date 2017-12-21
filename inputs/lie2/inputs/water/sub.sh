#/bin/bash

cp /home/usc/fr/hgc/bin/Q_sini/Qdyn5p .
module load hp-mpi ifort/10.1.012 icc/10.1.012
mpirun -np $NSLOTS ./Qdyn5p eq1.inp > eq1.log
mpirun -np $NSLOTS ./Qdyn5p eq2.inp > eq2.log
mpirun -np $NSLOTS ./Qdyn5p eq3.inp > eq3.log
mpirun -np $NSLOTS ./Qdyn5p eq4.inp > eq4.log
mpirun -np $NSLOTS ./Qdyn5p eq5.inp > eq5.log
mpirun -np $NSLOTS ./Qdyn5p dc1.inp > dc1.log
mpirun -np $NSLOTS ./Qdyn5p dc2.inp > dc2.log
mpirun -np $NSLOTS ./Qdyn5p dc3.inp > dc3.log
mpirun -np $NSLOTS ./Qdyn5p dc4.inp > dc4.log
mpirun -np $NSLOTS ./Qdyn5p dc5.inp > dc5.log
