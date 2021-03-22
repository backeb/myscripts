# to get i,j indices in ipython do:
# from netCDF4 import Dataset
# nc = Dataset("ERA-I/ans.6h.1990.10U.nc")
# lon = nc.variables["lon"][:]
# lat = nc.variables["lat"][:]
# from numpy import where, squeeze
# west = 0 
# east = 60
# south = -55
# north = -5
# ilon = where((lon >= west) & (lon <= east))
# ilat = where((lat >= south) & (lat <= north))
# ilon = squeeze(ilon)
# ilat = squeeze(ilat)
# print ilon[0], ilon[-1]
# print ilat[0], ilat[-1]

module load nco

for i in ERA-I/ans.6h.1990.10U.nc
do
   echo extracting subset from $i and ${i:0:20}V.nc
   ncks -F -d lat,190,290 -d lon,360,480 $i -o ${i:6:15}_subset.nc
   ncks -F -d lat,190,290 -d lon,360,480 ${i:0:20}V.nc -o ${i:6:14}V_subset.nc
done

