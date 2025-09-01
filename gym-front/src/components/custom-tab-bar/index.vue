<template>
  <view class="custom-tab-bar">
    <view class="tab-bar-content">
      <view 
        v-for="(item, index) in tabBarStore.tabList" 
        :key="index"
        class="tab-bar-item"
        @tap="tabBarStore.switchTab(item.pagePath)"
      >
        <image 
          :src="tabBarStore.currentPath === item.pagePath ? item.selectedIconPath : item.iconPath"
          class="tab-bar-icon"
        />
        <text 
          class="tab-bar-text"
          :class="tabBarStore.currentPath === item.pagePath ? 'text-[#ff7203]' : 'text-[#000000]'"
        >
          {{ item.text }}
        </text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { useTabBarStore } from '@/stores/tab-bar'

const tabBarStore = useTabBarStore()
</script>

<style scoped>
.custom-tab-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 100rpx;
  background: transparent;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  z-index: 999;
}

.tab-bar-content {
  display: flex;
  justify-content: space-around;
  align-items: center;
  height: 100%;
  padding-bottom: env(safe-area-inset-bottom);
}

.tab-bar-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  flex: 1;
}

.tab-bar-icon {
  width: 48rpx;
  height: 48rpx;
}

.tab-bar-text {
  font-size: 24rpx;
  margin-top: 4rpx;
}
</style> 