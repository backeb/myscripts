# download wavewatch3 phase2 reanalysis gribs data from ftp://polar.ncep.noaa.gov/pub/history/nopp-phase2/YYYYMM/gribs/
#
# Dependencies: wget, curl
#
# Author: bjornb
# Date: 28 Nov 2017
#
# Log: <Date: Author - Comment>
#

# get folder list and write into dirlist.txt
#curl -l ftp://polar.ncep.noaa.gov/pub/history/nopp-phase2/ >dirlist.txt

# read dirlist.txt line-by-line into dname in while loop and download corresponding data using wget
#while read dname
#do
#	wget ftp://polar.ncep.noaa.gov/pub/history/nopp-phase2/${dname}/partitions/multi_reanal.partition.glo_30m.${dname}.nc
#done <dirlist.txt

for year in `seq 1979 2009`
do
	for month in 01 02 03 04 05 06 07 08 09 10 11 12
	do
		# significant height of combined wind waves and swell (m) 
		wget ftp://polar.ncep.noaa.gov/pub/history/nopp-phase2/${year}${month}/gribs/multi_reanal.glo_30m_ext.hs.${year}${month}.grb2
		# primary wave mean period (s) 
		wget ftp://polar.ncep.noaa.gov/pub/history/nopp-phase2/${year}${month}/gribs/multi_reanal.glo_30m_ext.tp.${year}${month}.grb2
		# primary wave direction (degrees true, i.e. 0 deg => coming from North; 90 deg => coming from East)
		wget ftp://polar.ncep.noaa.gov/pub/history/nopp-phase2/${year}${month}/gribs/multi_reanal.glo_30m_ext.dp.${year}${month}.grb2
	done
done

