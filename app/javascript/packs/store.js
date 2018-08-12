import Vue from 'vue'
import Vuex from 'vuex'
import createPersistedState from 'vuex-persistedstate'
Vue.use(Vuex)

export const store = new Vuex.Store({
  state: {
    currentUser: {},
    auth_token: null,
    videos: []
  },
  getters: {
    currentAuthToken(state) {
      return state.auth_token;
    }
  },
  mutations: {
    setCurrentUser(state, { currentUser, auth_token }) {
      state.currentUser = currentUser;
      state.signedIn = true;
      state.auth_token = auth_token;
    },
    unsetCurrentUser(state) {
      state.currentUser = {};
      state.signedIn = false;
      state.auth_token = null;
    }
  },
  plugins: [createPersistedState()]
})
