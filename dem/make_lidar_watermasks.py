import os
from osgeo import gdal
from os import listdir
from os.path import isfile, join
import time
import xarray as xr

start = time.time()

# get water-mask tiles list generated using make_watermask_tiles.py and write to .txt
path2watermasktiles = "/p/input/scripts/additionalInput/water-mask/tiles/"
fileList = [f for f in listdir(path2watermasktiles) if isfile(join(path2watermasktiles, f))]
with open('/p/input/scripts/additionalInput/water-mask/WatermaskTilesFileList.txt', 'w') as f:
    for item in fileList:
        f.write(path2watermasktiles+"%s\n" % item)
fileList = '/p/input/scripts/additionalInput/water-mask/WatermaskTilesFileList.txt'

#inFile = "/p/input/scripts/additionalInput/lidardem/GLL_DTM_v2_GBM_RV210311.tif"
#inFile = "/p/input/scripts/additionalInput/lidardem/GLL_DTM_v2_Mekong_RV210311.tif"
inFile = "/p/input/scripts/additionalInput/lidardem/GLL_DTM_v2_Myanmar_RV210311.tif"

# get some parameters from the DEM
ds = xr.open_rasterio(inFile)
xmin = ds.x.data.min() 
ymin = ds.y.data.min()
xmax = ds.x.data.max()
ymax = ds.y.data.max()
target_xres = ds.res[0]
target_yres = ds.res[1]

# set some parameters to create the water mask
outFile = inFile.strip(".tif")+"_watermask.tif"
mode   = 'average' # resampling algorithm: {nearest (default),bilinear,cubic,cubicspline,lanczos,average,mode}

# make global water mask GeoTIFF at specified resolution
print("gdalbuildvrt "+fileList+"-->"+outFile.strip(".tif")+".vrt")
os.system('gdalbuildvrt -resolution user -tr %s %s -te %s %s %s %s -srcnodata -9999 -vrtnodata -9999 -r %s -input_file_list %s -overwrite %s'%(target_xres,target_yres,xmin,ymin,xmax,ymax,mode,fileList,outFile.strip(".tif")+".vrt"))
print("gdal_translate "+outFile.strip(".tif")+".vrt-->"+outFile)
os.system('gdal_translate -ot Int16 -of GTiff -co "COMPRESS=ZSTD" -co "PREDICTOR=2" -co "ZLEVEL=6" -co "TILED=YES" -co "BLOCKXSIZE=512" -co "BLOCKYSIZE=512" %s %s'%(outFile.strip(".tif")+".vrt",outFile))
print("gdalwarp "+outFile+"-->"+outFile.strip(".tif")+"_gdalwarp.tif")
os.system('gdalwarp -te %s %s %s %s -tr %s %s -tap -ot Int16 -r %s -srcnodata -9999 -dstnodata -9999 -of GTiff -overwrite -co "COMPRESS=ZSTD" -co "PREDICTOR=2" -co "ZLEVEL=6" -co "TILED=YES" -co "BLOCKXSIZE=512" -co "BLOCKYSIZE=512" %s %s'%(xmin,ymin,xmax,ymax,target_xres,target_yres,mode,outFile,outFile.strip(".tif")+"_gdalwarp.tif"))
os.remove(outFile)
os.rename(outFile.strip(".tif")+"_gdalwarp.tif",outFile)

end = time.time()
hours, rem = divmod(end-start, 3600)
minutes, seconds = divmod(rem, 60)
print("finished in {:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds))

