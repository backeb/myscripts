''' script that loads netnode_x, netnode_y from Delft-Flexible Mesh _com.nc file, converts to lon, lat and plots on basemap
Model areas implemented:
    - "Algoa Bay"
    - "St Helena Bay"
    - "False Bay"

Dependencies:	pyproj, netCDF4

Author: bjornb
Creation Date: 02 Nov 2017

Log: <Date: Author - Comment>
27 Feb 2018: bjornb - Generalised netnode2latlon function, tested successfully with Algoa Bay and St Helena Bay grids
02 Mar 2018: bjornb - Successfully tested netnode2latlon function for False Bay grid

'''

def netnode2latlon(netnode_x,netnode_y,whichModel):
    ''' function to convert netnode_x, netnode_y variabiles in Delf-Flexible Mesh _com.nc file to lat, lon
    
    USAGE:  lon, lat = netnode2latlon(netnode_x,netnode_y,whichModel)
    where whichModel is the model area  
    Model area options include:
    - "Algoa Bay"
    - "St Helena Bay"
    - "False Bay"
    
    '''
    from pyproj import Proj
    # the delft projection: see https://publicwiki.deltares.nl/display/OET/Python+convert+coordinates
    if whichModel == "Algoa Bay":
        projstr = ' +proj=tmerc +lat_0=0 +lon_0=25 +k=1 +x_0=100000 +y_0=4000000 \
                    +axis=enu +a=6378249.145 +b=6356514.966398753 \
                    +towgs84=-136,-108,-292,0,0,0,0 +units=m +no_defs'
        p = Proj(projstr)
    else:
        projected_coordinate_system = nc.variables["projected_coordinate_system"]
        p = Proj(projected_coordinate_system.proj4_params)
    # convert netnode_x,netnode_y to lon,lat 
    lon, lat = p(netnode_x,netnode_y,inverse=True)
    return lon, lat


'''test conversion and plot lon,lat on basemap'''
from netCDF4 import Dataset
import matplotlib.pyplot as plt
import sys

# define which model
#whichModel = "Algoa Bay"
#whichModel = "St Helena Bay"
whichModel = "False Bay"

# load correct _com.nc filename
if whichModel == "Algoa Bay":
    fname = "AlgoaBay_com.nc"
elif whichModel == "St Helena Bay":
    fname = "StHelenaBay_com.nc"
elif whichModel == "False Bay": 
    fname = "FalseBay_com.nc"
else:
    sys.exit("Model domain not found")


# load _com.nc file
nc = Dataset(fname)
netnode_x = nc.variables["NetNode_x"][:]
netnode_y = nc.variables["NetNode_y"][:]
# netnode2latlon
lon, lat = netnode2latlon(netnode_x,netnode_y,whichModel)


# plot on basemap
from mpl_toolkits.basemap import Basemap
from numpy import arange, round, floor, ceil

# define basemap
m = Basemap(projection='merc',llcrnrlat=lat.min(),urcrnrlat=lat.max(), llcrnrlon=lon.min(),urcrnrlon=lon.max(),lat_ts=lat.mean(),resolution='h')

# get lon/lat coordinates for basemap
x, y = m(lon, lat)

# plot search area
plt.plot(x, y, '.', zorder=1)

# draw map stuff
m.drawcoastlines(zorder=2)
m.fillcontinents(color='grey')
# draw parallels and meridians.
m.drawparallels(arange(floor(lat.min()),ceil(lat.max()),round((lat.max()-lat.min())/3,decimals=2)), labels = [1,0,0,1])
m.drawmeridians(arange(floor(lon.min()),ceil(lon.max()),round((lon.max()-lon.min())/3,decimals=2)), labels = [1,0,0,1])

plt.show()

