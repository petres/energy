#!/usr/bin/env python
# coding: utf-8

import cdsapi
import os.path
from datetime import date, timedelta
from pathlib import Path
import xarray as xr

c = cdsapi.Client()

START_YEAR = 2012
DELAY_DAYS = 5
DATA_FOLDER = Path("./data/era5")
CLIMATE_FOLDER = DATA_FOLDER/"climate"

until = date.today() - timedelta(days = DELAY_DAYS)

# Remove outdated files
for f in ['last_year.nc', 'last_month.nc']:
    current_file = CLIMATE_FOLDER/f
    if os.path.exists(current_file):
        os.remove(current_file)

queryBase = {
    'dataset': 'reanalysis-era5-single-levels',
    'options': {
        'product_type': 'reanalysis',
        'format': 'netcdf',
        'variable': '2m_temperature',
        'area': [50, 8, 45, 18], # north, west, south, east
        'time': [f"{hour:02d}:00" for hour in range(24)],
        'day': [f"{day:02d}" for day in range(1, (32))],
        'month': [f"{month:02d}" for month in range(1, 13)],
        #'grid': [0.5, 0.5],  # grid in 0.5deg steps in longitude/latitude
    },
}

def download_era5_temperature_years(years, folder):
    for year in years:
        filename = folder/f'{year}.nc'
        if not os.path.exists(filename):
            options = {
                'year': [str(year)],
            }
            c.retrieve(queryBase['dataset'], queryBase['options'] | options, filename)

def download_era5_temperature_last_year(until, folder):
    north, west, south, east = 50.,8, 45, 18
    day, month, year = (until.day, until.month, until.year)

    filename = folder/'last_year.nc' 
    if not os.path.exists(filename):
        options = {
            'month': [f"{month:02d}" for month in range(1, month)],
            'year': [str(year)],
        }
        c.retrieve(queryBase['dataset'], queryBase['options'] | options, filename)

    filename = folder/'last_month.nc' 
    if not os.path.exists(filename):
        options = {
            'day': [f"{day:02d}" for day in range(1, day)],
            'month': [f"{month:02d}"],
            'year': [str(year)],
        }
        c.retrieve(queryBase['dataset'], queryBase['options'] | options, filename)


download_era5_temperature_years(range(START_YEAR, (until.year - 1)), CLIMATE_FOLDER)

print(f'Downloading until {until}')
download_era5_temperature_last_year(until, CLIMATE_FOLDER)

