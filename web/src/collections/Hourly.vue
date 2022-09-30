<template>
    <div class="visualisations">
        <gen-vis src="./data/load/def-hourly.json"/>
        <gen-vis src="./data/generation/def-hourly.json"/>
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
