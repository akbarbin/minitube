<template>
  <section class="section-form">
    <div class="section">
      <h2>Sign up</h2>
    </div>
    <div class="section group">
      <form class="form-box" id="signup" @submit.prevent="signup">
        <div class="form-messages success" v-if="success">
          {{ success }}
        </div>

        <div class="form-messages error" v-if="error">
          {{ error }}
        </div>
        <div class="section group">
          <div class="col span_1_of_3">
            <label for="name">Name</label>
          </div>
          <div class="col span_2_of_3">
            <input v-model="name" type="text" name="name" id="name" placeholder="Your name" required>
            <p class="help-block" v-if="errors['name']">{{ errors["name"][0] }}</p>            
          </div>
        </div>
        <div class="section group">
          <div class="col span_1_of_3">
            <label for="email">Email</label>
          </div>
          <div class="col span_2_of_3">
            <input v-model="email" type="email" name="email" id="email" placeholder="Your email" required>
            <p class="help-block" v-if="errors['email']">{{ errors["email"][0] }}</p>
          </div>
        </div>
        <div class="section group">
          <div class="col span_1_of_3">
            <label for="password">Password</label>
          </div>
          <div class="col span_2_of_3">
            <input v-model="password" type="password" name="password" id="password" placeholder="Your password" required>
            <p class="help-block" v-if="errors['password']">{{ errors["password"][0] }}</p>
          </div>
        </div>
        <div class="section group">
          <div class="col span_1_of_3">
            <label>&nbsp;</label>
          </div>
          <div class="col span_2_of_3">
            <input type="submit" value="Sign me up">
          </div>
        </div>
      </form>
      <p class="ask-account">
        Do you have an account? Sign in <router-link to="/signin">here.</router-link>
      </p>
    </div>
  </section>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Signup',
  data () {
    return {
      name: '',
      email: '',
      password: '',
      success: '',
      error: '',
      errors: '',
    }
  },
  created () {
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signup() {
      let self = this;
      
      axios.post('/signup', {
        user: {
          name: this.name,
          email: this.email,
          password: this.password
        }
      })
        .then(function(response) {
          self.signupSuccessfull(response);
        })
        .catch(function(error) {
          self.signupFailed(error);
        })
    },
    signupSuccessfull(response) {
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
          self.signupFailed(error);
        })
    },
    signupFailed(error) {
      console.log(error.response.data)
      this.error = 'Something went wrong';
      this.errors = (error.response && error.response.data && error.response.data.errors)
    },
    checkSignedIn () {
      if (this.$store.state.signedIn) {
        this.$router.replace('/');
      }
    }
  }
}
</script>