# coding: utf-8
'''Purpose: download hydrodynamics data from Copernicus Marine Service

Dependencies: 
- register for username and password at <https://resources.marine.copernicus.eu/registration-form>.
- `conda env create -f environment.yaml`

Creation Date: 2 May 2022
Author: backeb <bjorn.backeberg@deltares.nl> Bjorn Backeberg
'''
from datetime import timedelta, datetime
from pathlib import Path
import subprocess
import xarray as xr # note dependencies: dask, netCDF4

def get_nrt_daily(username, password, longitude_min, longitude_max, latitude_min, latitude_max, date_min, date_max, vars, outdir):
	#make the /data/tmp directory if it does not exist
	Path(outdir+'/cmems/tmp').mkdir(parents=True, exist_ok=True)
	delta = datetime.strptime(date_max, '%Y-%m-%d') - datetime.strptime(date_min, '%Y-%m-%d')
	for var in vars:
		for i in range(delta.days+1):
			max_runs = 2
			run = 0
			day = datetime.strptime(date_min, '%Y-%m-%d').date() + timedelta(days=i)
			check_file = Path(outdir+'/cmems/tmp/cmems_'+str(var)+'_'+str(day)+'.nc')
			while not check_file.is_file():
				while run < max_runs:
					try:
						subprocess.run(['python', '-m', 'motuclient',
							'--motu', 'https://nrt.cmems-du.eu/motu-web/Motu',
							'--service-id', 'GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS',
							'--product-id', 'global-analysis-forecast-phy-001-024',
							'--longitude-min',str(longitude_min),
							'--longitude-max', str(longitude_max),
							'--latitude-min', str(latitude_min),
							'--latitude-max', str(latitude_max),
							'--date-min', str(day)+' 12:00:00',
							'--date-max', str(day)+' 12:00:00',
							'--depth-min', '0.493',
							'--depth-max', '5727.918000000001',
							'--variable', str(var),
							'--out-dir', outdir+'/cmems/tmp',
							'--out-name', 'cmems_'+str(var)+'_'+str(day)+'.nc',
							'--user', username,
							'--pwd', password],
							check=True,
							timeout=300)
					except subprocess.TimeoutExpired as e:
						print(var)
						print(e.stdout)
						print(e.stderr)
						continue
					else:
						break
					finally:
						run += 1
	ds = xr.open_mfdataset(outdir+'/cmems/tmp/cmems_*.nc', combine='by_coords', decode_times=False)
	ds.to_netcdf(outdir+'/cmems/cmems.nc')

def get_nrt_hourly(username, password, longitude_min, longitude_max, latitude_min, latitude_max, date_min, date_max, vars, outdir):
	#make the /data/tmp directory if it does not exist
	Path(outdir+'/cmems/tmp').mkdir(parents=True, exist_ok=True)
	delta = datetime.strptime(date_max, '%Y-%m-%d') - datetime.strptime(date_min, '%Y-%m-%d')
	for var in vars:
		for i in range(delta.days+1):
			max_runs = 2
			run = 0
			day = datetime.strptime(date_min, '%Y-%m-%d').date() + timedelta(days=i)
			check_file = Path(outdir+'/cmems/tmp/cmems_'+str(var)+'_'+str(day)+'.nc')
			while not check_file.is_file():
				while run < max_runs:
					try:
						subprocess.run(['python', '-m', 'motuclient',
							'--motu', 'https://nrt.cmems-du.eu/motu-web/Motu',
							'--service-id', 'GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS',
							'--product-id', 'global-analysis-forecast-phy-001-024-hourly-t-u-v-ssh',
							'--longitude-min',str(longitude_min),
							'--longitude-max', str(longitude_max),
							'--latitude-min', str(latitude_min),
							'--latitude-max', str(latitude_max),
							'--date-min', str(day)+' 00:00:00',
							'--date-max', str(day)+' 23:59:00',
							'--depth-min', '0.493',
							'--depth-max', '0.495',
							'--variable', str(var),
							'--out-dir', outdir+'/cmems/tmp',
							'--out-name', 'cmems_'+str(var)+'_'+str(day)+'.nc',
							'--user', username,
							'--pwd', password],
							check=True,
							timeout=300)
					except subprocess.TimeoutExpired as e:
						print(var)
						print(e.stdout)
						print(e.stderr)
						continue
					else:
						break
					finally:
						run += 1
	ds = xr.open_mfdataset(outdir+'/cmems/tmp/cmems_*.nc', combine='by_coords', decode_times=False)
	ds.to_netcdf(outdir+'/cmems/cmems.nc')
