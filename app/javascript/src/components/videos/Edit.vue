<template>
  <section class="section-form">
    <div class="section">
      <h2>Edit video</h2>
    </div>
    <div class="section group">
      <form class="form-box" id="form-video" @submit.prevent="updateVideo">
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
            <input type="file" id="file" ref="file" v-on:change="handleFileUpload()" name="title">
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
  name: 'EditVideo',
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

    var vm = this;
    axios.get('/api/v1/videos/' + this.$route.params.id)
      .then(function(response) {
        vm.title = response.data.title;
        var joinTags = response.data.tags.join(', ');
        vm.tags = joinTags;
      })
      .catch(function(error) {
        console.log(error)
        vm.$router.replace('/');
      })
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    updateVideo: function() {
      var vm = this;
      /* Initialize form data */
      var formData = new FormData();
      var i;
      vm.loading = true;

      /* Add the form data as params */
      var tags = vm.parseTagsToArray(vm.tags);
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
      this.error = error.response.data.message;
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