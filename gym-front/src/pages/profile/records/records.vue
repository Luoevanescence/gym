<template>
  <view class="p-4 bg-[#f5f6fa] min-h-screen">
    <view v-for="record in recordList" :key="record.recordId" class="bg-white rounded-lg p-4 mb-4 shadow-sm">
      <!-- 时间与类型 -->
      <view class="flex justify-between items-center text-xs text-[#999] mb-2">
        <text>{{ formatTime(record.accessTime) }}</text>
        <text :class="record.accessType === 'entry' ? 'text-[#00b894]' : 'text-[#d63031]'">
          {{ record.accessType === 'entry' ? '进场' : '出场' }}
        </text>
      </view>

      <!-- 设备信息 -->
      <view class="flex items-center mb-2">
        <view class="bg-[#74b9ff] text-white font-bold rounded-md w-12 h-12 flex justify-center items-center mr-4">
          <text class="text-sm text-center">门禁</text>
        </view>
        <view class="flex-1">
          <text class="font-bold text-base">{{ record.deviceName }}</text>
          <view class="text-xs text-[#888]">{{ record.location }}</view>
        </view>
      </view>

      <!-- 方法与体温 -->
      <view class="flex justify-between text-sm text-[#666]">
        <text>方式：{{ methodText(record.accessMethod) }}</text>
        <text v-if="record.temperature">体温：{{ record.temperature }}°C</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { storeToRefs } from 'pinia'
import { getAccessRecordsByUserId } from '@/serve/access' // 接口方法

const userStore = useUserStore()
const { userInfo } = storeToRefs(userStore)
const recordList = ref([])

onMounted(() => {
  if (userInfo.value?.userId) {
    getAccessRecordsByUserId(userInfo.value.userId).then(res => {
      if (res.success) {
        recordList.value = res.data
      }
    })
  }
})

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

const methodText = (method) => {
  return {
    qr_code: '二维码',
    face_recognition: '人脸识别',
    nfc: 'NFC'
  }[method] || '未知'
}
</script>
