import pandas as pd
import numpy as np

fname = "ABank_stations.txt"

with open(fname) as f:
    table = pd.read_table(f, sep='\t', header=None, names=['Cruise','Station','Date','Lon','Lat','MaxDepth'], lineterminator='\n')

lon = table.Lon.values
lat = table.Lat.values
date = pd.to_datetime(table.Date.values, format='%m/%d/%Y')
doy = date.dayofyear - 1
year = date.year
stn = table.Station.values
maxdepth = table.MaxDepth.values

# write stations.in files
for i in range(0, len(stn)):
	f = open("STATION_FILES/stations.in."+str(stn[i])+"."+str(year[i])+"_"+str("%03d" % (doy[i])), "w")
	f.write("#"+str(stn[i])+"\n")
	f.write(str("%0.2f" % lon[i])+"   "+str("%0.2f" % lat[i])+"\n")
	f.close()

del f, i

# write depthlevels.in files
for i in range(0, len(stn)):
	depthlevels = np.arange(5, maxdepth[i], 5)
	depthlevels = np.append(depthlevels, maxdepth[i])
	f = open("DEPTHLEVEL_FILES/depthlevels.in."+str(stn[i])+"."+str(year[i])+"_"+str("%03d" % (doy[i])), "w")
	f.write(str(len(depthlevels))+"                  # Number of z levels"+"\n")
	for x in range(0, len(depthlevels)):
		f.write("%s\n" % depthlevels[x])
	
	f.close()

