import os
from osgeo import gdal

inFile = 'cell_size_km2.nc'
outFile = 'cell_size_km2.tif'
os.system('gdal_translate -of GTiff -co "COMPRESS=DEFLATE" -co "TILED=YES" -a_nodata -9999 %s %s'%(inFile,outFile))

inFile = 'geogunit_107_all.nc'
outFile = 'geogunit_107_all.tif'
os.system('gdal_translate -of GTiff -co "COMPRESS=DEFLATE" -co "TILED=YES" -a_nodata -9999 %s %s'%(inFile,outFile))


# gdalwarp to DEM grid
numtype = 'Int16'
cellsizex = 0.009259259259260
cellsizey = -0.009259259259260
xmin = -180.0004167
ymin = -60.0004167
xmax = 179.9995833
ymax = 84.9995833
mode = 'average'

inFile = 'cell_size_km2.tif'
outFile = 'cell_size_km2_warpMERIT.tif'
os.system('gdalwarp -overwrite -ot %s -tr %s %s -te %s %s %s %s -r %s -co "COMPRESS=DEFLATE" %s %s'%(numtype,cellsizex,cellsizey,xmin,ymin,xmax,ymax,mode,inFile,outFile))

inFile = 'geogunit_107_all.tif'
outFile = 'geogunit_107_all_warpMERIT.tif'
os.system('gdalwarp -overwrite -ot %s -tr %s %s -te %s %s %s %s -r %s -co "COMPRESS=DEFLATE" %s %s'%(numtype,cellsizex,cellsizey,xmin,ymin,xmax,ymax,mode,inFile,outFile))
