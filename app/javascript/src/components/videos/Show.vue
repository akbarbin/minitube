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
        <video ref="videoRef" v-bind:src="video.source_file_url" id="video-container" width="100%" controls></video>
        <a>{{ video.title }}</a>
        <div class="video-feature">
          <i class="ion-ios-person icon-small"></i>
          {{ video.user.name }}
        </div>
        <div class="video-feature">
          <i class="ion-md-pricetags icon-small"></i>
          <span class="tags">{{ joinWith(video.tags) }}</span>
        </div>
        <br>
        <router-link v-if="isVideoOwner(video)" :to="{ name: 'EditVideo', params: { id: video.id }}" class="btn btn-full">Edit</router-link>
        <a href="#" v-if="isVideoOwner(video)" class="btn btn-full" @click="removeVideo()">Delete</a>
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
            <p>{{ comment.body }} <i class="ion-md-trash icon-small" v-if="isCommentOwner(comment)" @click="removeComment(comment)"></i></p>
          </div>
        </div>
        <br>
        <input type="text" autofocus autocomplete="off" placeholder="Puts a comment here?"
      v-model="video.newComment" @keyup.enter="addComment()" />
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
        newComment: [],
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
    isVideoOwner(video) {
      return (this.$store.state.currentUser.id === video.user.id );
    },
    isCommentOwner(comment) {
      console.log(comment)
      return (this.$store.state.currentUser.id === comment.user.id );
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
    },
    addComment () {
      var body = this.video.newComment && this.video.newComment.trim()
      if (!body) {
        return
      }
      axios({
        method: 'post',
        url: '/api/v1/videos/'+this.$route.params.id+ '/comments',
        headers: {'Authorization': this.$store.state.auth_token},
        data: {
          comment: { body: body }
        }
      })
        .then(response => {
          this.video.comments.push(response.data)
          this.video.newComment = ''
        })
        .catch(error => this.error = error.response)
    },
    removeComment (comment) {
       axios({
        method: 'delete',
        url: '/api/v1/videos/'+this.$route.params.id+ '/comments/' + comment.id,
        headers: {'Authorization': this.$store.state.auth_token},
      })
        .then(response => this.video.comments.splice(this.video.comments.indexOf(comment), 1))
        .catch(error => this.error = error.response)
    }
  }
}
</script>