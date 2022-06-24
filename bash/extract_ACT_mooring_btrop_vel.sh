module load nco

for i in INFILES/stations.in_*
do
   cp $i stations.in
   ~/hycom/MSCPROGS/src/Hyc2proj/hyc2stations AGUAVE_*.a
   # concatenate all data
   ncrcat AGUAVE_*groupACT_${i:20:2}.nc HYCOM_weekly_btrop_vel_ACT_${i:20:2}.nc
   # remove unnessary variables
   ncks -C -O -x -v depth HYCOM_weekly_btrop_vel_ACT_${i:20:2}.nc HYCOM_weekly_btrop_vel_ACT_${i:20:2}.nc
   rm AGUAVE_*groupACT_${i:20:2}.nc
done
