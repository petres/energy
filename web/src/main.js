import '../assets/styles/main.scss'

import { createApp } from 'vue'

import App from '@/App.vue'
// import Examples from '@/Examples.vue'
// import WWWI from '@/WWWI.vue'
// import FB from '@/FB.vue'
// import Playground from '@/Playground.vue'

// import { createWebHistory, createRouter } from 'vue-router'

// const router = createRouter({
//     history: createWebHistory(__webpack_public_path__),
//     routes: [
//         { path: '/', component: Examples, name: 'examples' },
//         { path: '/wwwi', component: WWWI, name: 'wwwi' },
//         { path: '/fb', component: FB, name: 'fb' },
//         { path: '/playground@:src?', component: Playground, name: 'playground', props: true },
//     ],
// })


const app = createApp(App)
    // .use(router)
    .mount('#app')
