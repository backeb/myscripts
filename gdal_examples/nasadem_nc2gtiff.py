import os
from osgeo import gdal

inDir = "/p/input/nasadem/v001/"
outDir = "/p/input/scripts/additionalInput/nasademGTiff/tiles/"

for entry in os.scandir(inDir):
    if (entry.path.endswith(".nc") and entry.is_file()):
        inFile = entry.path
        outFile = outDir+os.path.basename(inFile).strip(".nc")+".tif"
        print("gdal_translate "+inFile+" to "+outFile)
        os.system('gdal_translate -of GTiff -co "COMPRESS=DEFLATE" -co "TILED=YES" -a_nodata -9999 %s %s'%(inFile,outFile))

# resample DEM
# print("resampling DEM")
# outDir = '/p/input/merit-90m/resampled/'
# inList = '/p/input/merit-90m/90mGeotiffs.txt'
# resIn  = 90  # in meters
# outFil = '%sMERIT_%sm.vrt'%(outDir,resOut)
# mode   = 'average' # resampling algorithm: {nearest (default),bilinear,cubic,cubicspline,lanczos,average,mode}

# resVal = gdal.Open(open(inList, 'r').readline().rstrip()).GetGeoTransform()[1]/resIn*resOut
# os.system('gdalbuildvrt -resolution user -tr %s %s -r %s -input_file_list %s -overwrite %s'%(resVal,resVal,mode,inList,outFil))
# print("done gdalbuildvrt")
# #os.system('gdal_translate -of GTiff -co "COMPRESS=DEFLATE" -co "TILED=YES" %s %s'%(outFil,outFil.replace('.vrt','.tif')))
# os.system('gdal_translate -of GTiff -co "COMPRESS=DEFLATE" -co "TILED=YES" -co "BIGTIFF=YES" %s %s'%(outFil,outFil.replace('.vrt','.tif')))

