
Mdir=/home/nersc/xiejp/REANALYSIS/FILES

#ln -sf ${Mdir}/blkdat.input
#ln -sf ${Mdir}/regional.* .
#ln -sf ${Mdir}/grid.info .
#ln -sf ${Mdir}/depths*.uf .
#ln -sf ${Mdir}/meanssh*.uf .
#ln -sf ${Mdir}/re_sla.nc re_sla.nc 
#
Idir=/home/nersc/xiejp/work_2015/TOPAZ_Reanalysis/script/pre_obs/
#if [ ! -s ./prep_obs ]; then
#  ln -sf /home/nersc/xiejp/enkf/EnKF-MPI-TOPAZ2015/Prep_Routines/prep_obs .
#fi

Odir0=/work/xiejp/work_2016/Data/data0/tsla
Odir=/work/xiejp/work_2015/Data/TSLA
if [ ! -s ${Odir} ]; then
  mkdir ${Odir}
fi

Ndir=./data0
if [ ! -r ${Ndir} ]; then
  mkdir ${Ndir}
fi

Jdy0=23360
Jdy1=24105


Satn="al c2 e1 e2 en enn g2 h2 j1 j1g j1n j2 tp tpn"
#Satn="al c2 e1 e2 en enn g2 j1 j1g j1n j2 tp tpn"


ilink=1
# change the linking name
if [ ${ilink} -eq 0 ]; then
  for Jdy in `seq ${Jdy0} ${Jdy1}`; do
    Sdate=`jultodate ${Jdy} 1950 1 1`
    Ny=`echo ${Sdate:0:4}`
    Nm=`echo ${Sdate:4:2}`
    Nd=`echo ${Sdate:6:2}`
    for isat in al c2 en j1 g2 h2 enn j1g j1n j2 ; do
      Fstr=${isat}_sla_vxxc_${Sdate:0:8}
      nn=$(ls ${Odir0}/dt_global_${Fstr}_*.nc | wc -l)
      if [ ${nn} -eq 1 ]; then
        ls ${Odir0}/dt_global_${Fstr}_*.nc >00.txt
        Fnam0=`cat 00.txt`
        ln -sf ${Fnam0} ${Ndir}/sla_${Jdy}_${isat}.nc 
      fi
    done   # cycle for satellite
  done
fi


module load nco

for jday in `seq ${Jdy0} ${Jdy1}`; do
  rm observations*
  rm observations*
  ifile=0
  for isat in ${Satn}; do
     # combine the daily into the 7 days
     lday=0
     rm out*.nc
     for idy in `seq 0 6`; do
       let Ndy=jday-idy-1
       Fnam=data0/sla_${Ndy}_${isat}.nc
       echo ${Fnam} ${lday}
       if [ -s ${Fnam} ]; then
         ncecat -O ${Fnam} out${lday}.nc
         ncpdq -O -a time,record out${lday}.nc out${lday}.nc
         ncwa -O -a record out${lday}.nc out${lday}.nc 
         if [ ${Ndy} -gt 23735 ]; then
#            ncap2 -s 'SLA='
           ncks -x -v flag out${lday}.nc tmp.nc
           mv tmp.nc out${lday}.nc
         fi
         let lday=lday+1
       fi
     done
     if [ ${lday} -gt 0 ]; then
       Fnam=sla_${jday}_${isat}.nc
       [ -f ${Fnam} ] && rm ${Fnam}
       case ${lday} in
         2) ncrcat out0.nc out1.nc ${Fnam} ;;
         3) ncrcat out0.nc out1.nc out2.nc ${Fnam} ;;
         4) ncrcat out0.nc out1.nc out2.nc out3.nc ${Fnam} ;;
         5) ncrcat out0.nc out1.nc out2.nc out3.nc out4.nc ${Fnam} ;;
         6) ncrcat out0.nc out1.nc out2.nc out3.nc out4.nc out5.nc ${Fnam} ;;
         7) ncrcat out0.nc out1.nc out2.nc out3.nc out4.nc out5.nc out6.nc ${Fnam} ;;
         *) cp out0.nc ${Fnam} ;;
       esac
       let ifile=ifile+1
     fi
  done
  if [ ${ifile} -gt 0 ]; then
     sed "s/JULDDATE/${jday}/" ${Idir}Infile/infile.data_tslaMYO > infile.data
     ./prep_obs TSLA 1 
     if [ -s observations.uf -a -s observations-TSLA.nc ]; then
        mv observations.uf ${Odir}/obs_TSLA_${jday}.uf
        mv observations-TSLA.nc ${Odir}/obs_TSLA_${jday}.nc
        rm sla_${jday}_*.nc
     fi
  fi
  
done
