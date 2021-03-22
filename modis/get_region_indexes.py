import os
from glob import glob
from netCDF4 import Dataset
from numpy import where, ma, array, float32, squeeze
#import matplotlib.pyplot as plt


# SST4 is night time SST - good for comparison against in situ, skin temp affected by solar radiation (i.e. SST)

west = input("Specify western most lon (positive east): ")
east = input("Specify eastern most lon (positive east): ")
south = input("Specify southern most lat (positive north): ")
north = input("Specify northern most lat (positive north): ")

# List of netcdf files in your directory of choice
dataDir = os.getcwd()+"/global/"
filelist = glob(dataDir+"*.nc")

# Get landmask and longitude and latitude from 1st file
nc = Dataset(filelist[0])
lon = nc.variables['lon'][:]
lat = nc.variables['lat'][:]
ilon = where((lon >= west) & (lon <= east))
ilat = where((lat >= south) & (lat <= north))
idx = squeeze(array(ilon))
jdx = squeeze(array(ilat))
#sst = nc.variables['sst4'][:]
sst1 = nc.variables['sst4'][jdx,idx]
lon1 = lon[idx]
lat1 = lat[jdx]
nc.close()

i0=idx[0] # western most index
i1=idx[-1] # eastern most index
j0=jdx[0] # northern most index
j1=jdx[-1] # southern most index

print "western most lon = ", lon[i0], "E, corresponding lon index = ", i0
print "eastern most lon = ", lon[i1], "E, corresponding lon index = ", i1
print "southern most lat = ", lat[j0], "N, corresponding lat index = ", j0
print "northern most lat = ", lat[j1], "N, corresponding lat index = ", j1

seq = [i0, i1, j0, j1] # [east, west, north, south] - need to write north first for subsetting using ncks
fo = open("infile.ij","wb")
for i in range(0,len(seq)):
	fo.writelines('%d' % seq[i]+'\n')
fo.close()

print "wrote lon/lat indexes to infile.ij"

