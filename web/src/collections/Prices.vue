<template>
    <div class="visualisations">
        <gen-vis src="./data/electricity/def-price-daily.json"/>
        <gen-vis src="./data/gas/def-price.json"/>
        <gen-vis src="./data/others/def-brent.json"/>
        <gen-vis src="./data/others/def-coal.json"/>
        <gen-vis src="./data/others/def-eua.json"/>
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
