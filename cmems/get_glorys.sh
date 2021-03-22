#Download and process tsla data...
#
cd /work/bjornb/glorys/
for year in `seq 1993 2013`
do
   for month in 01 02 03 04 05 06 07 08 09 10 11 12
   do
      echo "Downloading glorys data for $year $month "
      wget --user=bbackeberg --password='iaTmwJ7D' ftp://bbackeberg@ftp.myocean.mercator-ocean.fr/Core/GLOBAL_REANALYSIS_PHYS_001_009/dataset-global-reanalysis-phys-001-009-ran-fr-glorys2v3-monthly-t/GLORYS2V3_ORCA025_${year}${month}15_R????????_gridT.nc
      wget --user=bbackeberg --password='iaTmwJ7D' ftp://bbackeberg@ftp.myocean.mercator-ocean.fr/Core/GLOBAL_REANALYSIS_PHYS_001_009/dataset-global-reanalysis-phys-001-009-ran-fr-glorys2v3-monthly-s/GLORYS2V3_ORCA025_${year}${month}15_R????????_gridS.nc
      wget --user=bbackeberg --password='iaTmwJ7D' ftp://bbackeberg@ftp.myocean.mercator-ocean.fr/Core/GLOBAL_REANALYSIS_PHYS_001_009/dataset-global-reanalysis-phys-001-009-ran-fr-glorys2v3-monthly-ssh/GLORYS2V3_ORCA025_${year}${month}15_R????????_SSH.nc
      wget --user=bbackeberg --password='iaTmwJ7D' ftp://bbackeberg@ftp.myocean.mercator-ocean.fr/Core/GLOBAL_REANALYSIS_PHYS_001_009/dataset-global-reanalysis-phys-001-009-ran-fr-glorys2v3-monthly-u-v/GLORYS2V3_ORCA025_${year}${month}15_R????????_gridUV.nc
   done
done

