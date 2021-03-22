#import xarray as xr
#import numpy as np
import os
from osgeo import gdal
import time

start = time.time()

inDir = "/p/input/water-mask/"
outDir = "/p/input/scripts/additionalInput/water-mask/tiles/"

# get info from 1 file
# fname = inDir+"occurrence_20E_30Sv1_1_2019.tif"
# os.system('gdalinfo %s'%(fname))

for entry in os.scandir(inDir):
    if (entry.path.endswith(".tif") and entry.is_file()):
        inFile = entry.path
        outFile = outDir+"watermask"+os.path.basename(inFile)[10:]
        print('gdal_calc: '+inFile+' --> '+outFile)
        os.system('gdal_calc.py -A %s --outfile=%s --calc="1*(A>50)" --NoDataValue=-9999 --co="COMPRESS=DEFLATE"  --co="TILED=YES" --quiet --overwrite'%(inFile,outFile))

end = time.time()
hours, rem = divmod(end-start, 3600)
minutes, seconds = divmod(rem, 60)
print("finished water-mask tiles in {:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds))

