from pathlib2 import Path
import os
import datetime
import numpy as np
import xarray as xr
#import pandas as pd

lonllc = 10 # longitude lower left corner
lonurc = 50 # longitude upper right corner
latllc = -45 #latitude lower left corner
laturc = -20 # latitude upper right corner

strtdt = datetime.date(2007,1,2) #pd.to_datetime(hyctime[0])
enddt = datetime.date(2007,12,31) #pd.to_datetime(hyctime[-1])
nmbrdys = (enddt - strtdt).days+1
svnm = "validationData/mursst_"+str(strtdt.strftime('%Y%m%d'))+"-"+str(enddt.strftime('%Y%m%d'))+".nc"

# first check if we've already downloaded the data
my_file = Path(svnm)
if my_file.is_file():
    print(svnm+" already exists (phew!)")
else:
    print("[opendap] downloading data from server (sit back, relax, this may take a while)...")

    url = []

    for i in np.arange(1,nmbrdys+1):

        date2dwnld = strtdt+datetime.timedelta(days=int(i)-1)
        doy = date2dwnld.timetuple().tm_yday

        url.append("https://opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/"\
                +str(date2dwnld.year)+"/"+"%03d"%doy+"/"\
                +str(date2dwnld.year)+str("%02d"%date2dwnld.month)+str("%02d"%date2dwnld.day)\
                +"090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc")

    print("[xarray] opening MUR SST dataset....")
    ds = xr.open_mfdataset(url, autoclose=True).sel(lon=slice(lonllc, lonurc),lat=slice(latllc, laturc))
    print("[xarray] ... done")

    # drop unwanted variables
    ds = ds.drop("analysis_error")
    ds = ds.drop("sea_ice_fraction")
    
    print("[xarray] writing dataset to netcdf file...")
    ds.to_netcdf(svnm, format = "NETCDF4")
    print("[xarry] ... done")


