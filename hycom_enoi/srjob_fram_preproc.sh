#!/bin/bash -l

#SBATCH --account=nn9481k --qos=preproc
#SBATCH --job-name=preproc
#SBATCH -t 24:00:00
#SBATCH  --mail-type=END
#SBATCH --mail-user=bbackeberg@csir.co.za
#SBATCH -o preproc%J.out
#SBATCH -e preproc%J.err

export OMP_NUM_THREADS=1

## Recommended safety settings:
set -o errexit # Make bash exit on any error
set -o nounset # Treat unset variables as errors

## Software modules
module restore system
module load NCL/6.4.0-intel-2017a
module load FFTW/3.3.6-intel-2017a
module load ESMF/6.3.0rp1-intel-2017a-HDF5-1.8.18
source /nird/home/bjornb/NERSC-HYCOM-CICE/TP0a1.00/REGION.src

export PYTHONPATH=$PYTHONPATH:/nird/home/bjornb/.local/lib/python2.7/site-packages/abfile
export PYTHONPATH=$PYTHONPATH:/nird/home/bjornb/.local/lib/python2.7/site-packages/modeltools
export PYTHONPATH=$PYTHONPATH:/nird/home/bjornb/.local/lib/python2.7/site-packages/modelgrid
export PYTHONPATH=$PYTHONPATH:/nird/home/bjornb/.local/lib/python2.7/site-packages/gridxsec

# added by Anaconda2 installer
export PATH="/nird/home/bjornb/anaconda2/bin:$PATH"

export SLURM_SUBMIT_DIR=$(pwd)
# Enter directory from where the job was submitted
cd $SLURM_SUBMIT_DIR       ||  { echo "Could not go to dir $SLURM_O_WORKDIR  "; exit 1; }

ulimit -s unlimited # needed for hyc2proj

# run application
./hyc2proj_mf.sh 
