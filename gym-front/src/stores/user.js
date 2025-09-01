import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useUserStore = defineStore('user', () => {
  const token = ref('')
  const userInfo = ref(null)

  function setUser(newToken, user) {
    token.value = newToken
    userInfo.value = user
    console.log('setUser', token.value, userInfo.value)
  }

  function setUserInfo(user) {
    userInfo.value = user
  }

  function clearUser() {
    token.value = ''
    userInfo.value = null
  }

  return { token, userInfo, setUser, setUserInfo, clearUser }
}, {
  persist: true
})
