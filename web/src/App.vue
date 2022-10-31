<template>
    <single v-if="$route.name == 'single'"/>
    <page v-else/>
</template>

<script>
import Page from '@/Page.vue';
import Single from '@/Single.vue';

import { mountGenVisByClass } from '@preschen/gen-vis';

// console.log(mountGenVisByClass)
// import { genVis } from '@/globals.js';

export default {
    components: {
        Page, Single,
    },
    mounted() {
        // let s = document.createElement('script');
        // s.setAttribute('src', `${genVis.path}-${genVis.version}.js`);
        // document.head.appendChild(s);
    },
    updated() {
        mountGenVisByClass('genVis');
    },
}
</script>
