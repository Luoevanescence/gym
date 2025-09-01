<script>
import { useUserStore } from '@/stores/user'

export default {
  onLaunch: function () {
    console.log('App Launch')
    // Initialize user information
    const userStore = useUserStore()
    const token = uni.getStorageSync('token')
    const user = uni.getStorageSync('user')
    
    if (token && user) {
      userStore.setUser(token, user)
    } else {
      // Redirect to login if no user information is found
      uni.navigateTo({
        url: '/pages/login/login'
      })
    }
  },
  onShow: function () {
    console.log('App Show')
  },
  onHide: function () {
    console.log('App Hide')
  },
}
</script>

<style>
/*每个页面公共css */
</style>
