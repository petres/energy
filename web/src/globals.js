export { genVis, collections };

const genVis = {
    // path: './data/gen-vis/gen-vis',
    path: 'https://data-science.wifo.ac.at/gen-vis/gen-vis',
    version: '0.2.7'
}

const vis = {
    'gas-price': {
        "tags": ["preset", "gas", "prices"],
        "options": {
            "title": "Gaspreis",
            "subtitle": "CEGH, täglich (rollierender 7-Tages Durchschnitt), in €/MWh",
            "footer": "Source: CEGH - Central European Gas Hub"
        },
    }
}


const collections = {
    // bla: {
    //     name: "Bla",
    //     menu: true,
    //     vis: [
            
    //     ]
    // },
    preset: {
        name: "Preset",
        menu: true,
        vis: [
            "electricity/load",
            "electricity/price",
            "gas/consumption-aggm",
            "gas/price",
            "gas/storage-AT",
            // "gas/storage",
            "electricity/generation-gas",
            "electricity/generation",
            "electricity/generation-facets",
        ]
    }, 
    prices: {
        name: "Energiepreise",
        menu: true,
        vis: [
            "electricity/price",
            "gas/price",
            "others/brent",
            "others/sprit",
            "others/coal",
            "others/eua",
        ]
    }, 
    gas: {
        name: "Gas",
        menu: true,
        vis: [
            "gas/consumption-aggm",
            "others/hdd",
            "others/temperature",
            "gas/price",
            "gas/storage-AT",
        ]
    }, 
    electricity: {
        name: "Strom",
        menu: true,
        vis: [
            "electricity/load",
            "electricity/price",
            "electricity/generation-facets",
            "electricity/generation",
        ]
    }, 
    international: {
        name: "International",
        menu: true,
        vis: [
            "electricity/load-international",
            "gas/storage-EU",
        ]
    }, 
    test: {
        name: "Gaskonsum Model",
        menu: false,
        vis: [
            "pred-gas-cons",
        ]
    }, 
    others: {
        name: "Others",
        menu: false,
        vis: [
            "electricity/load-hourly",
            "electricity/generation-hourly",
            "electricity/price-hourly",
            "others/dollar",
        ]
    }, 
}
