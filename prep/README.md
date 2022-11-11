# Energy Data Analysis

Joint project by [Johannes Schmidt](https://github.com/joph) and me. Provides data loading, preparation and analysis scripts. These script are also the base for the visualisations on [energy.abteil.org](https://energy.abteil.org).

## Data sources

Following data sources are used:

- [E-Control](https://www.e-control.at/)
    - Gas consumption
- [entsoe](https://www.entsoe.eu/)
    - Electricity generation
    - Electricity load
- [GIE - Gas Infrastructure Europe](https://www.gie.eu/)
    - Gas Storage
- [AGGM - Austrian Gas Grid Managment AG](https://www.aggm.at/)
    - Gas Consumption
- [CDS - Climate Data Store](https://cds.climate.copernicus.eu/)
    - Temperature
- [EEX - European Energy Exchange](https://www.eex.com/) via [Macrobond](https://www.macrobond.com/)
    - Electricity price
- [ICE - Intercontinental Exchange](https://www.theice.com/) via [Macrobond](https://www.macrobond.com/)
    - Coal Price
    - Brent Price
- [NASDAQ OMX - Nasdaq Commodities ](http://www.nasdaqomx.com/) via [Macrobond](https://www.macrobond.com/)
    - EUA Price
- others

## Contribute

Any contribution is welcome, start by cloning this repo:

    git clone https://github.com/energy-monitor/explore

## Loading Data

Copy the `creds-template.json` file to `creds.json` and fill it with your credentials. Credentials can be obtained by registering on the corresponding data supplier webpages (free, except for data series fetched via the data provider Macrobond).

Calling one of the scripts in the `load` folder will download the data from the corresponding data source, extract, aggregate and store the data for the visualisation.

