import xarray as xr
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


import os
import itertools

path = 'data/population/'

in_raster = f'{path}gpw_v4_population_density_rev11_2020_30_sec.tif'
out_raster = f'{path}austria_population_1_km.tif'
clip = '{path}shape-file-austria/AUT_adm0.shp'
cmd = 'gdalwarp -q -cutline %s -crop_to_cutline %s %s' % (clip, in_raster, out_raster)
os.system(cmd)

population = xr.open_rasterio(out_raster)
# replace negative values by 0
population = population.where(population>=0, np.nan)


temp_austria_2018 = xr.open_dataset('data/climate/2018.nc')

def getPOPsumtile(ij):
    lon = ij.lon
    lat = ij.lat
    lonmin = lon - 0.125
    lonmax = lon + 0.125
    lons = pop1.x[(population.x>=lonmin)&(population.x<lonmax)].values
    latmin = lat - 0.125
    latmax = lat + 0.125
    lats = pop1.y[(population.y>=latmin)&(population.y<latmax)].values
    return(float(population.sel(x=lons,y=lats).mean().values))
    
templons = list(temp_austria_2018.longitude.values)
templats = list(temp_austria_2018.latitude.values)

lonlats = pd.DataFrame(itertools.product(templons, templats),columns=['lon','lat'])

lonlats['sum_pop'] = lonlats.apply(getPOPsumtile,axis=1)

population_era5 = lonlats.sum_pop.values.reshape((len(templons),len(templats))).transpose()

population_rel = population_era5/np.nansum(population_era5)

pop_era5_rel = xr.DataArray(data=population_rel, 
                       coords={'latitude':templats,'longitude':templons}, 
                       dims=['latitude','longitude'], name='rel_pop')

pop_era5_rel.to_netcdf('pop_era5_rel.nc')

