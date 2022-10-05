# [Energy Monitor (energy.abteil.org)](https://energy.abteil.org)

Joint project by [Johannes Schmidt](https://github.com/joph) and me.

Following data sources are used:

- [E-Control](https://www.e-control.at/)
- [entsoe](https://www.entsoe.eu/)
- [GIE - Gas Infrastructure Europe](https://www.gie.eu/)
- [AGGM - Austrian Gas Grid Managment AG](https://www.aggm.at/)
- [EEX - European Energy Exchange](https://www.eex.com/) via [Macrobond](https://www.macrobond.com/)

This repository contains the data preparation code as well as the frontemd code.

## Contribute

Any contribution is welcome, start by cloning this repo:

    git clone https://github.com/petres/energy

## Data Preparation

Copy in the folder `prep` the `creds-template.json` file to `creds.json` and fill it with your credentials. Credentials can be obtained by registering on the corresponding data supplier webpages (free, except for the EEX data, which is retrieved via the non-free data provider Macrobond).

Calling one of the scripts in the `load` folder will download the data from the corresponding data source, extract, aggregate and store the data for the visualisation.


## Web

The website is uses [webpack](https://webpack.js.org/) as bundler and the javascript framework [Vue.js](https://vuejs.org/). 
The visualisations are created by the [gen-vis](https://github.com/petres/gen-vis) library which is build on top of [Vue.js](https://vuejs.org) and [d3](https://d3js.org/).

To run the monitor website locally in dev mode:

    cd web
    npm install
    npm run dev
