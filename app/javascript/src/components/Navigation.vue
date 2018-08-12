<template>
  <header>
    <nav class="navbar-default">
      <div class="section clearfix">
        <router-link to='/' class="logo">MiniTube</router-link>
        <ul>
          <li v-if="!isLoggedIn()"><router-link to='/signin'>Sign in</router-link></li>
          <li v-if="!isLoggedIn()"><router-link to='/signup'>Sign up</router-link></li>
          <li v-if="isLoggedIn()"><a href="#" @click="signOut">Sign out</a></li>
        </ul>
      </div>
    </nav>
  </header>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Navigation',
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    signOut () {
      axios.delete('/signout', {
        headers: {'Authorization': this.$store.state.auth_token}
      })
        .then(response => {
          this.$store.commit('unsetCurrentUser')
          this.$router.replace('/')
        })
        .catch(error => this.setError(error, 'Cannot sign out'))
    },
    isLoggedIn() {
      return (this.$store.state.signedIn);
    }
  }
}
</script>