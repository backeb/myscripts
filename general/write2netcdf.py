def write2nc :
    from netCDF4
# write to netcdf file
# check if selected filename exists
while os.path.isfile(fname):
	fname = input(fname+" already exists, choose another: ")

print "writing data to netcdf file " +fname +"...."
rootgrp = Dataset(fname, "w", format="NETCDF4")

# define dimensions
longitude = rootgrp.createDimension("longitude", len(lon))
latitude = rootgrp.createDimension("latitude", len(lat))
time = rootgrp.createDimension("time", len(day))

# The createVariable method has two mandatory arguments, the variable name (a Python string), and the variable datatype.
# The variable's dimensions are given by a tuple containing the dimension names (defined previously with createDimension) 
longitudes = rootgrp.createVariable("longitude","f8",("longitude",),fill_value = nc.variables.get("lon")._FillValue)
latitudes = rootgrp.createVariable("latitude","f8",("latitude",),fill_value = nc.variables.get("lat")._FillValue)
times = rootgrp.createVariable("time","f8",("time",),fill_value = -32767.0)
sst4 = rootgrp.createVariable("sea_surface_temperature","f8",("time","latitude","longitude",),fill_value = 65535)

# write attributes
import time as t
# global
rootgrp.description = "Regional subset of monthly mean MODIS Level-3 Standard Mapped Global Image"
rootgrp.history = "Created " + t.ctime(t.time())
rootgrp.time_coverage_start = datetime.fromordinal(int(torig.toordinal()+julday[0])).strftime("%d/%m/%Y")
rootgrp.time_coverage_end = datetime.fromordinal(int(torig.toordinal()+julday[-1])).strftime("%d/%m/%Y")
rootgrp.spatialResolution = str(nc.spatialResolution)
# by variable
# longitudes
longitudes.long_name = nc.variables.get("lon").long_name
longitudes.units = nc.variables.get("lon").units
longitudes.valid_min = lon.min()
longitudes.valid_max = lon.max()
# latitudes
latitudes.long_name = nc.variables.get("lat").long_name
latitudes.units = nc.variables.get("lat").units
latitudes.valid_min = lat.min()
latitudes.valid_max = lat.max()
# times
times.long_name = "Date of the middle of the month for which monthly mean is valid"
times.units = "Days since 1-Jan-1950"
times.valid_min = julday.min()
times.valid_max = julday.max()
# sst
sst4.long_name = nc.variables.get("sst4").long_name
sst4.units = nc.variables.get("sst4").units
sst4.standard_name = nc.variables.get("sst4").standard_name
sst4.display_scale = nc.variables.get("sst4").display_scale
sst4.display_min = nc.variables.get("sst4").display_min
sst4.display_max = nc.variables.get("sst4").display_max
sst4.scale_factor = nc.variables.get("sst4").scale_factor
sst4.add_offset = nc.variables.get("sst4").add_offset

# write data to variables
longitudes[0:len(lon)] = lon
latitudes[0:len(lat)] = lat
times[0:len(julday)] = julday
sst4[0:len(julday), 0:len(lat), 0:len(lon)] = sst
rootgrp.close()

