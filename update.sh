#!/usr/bin/env bash

echo `date -Iseconds` > web/data/update.txt

# Update
cd prep

python3 heating-degree-days/download-heating-degree-days.py

Rscript load/econtrol-gas-consumption.r
Rscript load/gie-storage.r
Rscript load/aggm-gas-consumption.r.r
# Rscript heating-degree-days/prepare-heating-degree-days.R
Rscript load/aggm-gas-consumption.r

Rscript load/entsoe/load.r
Rscript load/entsoe/generation.r
Rscript load/entsoe/generation-hourly.r
Rscript load/entsoe/generation-gas.r

cd ..

# Upload
cd web

./sync-data.sh

cd ..
