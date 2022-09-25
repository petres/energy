# [Energy Monitor (energy.abteil.org)](https://energy.abteil.org)

This repository contains the code of a simple energy monitor displaying energy data from:
- [E-Control](https://www.e-control.at/)
- [entsoe](https://www.entsoe.eu/)
- [Gas Infrastructure Europe](https://www.gie.eu/)


Any contribution is welcome, start by cloning this repo:

    git clone https://github.com/petres/energy

## Data

Copy the `creds-template.json` file to `creds.json` and fill it with your credentials. 
Calling a scripts in the `load` folder will download data from the corresponding data source, extract, aggregate and store the data for the visualisation.


## Web

The website is uses [webpack](https://webpack.js.org/) as bundler and the javascript framework [vue3](https://vuejs.org/). 
The visualisations are created by the [gen-vis](https://github.com/petres/gen-vis) library which is build on top of [d3](https://d3js.org/).

To run the dev website:

    cd web
    npm install
    npm run dev
