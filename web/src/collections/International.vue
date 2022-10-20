<template>
    <div class="visualisations">
        <gen-vis src="./data/electricity/load/def-int.json"/>
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
