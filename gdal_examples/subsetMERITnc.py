import xarray as xr

inFile = "/p/input/merit-90m/MERIT.nc"

#ds = xr.open_dataset(inFile)
print("opening "+inFile+" subset")
ds1 = xr.open_dataset(inFile).sel(lat=slice(-30,-20),lon=slice(15,25))
print("writing subset netcdf file")
ds1.to_netcdf("subsetDEM.nc")
