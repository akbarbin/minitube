<template>
  <section class="section-form">
    <div class="section">
      <h2>Upload video</h2>
    </div>
    <div class="section group">
      <form class="form-box" id="form-video" @submit.prevent="createVideo">
        <div class="form-messages success" v-if="success">
          {{ success }}
        </div>

        <div class="form-messages error" v-if="error">
          {{ error }}
        </div>
        <div class="section group">
          <div class="col span_1_of_3">
            <label for="title">Title</label>
          </div>
          <div class="col span_2_of_3">
            <input v-model="title" type="text" name="title" id="title" placeholder="Video title" required>
            <p class="help-block" v-if="errors['title']">{{ errors["title"][0] }}</p>
          </div>
        </div>
        <div class="section group">
          <div class="col span_1_of_3">
            <label for="title">Tags</label>
          </div>
          <div class="col span_2_of_3">
            <input v-model="tags" type="text" name="tags" id="tags" placeholder="Tags seperated by comma" required>
            <p class="help-block" v-if="errors['tags']">{{ errors["tags"][0] }}</p>
          </div>
        </div>
        <div class="section group">
          <div class="col span_1_of_3">
            <label for="title">File</label>
          </div>
          <div class="col span_2_of_3">
            <input type="file" id="file" ref="file" v-on:change="handleFileUpload()" name="title" required>
          </div>
        </div>
        <div class="section group">
          <div class="col span_1_of_3">
            <label>&nbsp;</label>
          </div>
          <div class="col span_2_of_3">
            <input type="submit" value="Upload">
            <span v-if="loading">Loading...</span>
          </div>
        </div>
      </form>
    </div>
  </section>
</template>

<script>
import axios from 'axios'

export default {
  name: 'NewVideo',
  data () {
    return {
      loading: false,
      title: '',
      tags: '',
      source_file: '',
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
    createVideo: function() {
      var vm = this;
      /* Initialize form data */
      var formData = new FormData();
      var i;
      vm.loading = true;

      /* Add the form data as params */
      var tags = this.parseTagsToArray(this.tags);
      for (i = 0; i <= tags.length; i++) {
        formData.append('video[tags][]', tags[i]);
      }

      formData.append('video[title]', this.title);
      formData.append('video[source_file]', this.source_file);

      axios({
        method: 'post',
        url: '/api/v1/videos',
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': this.$store.state.auth_token
        },
        data: formData
      })
        .then(function(response) {
          vm.addVideoSuccessfull(response);
        })
        .catch(function(error) {
          vm.addVideoFailed(error);
        })
        .then(function () {
          vm.loading = false;
          // always executed
        });
    },
    addVideoSuccessfull (response) {
      this.$router.replace('/');
    },
    addVideoFailed (error) {
      console.log(error.response)
      this.error = 'Something went wrong';
      this.errors = (error.response && error.response.data && error.response.data.errors)
    },
    checkSignedIn () {
      if (!this.$store.state.signedIn) {
        this.$router.replace('/signin');
      }
    },
    handleFileUpload: function() {
      this.source_file = this.$refs.file.files[0];
    },
    parseTagsToArray: function(tags) {
      return tags.replace(/\s/g, '').split(',');
    }
  }
}
</script>