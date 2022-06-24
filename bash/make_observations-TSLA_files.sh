
for julday in `seq 22305 7 23005`
do
   ln -s /work/bjornb/alongtrack_processed/sla_${julday}_*.nc .
   cat infile.data.TSLA | sed "s/julianday/${julday}/" > infile.data
   ~/REANALYSIS/ASSIM/BIN/prep_obs
   mv observations-TSLA.nc /work/bjornb/alongtrack_renamed/${julday}.nc
   rm sla_${julday}_*.nc
done

