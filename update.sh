#!/usr/bin/env bash

# - WRITE TIME -----------------------------------------------------------------
echo `date -Iseconds` > web/data/update.txt


# - UPDATE DATA ----------------------------------------------------------------
cd prep

# - TEMP/HEATING DAYS
python3 load/era5/downloadExtractFull.py
Rscript calc/hdd.r
# Rscript calc/prediction-gas-consumption/linearModel1.r

# - GAS
Rscript load/econtrol-gas-consumption.r
Rscript load/aggm/gas-consumption.r
Rscript load/gie/detailed.r

# - ELECTRICITY
Rscript load/entsoe/load.r
Rscript load/entsoe/load-int.r
Rscript load/entsoe/generation.r
Rscript load/entsoe/generation-hourly.r
Rscript load/entsoe/generation-facets.r
Rscript load/entsoe/generation-gas.r
Rscript load/entsoe/generation-int.r

cd ..


# - UPLOAD DATA ----------------------------------------------------------------
cd web
./sync-data.sh
cd ..
