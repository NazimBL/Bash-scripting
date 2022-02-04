#!/bin/bash

#SBATCH --job-name=md_bnz_simulation                                                          
#SBATCH --partition=talon                                                       
#SBATCH --exclusive                                                             
#SBATCH --time=28-00:00:00                                                      
#SBATCH --nodes=1                                                               
#SBATCH --error=./err.txt                                                       
#SBATCH --output=./out.txt                                                     
#SBATCH --mail-type=NONE                                                       
#SBATCH --mail-user=nazim.belabbaci@ndus.edu                                                            

module load intel/mpi/64
module load intel/mkl/64
export FI_PROVIDER-tcp

tmp=298

echo "Show Time !!!"

# this is to edit md file to go through all temps
for j in {260,265,270,275,280,285,290,292,295,298,300,310,320,330}
do
    sed -i "s/$tmp/$j/g" md.mdp
    tmp=$j
#gromacs commands  
    /home/export/apps/gromacs-5.1.4-gpu/bin/gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o mdout_$j.tpr
    /home/export/apps/gromacs-5.1.4-gpu/bin/gmx mdrun -deffnm mdout_$j -v
done    

