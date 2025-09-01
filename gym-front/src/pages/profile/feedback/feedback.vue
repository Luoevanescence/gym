<template>
  <view class="p-4 bg-[#f5f6fa]">
    <!-- 新增反馈表单 -->
    <view class="bg-white rounded-lg p-4 mb-6 shadow-sm">
      <view class="font-bold text-base mb-4">提交新反馈</view>
      <view class="mb-3">
        <text class="text-sm text-[#555]">类型：</text>
        <picker :range="feedbackTypeLabels" @change="onTypeChange">
          <view class=" rounded px-2 py-1 bg-[#f0f2f5] text-sm">
            {{ selectedTypeLabel }}
          </view>
        </picker>
      </view>
      <view class="mb-3">
        <textarea v-model="newFeedback.content" class="rounded p-2 text-sm bg-[#f0f2f5]"
          placeholder="请输入反馈内容" rows="4" />
      </view>
      <view class="mb-3">
        <input v-model="newFeedback.contactPhone" class="rounded p-2 text-sm bg-[#f0f2f5]"
          placeholder="联系电话 (可选)" @blur="validatePhone"/>
      </view>

      <!-- 图片上传 -->
      <view class="mb-3">
        <button class="bg-[#00b894] text-white text-sm py-1 px-4 rounded" @click="chooseImage">
          {{ imageUploaded ? '图片已上传' : '上传图片（选填）' }}
        </button>
      </view>

      <view v-if="newFeedback.images" class="flex justify-center flex-wrap gap-2 mb-3">
        <view class="relative w-full">
          <ImageWithError :src="newFeedback.images" :wrapperClass="'w-full h-50 rounded'" />
          <!-- 删除按钮 -->
          <view @click="deleteImage" class="z-2 absolute top-0 right-0 text-white bg-black rounded-full w-4 h-4 flex items-center justify-center text-lg">
            ×
          </view>
        </view>
      </view>

      <button class="bg-[#1a73e8] text-white py-2 rounded text-sm w-full" @click="submitFeedback">提交反馈</button>
    </view>

    <!-- 已提交反馈列表 -->
    <view class="font-bold text-base mb-3">我的反馈记录</view>
    <view v-for="feedback in feedbackList" :key="feedback.feedbackId" class="bg-white rounded-lg p-4 mb-4 shadow-sm">
      <view class="flex justify-between items-center text-xs text-[#999] mb-2">
        <text>{{ formatTime(feedback.createdAt) }}</text>
        <text :class="getStatusColor(feedback.status)">
          {{ mapStatusToChinese(feedback.status) }}
        </text>
      </view>

      <view class="text-sm mb-1">类型：{{ mapTypeToChinese(feedback.feedbackType) }}</view>
      <view class="text-sm text-[#444] mb-2">内容：{{ feedback.content }}</view>

      <view v-if="feedback.images" class="flex flex-wrap gap-2">
        <ImageWithError :src="feedback.images" :wrapperClass="'w-24 h-16 rounded'" />
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { storeToRefs } from 'pinia'
import { uploadAvatar } from '@/serve/upload'
import { getUserFeedbacks, submitUserFeedback } from '@/serve/feedback'
import { validatePhoneOptional } from '@/utils/validate'

const userStore = useUserStore()
const { userInfo } = storeToRefs(userStore)

const feedbackList = ref([])

// 类型映射：英文(后端) -> 中文(前端)
const typeToChineseMap = {
  suggestion: '建议',
  complaint: '投诉',
  // repair: '报修',
  other: '其他'
}

// 状态映射：英文(后端) -> 中文(前端)
const statusToChineseMap = {
  'pending': '待处理',
  'processing': '处理中',
  'resolved': '已处理',
  'closed': '已关闭'
}
// 将英文类型转换为中文显示
const mapTypeToChinese = (type) => {
  return typeToChineseMap[type] || type
}

// 将英文状态转换为中文显示
const mapStatusToChinese = (status) => {
  return statusToChineseMap[status] || status
}
// 获取状态对应的颜色类
const getStatusColor = (status) => {
  switch (status) {
    case 'pending': return 'text-[#f39c12]' // 橙色
    case 'processing': return 'text-[#3498db]' // 蓝色
    case 'resolved': return 'text-[#2e7d32]' // 绿色
    case 'closed': return 'text-[#95a5a6]' // 灰色
    default: return 'text-[#d63031]' // 红色
  }
}

const feedbackTypeKeys = Object.keys(typeToChineseMap)
const feedbackTypeLabels = Object.values(typeToChineseMap)

const selectedTypeLabel = ref(feedbackTypeLabels[0])
const imageUploaded = ref(false)

const newFeedback = ref({
  feedbackType: feedbackTypeKeys[0],
  content: '',
  contactPhone: userInfo.value.phone || '',
  images: ''
})
const validatePhone = () => {
  const isValid = validatePhoneOptional(newFeedback.value.contactPhone)
  if (!isValid) {
    uni.showToast({ title: '请输入有效手机号', icon: 'none' })
    return false
  }
  return true
}
const onTypeChange = (e) => {
  const index = e.detail.value
  selectedTypeLabel.value = feedbackTypeLabels[index]
  newFeedback.value.feedbackType = feedbackTypeKeys[index]
}

const chooseImage = () => {
  uni.chooseImage({
    count: 1,
    success: async (res) => {
      const tempPath = res.tempFilePaths[0];
      try {
        // 上传头像接口
        const result = await uploadAvatar(tempPath);
        // 只存储一张图片
        newFeedback.value.images = result.url; // 更新为单张图片的 URL
        imageUploaded.value = true;
        uni.showToast({ title: '上传成功', icon: 'success' });
      } catch (err) {
        console.error('上传失败:', err);
        uni.showToast({ title: err.message || '上传失败', icon: 'none' });
      }
    }
  });
};

// 删除图片
const deleteImage = () => {
  newFeedback.value.images = ''; // 清空图片 URL
  imageUploaded.value = false; // 重置上传状态
};

const loadFeedbacks = async () => {
  const res = await getUserFeedbacks(userInfo.value.userId)
  if (res.success) {
    feedbackList.value = res.data
  }
}

const submitFeedback = async () => {
  if (!newFeedback.value.content.trim()) {
    return uni.showToast({ title: '请输入反馈内容', icon: 'none' })
  }
  if (!validatePhone()) return
  const res = await submitUserFeedback({
    userId: userInfo.value.userId,
    ...newFeedback.value
  })
  if (res.success) {
    uni.showToast({ title: '提交成功', icon: 'success' })
    newFeedback.value.content = ''
    newFeedback.value.contactPhone = ''
    newFeedback.value.images = '' // 清空已提交的图片
    imageUploaded.value = false
    selectedTypeLabel.value = feedbackTypeLabels[0]
    newFeedback.value.feedbackType = feedbackTypeKeys[0]
    await loadFeedbacks()
  } else {
    uni.showToast({ title: '提交失败', icon: 'none' })
  }
}

const formatTime = (time) => {
  if (!time) return ''
  const date = typeof time === 'string' ? new Date(time) : time
  const yyyy = date.getFullYear()
  const MM = String(date.getMonth() + 1).padStart(2, '0')
  const dd = String(date.getDate()).padStart(2, '0')
  const hh = String(date.getHours()).padStart(2, '0')
  const mm = String(date.getMinutes()).padStart(2, '0')
  return `${yyyy}/${MM}/${dd} ${hh}:${mm}`
}

onMounted(() => {
  if (userInfo.value?.userId) {
    loadFeedbacks()
  }
})
</script>

<style scoped>
image {
  object-fit: cover;
}
</style>
