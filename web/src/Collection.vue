<template>
    <div class="visualisations">
        <gen-vis v-for="v in vis" :src="`/data/${v}.json`"/>
    </div>
</template>

<script>
import { collections } from '@/globals.js';

import GenVis from '@/GenVis.vue';

export default {
    data: () => ({
        vis: [],
    }),
    components: {
        GenVis
    },
    watch: { 
        '$route.name': {
            handler: function(n) {
                this.vis = collections[n.substring(11)].vis;
                // console.log(this.vis)
            },
            immediate: true
        }
    }
}
</script>
