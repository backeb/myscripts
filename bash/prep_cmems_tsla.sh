# pre-process cmems along-track sla data for EnOI
# takes daily files downloaded from cmems, renames them and concatenates them to 1 file every 7 days containing 7 days of data
#
# Dependencies: nco; datetojul
#
# Author: bjornb
# Date: 20 Jul 2017
#
# Change log: <Date: Author - Comment>
# 21 Jul 2017: bjornb - tested j2 satellite data
#

# rename data files to sla_{julday}_{satellite}.nc
for sat in j2
do
   for fname in cmems_download/dt_global_${sat}_phy_vxxc_l3_????????_????????.nc
   do
      date=`echo ${fname:40:8}`
      julday=`~/hycom/MSCPROGS/src/DateTools/datetojul ${date:0:4} ${date:4:2} ${date:6:2} 1950 1 1`
      cp -v cmems_download/dt_global_${sat}_phy_vxxc_l3_${date}_????????.nc daily/sla_${julday}_${sat}.nc
   done
done

#for i in j1n
#do
   #for j in dt_upd_global_${i}_sla_vxxc_????????_????????_????????.nc
   #do
      #date=`echo ${j:36:8}`
      #julday=`~/hycom/MSCPROGS/src/DateTools/datetojul ${date:0:4} ${date:4:2} ${date:6:2} 1950 1 1`
      #cp -v dt_upd_global_${i}_sla_vxxc_????????_${date}_????????.nc ${TSLADIR}/sla_${julday}_${i}.nc
   #done
#done

unset sat
unset date
unset julday

# concat to 7-day

module load nco 

#BEGIN=21129
BEGIN=21479
INTERVAL=7
END=21914
for sat in j2
do
   for julday in `seq $BEGIN $INTERVAL $END`
   do
      lday=0
      rm out*.nc
      for idy in `seq 6 -1 0`
      do
         let Ndy=julday-idy-1
         fname=daily/sla_${Ndy}_${sat}.nc
         echo $fname $lday
         if [ -s $fname ]
         then
            cp -v ${fname} out${lday}.nc
            ncks -O -h --mk_rec_dmn time out${lday}.nc out${lday}.nc
            let lday=lday+1
         fi
      done
      if [ ${lday} -gt 0 ]
      then
         fname=7day/sla_${julday}_${sat}.nc
         [ -f ${fname} ] && rm ${fname} # if ${fname} exists, remove that file
         case ${lday} in
            2) ncrcat out0.nc out1.nc ${fname} >NUL 2>NUL ;; # suppress/redirect stdout and stderr using '>NUL 2>NUL'
            3) ncrcat out0.nc out1.nc out2.nc ${fname} >NUL 2>NUL ;;
            4) ncrcat out0.nc out1.nc out2.nc out3.nc ${fname} >NUL 2>NUL ;;
            5) ncrcat out0.nc out1.nc out2.nc out3.nc out4.nc ${fname} >NUL 2>NUL ;;
            6) ncrcat out0.nc out1.nc out2.nc out3.nc out4.nc out5.nc ${fname} >NUL 2>NUL ;;
            7) ncrcat out0.nc out1.nc out2.nc out3.nc out4.nc out5.nc out6.nc ${fname} >NUL 2>NUL ;;
            *) cp out0.nc ${fname} >NUL 2>NUL ;;
         esac
      fi
   done
done

rm NUL out*.nc
