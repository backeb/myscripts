import os
from osgeo import gdal

# resample water mask
print("resampling water mask")
outDir = '/p/input/scripts/additionalInput/water-mask/global/'
inList = '/p/input/scripts/additionalInput/water-mask/30mWaterMaskGTiffs.txt'
refDEM = 'MERIT' # or 'NASA' or 'LiDAR'
resIn  = 30  # in meters
resOut = 1000 # in meters
outFil = '%sWaterMask_%s_%sm.vrt'%(outDir,refDEM,resOut)
mode   = 'average' # resampling algorithm: {nearest (default),bilinear,cubic,cubicspline,lanczos,average,mode}

#resVal = gdal.Open(open(inList, 'r').readline().rstrip()).GetGeoTransform()[1]/resIn*resOut
#os.system('gdalbuildvrt -resolution user -tr %s %s -r %s -input_file_list %s -overwrite %s'%(resVal,resVal,mode,inList,outFil))
#os.system('gdal_translate -of GTiff -co "COMPRESS=DEFLATE" -co "TILED=YES" -co "BIGTIFF=YES" %s %s'%(outFil,outFil.replace('.vrt','.tif')))
#os.system('')


# gdalwarp to DEM grid
numtype = 'Int16'
cellsizex = 0.009259259259260
cellsizey = -0.009259259259260
xmin = -180.0004167
ymin = -60.0004167
xmax = 179.9995833
ymax = 84.9995833

inFile = outFil.strip('.vrt')+".tif"
outFile = outFil.strip('.vrt')+"_warp"+refDEM+".tif"

os.system('gdalwarp -overwrite -ot %s -tr %s %s -te %s %s %s %s -r %s -co "COMPRESS=DEFLATE" %s %s'%(numtype,cellsizex,cellsizey,xmin,ymin,xmax,ymax,mode,inFile,outFile))

# gdalwarp -overwrite -ot Int16 -tr 0.009259259259260 -0.009259259259260 -te -180.0004167 -60.0004167 179.9995833 84.9995833 -r average -co "COMPRESS=DEFLATE" p/input/scripts/additionalInput/nasademGTiff/resample_1km/NASA_1000m.tif p/input/scripts/additionalInput/nasademGTiff/resample_1km/NASA_1000m_warpMERIT_avg.tif
# gdalwarp -overwrite -ot <NUMERICAL_TYPE> -tr <CELLSIZE_X> <CELLSIZE_Y> -te <XMIN YMIN XMAX YMAX> -r <RESAMPLING_METHOD> -co <COMPRESSION_METHOD> <INPUT_FILE> <OUTPUT_FILE>
