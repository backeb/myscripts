# coding: utf-8
"""Purpose: download ERA5 data from the Copernicus Data Store

Dependencies: 
- $HOME/.cdsapirc (for more info: https://cds.climate.copernicus.eu/api-how-to#install-the-cds-api-key)
- `conda env create -f environment.yaml`

Creation date: 5 May 2022
Author: backeb <bjorn.backeberg@deltares.nl> Bjorn Backeberg
"""
import cdsapi
from datetime import datetime, timedelta
from pathlib import Path
import xarray as xr

def get_era5_single_levels(longitude_min, longitude_max, latitude_min, latitude_max, date_min, date_max, vars, outdir):
	c = cdsapi.Client()
	# here we make the strings to use in the api 
	areastr = [str(longitude_min)+'/'+str(latitude_min)+'/'+str(longitude_max)+'/'+str(latitude_max)]
	vars = list(vars) # convert tuple to list for cdsapi
	#make the /data/era5 directory if it does not exist
	Path(outdir+'/era5/tmp').mkdir(parents=True, exist_ok=True)
	delta = datetime.strptime(date_max, '%Y-%m-%d') - datetime.strptime(date_min, '%Y-%m-%d')
	for i in range(delta.days+1):
		day = datetime.strptime(date_min, '%Y-%m-%d').date() + timedelta(days=i)
		check_file = Path(outdir+'/era5/tmp/era5_'+str(day)+'.nc')
		while not check_file.is_file():
			yearstr = [f'{day.year:0>4}']
			monthstr = [f'{day.month:0>2}']
			daystr = [f'{day.day:0>2}']
			c.retrieve(
				'reanalysis-era5-single-levels', 
				{
				'product_type':'reanalysis',
				'variable': vars,
				'year':yearstr,
				'area':areastr,
				'month':monthstr,
				'day':daystr,
				'time':[
					'00:00','01:00','02:00',
					'03:00','04:00','05:00',
					'06:00','07:00','08:00',
					'09:00','10:00','11:00',
					'12:00','13:00','14:00',
					'15:00','16:00','17:00',
					'18:00','19:00','20:00',
					'21:00','22:00','23:00'
					],
				'format':'netcdf'
				},
				check_file)
	ds = xr.open_mfdataset(outdir+'/era5/tmp/era5_*.nc', combine='by_coords', decode_times=False)
	ds.to_netcdf(outdir+'/era5/era5.nc')
