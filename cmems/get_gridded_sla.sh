#!/bin/bash
####################################################################
#
# Download gridded SLA from CMEMS website
#
# Marjolaine Krug: mkrug@csir.co.za
####################################################################
marjoLogin=mkrug1
marjoPass=Marjo001
localDir=/media/marjolaine/mkPassport/wd/CSIR/2017/SRP_TIPHOON/work/data/

# initialise stuff for data definitions
dataStr=SEALEVEL_GLO_PHY_L4_NRT_OBSERVATIONS_008_046-TDS
dataset=dataset-duacs-nrt-global-merged-allsat-phy-l4-v3
#domain
west=10.
east=50.
north=-15.
south=-45.

#startDate=20170401
#endDate=20170501
# Number of days to get before endDate
#ndays=$(( (`date -d $endDate +%s` - `date -d $startDate +%s`) / (24*3600) ))

# To use current day as endDate uncommment following
endDate=$(date "+%Y%m%d")
ndays=2


# Retreive netcdf files for last ndays before endDate
for i in `seq 1 $ndays`
do 
    mydate=`date +%Y-%m-%d -d "${endDate}-${i} days"`
    dateStr=`date +%Y%m%d -d "${endDate}-${i} days"`
    echo $i": Getting "${dataset}_${dateStr}.nc
    /home/marjolaine/mkPython/packages/motuClient_1.4.00/src/python/motu-client.py -u $marjoLogin -p $marjoPass -m http://motu.sltac.cls.fr/motu-web/Motu -s $dataStr -d $dataset -x $west -X $east -y $south -Y $north -t $mydate -T $mydate -v err -v vgosa -v vgos -v sla -v adt -v ugosa -v ugos -o $localDir -f ${dataset}_${dateStr}.nc

done


#All you need to do it download the motu client and the python file on your path. You can download the motu client here
#
#https://sourceforge.net/projects/cls-motu/?source=typ_redirect
#
#In your .bashrc file add the directory where you unzip the motu client archive. 
#
#PYTHONPATH=~/mkPython/packages/nansat:~/mkPython/packages/openwind/openwind:~/mkPython/mkDefs:~/mkPython/mkDefs/Seaglider:~/mkPython/packages/NB_stats:~/mkPython/packages/SeaGlider-utilities-master:~/mkPython/packages/motuClient_1.4.00/src/python
#export PYTHONPATH
#
#And then make the motu-client.py file executable as well as your shell file of course. Et voila !
