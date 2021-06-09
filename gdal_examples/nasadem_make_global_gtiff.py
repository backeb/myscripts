import os
from osgeo import gdal
from os import listdir
from os.path import isfile, join
import time

start = time.time()

# get nasadem tiles list generated using nasadem_nc2gtiff_tiles.py and write to .txt
path2watermasktiles = "/p/input/scripts/additionalInput/nasadem/tiles/"
fileList = [f for f in listdir(path2watermasktiles) if isfile(join(path2watermasktiles, f))]
with open('/p/input/scripts/additionalInput/nasadem/NASADEMTilesFileList.txt', 'w') as f:
    for item in fileList:
        f.write(path2watermasktiles+"%s\n" % item)
fileList = '/p/input/scripts/additionalInput/nasadem/NASADEMTilesFileList.txt'

# define some parameters to get 1 global watermask GeoTIFF
target_xres = 0.000833333333333 # 90m
target_yres = 0.000833333333333 # 90m, note both target_res have to be positive values
mask = "/p/input/merit-90m/MERIT_90m.tif"
outFile = '/p/input/scripts/additionalInput/nasadem/global/NASADEM_90m.tif'
#target_xres = 0.01 # 1000m
#target_yres = 0.01 # 1000m, note both target_res have to be positive values
#mask = "/p/input/merit-90m/MERIT_1000m.tif"
#outFile = '/p/input/scripts/additionalInput/nasadem/global/NASADEM_1000m.tif'

# don't change the below
xmin = -180.0004167 # MERIT_90m.tif and MERIT_1000m.tif xmin
ymin = -90.0004167 # MERIT_90m.tif and MERIT_1000m.tif ymin
xmax = 179.9995833 # MERIT_90m.tif and MERIT_1000m.tif xmax
ymax = 89.9995833 # MERIT_90m.tif and MERIT_1000m.tif ymax
mode   = 'average' # resampling algorithm: {nearest (default),bilinear,cubic,cubicspline,lanczos,average,mode}

# make global water mask GeoTIFF at specified resolution
print("gdalbuildvrt "+fileList+"-->"+outFile.strip(".tif")+".vrt")
os.system('gdalbuildvrt -resolution user -tr %s %s -te %s %s %s %s -srcnodata -9999 -vrtnodata -9999 -r %s -input_file_list %s -overwrite %s'%(target_xres,target_yres,xmin,ymin,xmax,ymax,mode,fileList,outFile.strip(".tif")+".vrt"))

#print("gdal_translate "+outFile.strip(".tif")+".vrt-->"+outFile)
os.system('gdal_translate -ot Float32 -of GTiff -co "COMPRESS=ZSTD" -co "PREDICTOR=2" -co "ZLEVEL=6" -co "TILED=YES" -co "BLOCKXSIZE=512" -co "BLOCKYSIZE=512" -co "BIGTIFF=YES" %s %s'%(outFile.strip(".tif")+".vrt",outFile))

#print("gdalwarp "+outFile+"-->"+outFile.strip(".tif")+"_gdalwarp.tif")
os.system('gdalwarp -te %s %s %s %s -tr %s -%s -ot Float32 -r %s -srcnodata -9999 -dstnodata -9999 -of GTiff -overwrite -co "COMPRESS=ZSTD" -co "PREDICTOR=2" -co "ZLEVEL=6" -co "TILED=YES" -co "BLOCKXSIZE=512" -co "BLOCKYSIZE=512" -co "BIGTIFF=YES" %s %s'%(xmin,ymin,xmax,ymax,target_xres,target_yres,mode,outFile,outFile.strip(".tif")+"_gdalwarp.tif"))

print("gdal_calc to mask coastal seas using MERIT")
os.system('gdal_calc.py -A %s -B %s --outfile=%s --overwrite --co="COMPRESS=ZSTD" --co="PREDICTOR=2" --co="ZLEVEL=6" --co="TILED=YES" --co="BLOCKXSIZE=512" --co="BLOCKYSIZE=512" --co="BIGTIFF=YES" --calc="numpy.where(B!=-9999, A,-9999)" --NoDataValue=-9999'%(outFile,mask,outFile.strip(".tif")+"_gdalwarp_mask.tif"))

# clean up directory
os.remove(outFile)
os.remove(outFile.strip(".tif")+"_gdalwarp.tif")
os.rename(outFile.strip(".tif")+"_gdalwarp_mask.tif",outFile)

end = time.time()
hours, rem = divmod(end-start, 3600)
minutes, seconds = divmod(rem, 60)
print("finished in {:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds))
