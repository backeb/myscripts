import os
from osgeo import gdal
import time

start = time.time()

inFile = "/p/input/merit-90m/MERIT.nc" 
outFile = "/p/input/merit-90m/MERIT_90m.tif"

print("gdal_translate "+inFile+"-->"+outFile)
os.system('gdal_translate -of GTiff -ot Float32 -co "COMPRESS=ZSTD" -co "PREDICTOR=3" -co "ZLEVEL=6" -co "TILED=YES" -co "BLOCKXSIZE=512" -co "BLOCKYSIZE=512" -co "BIGTIFF=YES" -a_nodata -9999 NETCDF:%s:elevation %s'%(inFile,outFile)) 

end = time.time()
hours, rem = divmod(end-start, 3600)
minutes, seconds = divmod(rem, 60)
print("finished in {:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds))
