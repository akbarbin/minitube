import Vue from 'vue/dist/vue.esm'
import Router from 'vue-router'
import Signin from '../components/Signin'
import Signup from '../components/Signup'
import VideoList from '../components/videos/List'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'VideoList',
      component: VideoList
    },
    {
      path: '/signin',
      name: 'Signin',
      component: Signin
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup
    }
  ]
})
