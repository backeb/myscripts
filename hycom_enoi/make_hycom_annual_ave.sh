#qsub -l mppwidth=1,walltime=24:00:00,mppmem=1000mb -A nn2993k -I

for year in `seq 1993 2007`
do
   ~/hycom/MSCPROGS/src/Average/hycave nersc_weekly INDAVE_${year}*.a
   mv XXXAVE_9999_99_9.a INDAVE_${year}.a
   mv XXXAVE_9999_99_9.b INDAVE_${year}.b
done

for i in INDAVE_????.a
do
   ~/hycom/MSCPROGS/src/Average/hycave nersc_weekly $i
   mv XXXAVE_9999_99_9.a INDAVE_1993-2007.a
   mv XXXAVE_9999_99_9.b INDAVE_1993-2007.b
done

~/hycom/MSCPROGS/src/ExtractNC3D/h2nc INDAVE_1993-2007.a
mv tmp1.nc INDAVE_1993-2007.nc


