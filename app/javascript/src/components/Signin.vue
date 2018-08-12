<template>
  <section class="section-form">
    <div class="section">
      <h2>Sign in</h2>
    </div>
    <div class="section group">
      <form class="form-box" id="signin" @submit.prevent="signin">
        <div class="form-messages success" v-if="success">
          {{ success }}
        </div>

        <div class="form-messages error" v-if="error">
          {{ error }}
        </div>
        <div class="section group">
          <div class="col span_1_of_3">
            <label for="name">Email</label>
          </div>
          <div class="col span_2_of_3">
            <input v-model="email" type="email" name="email" id="email" placeholder="Your email" required>
          </div>
        </div>
        <div class="section group">
          <div class="col span_1_of_3">
            <label for="password">Password</label>
          </div>
          <div class="col span_2_of_3">
            <input v-model="password" type="password" name="password" id="password" placeholder="Your password" required>
          </div>
        </div>
        <div class="section group">
          <div class="col span_1_of_3">
            <label>&nbsp;</label>
          </div>
          <div class="col span_2_of_3">
            <input type="submit" value="Sign me in">
          </div>
        </div>
      </form>
      <p class="ask-account">
        Do you want to share video? Register <router-link to="/signup">here.</router-link>
      </p>
    </div>
  </section>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Signin',
  data () {
    return {
      email: '',
      password: '',
      success: '',
      error: '',
    }
  },
  created () {
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signin() {
      let self = this;

      axios.post('/signin', { email: this.email, password: this.password})
        .then(function(response) {
          self.signinSuccessfull(response);
        })
        .catch(function(error) {
          self.signinFailed(error);
        })
    },
    signinSuccessfull(response) {
      let self = this;
      axios({
        method: 'get',
        url: '/profile',
        headers: {'Authorization': response.data.auth_token}
      })
        .then(function(profileResponse) {
          self.error = '';
          self.success = response.data.message;

          self.$store.commit('setCurrentUser', { currentUser: profileResponse.data, auth_token: response.data.auth_token });

          self.$router.replace('/');
        })
        .catch(function(error) {
          self.signinFailed(error);
        })
    },
    signinFailed(error) {
      this.error = error.response.data.error;
      this.$store.commit('unsetCurrentUser');
    },
    checkSignedIn () {
      if (this.$store.state.signedIn) {
        this.$router.replace('/');
      }
    }
  }
}
</script>