# download along-track sla data from cmems
#
# Dependencies: wget, curl, julday
#
# Author: bjornb
# Date: 20 Jul 2017
#
# Log: <Date: Author - Comment>
# 20 Jul 2017: bjornb - tested j2 satellite data for 2008 and 2009
# 24 Jul 2017: bjornb - added check to only download data in date range, downloaded data for en, g2, j1, j1n and j2 for 7-Nov-2007 to 31-Dec-2009

cd cmems_download/

# start and end date in julian days to download
START=21129
END=21914

for sat in en g2 j1 j1n j2
do
   echo "checking what years are available for satellite: $sat"
   curl -l ftp://bbackeberg@ftp.sltac.cls.fr/Core/SEALEVEL_GLO_PHY_L3_REP_OBSERVATIONS_008_045/dataset-duacs-rep-global-${sat}-phy-unfiltered-l3-v3/ --user bbackeberg:iaTmwJ7D >availyears.txt
   while read year
   do
      echo "checking what data are availabe for $year for satellite: $sat"
      curl -l ftp://bbackeberg@ftp.sltac.cls.fr/Core/SEALEVEL_GLO_PHY_L3_REP_OBSERVATIONS_008_045/dataset-duacs-rep-global-${sat}-phy-unfiltered-l3-v3/${year}/ --user bbackeberg:iaTmwJ7D >availdata.txt
      while read fname
      do
         if [ "${fname: -3}" == ".gz" ]
         then
            date=`echo ${fname: -23:8}`
            julday=`~/hycom/MSCPROGS/src/DateTools/datetojul ${date:0:4} ${date:4:2} ${date:6:2} 1950 1 1`
         fi
         if [ $julday -ge $START ] && [ $julday -le $END ]
         then
            echo "Downloading along-track sla for satellite $sat for ${date:0:4}/${date:4:2}/${date:6:2}"
            wget --user=bbackeberg --password='iaTmwJ7D' ftp://bbackeberg@ftp.sltac.cls.fr/Core/SEALEVEL_GLO_PHY_L3_REP_OBSERVATIONS_008_045/dataset-duacs-rep-global-${sat}-phy-unfiltered-l3-v3/${year}/${fname}
         fi
      done <availdata.txt
   done <availyears.txt
done

