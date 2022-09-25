<template>
    <div>
        <div class="header">
            <h1>Strom/Gasenergiedaten für Österreich</h1><span title="last data update" class="updated">{{ updated }}</span>
        </div>
        <!-- <div class="menu"> -->
            <!-- <router-link :to="{ name: 'examples' }">Examples</router-link>
            <router-link :to="{ name: 'wwwi' }">WWWI</router-link>
            <router-link :to="{ name: 'fb' }">FB</router-link>
            <router-link :to="{ name: 'playground' }">Playground</router-link> -->
        <!-- </div> -->
        <!-- <router-view></router-view> -->

        <div class="visualisations">
            <gen-vis src="./data/load/def.json"/>
            <gen-vis src="./data/consumption-gas/def.json"/>
            <gen-vis src="./data/storage/def.json"/>
            <gen-vis src="./data/generation-gas/def.json"/>
            <gen-vis src="./data/generation/def.json"/>
        </div>
        <div class="footer">
            <span><a href="https://github.com/petres/gen-vis" target="_blank">gen-vis</a> {{ version }}</span>
        </div>
    </div>
</template>

<script>
import GenVis from '@/GenVis.vue';
import axios from 'axios';

const base='https://data-science.wifo.ac.at/gen-vis/gen-vis';
// const base='/data/gen-vis/gen-vis';
const version = '0.2.3';


export default {
    components: {
        GenVis
    },
    data: () => ({
        updated: null,
        version: version
    }),
    mounted() {
        const self = this;
        let s = document.createElement('script');
        s.setAttribute('src', `${base}-${version}.js`);
        document.head.appendChild(s);

        if (window.mountGenVisByClass) {
            window.mountGenVisByClass('genVis')
        } else {
            window.onload = () => window.mountGenVisByClass('genVis')
        }

        axios.get('/data/update.txt')
            .then(function (response) {
                const d = new Date(response.data.trim())
                self.updated = d.toLocaleString()
            })
    }
}
</script>
