#!/usr/bin/env bash

# - WRITE TIME -----------------------------------------------------------------
echo `date -Iseconds` > web/data/update.txt


# - UPDATE DATA ----------------------------------------------------------------
cd prep

# - HEATING DAYS
# python3 heating-degree-days/download-heating-degree-days.py
# Rscript heating-degree-days/prepare-heating-degree-days.R

# - GAS
# Obsolete, gas consumption is now obtained from AGGM 
# Rscript load/econtrol-gas-consumption.r
Rscript load/aggm-gas-consumption.r
Rscript load/gie-storage.r

# - ELECTRICITY 
Rscript load/entsoe/load.r
Rscript load/entsoe/generation.r
Rscript load/entsoe/generation-hourly.r
Rscript load/entsoe/generation-facets.r
Rscript load/entsoe/generation-gas.r

cd ..


# - UPLOAD DATA ----------------------------------------------------------------
cd web
./sync-data.sh
cd ..
