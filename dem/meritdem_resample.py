import os
from osgeo import gdal
import time

start = time.time()

inFile = '/p/input/merit-90m/MERIT_90m.tif'
target_xres = 0.01
target_yres = -0.01
mode   = 'average' # resampling algorithm: {nearest (default),bilinear,cubic,cubicspline,lanczos,average,mode}
outFile = inFile.strip("_90m.tif")+"_1000m.tif"

print("resampling using gdalwarp "+inFile+"-->"+outFile)
os.system('gdalwarp -tr %s %s -ot Float32 -r %s -srcnodata -9999 -dstnodata -9999 -of GTiff -overwrite -co "COMPRESS=ZSTD" -co "PREDICTOR=3" -co "ZLEVEL=6" -co "TILED=YES" -co "BLOCKXSIZE=512" -co "BLOCKYSIZE=512" -co "BIGTIFF=YES" %s %s'%(target_xres,target_yres,mode,inFile,outFile))

end = time.time()
hours, rem = divmod(end-start, 3600)
minutes, seconds = divmod(rem, 60)
print("finished in {:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds))

