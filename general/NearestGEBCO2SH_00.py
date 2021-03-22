__author__ = 'fine'
#!/usr/bin/python
##Finds points in GEBCO data that are closest to points in SANHO soundings data.
from netCDF4 import Dataset
from scipy import spatial
import numpy as np
import csv
from datetime import datetime
import os, sys

#SECTION 1 of this scripts puts the data into the correct format for the matching algorithm
#SECTION 2 of this script does the search for points within the GEBCO set that are closest to points in the SANHO set
#SECTION 3 of this script saves the points and their corresponding GEBCO depths to a CSV file
########################################################################################################################
#BEGIN
#SECTION1 START
#set paths to gebco and sanho data files:
path= os.path.join(os.getcwd()[:-7],'INPUT')
path_out=os.path.join(os.getcwd()[:-7],'OUTPUT')
gebco_nc_file = os.path.join(path,'GEBCO_2014_2D.nc')
sh_csv_file=os.path.join(path,'sh_datasplit_0.csv')

#put the information in the gebco netcdf data into a data set:
fh = Dataset(gebco_nc_file, mode='r')

#put the netcdf variables into separate arrays:
lons = fh.variables['lon'][:]
lats = fh.variables['lat'][:]
elevations= fh.variables['elevation'][:]

#Initialise sanho lons, lats, depths, and the combination of lon,lat points into an SH array
LON_SH=[]
LAT_SH=[]
DEPTH_SH=[]
POINTS_SH=[]

#read the sanho csv file and put the data into the initialised sanho arrays:
with open(sh_csv_file, 'rb') as csvfile:
    data_sh = csv.reader(csvfile, delimiter=',')
    for row in data_sh:
        LON_SH.append(float(row[0]))
        LAT_SH.append(float(row[1]))
        pnt=[float(row[0]),float(row[1])]
        POINTS_SH.append(pnt)
POINTS_SH=np.vstack(POINTS_SH)
#find the limits of the lon and lat arrays:
maxLON_SH= max(LON_SH)
minLON_SH= min(LON_SH)
maxLAT_SH=max(LAT_SH)
minLAT_SH=min(LAT_SH)

#initialise gebco depth and gebco points arrays
DEPTH_GEB=[]
POINTS_GEB=[]

#extract only the necessary gebco points
for i,lon in enumerate(lons):
    if (minLON_SH<= lon <= maxLON_SH ):
        for j,lat in enumerate(lats):
            if (minLAT_SH<= lat <= maxLAT_SH):
                pnt=[lon,lat]
                DEPTH_GEB.append(elevations[j,i])
                POINTS_GEB.append(pnt)

POINTS_GEB=np.vstack(POINTS_GEB)


#SECTION1 END
########################################################################################################################
#SECTION2 START
DEPTH_MATCH=[]
POINT_MATCH=[]
print 'START MATCH00'
cnt=0
cnt_end=len(POINTS_SH)
for pt in POINTS_SH:
    if  np.mod(cnt,100)==0:print cnt ,'of', cnt_end
    startTime = datetime.now() #start timing the search for this point
    indexmatch=spatial.KDTree(POINTS_GEB).query(pt)[1] #index of nearest point
    POINT_MATCH.append(POINTS_GEB[indexmatch]) # <-- the nearest point
    DEPTH_MATCH.append(np.array(DEPTH_GEB[indexmatch])) #DEPTH value for this match in gebco set
    cnt+=1
    # print datetime.now() - startTime #print the time it took to find and save these matches
    

DEPTH_MATCH=np.array(DEPTH_MATCH)
POINT_MATCH=np.array(POINT_MATCH).transpose()

OUTPUT=np.vstack([POINT_MATCH,DEPTH_MATCH])
OUTPUT= OUTPUT.transpose()
print 'END MATCH00'
#SECTION2 END
########################################################################################################################
#SECTION3 START
#check if OUTPUT directory exists and if not, create it:
if not os.path.exists(path_out): os.makedirs(path_out)

np.savetxt(
    os.path.join(path_out,'nearestGEBCO2SANHO_00.csv'),           # file name
    OUTPUT,                # array to save
    fmt='%.5f',             # formatting, 5 digits in this case
    delimiter=',',          # column delimiter
    newline='\n',           # new line character
    )
#SECTION3 END
print 'output written to nearestGEBCO2SANHO_00.csv'
########################################################################################################################
#END