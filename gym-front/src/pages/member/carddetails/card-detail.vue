<script setup>
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { useImageStore } from '@/stores/imageStore.js';
import { getCardTypeById } from '@/serve/card.js'
import { createOrder } from '@/serve/pay'
import { useUserStore } from '@/stores/user'
import { storeToRefs } from 'pinia'
import { getUserInfo } from '@/serve/user'
const userStore = useUserStore()
const { token, userInfo } = storeToRefs(userStore)
const typeId = ref(null)
const { getUrl } = useImageStore();
const CardData = ref({
  availableStores: [{ storeId: 1, storeName: "电科大中山学院店" }, { storeId: 2, storeName: "利和广场店" }],
  availableTime: "00:00-24:00",
  description: "单次体验，24小时内有效",
  durationDays: 1,
  maxDailyUsage: 1,
  originalPrice: "30.00",
  perUseDurationMinutes: 1440,
  price: "29.90",
  typeId: "type001",
  typeName: "单次体验卡",
  validDurationType: "days",
  validStartOffset: 1
})
//  获取会员卡详情
const getCardDetail = (typeId) => {
  getCardTypeById(typeId).then(res => {
    if (res.success) {
      console.log(res.data);
      CardData.value = res.data;
    }
  });
}
//加载
onLoad((options) => {
  typeId.value = options.typeId
  console.log(typeId.value);
  getCardDetail(typeId.value)
})
//分享
const onShare = () => {
  // 显示原生分享面板（仅微信小程序端有效）
  uni.showShareMenu({
    withShareTicket: true,
    success: () => {
      console.log('显示分享面板成功')
    },
    fail: (err) => {
      console.error('显示分享失败', err)
    }
  })
}

const showPayDialog = ref(false)

// 点击立即购买按钮
const openPayDialog = () => {
  showPayDialog.value = true
}

// 模拟支付行为


const handlePay = async () => {
  uni.showLoading({ title: '支付中...' })

  try {
    const res = await createOrder({
      userId: userInfo.value.userId,
      amount: CardData.value.price,
      membershipTypeId: CardData.value.typeId,
      orderDescription: `购买 ${CardData.value.typeName}`
    });

    uni.hideLoading();
    showPayDialog.value = false;

    if (res.success) {
      uni.showToast({ title: '支付成功', icon: 'success' });
      // console.log('????????',userInfo.value.userId);
      // 支付成功后，重新获取用户信息并更新 pinia
      const userRes = await getUserInfo(userInfo.value.userId);
      if (userRes.success) {
        userStore.setUserInfo(userRes.data)
        console.log('????????',userRes.data,userInfo.value.userId);
      }

      // 跳转页面
      setTimeout(() => {
        uni.navigateBack();
      }, 3000);
    } else {
      uni.showToast({ title: '支付失败', icon: 'none' });
    }
  } catch (err) {
    uni.hideLoading();
    console.error('支付异常:', err);
    uni.showToast({ title: '请求失败', icon: 'none' });
  }
}





