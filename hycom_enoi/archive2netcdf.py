# script to load HYCOM-CICE archive files and write to netcdf
#
# Dependencies: basemap - to install do "conda install -c anaconda basemap"
#
# Author: bjornb
# Creation Date: 24 Nov 2017
#
# Log: <Date: Author - Comment>
#

"""
Deinfe some functions
"""

def interp2latlon(lon,lat,data,res=0.1) :
	#--------------------------------------------------------------------------------------------------------------------
	# Knut-Arild's function to interpolate hycom grid to regular lat-lon grid
	# 
	#--------------------------------------------------------------------------------------------------------------------
	# USAGE
	# lo2d, la2d, z = interp2latlon(lon_in, lat_in, res=0.1)
	#
	# INPUT
	# lon_in	=	hycom longitude loaded from .a file
	# lat_in	=	hycom latitude loaded from .a file
	# res 		=	resolution, default set to 0.1
	#
	# OUTPUT
	# lo2d		=	regular longitudes on meshgrid
	# la2d   	=	regular latitudes on meshgrid
	# z		=	hycom variable interpolated onto regular grid using cubic interpolation
	#--------------------------------------------------------------------------------------------------------------------
	import numpy
	import scipy.interpolate

	lon2 = lon
	# New grid
	minlon=numpy.floor((numpy.min(lon2)/res))*res
	minlat=max(-90.,numpy.floor((numpy.min(lat)/res))*res)
	maxlon=numpy.ceil((numpy.max(lon2)/res))*res
	maxlat=min(90.,numpy.ceil((numpy.max(lat)/res))*res)
	#maxlat=90.
	lo1d = numpy.arange(minlon,maxlon+res,res)
	la1d = numpy.arange(minlat,maxlat,res)
	lo2d,la2d=numpy.meshgrid(lo1d,la1d)
	print minlon,maxlon,minlat,max
	
	if os.path.exists("grid.info") :
		import mod
		
		grid=modelgrid.ConformalGrid.init_from_file("grid.info")
		map=grid.m
		
		# Index into model data, using grid info
		I,J=map.ll2gind(la2d
		
		# Location of model p-cell corner 
		I=I-0.5
		J
		
		# Mask out points not on grid
		K=J<data.shape[0]-1
		K=numpy.logical_and(K,I<data.shape[1]-1)
		K=numpy.logical_and(K,J>=0)
		K=numpy.logical_and(K
		
		# Pivot point 
		Ii=I.astype('i')
		Ji=J.astyp
		
		# Takes into account data mask
		tmp =numpy.logical_and(K[K],~data.mask[Ji[K],Ii[K]])
		K[
		
		tmp=data[Ji[K],Ii[K]]
		a,b=numpy.where(K)
		z=numpy.zeros(K.shape)
		z[a,b] = tmp
		z=numpy.ma.masked_where
		
		# Brute force ...
	else  :
		K=numpy.where(~data.mask)
		z=scipy.interpolate.griddata( (lon2[K],lat[K]),data[K],(lo2d,la2d),'cubic')
		z=numpy.ma.masked_invalid(z)
		z2=scipy.interpolate.griddata( (lon2.flatten(),lat.flatten()),data.mask.flatten(),(lo2d,la2d),'nearest')
		z2=z2>.1
		z=numpy.ma.masked_where
	
	return lo2d,la2d,z

# TODO set up function to load one file at at time do multiple times in for loop after - more generic this way
def load_all(rungen,var) :
	import glob
	import os
	import abfile
	# list of all archm*.a files in directory
	flist = sorted(glob.glob(os.getcwd()+"/archm*.a"))
	
	# initialise some variables
	ab = abfile.ABFileGrid("regional.grid","r")
	lon=ab.read_field("plon")
	lat=ab.read_field("plat")
	ab.close()
	day = list()
	varDim = [ len(flist), numpy.size(lon, axis=0), numpy.size(lon, axis=1) ]


ab = abfile.ABFileArchv("archm.2007_281_12.a","r")
ssh = ab.read_field("srfhgt",0)
ab.close()


#lon,lat,ssh2 = interp2latlon(plon,plat,ssh)

#import matplotlib.pyplot as plt
#plt.contourf(lon,lat,ssh);plt.colorbar();plt.show()



#from mpl_toolkits.basemap import Basemap
#bm = Basemap(projection='merc',llcrnrlat=plat.min(),urcrnrlat=plat.max(),llcrnrlon=plon.min(),urcrnrlon=plon.max(),lat_ts=median(plat),resolution='i')
#x,y=bm(plon,plat)

