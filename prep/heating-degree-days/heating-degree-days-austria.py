import glob
import os.path

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from plotnine import *

from pathlib import Path

import xarray as xr
PATH_ERA5 = 'data/climate/'

if not os.path.isdir(Path(PATH_ERA5)):
    raise RuntimeError(f"Wrong path to ERA5 data: PATH_ERA5 = {PATH_ERA5}")
    
def download_era5_temperature(start_year, end_year, end_month, end_day, dataset):
    north, west, south, east = 50.,8, 45, 18

    for year in range(start_year, end_year + 1):
    
        filename = Path(PATH_ERA5) / f'{year}.nc' 
        
        if end_day < 6:
            end_day = 30 - 5 + end_day
            end_month = end_month - 1
        
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
                    'day': [f"{day:02d}" for day in range(1, (end_day - 5))],
                    'time': [f"{hour:02d}:00" for hour in range(24)],
                    'month': [f"{month:02d}" for month in range(1, end_month + 1)],
                    'year': [str(year)],
                },
            f"{filename}.part")
            os.rename(f"{filename}.part", filename)



today = datetime.date.today()
year = today.year
month = today.month
day = today.day

current_file = f'{}PATH_ERA5/{year}.nc'

if os.path.exists(current_file):
    os.remove(current_file)

download_era5_temperature(2018, year, month, day, 'reanalysis-era5-single-levels')


pop = xr.open_dataarray('data/population/pop_era5_rel.nc')

years =   range(2018, year + 1)
   
for year in years:
    out =  f'{PATH_ERA5}/temperature_population_{year}_corrected.nc'
    file = f'{PATH_ERA5}/{year}.nc'
    temperature = xr.open_mfdataset(file).t2m-273.15
    temperature = temperature.resample(time="d").mean()
    temperature = temperature.where(temperature<=12, 20)
    temperature = 20 - temperature
    (temperature * pop).sum(['longitude','latitude']).to_netcdf(out)

xr.open_mfdataset(f'{PATH_ERA5}/temperature_population_*_corrected.nc').__xarray_dataarray_variable__.to_pandas().max(axis=1).to_csv("data/output/heating-degree-days.csv")