DOWNLDDIR=/work/bjornb/alongtrack
TSLADIR=/work/bjornb/alongtrack_processed

cd $DOWNLDDIR

for i in c2 j2
do
   for j in dt_upd_global_${i}_sla_vxxc_????????_????????_????????.nc
   do
      date=`echo ${j:35:8}`
      julday=`~/hycom/MSCPROGS/src/DateTools/datetojul ${date:0:4} ${date:4:2} ${date:6:2} 1950 1 1`
      cp -v dt_upd_global_${i}_sla_vxxc_????????_${date}_????????.nc ${TSLADIR}/sla_${julday}_${i}.nc
   done
done

for i in enn j1g j1n
do
   for j in dt_upd_global_${i}_sla_vxxc_????????_????????_????????.nc
   do
      date=`echo ${j:36:8}`
      julday=`~/hycom/MSCPROGS/src/DateTools/datetojul ${date:0:4} ${date:4:2} ${date:6:2} 1950 1 1`
      cp -v dt_upd_global_${i}_sla_vxxc_????????_${date}_????????.nc ${TSLADIR}/sla_${julday}_${i}.nc
   done
done

cd $TSLADIR

module load nco

# j2
ncks -h --mk_rec_dmn time sla_22743_j2.nc out1.nc
ncks -h --mk_rec_dmn time sla_22746_j2.nc out2.nc
ncrcat out1.nc out2.nc out3.nc
mv out3.nc sla_22746_j2.nc
rm out*.nc sla_22743_j2.nc

ncks -h --mk_rec_dmn time sla_22808_j2.nc out1.nc
ncks -h --mk_rec_dmn time sla_22809_j2.nc out2.nc
ncrcat out1.nc out2.nc out3.nc
mv out3.nc sla_22809_j2.nc
rm out*.nc sla_22808_j2.nc

# g2
ncks -h --mk_rec_dmn time sla_22808_c2.nc out1.nc
ncks -h --mk_rec_dmn time sla_22809_c2.nc out2.nc
ncrcat out1.nc out2.nc out3.nc
mv out3.nc sla_22809_c2.nc
rm out*.nc sla_22808_c2.nc

# enn
mv sla_22743_enn.nc sla_22746_enn.nc

