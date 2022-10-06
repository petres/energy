<template>
    <div class="visualisations">
        <!-- <gen-vis src="./data/gas/def-consumption-econtrol.json"/> -->
        <gen-vis src="./data/electricity/load/def.json"/>
        <gen-vis src="./data/electricity/def-price-daily.json"/>
        <gen-vis src="./data/gas/consumption/def-aggm.json"/>
        <gen-vis src="./data/gas/def-price.json"/>
        <gen-vis src="./data/gas/storage/def.json"/>
        <gen-vis src="./data/electricity/generation/def-gas.json"/>
        <gen-vis src="./data/electricity/generation/def.json"/>
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
