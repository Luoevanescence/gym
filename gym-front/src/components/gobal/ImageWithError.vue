<template>
  <view class="relative" :class="containerClass">
    <!-- 图片容器（包裹图片和状态提示） -->
    <view :class="wrapperClass" class="relative">
      <image
        :src="currentSrc"
        :class="imgClass"
        :mode="props.mode"
        @load="handleLoad"
        @error="handleError"
      />
      
      <!-- 加载中状态（位于图片容器内） -->
      <view v-if="loading" :class="loadingClass">
        <text :class="loadingTextClass">加载中...</text>
      </view>
      
      <!-- 错误状态（位于图片容器内） -->
      <view v-if="error" :class="errorClass">
        <view class="text-center">
          <text :class="errorIconClass">❌</text>
          <text :class="errorTextClass">图片加载失败</text>
          <text v-if="showDebugInfo" :class="errorDebugClass">{{ errorMessage }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const props = defineProps({
  src: {
    type: String,
    required: true
  },
//   width: {
//     type: String,
//     default: '100%'
//   },
//   height: {
//     type: String,
//     default: '100%'
//   },
  mode: {
    type: String,
    default: 'aspectFill'
  },
  debug: {
    type: Boolean,
    default: false
  },
  
  // 容器样式配置
  containerClass: {
    type: [String, Array, Object],
    default: ''
  },
  
  // 图片包裹层样式配置（添加relative使其成为定位参考）
  wrapperClass: {
    type: [String, Array, Object],
    default: 'w-full h-full overflow-hidden rounded bg-[#f0f2f5] relative'
  },
  
  // 图片样式配置
  imgClass: {
    type: [String, Array, Object],
    default: 'w-full h-full object-cover rounded'
  },
  
  // 加载中状态样式配置（使用绝对定位相对于图片容器）
  loadingClass: {
    type: [String, Array, Object],
    default: 'absolute w-full h-full inset-0 flex items-center justify-center bg-[#00000030] rounded'
  },
  
  loadingTextClass: {
    type: [String, Array, Object],
    default: 'text-white  text-sm bg-[#00000060] px-2 py-1 rounded'
  },
  
  // 错误状态样式配置（使用绝对定位相对于图片容器）
  errorClass: {
    type: [String, Array, Object],
    default: 'absolute w-full h-full inset-0 flex items-center justify-center bg-[#00000030] rounded'
  },
  
  errorIconClass: {
    type: [String, Array, Object],
    default: 'text-white text-xs block mb-1'
  },
  
  errorTextClass: {
    type: [String, Array, Object],
    default: 'text-white text-xs px-2 py-1 rounded'
  },
  
  errorDebugClass: {
    type: [String, Array, Object],
    default: 'text-white text-xs mt-1 bg-[#00000060] px-2 py-1 rounded'
  }
})

const loading = ref(true)
const error = ref(false)
const errorMessage = ref('')
const currentSrc = ref(props.src)

// 处理图片加载成功
const handleLoad = () => {
  loading.value = false
  error.value = false
}

// 处理图片加载失败
const handleError = (e) => {
  loading.value = false
  error.value = true
  
  if (e && e.detail && e.detail.errMsg) {
    errorMessage.value = e.detail.errMsg
    console.error('图片加载失败:', props.src, errorMessage.value)
    reportImageError(props.src, errorMessage.value)
  }
}

// 图片加载错误上报
const reportImageError = (url, message) => {
  console.log('[ImageErrorReport]', { url, message })
}

// 支持重试加载
const retryLoad = () => {
  if (error.value) {
    loading.value = true
    error.value = false
    currentSrc.value = `${props.src}?t=${Date.now()}`
  }
}

onMounted(() => {
  // 图片预加载逻辑
})
</script>

<style scoped>
/* 自定义样式 */
</style>