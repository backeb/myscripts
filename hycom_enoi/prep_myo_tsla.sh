DOWNLDDIR=/work/bjornb/OBS/TSLA_MYO_download
TSLADIR=/work/bjornb/OBS/TSLA

cd $DOWNLDDIR

for i in en g2 j1 j2
do
   for j in dt_upd_global_${i}_sla_vxxc_????????_????????_????????.nc
   do
      date=`echo ${j:35:8}`
      julday=`~/hycom/MSCPROGS/src/DateTools/datetojul ${date:0:4} ${date:4:2} ${date:6:2} 1950 1 1`
      cp -v dt_upd_global_${i}_sla_vxxc_????????_${date}_????????.nc ${TSLADIR}/sla_${julday}_${i}.nc
   done
done

for i in j1n
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

# Envisat
ncks -h --mk_rec_dmn time sla_21434_en.nc out1.nc
ncks -h --mk_rec_dmn time sla_21437_en.nc out2.nc
ncrcat out1.nc out2.nc out3.nc
mv out3.nc sla_21437_en.nc
rm out*.nc sla_21434_en.nc

ncks -h --mk_rec_dmn time sla_21476_en.nc out1.nc
ncks -h --mk_rec_dmn time sla_21479_en.nc out2.nc
ncrcat out1.nc out2.nc out3.nc
mv out3.nc sla_21479_en.nc
rm out*.nc sla_21476_en.nc


ncks -h --mk_rec_dmn time sla_21594_en.nc out1.nc
ncks -h --mk_rec_dmn time sla_21598_en.nc out2.nc
ncrcat out1.nc out2.nc out3.nc
mv out3.nc sla_21598_en.nc
rm out*.nc sla_21594_en.nc

# g2
mv sla_21434_g2.nc sla_21437_g2.nc

# Jason-1
ncks -h --mk_rec_dmn time sla_21434_j1.nc out1.nc
ncks -h --mk_rec_dmn time sla_21437_j1.nc out2.nc
ncrcat out1.nc out2.nc out3.nc
mv out3.nc sla_21437_j1.nc
rm out*.nc sla_21434_j1.nc

mv sla_21476_j1.nc sla_21479_j1.nc

# Jason-2
ncks -h --mk_rec_dmn time sla_21594_j2.nc out1.nc
ncks -h --mk_rec_dmn time sla_21598_j2.nc out2.nc
ncrcat out1.nc out2.nc out3.nc
mv out3.nc sla_21598_j2.nc
rm out*.nc sla_21594_j2.nc


