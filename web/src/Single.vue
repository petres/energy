<template>
    <div class='visEntry'>
        <gen-vis :src="`/data/${$route.params.id.replaceAll('~', '/')}.json`"/>
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
