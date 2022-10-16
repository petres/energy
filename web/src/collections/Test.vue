
<template>
    <div class="visualisations">
        <gen-vis src="./data/def-pred-gas-cons.json"/>
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
