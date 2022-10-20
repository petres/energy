<template>
    <div class="visualisations">
        <gen-vis src="./data/electricity/load/def-hourly.json"/>
        <gen-vis src="./data/electricity/generation/def-hourly.json"/>
        <gen-vis src="./data/electricity/def-price-hourly.json"/>
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
