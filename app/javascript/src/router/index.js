import Vue from 'vue'
import Router from 'vue-router'
import Signin from '../components/Signin'
import Signup from '../components/Signup'
import VideoList from '../components/videos/List'
import NewVideo from '../components/videos/New'

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
    },
    {
      path: '/videos/new',
      name: 'NewVideo',
      component: NewVideo
    },
  ]
})
