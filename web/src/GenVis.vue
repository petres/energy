<template>
    <div class='visEntry'>
        <!-- <span class="visSrc"><router-link :to="{ name: 'playground', params: {src: src} }">{{ src }}</router-link></span> -->
        <div class="genVis" :data-def-file="src"></div>
    </div>
</template>

<script>

export default {
    props: ['src'],
    // mounted() {
    //     if (window.mountGenVisByClass) {
    //         window.mountGenVisByClass('genVis')
    //         console.log('now')
    //     } else {
    //         window.onload = () => window.mountGenVisByClass('genVis')
    //     }
    // } 
}
</script>
