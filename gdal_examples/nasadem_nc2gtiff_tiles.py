import os
from osgeo import gdal
import time

start = time.time()

inDir = "/p/input/nasadem/v001/" # netcdf files
outDir = "/p/input/scripts/additionalInput/nasadem/tiles/"

for entry in os.scandir(inDir):
    if (entry.path.endswith(".nc") and entry.is_file()):
        inFile = entry.path
        outFile = outDir+os.path.basename(inFile).strip(".nc")+".tif"
        print("gdal_translate "+inFile+" to "+outFile)
        os.system('gdal_translate -of GTiff -ot Float32 -co "COMPRESS=ZSTD" -co "PREDICTOR=3" -co "ZLEVEL=6" -co "TILED=YES" -co "BLOCKXSIZE=512" -co "BLOCKYSIZE=512" -a_nodata -9999 NETCDF:%s:NASADEM_HGT %s'%(inFile,outFile))

end = time.time()
hours, rem = divmod(end-start, 3600)
minutes, seconds = divmod(rem, 60)
print("finished in {:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds))

