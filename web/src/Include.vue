<template>
    <div id="include">
        <div v-for="v in vis" class="entry">
            <a :href="url(v.id)" target="_blank">{{ v.id }}</a>
            <div class="code">
                Code:
                <pre>{{ iframe(v.id) }}</pre>
            </div>
            <div v-html="iframe(v.id)"/>
        </div>
    </div>
</template>

<script>

// const urlSingle = "/single/";
const urlSingle = "https://energy.abteil.org/single/";

export default {
    methods: {
        escaped (id) {
            return id.replace('/', '~')
        },
        url (id) {
            return urlSingle + this.escaped(id);
        },
        iframe (id) {
            return `<iframe width="100%" height="400px" frameBorder="0" src="${this.url(id)}"/>`
        }
    },
    data: () => ({
        vis: [
            { id: "gas/def-price" },
            { id: "def-pred-gas-cons" },
        ]
    }),
}
</script>

<style lang="scss">
#include {
    margin: 50px 20px;
    .entry {
        margin: 50px 0;
        .code {
           margin: 20px 0; 
        }
        pre {
            background-color: #EEE;
            padding: 10px;
        }
    }
}
</style>