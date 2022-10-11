<template>
    <div class="visualisations">
        <gen-vis src="./data/gas/consumption/def-aggm.json"/>
        <gen-vis src="./data/gas/def-price.json"/>
        <gen-vis src="./data/gas/storage/def.json"/>
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
