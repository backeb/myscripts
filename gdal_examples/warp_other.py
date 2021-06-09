import os
from osgeo import gdal
from os import listdir
from os.path import isfile, join
import time

start = time.time()

#inFile = "/p/input/scripts/area_stats/cell_size_km2.tif"
inFile = "/p/input/scripts/area_stats/geogunit_107_all.tif"

# parameters for gdalwarp for 90m
#xmin = -180.0004167
#ymin = -90.0004167
#xmax = 179.9995833
#ymax = 89.9995833
#target_xres = 0.000833333333333
#target_yres = 0.000833333333333
#outFile = inFile.strip(".tif")+"_warped_90m.tif"

# parameters for gdalwarp for 1km
xmin = -180.0004167
ymin = -90.0004167
xmax = 179.9995833
ymax = 89.9995833
target_xres = 0.01
target_yres = 0.01
outFile = inFile.strip(".tif")+"_warped_1km.tif"

# parameters for gdalwarp for 5km
#xmin = -180.0000000
#ymin = -90.0000000
#xmax = 180.0000000
#ymax = 90.0000000
#target_xres = 0.050000000000000
#target_yres = 0.050000000000000
#outFile = inFile.strip(".tif")+"_warped_5km.tif"

# set some parameters to create the water mask
mode   = 'average' # resampling algorithm: {nearest (default),bilinear,cubic,cubicspline,lanczos,average,mode}

print("gdalwarp "+inFile+"-->"+outFile)
os.system('gdalwarp -te %s %s %s %s -tr %s -%s -tap -ot Float32 -r %s -srcnodata -9999 -dstnodata -9999 -of GTiff -overwrite -co "COMPRESS=ZSTD" -co "PREDICTOR=2" -co "ZLEVEL=6" -co "BIGTIFF=YES" -co "TILED=YES" -co "BLOCKXSIZE=512" -co "BLOCKYSIZE=512" %s %s'%(xmin,ymin,xmax,ymax,target_xres,target_yres,mode,inFile,outFile))

end = time.time()
hours, rem = divmod(end-start, 3600)
minutes, seconds = divmod(rem, 60)
print("finished in {:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds))

