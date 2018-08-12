<template>
  <section class="section-form">
    <div class="section">
      <h2>Detail</h2>
    </div>
    <div class="section">
      <div class="form-messages success" v-if="success">
        {{ success }}
      </div>

      <div class="form-messages error" v-if="error">
        {{ error }}
      </div>
      <div class="video-box detail">
        <img v-bind:src="video.source_file_url">
        <a>{{ video.title }}</a>
        <div class="video-feature">
          <i class="ion-ios-person icon-small"></i>
          {{ video.user.name }}
        </div>
        <div class="video-feature">
          <i class="ion-md-pricetags icon-small"></i>
          <span class="tags">{{ joinWith(video.tags) }}</span>
        </div>
        <div class="video-feature">
          <router-link v-if="isLoggedIn()" :to="{ name: 'EditVideo', params: { id: video.id }}" class="btn btn-full">Edit</router-link>
          <a href="#" v-if="isLoggedIn()" class="btn btn-full" @click="removeVideo()">Delete</a>
        </div>
      </div>
    </div>
    <div class="section" id="comments-box">
      <div class="video-box detail">
        <h3>Comments</h3>
        <div class="comments">
          <div class="comment-item" v-for="comment in video.comments" :key="comment.id">
            <div class="video-feature">
              <i class="ion-ios-person icon-small"></i>
              <b>{{ comment.user.name }}</b>
            </div>
            <p>{{ comment.body }}</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ShowVideo',
  data () {
    return {
      loading: false,
      video: {
        user: {},
        comments: []
      },
      success: '',
      error: '',
      errors: '',
    }
  },
  created () {
    var vm = this;
    axios.get('/api/v1/videos/' + this.$route.params.id)
      .then(function(response) {
        console.log(response);
        vm.video = response.data;
        vm.video.comments = response.data.comments;
      })
      .catch(function(error) {
        console.log(error)
        vm.$router.replace('/');
      })
  },
  methods: {
    joinWith: function (tags) {
      if (tags) {
        return tags.join(', ');
      }
    },
    updateVideo: function() {
      var vm = this;
      /* Initialize form data */
      var formData = new FormData();
      var i;
      vm.loading = true;

      /* Add the form data as params */
      var tags = this.parseTagsToArray(this.tags);
      for (i = 0; i < tags.length; i++) {
        formData.append('video[tags][]', tags[i]);
      }

      formData.append('video[title]', this.title);
      formData.append('video[source_file]', this.source_file);

      axios({
        method: 'put',
        url: '/api/v1/videos/' + this.$route.params.id,
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': this.$store.state.auth_token
        },
        data: formData
      })
        .then(function(response) {
          vm.updateVideoSuccessfull(response);
        })
        .catch(function(error) {
          vm.updateVideoFailed(error);
        })
        .then(function () {
          vm.loading = false;
          // always executed
        });
    },
    updateVideoSuccessfull (response) {
      this.$router.replace('/');
    },
    updateVideoFailed (error) {
      console.log(error.response)
      this.error = 'Something went wrong';
      this.errors = (error.response && error.response.data && error.response.data.errors)
    },
    parseTagsToArray: function(tags) {
      return tags.replace(/\s/g, '').split(',');
    },
    isLoggedIn() {
      return (this.$store.state.signedIn);
    },
    removeVideo () {
      axios({
        method: 'delete',
        url: '/api/v1/videos/' + this.$route.params.id,
        headers: {
          'Authorization': this.$store.state.auth_token
        }
      })
        .then(response => this.$router.replace('/'))
        .catch(error => this.$router.replace('/'))
    }
  }
}
</script>