#Download and process tsla data...
#
MAINDIR=/home/nersc/bjornb/REANALYSIS/ASSIM/BIN
WORKDIR=/work/bjornb
cd /work/bjornb/OBS/SST/OSTIA/
julday=21136
while [ $julday -le 21913 ]
do
  date=`jultodate $julday 1950 1 1`
  year=`echo $date | cut -c1-4`
  echo "Downloading SST OSTIA for the date $date "
  echo "Equivalent Julday is $julday "
  wget --user=bbackeberg --password='iaTmwJ7D' ftp://bbackeberg@data.ncof.co.uk/Core/SST_GLO_SST_L4_NRT_OBSERVATIONS_010_001/METOFFICE-GLO-SST-L4-NRT-OBS-SST-V2/${year}/sst/${date}120000-UKMO-L4_GHRSST-SSTfnd-OSTIA-GLOB-v02.0-fv02.0.nc
  if [ -f  ${date}120000-UKMO-L4_GHRSST-SSTfnd-OSTIA-GLOB-v02.0-fv02.0.nc ]
    then
       echo "Data available for $date and $i ... moving to new file name"
        mv ${date}120000-UKMO-L4_GHRSST-SSTfnd-OSTIA-GLOB-v02.0-fv02.0.nc ${date}_sst.nc
  else
    echo "Data for $date $i not available, I QUIT"
  fi
  let julday=julday+7
done

