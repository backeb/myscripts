import os
from osgeo import gdal

# resample DEM
print("resampling DEM")
outDir = '/p/input/scripts/additionalInput/nasademGTiff/resample_1km/'
inList = '/p/input/scripts/additionalInput/nasademGTiff/30mGeotiffs.txt'
resIn  = 30  # in meters
resOut = 1000 # in meters
outFil = '%sNASA_%sm.vrt'%(outDir,resOut)
mode   = 'average' # resampling algorithm: {nearest (default),bilinear,cubic,cubicspline,lanczos,average,mode}

resVal = gdal.Open(open(inList, 'r').readline().rstrip()).GetGeoTransform()[1]/resIn*resOut
os.system('gdalbuildvrt -resolution user -tr %s %s -r %s -input_file_list %s -overwrite %s'%(resVal,resVal,mode,inList,outFil))
print("done gdalbuildvrt")
#os.system('gdal_translate -of GTiff -co "COMPRESS=DEFLATE" -co "TILED=YES" %s %s'%(outFil,outFil.replace('.vrt','.tif')))
os.system('gdal_translate -of GTiff -co "COMPRESS=DEFLATE" -co "TILED=YES" -co "BIGTIFF=YES" %s %s'%(outFil,outFil.replace('.vrt','.tif')))

