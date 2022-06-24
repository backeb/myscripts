#!/bin/bash
#
# Give the job a name (optional)
#PBS -N "seqjob"
#
# Specify the project the job should be accounted on (obligatory)
#PBS -A nn2993k
#
# The job needs at most 60 hours wall-clock time on 1 CPU (obligatory)
#PBS -l mppwidth=1,walltime=24:00:00
#
# Write the standard output of the job to file 'seqjob.out' (optional)
#PBS -o seqjob.out
#
# Write the standard error of the job to file 'seqjob.err' (optional)
#PBS -e seqjob.err
#
# Make sure I am in the correct directory
cd /work/bjornb/4julie_IND/expt_01.3/data/

# Invoke the executable on the compute node
aprun -B /home/nersc/bjornb/Scripts/make_hycom_annual_ave.sh
