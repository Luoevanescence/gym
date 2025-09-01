<template>
  <view class="p-4 bg-[#f5f6fa] min-h-screen">
    <view v-for="item in orderList" :key="item.orderId" class="bg-white rounded-lg p-4 mb-4 shadow-sm">
      <!-- 顶部时间与状态 -->
      <view class="flex justify-between items-center text-xs text-[#999] mb-2">
        <text>{{ formatTime(item.paymentTime) }}</text>
        <text class="text-[#ff7000]">已支付</text>
      </view>

      <!-- 中间卡片内容 -->
      <view class="flex items-center mb-2">
        <!-- 左侧天数 -->
        <view
          class="bg-[#ffa259] text-white font-bold rounded-md w-12 h-12 flex flex-col justify-center items-center mr-4">
          <text class="text-lg">{{ item.durationDays }}</text>
          <text class="text-xs">天</text>
        </view>

        <!-- 右侧标题 -->
        <view class="flex-1">
          <text class="font-bold text-base">{{ item.cardType }}会员卡 - {{ item.durationDays }}天</text>
        </view>
      </view>

      <!-- 底部金额 -->
      <view class="flex justify-between items-center text-sm text-[#666] mt-1">
        <text>共计1件商品</text>
        <view class="text-right">
          <text class="mr-1 text-[#999]">总计：</text>
          <text class="text-[#ff7000] font-bold">¥{{ item.amount }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { storeToRefs } from 'pinia'
import { getOrdersByUserId } from '@/serve/pay'

const userStore = useUserStore()
const { userInfo } = storeToRefs(userStore)

const orderList = ref([])

onMounted(() => {
  if (userInfo.value?.userId) {
    getOrdersByUserId(userInfo.value.userId).then(res => {
      if (res.success) {
        orderList.value = res.data
      }
    })
  }
})

const formatTime = (time) => {
  if (!time) return '';
  const date = typeof time === 'string' ? new Date(time) : time;
  const yyyy = date.getFullYear();
  const MM = String(date.getMonth() + 1).padStart(2, '0');
  const dd = String(date.getDate()).padStart(2, '0');
  const hh = String(date.getHours()).padStart(2, '0');
  const mm = String(date.getMinutes()).padStart(2, '0');
  return `${yyyy}/${MM}/${dd} ${hh}:${mm}`;
};
</script>

<style scoped></style>
