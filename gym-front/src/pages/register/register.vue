<template>
  <view class="min-h-screen bg-white px-4 sm:px-6 md:px-8 py-6 sm:py-8">
    <view class="max-w-md mx-auto">
      <view class="text-lg sm:text-xl font-bold mb-6 sm:mb-8">用户注册</view>
      <div class="space-y-4 sm:space-y-6">
        <div class="relative">
          <input 
            v-model="name" 
            placeholder="姓名" 
            class="w-full px-4 py-3 sm:py-4 text-sm sm:text-base border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent transition-all duration-300" 
          />
        </div>
        <div class="relative">
          <input 
            v-model="phone" 
            placeholder="手机号" 
            type="tel"
            class="w-full px-4 py-3 sm:py-4 text-sm sm:text-base border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent transition-all duration-300" 
          />
        </div>
        <div class="relative">
          <input 
            v-model="password" 
            type="password" 
            placeholder="密码" 
            class="w-full px-4 py-3 sm:py-4 text-sm sm:text-base border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent transition-all duration-300" 
          />
        </div>
        <button 
          @click="registerUser" 
          class="w-full bg-orange-500 text-white py-3 sm:py-4 rounded-lg text-sm sm:text-base font-medium hover:bg-orange-600 active:scale-95 transition-all duration-300 shadow-md"
        >
          注册
        </button>
      </div>
    </view>
  </view>
</template>

<script setup>
import { ref } from 'vue'
// import db from '@/utils/db'
// import { nanoid } from 'nanoid'

const name = ref('')
const phone = ref('')
const password = ref('')
const registerUser = () => {
  
}
</script>

<style scoped>
/* 添加输入框聚焦时的动画效果 */
input:focus {
  transform: translateY(-1px);
}

/* 添加按钮点击动画 */
button:active {
  transform: scale(0.98);
}
</style>
