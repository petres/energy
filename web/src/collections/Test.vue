
<template>
    <div class="visualisations">
        <gen-vis src="./data/heating-degree-days/def.json"/>
        <gen-vis src="./data/others/def-brent.json"/>
        <gen-vis src="./data/others/def-coal.json"/>
        <gen-vis src="./data/others/def-eua.json"/>
        <gen-vis src="./data/others/def-dollar.json"/>
    </div>
</template>

<script>
import GenVis from '@/GenVis.vue';

export default {
    components: {
        GenVis
    },
}
</script>
