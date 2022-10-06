
<template>
    <div class="visualisations">
        <gen-vis src="./data/heating-degree-days/def.json"/>
        <gen-vis src="./data/generation/def-facets.json"/>
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
