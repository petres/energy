#!/usr/bin/env bash

# - WRITE TIME -----------------------------------------------------------------
echo `date -Iseconds` > web/data/update-macrobond.txt


# - UPDATE DATA ----------------------------------------------------------------
cd prep
Rscript update-macrobond.r
cd ..


# - UPLOAD DATA ----------------------------------------------------------------
cd web
./sync-data.sh
cd ..
