<script setup>
import { ref } from 'vue';
import { onLoad } from '@dcloudio/uni-app';
import { getCardTypes } from '@/serve/card'
import { useTabBarStore } from '@/stores/tab-bar'
import { useImageStore } from '@/stores/imageStore.js';
import CustomTabBar from '@/components/custom-tab-bar/index.vue'

const tabBarStore = useTabBarStore()
const { getUrl } = useImageStore();

const gymCardData = ref([{
  description: "单次体验，24小时内有效",
  durationDays: 1,
  maxDailyUsage: 1,
  originalPrice: "50.00",
  price: "29.90",
  typeId: "type001",
  typeName: "单次体验卡",
  unitLabel: "次",
  unitValue: 1
},]);

const goToDetail = (item) => {
  uni.navigateTo({
    url: `/pages/member/carddetails/card-detail?typeId=${item.typeId}`
  })
}
//获取会员卡类型列表
const getCardTypesData = () => {
  getCardTypes()
    .then(res => {
      if (res.success) {
        // console.log('会员卡类型列表:', res.data);
        gymCardData.value = res.data; // 若为 ref，可直接赋值
      }
    })
    .catch(err => {
      console.error('获取会员卡失败', err);
    });
}

onLoad(() => {
  getCardTypesData()

});

</script>
<template>
  <image class="fixed top-0 left-0 z-[-1] w-full h-full object-cover" :src="getUrl('/common/bg2.png')" />
  <view class="bg-custom-gradient h-[100vh] w-full px-6 py-6 pt-20 ">
    <view class="text-[#ff7000] font-bold text-3xl mb-4">会员卡</view>
    <view class="css-scroll-container" :style="{ height: `calc(100vh - ${300}rpx)` }">
      <view class="text-white mb-6" v-for="item in gymCardData" :key="item.id">
        <view
          class="flex flex-col justify-center items-start w-full bg-[#ffa259] drop-shadow-md p-4 pb-2 pr-2  rounded-t-md "
          @click="goToDetail(item)">
          <image class="absolute top-0 left-0 z-[-1] w-full h-full object-cover" :src="getUrl('/member/card_bg.png')" />
          <view>
            <view class="text-2xl font-bold">{{ item.unitValue }}<text class="text-base font-normal ml-1">{{ item.unitLabel
                }}</text>
            </view>
            <view class="text-base">{{ item.typeName }}</view>
          </view>
          <view class="flex justify-end items-center w-full">
            <!-- <view class="text-sm ">{{ item.startTime }}至{{ item.endTime }}可用</view> -->
            <view class=" w-[30%] flex justify-center items-center text-sm ">
              <text>使用规则</text>
              <img class="w-3 h-3 ml-2" :src="getUrl('/member/down_arrow.png')" alt="">
            </view>
          </view>
        </view>
        <!-- 规则详情
         <view class="bg-white  mt-2 p-4 text-[#363634] text-sm">hbvunienowpj[kqpc]l[;;[veproituyioedpwsa[]]]</view> -->
        <view class=" flex justify-between items-center w-full bg-white px-2 rounded-b-md shadow-sm">
          <image class=" w-14 h-14 object-contain" :src="getUrl('/member/logo_count.png')" mode="scaleToFill" />

          <view class="flex flex-col justify-end h-full"> <!-- 新增 flex-col 垂直布局，底部对齐 -->
            <!-- 价格组内的水平排列容器 -->
            <view class="flex items-end space-x-1"> <!-- 水平排列 + 垂直底部对齐 -->
              <view class="text-sm text-[#dadada] line-through">
                ￥{{ item.originalPrice }}
              </view>
              <view class="text-2xl font-bold text-[#ffa259]">
                <text class="text-base font-normal">￥</text>{{ item.price }}
              </view>
            </view>
          </view>

        </view>
      </view>
      <view class="tab-bar-height"></view>
    </view>

    <custom-tab-bar></custom-tab-bar>
  </view>
</template>

<style scoped>
.bg-custom-gradient {
  /*
    background-image: linear-gradient(to bottom, #ffeddb 40%, #ffffff 60%);
    */
}
</style>