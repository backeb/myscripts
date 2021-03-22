# load wavewatch3 .grb2, subset/extract point and write to netcdf/csv
#
# Dependencies: - the usual: scipy, numpy, etc.
#		- pygrib (only compatible with python27, install by doing "conda install pygrib")
#
# Author: bjornb
# Date: 28 Nov 2017
#
# Log: <Date: Author - Comment>
# 30-Nov-2017: bjornb - fixed bug that caused duplicate data at start/end of each month
# 30-Nov-2017: bjornb - TODO add function to write to netcdf
#

import time
total_start_time = time.time()
import os
from glob import glob
import pygrib
import datetime
import pandas as pd
from numpy import transpose
#from numpy.ma import masked_array
#import matplotlib.pyplot as plt

"""
Define some functions
"""
def subset2region(west,east,south,north,lon_in,lat_in,data_in) :
	# subset gridded data to region as specified by west, east, south, north lon/lats
	from numpy import where, array, squeeze
	# get rid of duplicate dimension
	# TODO - generalise getting rid of duplicate dimension
	lon1 = lon_in[0,:]
	lat1 = lat_in[:,0]
	# find indices for region
	idx = squeeze(array(where((lat1 >= south) & (lat1 <= north))))
	jdx = squeeze(array(where((lon1 >= west) & (lon1 <= east))))
	# create subset region output data
	lon_out = lon_in[idx[0]:idx[-1],jdx[0]:jdx[-1]]
	lat_out = lat_in[idx[0]:idx[-1],jdx[0]:jdx[-1]]
	data_out=data_in[idx[0]:idx[-1],jdx[0]:jdx[-1]]
	return data_out, lon_out, lat_out

def grid2point(lon_pt,lat_pt,lon_in,lat_in,data_in) :
	# extract nearest data point from gridded data using kd-tree for quick nearest-neighbor lookup
	from scipy import spatial
	from numpy import transpose
	# subset to a small region 1 degree around point to make kd-tree faster (halves time)
	data_in, lon_in, lat_in = subset2region(lon_pt-1,lon_pt+1,lat_pt-1,lat_pt+1,lon_in,lat_in,data_in)
	# flatten input dat for use with kd-tree
	lonlat = transpose([lon_in.flatten(), lat_in.flatten()])
	data_in = data_in.flatten()
	pt = [lon_pt, lat_pt]
	# do kd-tree and return index of nearest point
	ptdx = spatial.KDTree(lonlat).query(pt)[1]
	lon_out = lonlat[ptdx][0]
	lat_out = lonlat[ptdx][1]
	data_out = data_in[ptdx]
	return data_out, lon_out, lat_out


# point to extract from gridded data
lon_pt = 14.2369
lat_pt = -22.94195

# get list of filenames to load
flistHs = glob(os.getcwd()+"/multi_reanal.glo_30m_ext.hs.*.grb2") # wave height
flistTp = glob(os.getcwd()+"/multi_reanal.glo_30m_ext.tp.*.grb2") # period
flistDp = glob(os.getcwd()+"/multi_reanal.glo_30m_ext.dp.*.grb2") # direction

# initialise some variables
YY = [] # initialise date related variables
MM = []
DD = []
hh = []
mm = []
ss = []
hs = [] # wave height
tp = [] # period
dp = [] # direction
lon = []
lat = []
# get the global lon/lat
gribs = pygrib.open(flistHs[0]) # open the grib file for wave height
grb=gribs[1] # grb message numbers start at 1
globLat, globLon = grb.latlons() # extract the grib lat/lon values
gribs.close()
del grb, gribs

# extract data for point and append to final variable
# first loop through all files in flist
for ff in range(0, len(flistHs)):
	
	gribsHs =  pygrib.open(flistHs[ff])
	gribsTp =  pygrib.open(flistTp[ff])
	gribsDp =  pygrib.open(flistDp[ff])
	gribLen = len(gribsHs())

	start_time = time.time()

	print "appending "+str(gribLen-1)+ " grb messages from "+flistHs[ff][35:-14]+"[.hs.|.tp.|.dp.]"+flistHs[ff][-12:-1]
	# then loop through grb messages (grbLen) and load data
	for gg in range(1, gribLen):
		grbHs = gribsHs[gg]
		globHs = grbHs.values
		grbTp = gribsTp[gg]
		globTp = grbTp.values
		grbDp = gribsDp[gg]
		globDp = grbDp.values
		
		# extract point
		tmpHs, tmplon, tmplat = grid2point(lon_pt, lat_pt, globLon, globLat, globHs)
		tmpTp, tmplon, tmplat = grid2point(lon_pt, lat_pt, globLon, globLat, globTp)
		tmpDp, tmplon, tmplat = grid2point(lon_pt, lat_pt, globLon, globLat, globDp)
		
		hs.append(tmpHs)
		tp.append(tmpTp)
		dp.append(tmpDp)
		lon.append(tmplon)
		lat.append(tmplat)
		YY.append(grbHs.validDate.year)
		MM.append(grbHs.validDate.month)
		DD.append(grbHs.validDate.day)
		hh.append(grbHs.validDate.hour)
		mm.append(grbHs.validDate.minute)
		ss.append(grbHs.validDate.second)

		del tmpHs, tmpTp, tmpDp, tmplon, tmplat, grbHs
		
	gribsHs.close()
	gribsTp.close()
	gribsDp.close()
	del gribsHs, gribsTp, gribsDp, gribLen

        print ("--- %s:%s:%s ---" % (int(floor((time.time() - start_time)/60/60)), \
                int(floor((time.time() - start_time)/60)), \
                int(round((((time.time() - start_time)/60)-floor((time.time() - start_time)/60))*60))))

# create pandas data from from variables
all_data = transpose([YY, MM, DD, hh, mm, ss, lon, lat, hs, tp, dp])
df = pd.DataFrame(all_data,columns=[	'Year','Month','Day','Hours','Minutes','Seconds',\
					'Longitude [degE]','Latitude [degN]',\
					'Significant Wave Height [m]',\
					'Primary wave mean period [s]',\
					'Primary wave direction [degrees true, coming from]'])

# write to tabe delimited csv
df.to_csv("wave_data_at_location.csv",sep='\t')

#hs1 = masked_array(hs)

print ("--- %s:%s:%s ---" % (int(floor((time.time() - total_start_time)/60/60)), \
        int(floor((time.time() - total_start_time)/60)), \
        int(round((((time.time() - total_start_time)/60)-floor((time.time() - total_start_time)/60))*60))))
