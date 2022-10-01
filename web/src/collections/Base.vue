<template>
    <div class="visualisations">
        <!-- <gen-vis src="./data/consumption-gas/def-econtrol.json"/> -->
        <gen-vis src="./data/load/def.json"/>
        <gen-vis src="./data/electricity/def-price-daily.json"/>
        <gen-vis src="./data/consumption-gas/def-aggm.json"/>
        <gen-vis src="./data/storage/def.json"/>
        <gen-vis src="./data/generation-gas/def.json"/>
        <gen-vis src="./data/generation/def.json"/>
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
