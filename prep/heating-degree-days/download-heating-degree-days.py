import cdsapi
import os.path
import datetime
from pathlib import Path
import xarray as xr
import glob

c = cdsapi.Client()

PATH_ERA5 = 'data/climate/'

DELAY_DAYS = 6

if not os.path.isdir(Path(PATH_ERA5)):
    raise RuntimeError(f"Wrong path to ERA5 data: PATH_ERA5 = {PATH_ERA5}")

def download_era5_temperature_cache(start_year, end_year, dataset):
    north, west, south, east = 50.,8, 45, 18

    for year in range(start_year, end_year + 1):
    
        filename = Path(PATH_ERA5) / f'{year}.nc' 
        
        if not os.path.exists(filename):
            
            c.retrieve(
                dataset,
                {
                    'product_type': 'reanalysis',
                    'format': 'netcdf',
                    'variable': '2m_temperature',
                    'area': [
                        north, west, south, east
                    ],
                    #'grid': [0.5, 0.5],  # grid in 0.5deg steps in longitude/latitude
                    'day': [f"{day:02d}" for day in range(1, (32))],
                    'time': [f"{hour:02d}:00" for hour in range(24)],
                    'month': [f"{month:02d}" for month in range(1, 13)],
                    'year': [str(year)],
                },
            f"{filename}.part")
            os.rename(f"{filename}.part", filename)


def download_era5_temperature_last_year(year, month, end_day, dataset):
    north, west, south, east = 50.,8, 45, 18

    filename = Path(PATH_ERA5) / f'last_year.nc' 
    
    if not os.path.exists(filename):
            
            c.retrieve(
                dataset,
                {
                    'product_type': 'reanalysis',
                    'format': 'netcdf',
                    'variable': '2m_temperature',
                    'area': [
                        north, west, south, east
                    ],
                    #'grid': [0.5, 0.5],  # grid in 0.5deg steps in longitude/latitude
                    'day': [f"{day:02d}" for day in range(1, (32))],
                    'time': [f"{hour:02d}:00" for hour in range(24)],
                    'month': [f"{month:02d}" for month in range(1, month)],
                    'year': [str(year)],
                },
            f"{filename}.part")
            os.rename(f"{filename}.part", filename)
    
    filename = Path(PATH_ERA5) / f'last_month.nc' 
        
    if not os.path.exists(filename):
            
            c.retrieve(
                dataset,
                {
                    'product_type': 'reanalysis',
                    'format': 'netcdf',
                    'variable': '2m_temperature',
                    'area': [
                        north, west, south, east
                    ],
                    #'grid': [0.5, 0.5],  # grid in 0.5deg steps in longitude/latitude
                    'day': [f"{day:02d}" for day in range(1, (end_day - DELAY_DAYS + 1))],
                    'time': [f"{hour:02d}:00" for hour in range(24)],
                    'month': [f"{month:02d}" for month in range(month, month + 1)],
                    'year': [str(year)],
                },
            f"{filename}.part")
            os.rename(f"{filename}.part", filename)

today = datetime.date.today()
year = today.year
month = today.month
day = today.day

#this is necessary unfortunately as a query with a period to close to the current day,
#will fail with an error message

if day <= DELAY_DAYS:
    day = 30 + day
    if month == 1:
        month = 12
        year = year - 1
    else:
        month = month - 1

current_file = f'{PATH_ERA5}/last_year.nc'

if os.path.exists(current_file):
    os.remove(current_file)

download_era5_temperature_cache(2018, year - 1, 'reanalysis-era5-single-levels')

current_file = f'{PATH_ERA5}/last_month.nc'

if os.path.exists(current_file):
    os.remove(current_file)

print(f'Downloading until {year}-{month}-{day-DELAY_DAYS}')
download_era5_temperature_last_year(year, month, day, 'reanalysis-era5-single-levels')

pop = xr.open_dataarray('data/population/pop_era5_rel.nc')
file = f'{PATH_ERA5}/*.nc'

temperature = xr.open_mfdataset(file)
temperature = temperature.t2m  - 273.15
temperature = temperature.resample(time="d").mean()
temperature = temperature.where(temperature<=12, 20)
temperature = 20 - temperature
temperature = (temperature * pop).sum(['longitude','latitude'])

temperature.to_pandas().max(axis=1).to_csv("data/output/heating-degree-days.csv")


