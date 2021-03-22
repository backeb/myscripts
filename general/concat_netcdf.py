import os
from glob import glob
from netCDF4 import Dataset
from numpy import empty, shape, mean
import matplotlib.pyplot as plt

# List of netcdf files in your directory of choice
dataDir = os.getcwd()+"/"
filelist = glob(dataDir+"innovation_*.nc")

# initialise some variables
nc = Dataset(filelist[0])
sla = empty([ len(filelist), shape(nc.variables["sla"][:])[0], shape(nc.variables["sla"][:])[1] ])
ssh = empty([ len(filelist), shape(nc.variables["ssh"][:])[0], shape(nc.variables["ssh"][:])[1] ])
sst = empty([ len(filelist), shape(nc.variables["temp"][:])[1], shape(nc.variables["temp"][:])[2] ])
u = empty([ len(filelist), shape(nc.variables["u"][:])[1], shape(nc.variables["u"][:])[2] ])
v = empty([ len(filelist), shape(nc.variables["v"][:])[1], shape(nc.variables["v"][:])[2] ])
lon = nc.variables["lon"][:]
lat = nc.variables["lat"][:]
julday = empty([ len(filelist) ])
nc.close()

# load netcdf data
for i in range(0, len(filelist)):
	nc = Dataset(filelist[i])
	print "appending", filelist[i], "to data..."	
	sla[i,:,:] = nc.variables["sla"][:]
	ssh[i,:,:] = nc.variables["ssh"][:]
        sst[i,:,:] = nc.variables["temp"][0,:,:]
        u[i,:,:] = nc.variables["u"][0,:,:]
        v[i,:,:] = nc.variables["v"][0,:,:]
        julday[i] = float(filelist[i][-8:-3])
	nc.close()

from datetime import date, timedelta
from numpy import empty
yy = empty(len(julday))
mm = empty(len(julday))
dd = empty(len(julday))
start = date(1950,1,1)
for i in range(0, len(julday)):
    yy[i] = (start + timedelta(int(julday[i]))).year
    mm[i] = (start + timedelta(int(julday[i]))).month
    dd[i] = (start + timedelta(int(julday[i]))).day


# TODO - replace landmask with NaN
"""
# PLOT ON MAP ###############################################################################################################
from mpl_toolkits.basemap import Basemap
from numpy import arange

# define basemap
m = Basemap(projection='merc',llcrnrlat=-40,urcrnrlat=-8, llcrnrlon=5,urcrnrlon=22,lat_ts=-24,resolution='l')

# draw map stuff
m.drawcoastlines()
m.fillcontinents(color='coral',lake_color='aqua')
# draw parallels and meridians.
m.drawparallels(arange(5.,22.,1.))
m.drawmeridians(arange(-40.,-8.,1.))

# get lon/lat coordinates for basemap
x, y = m(lon, lat)

# plot search area
plt.pcolormesh(x,y,mean(sst,0)); plt.colorbar(); plt.show()

"""
