# load multiple cfsr wind data files for specified location using xarray and write to csv
#
# Dependencies: xarray, numpy, math, pandas
#
# Author: bjornb
# Date: 01 Dec 2017
#
# Log: <Date: Author - Comment>
#

import xarray as xr
from numpy import sqrt, pi, arctan2, log, transpose, tile
from math import atan2
from pandas import to_datetime, DataFrame

# open all netcdf files in directory using the '*' wildcard
# select only point nearest to specified lat lon point
ds = xr.open_mfdataset("pgbhnl.gdas.*.nc", autoclose=True).sel(lat=-22.94195, lon=14.2369, method='nearest')

# load the variables you're interested in
lon = ds.lon.values
lat = ds.lat.values
u = ds.U_GRD_L100.values
v = ds.V_GRD_L100.values
tm = ds.time.values
# convert xarray time to pandas datetime
tm = to_datetime(tm)
# make YY, MM, DD, hh, mm, ss
YY = tm.year
MM = tm.month
DD = tm.day
hh = tm.hour
mm = tm.minute
ss = tm.second
del tm

# repeat lon lat for the length of the dataset
lon = tile(lon,len(u))
lat = tile(lat,len(u))

#u = -3.711 
#v = -1.471

wind100m = sqrt(u**2 + v**2)

dir_trig_to = arctan2(u/wind100m, v/wind100m) 
dir_trig_to_degrees = dir_trig_to * 180/pi
dir_trig_from_degrees = dir_trig_to_degrees + 180 ## 68.38 degrees
#dir_cardinal = 90 - dir_trig_from_degrees # not sure about this whole cardinal direction thing
dir100m = dir_trig_from_degrees
del dir_trig_to, dir_trig_to_degrees, dir_trig_from_degrees

# calculate winds at 20m and 60m
# based on https://en.wikipedia.org/wiki/Log_wind_profile
# z0 = is a corrective measure to account for the effect of the roughness of a surface on wind flow
#       for very flat terrain (snow, desert) the roughness length (z0) may be in the range 0.001 to 0.005 m
# d = Zero-plane displacement, the height in meters above the ground at which zero wind speed is achieved
#       as a result of flow obstacles such as trees or buildings.
#       assume d=0 over the ocean
z0 = 0.0002  # assume some roughness over: from https://websites.pmc.ucsc.edu/~jnoble/wind/extrap/
z1 = 100 # height at which wind is known
z2 = [20, 60] # heights at which wind is unknown
d = 0 
wind20m = wind100m * ( log((z2[0]-d)/z0) / log((z1-d)/z0) )
wind60m = wind100m * ( log((z2[1]-d)/z0) / log((z1-d)/z0) )

# create pandas dataframe from variables
all_data = transpose([YY, MM, DD, hh, mm, ss, lon, lat, wind20m, wind60m, wind100m, dir100m])
df = DataFrame(all_data, columns=[  	'Year','Month','Day','Hours','Minutes','Seconds',\
					'Longitude [degE]','Latitude [degN]',\
					'Wind speed at 20m [m/s]', 'Wind speed at 60m [m/s]', 'Wind speed at 100m [m/s]',\
					'Wind direction [degrees true, coming from]'])

# write to tabe delimited csv
df.to_csv("wind_data_at_location.csv",sep='\t')

