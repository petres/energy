import '../assets/styles/main.scss'

import { createApp } from 'vue'
import { createWebHistory, createRouter } from 'vue-router'

import App from '@/App.vue'

import CollectionBase from '@/collections/Base.vue'
import CollectionHourly from '@/collections/Hourly.vue'
import CollectionTest from '@/collections/Test.vue'

import CollectionGas from '@/collections/Gas.vue'
import CollectionElectricity from '@/collections/Electricity.vue'
import CollectionOthers from '@/collections/Others.vue'


const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: CollectionBase, name: 'base' },
    { path: '/hourly', component: CollectionHourly, name: 'hourly' },
    { path: '/test', component: CollectionTest, name: 'test' },
    { path: '/gas', component: CollectionGas, name: 'gas' },
    { path: '/electricity', component: CollectionElectricity, name: 'electricity' },
    { path: '/others', component: CollectionOthers, name: 'others' },
  ],
})

const app = createApp(App)
    .use(router)
    .mount('#app')
