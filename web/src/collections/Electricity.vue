<template>
    <div class="visualisations">
        <gen-vis src="./data/electricity/load/def.json"/>
        <gen-vis src="./data/electricity/def-price-daily.json"/>
        <gen-vis src="./data/electricity/generation/def-gas.json"/>
        <gen-vis src="./data/electricity/generation/def.json"/>
        <gen-vis src="./data/electricity/generation/def-facets.json"/>
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
