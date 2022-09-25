#!/usr/bin/env bash

echo `date -Iseconds` > web/data/update.txt

# Update
cd prep

Rscript load/econtrol-gas-consumption.r
Rscript load/gie-storage.r

Rscript load/entsoe/load.r
Rscript load/entsoe/generation.r
Rscript load/entsoe/generation-gas.r

cd ..

# Upload
cd web

./sync-data.sh

cd ..
