import os
from osgeo import gdal
import time

start = time.time()

inFile = "/p/input/merit-90m/MERIT.nc" 
outFile = "/p/input/merit-90m/MERIT_90m.tif"
#inFile = "subsetDEM.nc"
#outFile = "subsetDEM.tif"

#print("gdal_translate "+inFile+"-->"+outFile)
#os.system('gdal_translate -of GTiff -ot Float32 -co "COMPRESS=DEFLATE" -co "TILED=YES" -co "BIGTIFF=YES" -a_nodata -9999 NETCDF:%s:elevation %s'%(inFile,outFile))
#os.system('gdal_translate -of GTiff -ot Float32 -co "COMPRESS=DEFLATE" -co "PREDICTOR=3" -co "ZLEVEL=6" -co "TILED=YES" -co "BIGTIFF=YES" -a_nodata -9999 NETCDF:%s:elevation %s'%(inFile,outFile)) # 194M
#os.system('gdal_translate -of GTiff -ot Float32 -co "COMPRESS=ZSTD" -co "PREDICTOR=3" -co "ZLEVEL=9" -co "TILED=YES" -co "BIGTIFF=YES" -a_nodata -9999 NETCDF:%s:elevation %s'%(inFile,outFile)) # 184M
#os.system('gdal_translate -of GTiff -ot Float32 -co "COMPRESS=ZSTD" -co "PREDICTOR=3" -co "ZLEVEL=9" -co "TILED=YES" -co "BLOCKXSIZE=512" -co "BLOCKYSIZE=512" -co "BIGTIFF=YES" -a_nodata -9999 NETCDF:%s:elevation %s'%(inFile,outFile)) # 182M
os.system('gdal_translate -of GTiff -ot Float32 -co "COMPRESS=ZSTD" -co "PREDICTOR=3" -co "ZLEVEL=6" -co "TILED=YES" -co "BLOCKXSIZE=512" -co "BLOCKYSIZE=512" -co "BIGTIFF=YES" -a_nodata -9999 NETCDF:%s:elevation %s'%(inFile,outFile)) # 182M

#datatype = "" # Int32, Int16, Float64, UInt16, Byte, UInt32, Float32
#compress = "" 
#
#inFile2 = outFile
#outFile2 = inFile2.strip(".tif")+"_sf100_"+datatype+".tif"
#print("gdal_calc "+inFile2+"-->"+outFile2)
##os.system('gdal_calc.py -A %s --outfile=%s --calc="100*A" --type="Int16" --co="COMPRESS=DEFLATE"  --co="TILED=YES" --quiet --overwrite'%(inFile2,outFile2))
#os.system('gdal_calc.py -A %s --outfile=%s --calc="100*A" --type="Int16" --co="TILED=YES" --quiet --overwrite'%(inFile2,outFile2))
"gdal_calc fill no value"
"try wrap with numpy"


#inFile3 = outFile2
#outFile3 = inFile3.strip(".tif")+"_Int16.tif"
#print("gdal_translate "+inFile3+"-->"+outFile3)
#os.system('gdal_translate -of GTiff -ot Int16 -co "COMPRESS=DEFLATE" -co "TILED=YES" -co "BIGTIFF=YES" -a_nodata -9999 %s %s'%(inFile3,outFile3))


end = time.time()
hours, rem = divmod(end-start, 3600)
minutes, seconds = divmod(rem, 60)
print("finished in {:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds))


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

