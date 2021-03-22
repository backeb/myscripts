# -*- coding: utf-8 -*-
""" general function regularly used when analysing data

Created: 06 Dec 2017
Author(s): bbackeberg@csir.co.za

Dependencies: - the usual: scipy, numpy, etc.

Change Log: <Date: Author - Comment>
    06 Dec 2017: bjornb - added function to find indexes of lon/lat grid in polygon
    06 Dec 2017: bjornb - forgot to add return to inpolygon function
    06 Dec 2017: bjornb - added subset2region and grid2point functions
"""
def inpolygon(polypts, lon_in, lat_in) :
    """
    return a vector containing 1s/0s indicating True/False for lon/lat points inside defined polygon
    
    USAGE
    inpoly = inpolygon(polypts, lon_in, lat_in)
   
    INPUT
    polypts     =   polygon points, make sure that you close the polygon, 
                    i.e. your last lon/lat pair = first lon/lat pair.
                    e.g. polypts = [(lon1,lat1),(lon2,lat2),(lon3,lat3),...,(lon1,lat1)]
    lon_in      =   input longitude vector
    lat_in      =   input latitude vector
    
    OUTPUT
    inpoly	=   vector containing 1s and 0s indicating True/False for lon/lat points inside defined polygon
    """
    from matplotlib.path import Path
    from numpy import zeros
    # define polygon points, make sure that you close the polygon, i.e. your last lon/lat pair = first lon/lat pair
    # e.g. p = Path([(lon1,lat1),(lon2,lat2),(lon3,lat3),...,(lon1,lat1)])
    p = Path(polypts)
    inpoly = zeros(len(lon_in))
    # find points in polygon
    for ii in range(0,len(lon),1):
        if p.contains_points([(lon_in[ii], lat_in[ii])]):
            inpoly[ii] = 1
	else:
	    inpoly[ii] = 0
    return inpoly

def subset2region(west,east,south,north,lon_in,lat_in,data_in) :
    #--------------------------------------------------------------------------------------------------------------------
    # subset gridded data to region as specified by west, east, south, north lon/lats
    #
    #--------------------------------------------------------------------------------------------------------------------
    # USAGE
    # data_out, lon_out, lat_out = subset2region(west,east,south,north,lon_in,lat_in,data_in)
    #
    # INPUT
    # west, east, south, north  = lon/lat coordinates to subset to
    # lon_in    =   input longitude vector
    # lat_in    =   input latitude vector
    # data_in   =   input gridded data
    #
    # OUTPUT
    # data_out  =   output subset gridded data
    # lon_out   =   output subset lon vector
    # lat_out   =   output subset lat vector
    #--------------------------------------------------------------------------------------------------------------------
    from numpy import where, array, squeeze
    # find indices for region
    idx = squeeze(array(where((lat1 >= south) & (lat1 <= north))))
    jdx = squeeze(array(where((lon1 >= west) & (lon1 <= east))))
    # create subset region output data
    # TODO need to find a way to make sure that the correct dimensions are used, lon/lat agrees with size of data_in
    lon_out = lon_in[idx[0]:idx[-1],jdx[0]:jdx[-1]]
    lat_out = lat_in[idx[0]:idx[-1],jdx[0]:jdx[-1]]
    data_out=data_in[idx[0]:idx[-1],jdx[0]:jdx[-1]]
    return data_out, lon_out, lat_out

def grid2point(lon_pt,lat_pt,lon_in,lat_in,data_in) :
    #--------------------------------------------------------------------------------------------------------------------
    # extract nearest data point from gridded data using kd-tree for quick nearest-neighbor lookup
    #
    #--------------------------------------------------------------------------------------------------------------------
    # USAGE
    # data_out, lon_out, lat_out = grid2point(lon_pt,lat_pt,lon_in,lat_in,data_in)
    #
    # INPUT
    # lon_pt    = longitude point to find
    # lat_pt    = latitude point to find
    # lon_in    =   input longitude vector
    # lat_in    =   input latitude vector
    # data_in   =   input gridded data
    #
    # OUTPUT
    # data_out  =   output data at point
    # lon_out   =   output closest lon point
    # lat_out   =   output closest lat point
    #--------------------------------------------------------------------------------------------------------------------
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

