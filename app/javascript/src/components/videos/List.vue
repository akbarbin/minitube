<template>
  <section class="secion-videos" id="videos">
    <div class="section">
      <form id="filter-form" @submit,prevent="filter">
        <div class="filter-input">
          <div class="input-group">
            <input v-model="keyword" type="text" placeholder="Search">
            <button type="submit"><i class="ion-ios-search icon-medium"></i></button>
          </div>
          <p v-if="loading">Loading...</p>
        </div>
      </form>
    </div>
    <div class="section group">
      <div class="video-box" v-for="video in videos" :key="video.id">
        <div class="video-file">
          <video ref="videoRef" v-bind:src="video.source_file_url" id="video-container" width="100%" height="100%" controls></video>
        </div>
        <router-link :to="{ name: 'ShowVideo', params: { id: video.id }}">{{ video.title }}</router-link>
        <div class="video-feature">
          <i class="ion-ios-person icon-small"></i>
          {{ video.user.name }}
        </div>
        <div class="video-feature">
          <i class="ion-md-pricetags icon-small"></i>
          <span class="tags">{{ joinWith(video.tags) }}</span>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import axios from 'axios'

export default {
  name: 'VideoList',
  data () {
    return {
      keyword: '',
      loading: false,
      videos: []
    }
  },
  watch: {
    // whenever search changes, this function will run
    keyword: function(newKeyword, oldKeyword) {
      this.loading = true;
      this.debouncedGetVideos()
    }
  },
  created () {
    this.getVideos();

    // _.debounce is a function provided by lodash to limit how
    // often a particularly expensive operation can be run.
    // In this case, we want to limit how often we access
    // /api, waiting until the user has completely
    // finished typing before making the ajax request. To learn
    // more about the _.debounce function (and its cousin
    // _.throttle), visit: https://lodash.com/docs#debounce

    this.debouncedGetVideos = _.debounce(this.getVideos, 500)
  },
  methods: {
    joinWith: function (tags) {
      if (tags) {
        return tags.join(', ');
      }
    },
    filter: function () {
      this.getVideos();
    },
    getVideos: function() {
      var vm = this;
      axios.get('/api/v1/videos', {
        params: {
          keyword: vm.keyword
        }
      })
        .then(function(response) {
          vm.loading = false;
          vm.videos = response.data.videos
        })
        .catch(function(error) {
          console.log(error)
        })
    }
  }
}
</script>