# check out ~fanf/Scripts fpr some cool bash shit

cd /work/bjornb/PREPOBS

module load nco

i=0

while [ $i -lt 7 ]
do
   cat infile.data.MYO | sed "s/dayinweek/${i}/" > infile.data
   ./prep_obs
   mv observations.uf tmpobs0${i}.uf
   mv observations-TSLA.nc tmpTSLA0${i}.nc
   ncks -h --mk_rec_dmn nobs tmpTSLA0${i}.nc tmpTSLA0${i}n.nc

   let i=i+1

done

cat tmpobs??.uf >observations.uf

ncrcat -h tmpTSLA00n.nc tmpTSLA01n.nc tmpTSLA02n.nc tmpTSLA03n.nc tmpTSLA04n.nc tmpTSLA05n.nc tmpTSLA06n.nc observations-TSLA.nc
rm tmp*.uf tmp*.nc *.tmp
