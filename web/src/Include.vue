<template>
    <div id="include">
        <div v-for="v in vis" class="entry">
            <a :href="url(v)" target="_blank">{{ v }}</a>
            <div class="code">
                Code:
                <pre>{{ iframe(v) }}</pre>
            </div>
            <div v-html="iframe(v)"/>
        </div>
    </div>
</template>

<script>

// const urlSingle = "/single/";
const urlSingle = "https://energy.abteil.org/single/";

import { collections } from '@/globals.js';

const vis = [...new Set(Object.values(collections).map(v => v.vis).flat())]
// console.log(vis)


export default {
    methods: {
        escaped (id) {
            return id.replaceAll('/', '~')
        },
        url (id) {
            return urlSingle + this.escaped(id);
        },
        iframe (id) {
            return `<iframe width="100%" height="450px" frameBorder="0" src="${this.url(id)}"/>`
        }
    },
    data: () => ({
        vis: vis
    }),
}
</script>

<style lang="scss">
#include {
    margin: 50px 20px;
    .entry {
        margin: 50px 0;
        .code {
           margin: 20px 0; 
        }
        pre {
            background-color: #EEE;
            padding: 10px;
        }
    }
}
</style>