</script>
<template>
  <!-- 背景图 -->
  <image class="absolute top-0 left-0 z-[-1] w-full h-full object-cover" :src="getUrl('/common/bg2.png')" />
  <view class="relative min-h-screen bg-[#fef1e6] px-6 pt-6">
    <!-- 卡片内容 -->
    <view class="text-white mb-6">
      <view
        class="flex flex-col justify-center items-start w-full bg-[#ffa259] drop-shadow-md p-4 pb-2 pr-2  rounded-t-md ">
        <image class="absolute top-0 left-0 z-[-1] w-full h-full object-cover" :src="getUrl('/member/card_bg.png')" />
        <view>
          <view class="text-2xl font-bold">{{ CardData.unitValue }}<text class="text-base font-normal ml-1">{{
            CardData.unitLabel
              }}</text>
          </view>
          <view class="text-base">{{ CardData.typeName }}</view>
        </view>
        <view class="flex justify-end items-center w-full">
          <!-- <view class="text-sm ">{{ CardData.startTime }}至{{ CardData.endTime }}可用</view> -->
          <view class=" w-[30%] flex justify-center items-center text-sm ">
            <text>使用规则</text>
            <img class="w-3 h-3 ml-1 rotate-270 " :src="getUrl('/member/down_arrow.png')" alt="">
          </view>
        </view>
      </view>
      <view class=" flex justify-between items-center w-full bg-white px-2 rounded-b-md shadow-sm">
        <image class=" w-14 h-14 object-contain" :src="getUrl('/member/logo_count.png')" mode="scaleToFill" />
        <view class="flex flex-col justify-end h-full"> <!-- 新增 flex-col 垂直布局，底部对齐 -->
          <!-- 价格组内的水平排列容器 -->
          <view class="flex items-end space-x-1"> <!-- 水平排列 + 垂直底部对齐 -->
            <view class="text-sm text-[#dadada] line-through">
              ￥{{ CardData.originalPrice }}
            </view>
            <view class="text-2xl font-bold text-[#ffa259]">
              <text class="text-base font-normal">￥</text>{{ CardData.price }}
            </view>
          </view>
        </view>

      </view>
    </view>
    <!-- 卡片规则详情 -->
    <view class=" mt-2 rounded-md text-sm text-gray-800 space-y-3 ">
      <view class="flex items-start w-full ">
        <image class="w-4 h-4  mr-2 mt-1" :src="getUrl('/member/member_store.svg')" />
        <view class="flex flex-col items-start">
          <view class="text-md font-bold">适用门店</view>
          <view class="text-xs text-[#838383] ">
            {{
              CardData.availableStores && CardData.availableStores.length > 0
                ? CardData.availableStores.map(store => store.storeName).join('、')
                : '暂无适用门店'
            }}
          </view>
        </view>
      </view>
      <view class="flex items-start w-full ">
        <image class="w-4 h-4 mr-2 mt-1" :src="getUrl('/member/member_date.svg')" />
        <view class="flex flex-col items-start">
          <view class="text-md font-bold">可用日期</view>
          <view class="text-xs text-[#838383] ">购卡后第{{ CardData.validStartOffset }}天</view>
          <view class="text-xs text-[#838383] ">
            {{ CardData.durationDays === 1 ? '购卡后一天内未使用完作废' : `自激活日起${CardData.durationDays}天有效` }}
          </view>
        </view>
      </view>

      <view class="flex items-start w-full ">
        <image class="w-4 h-4 mr-2 mt-1" :src="getUrl('/member/member_clock.svg')" />
        <view class="flex flex-col items-start">
          <view class="text-md font-bold">单次可用时长</view>
          <view class="text-xs text-[#838383] ">
            {{ (CardData.perUseDurationMinutes / 60).toFixed(2) }} 小时
          </view>
        </view>
      </view>

      <view class="flex items-start w-full ">
        <image class="w-4 h-4 mr-2 mt-1" :src="getUrl('/member/member_time.svg')" />
        <view class="flex flex-col items-start">
          <view class="text-md font-bold">可用时间</view>
          <view class="text-xs text-[#838383] ">
            周一至周日 {{ CardData.availableTime }}
          </view>
        </view>
      </view>

    </view>


    <!-- 底部栏 -->
    <view
      class="fixed bottom-0 left-0 w-full bg-white border-t border-gray-200 px-4 py-3 flex justify-between items-center">
      <text class="text-[#ffa763] text-lg font-bold">¥8.8</text>
      <view class="flex space-x-3">
        <button @tap="onShare" class="rounded-full px-4 py-1 text-sm flex items-center justify-center">
          <image class="w-4 h-4 mr-2" :src="getUrl('/member/member_share.svg')" />分享
        </button>
        <button @tap="openPayDialog"
          class="bg-orange-500 text-white rounded-full px-2 py-1 text-sm flex items-center justify-center">立即购买</button>
      </view>
    </view>
  </view>
  <view v-if="showPayDialog" class="fixed inset-0 z-50 bg-black/50 flex items-end justify-center">
    <view class="w-full bg-white rounded-t-lg p-4">
      <!-- 顶部标题 -->
      <view class="flex justify-between items-center mb-3">
        <text class="font-bold text-lg">支付</text>
        <text class="text-gray-400 text-sm" @tap="showPayDialog = false">关闭</text>
      </view>

      <!-- 商家与金额 -->
      <view class="mb-4">
        <text class="block text-sm text-gray-500 mb-1">商家</text>
        <text class="block text-base font-bold">燃时自助健身房</text>
        <text class="block text-2xl font-bold text-[#ff7000] mt-2">¥{{ CardData.price }}</text>
      </view>

      <!-- 支付方式 -->
      <view class="mb-4">
        <text class="text-sm text-gray-500">支付方式</text>
        <view class="flex items-center mt-2">
          <image class="w-5 h-5 mr-2" :src="getUrl('/member/member_money.svg')" />
          <text>零钱</text>
          <text class="ml-auto text-green-500">✓</text>
        </view>
      </view>

      <!-- 支付按钮 -->
      <button class="bg-green-500 text-white w-full py-2 rounded-full text-base mt-2" @tap="handlePay">
        支付
      </button>
    </view>
  </view>


</template>
