<template>
  <view class="flex flex-col items-center w-full min-h-screen px-4 relative">
    <!-- 背景图 -->
    <image class="fixed top-0 left-0 z-[-1] w-full h-full object-cover" :src="getUrl('/common/bg2.png')"
      mode="aspectFill" />

    <!-- 占位 -->
    <view class="h-30"></view>

    <!-- 个人卡片 -->
    <view class="w-full bg-white rounded-xl shadow px-4 py-4 mb-4"
      @click="handleMenu({ path: '/pages/profile/personal/personal' })">
      <view class="flex items-center">
        <image :src="isLogin ? userInfo?.avatarUrl : getUrl('/common/avatar.png') || getUrl('/common/avatar.png')"
          class="w-12 h-12 rounded-full" mode="aspectFill" />
        <view class="ml-3">
          <view class="flex items-center space-x-2">
            <text class="font-bold text-base mr-1">
              {{ isLogin ? userInfo?.name : '请点击登录' }}
            </text>
            <text class="text-xs text-white bg-orange-400 px-1 py-[2px] rounded-md">
              {{ isLogin ? 'VIP1' : 'VIP0' }}
            </text>
          </view>
        </view>
      </view>

      <!-- 资产 -->
      <view class="mt-4 grid grid-cols-3 text-center text-sm">
        <view>
          <view class="text-xl font-bold">{{ isLogin ? userInfo?.cardCount : '0' }}</view>
          <view class="text-gray-500 text-xs">会员卡</view>
        </view>
        <view>
          <view class="text-xl font-bold">0</view>
          <view class="text-gray-500 text-xs">优惠券</view>
        </view>
        <view>
          <view class="text-xl font-bold">{{ isLogin ? userInfo?.points || '0' : '0' }}</view>
          <view class="text-gray-500 text-xs">积分</view>
        </view>
      </view>

      <!-- 有效期 / 提示 -->
      <view class="mt-4 text-xs text-gray-500">
        {{ isLogin ? '会员有效期至 2025.3.28' : '您当前还未购买会员卡' }}
      </view>

      <!-- 积分进度条 -->
      <view class="mt-2 flex items-center space-x-2 text-xs text-gray-400">
        <view class="w-full h-2 bg-gray-200 rounded-full overflow-hidden">
          <view class="h-full bg-orange-400" :style="{ width: isLogin ? '28%' : '0%' }"></view>
        </view>
        <text class="text-[10px] text-orange-500">{{ isLogin ? 'VIP1' : 'VIP0' }}</text>
      </view>
    </view>


    <!-- 功能列表 -->
    <view class="w-full bg-white rounded-xl shadow px-4 py-2 text-sm">
      <view v-for="(item, index) in menuList" :key="item.text" class="flex items-center justify-between py-3"
        :class="index !== menuList.length - 1 ? 'border-b border-gray-100' : ''" @click="handleMenu(item)">
        <view class="flex items-center">
          <image :src="getUrl(item.icon)" class="w-4 h-4 mr-2" mode="aspectFit" />
          <text>{{ item.text }}</text>
        </view>
        <image :src="getUrl('/profile/profile_arrow.svg')" class="w-3 h-3" />
      </view>
    </view>

    <!-- tabbar 占位 -->
    <view class="tab-bar-height"></view>
    <custom-tab-bar></custom-tab-bar>
  </view>
</template>

<script setup>
import { computed } from 'vue'
import { useUserStore } from '@/stores/user.js'
import { useImageStore } from '@/stores/imageStore.js'
import { useTabBarStore } from '@/stores/tab-bar'
import { storeToRefs } from 'pinia'
import CustomTabBar from '@/components/custom-tab-bar/index.vue'





const userStore = useUserStore()
const { getUrl } = useImageStore()
const { token, userInfo } = storeToRefs(userStore)
const isLogin = computed(() => !!token.value)

// 菜单配置
const menuList = [
  { icon: '/profile/records.svg', text: '进场记录', path: '/pages/profile/records/records' },
  { icon: '/profile/orders.svg', text: '订单记录', path: '/pages/profile/orders/orders' },
  { icon: '/profile/opinions.svg', text: '意见反馈', path: '/pages/profile/feedback/feedback' },
  { icon: '/profile/instrument.svg', text: '器械报修', path: '/pages/profile/repair/repair' },
  { icon: '/profile/help.svg', text: '使用帮助', path: '/pages/profile/help/help' },

]
const goLogin = () => {
  uni.navigateTo({
    url: '/pages/login/login'
  })
}
// 跳转逻辑
const handleMenu = (item) => {
  if (!isLogin.value) {
    uni.showModal({
      title: '温馨提示',
      content: '请先登录后再使用该功能',
      confirmText: '去登录',
      cancelText: '取消',
      success: (res) => {
        if (res.confirm) {
          goLogin();
        }
      }
    });
    return;
  }

  if (item.path) {
    uni.navigateTo({ url: item.path });
  }
}


</script>

<style scoped>
.tab-bar-height {
  height: 120rpx;
}
</style>
