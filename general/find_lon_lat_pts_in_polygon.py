import pandas as pd
from matplotlib.path import Path
import numpy as np

data = pd.read_csv('Interpolate_Data2.txt',sep='\t')

lon = data.lon.values
lat = data.lat.values

# define polygon points, make sure that you close the polygon, i.e. your last lon/lat pair = first lon/lat pair
# e.g. p = Path([(lon1,lat1),(lon2,lat2),(lon3,lat3),...,(lon1,lat1)])
p = Path([(10,-40), (15,-30), (10,-20), (10,-40)])

InPolygon = np.zeros(len(lon))

for ii in range(0,len(lon),1):
	if p.contains_points([(lon[ii], lat[ii])]):
		InPolygon[ii] = 1
	else:
		InPolygon[ii] = 0

#from matplotlib import pyplot as plt
#indx = np.where (InPolygon == 1)
#plt.plot(lon[indx],lat[indx],'.')







