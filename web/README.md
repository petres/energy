# [Energy Monitor (energy.abteil.org)](https://energy.abteil.org)

Joint project by [Johannes Schmidt](https://github.com/joph) and me. This repository provides the frontend code for the monitor webpage.

## Contribute

Any contribution is welcome, start by cloning this repo:

    git clone https://github.com/energy-monitor/web.git

## Web

The website uses [webpack](https://webpack.js.org/) as bundler and the javascript framework [Vue.js](https://vuejs.org/). 
The visualisations are created by the [gen-vis](https://github.com/petres/gen-vis) library which is build on top of [Vue.js](https://vuejs.org) and [d3](https://d3js.org/).

To run the monitor website locally in dev mode:

    cd web
    npm install
    npm run dev
