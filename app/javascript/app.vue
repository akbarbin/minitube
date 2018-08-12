<template>
  <div id='app'>
    <Navigation></Navigation>
    <router-view></router-view>
  </div>
</template>

<script>
import Navigation from './src/components/Navigation'

export default {
  name: 'App',
  components: { Navigation }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
