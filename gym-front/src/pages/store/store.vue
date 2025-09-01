<script setup>
import { ref, onMounted } from 'vue'
import { useTabBarStore } from '@/stores/tab-bar'
import CustomTabBar from '@/components/custom-tab-bar/index.vue'
import { useImageStore } from '@/stores/imageStore.js';
import { searchStoresByName } from '@/serve/storeApi'
const tabBarStore = useTabBarStore()
const { getUrl } = useImageStore()
const storeName = ref('')
const storesList = ref([
	// {
	// 	latitude: 22.5227,
	// 	longitude: 113.3926,
	// 	id: "store-001",
	// 	storeName: "电科大中山学院店",
	// 	distance: "0.02km",
	// 	address: "广东省中山市石岐区学院路1号龙凤楼2楼",
	// 	currentPeople: 26,
	// 	mainImage: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_1.png",
	// 	phone: "18033092080",
	// 	equipmentTypes: 13,
	// 	businessHours: "周一至周日 00:00 - 24:00",
	// 	addressMap: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_map.png",

	// },
	// {
	// 	latitude: 22.5227,
	// 	longitude: 113.3926,
	// 	id: "store-002",
	// 	storeName: "利和广场店",
	// 	distance: "1.5km",
	// 	address: "广东省中山市东区中山三路16号利和广场5楼",
	// 	currentPeople: 48,
	// 	mainImage: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_2.png",
	// 	phone: "18923356789",
	// 	equipmentTypes: 15,
	// 	businessHours: "周一至周日 09:00 - 22:00",
	// 	addressMap: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_map.png"
	// },
	// {
	// 	latitude: 22.5227,
	// 	longitude: 113.3926,
	// 	id: "store-003",
	// 	storeName: "大信新都汇店",
	// 	distance: "2.3km",
	// 	address: "广东省中山市石岐区莲塘北路18号大信新都汇B座3楼",
	// 	currentPeople: 32,
	// 	mainImage: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_3.png",
	// 	phone: "13560678901",
	// 	equipmentTypes: 12,
	// 	businessHours: "周一至周日 10:00 - 21:30",
	// 	addressMap: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_map.png"
	// },
	// {
	// 	latitude: 22.5227,
	// 	longitude: 113.3926,
	// 	id: "store-004",
	// 	storeName: "小榄百汇时代店",
	// 	distance: "15.8km",
	// 	address: "广东省中山市小榄镇升平中路10号百汇时代广场4楼",
	// 	currentPeople: 56,
	// 	mainImage: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_4.png",
	// 	phone: "18676012345",
	// 	equipmentTypes: 18,
	// 	businessHours: "周一至周日 08:30 - 23:00",
	// 	addressMap: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_map.png"
	// },
	// {
	// 	latitude: 22.5227,
	// 	longitude: 113.3926,
	// 	id: "store-005",
	// 	storeName: "古镇华艺广场店",
	// 	distance: "28.6km",
	// 	address: "广东省中山市古镇镇中兴大道南1号华艺广场6楼",
	// 	currentPeople: 19,
	// 	mainImage: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_5.png",
	// 	phone: "13825934567",
	// 	equipmentTypes: 10,
	// 	businessHours: "周一至周日 09:30 - 22:30",
	// 	addressMap: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_map.png"
	// },
	// {
	// 	latitude: 22.5227,
	// 	longitude: 113.3926,
	// 	id: "store-006",
	// 	storeName: "三乡顺昌广场店",
	// 	distance: "12.1km",
	// 	address: "广东省中山市三乡镇文昌东路10号顺昌广场3楼",
	// 	currentPeople: 38,
	// 	mainImage: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_1.png",
	// 	phone: "15918234567",
	// 	equipmentTypes: 14,
	// 	businessHours: "周一至周日 00:00 - 24:00",
	// 	addressMap: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_map.png"
	// },
	// {
	// 	latitude: 22.5227,
	// 	longitude: 113.3926,
	// 	id: "store-006",
	// 	storeName: "三乡顺昌广场店",
	// 	distance: "12.1km",
	// 	address: "广东省中山市三乡镇文昌东路10号顺昌广场3楼",
	// 	currentPeople: 38,
	// 	mainImage: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_1.png",
	// 	phone: "15918234567",
	// 	equipmentTypes: 14,
	// 	businessHours: "周一至周日 00:00 - 24:00",
	// 	addressMap: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_map.png"
	// }
])
const searchStores = async () => {
	console.log(storeName.value)
  try {
    const res = await searchStoresByName(storeName.value)
    storesList.value = res.data
	console.log(res.data)
  } catch (err) {
    console.error('搜索失败', err)
  }
}

// 根据人数动态计算进度条亮起的数量
const getBarStyle = (index, currentPeople) => {
	// 根据人数确定亮起的条数
	let activeCount = Math.min(Math.floor(currentPeople / 5), 7); // 总共7个竖条
	if (currentPeople > 35) {
		activeCount = 7;  // 超过35人时，所有条目亮起
	}

	// 判断当前条是否需要被点亮
	const isActive = index <= activeCount;

	return {
		backgroundColor: isActive ? '#ff7000' : '#c4c4c4',
	};
};

//门店详情弹窗
const showPopup = ref(false)
const selectedStore = ref(null)

const openStorePopup = (store) => {
	selectedStore.value = store
	showPopup.value = true
}

const closePopup = () => {
	showPopup.value = false
}
const openMap = (store) => {
	wx.openLocation({
		latitude: parseFloat(store.latitude),
		longitude: parseFloat(store.longitude),
		name: store.storeName,
		address: store.address,
		scale: 18
	})
}
// 页面加载时触发
onMounted(() => {
  searchStores()
})
</script>
<template>
	<image class="fixed top-0 left-0 z-[-1] w-full h-full object-cover" :src="getUrl('/common/bg2.png')" />
	<view class="w-full h-auto  height-[100vh] overflow-hidden">
		<view class=" pt-20 pb-4 px-6">
			<view class="flex justify-between items-end">
				<view class="text-[#ff7000] font-bold text-3xl mb-4">门店列表</view>
				<view class="relative ">
					<!-- 输入框 -->
					<input v-model="storeName" type="text" placeholder="搜索门店名称"
						class="bg-[#ffffff90] bg-[length:24px_24px]  bg-no-repeat  rounded-full pl-8 pr-3 py-2 w-25  placeholder-gray-300 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-[#ffa259]/50" />

					<!-- 点击图标搜索 -->
					<img :src="getUrl('/stores/store_search.svg')" @click="searchStores" alt="搜索"
						class="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 cursor-pointer" />
				</view>
			</view>
		</view>
		<view class="css-scroll-container px-6" :style="{ height: `calc(100vh - ${300 + 20}rpx)` }">
			<view class="flex flex-wrap flex-col justify-between items-stretch">
				<view class="w-full h-25 bg-white rounded-lg flex justify-between items-center p-2 x-6 mb-4"
					v-for="store in storesList" :key="store.id" @click="openStorePopup(store)">
					<image class="w-2/5 h-full object-cover rounded-lg" :src="store.mainImage" mode="scaleToFill" />
					<view class="flex flex-col w-3/5 h-full pl-2 justify-between">
						<view class="flex justify-between items-center mb-1">
							<view class="text-sm font-bold">{{ store.storeName }}</view>
							<view class="text-xs text-[#bcbaba] font-bold">{{ store.distance }}</view>
						</view>
						<view class="flex items-start h-10">
							<image class="w-3 h-3 object-contain mr-1" :src="getUrl('/stores/store_nav.svg')"
								mode="scaleToFill" />
							<view class="text-[10px] txet-[#bcbaba]">{{ store.address }}</view>
						</view>
						<view class="flex justify-end">
							<div class="mt-2 py-2 px-2 flex items-center bg-[#fff8f1] rounded-lg">
								<span class="mr-1 text-[8px] font-bold">当前人数：</span>
								<div class="flex space-x-0.5">

									<div v-for="index in 7" :key="index"
										:style="getBarStyle(index, store.currentPeople)" class="w-1 h-3 rounded-full">
									</div>
								</div>
								<span class="ml-1 text-orange-500 text-[8px] font-bold">{{ store.currentPeople
								}}人</span>
							</div>
						</view>
					</view>
				</view>
			</view>
			<view class="tab-bar-height-store">已经到底啦~~</view>
		</view>
	</view>
	<!-- 门店详情弹窗 -->
	<view v-if="showPopup" class="fixed inset-0 z-50 bg-[#00000056] bg-opacity-10 flex items-center justify-center"
		@click.self="closePopup">
		<view class="bg-white w-11/12 max-w-md rounded-xl overflow-hidden relative" @click.stop>
			<!-- 关闭按钮 -->
			<!-- <view class="absolute top-2 right-2 text-gray-400 text-xl" @click="closePopup">×</view> -->

			<!-- 地图 -->
			<image :src="selectedStore?.addressMap" mode="widthFix" class="w-full h-40 rounded-md object-cover" />
			<view class="px-4 py-2 relative">
				<!-- 导航 -->
				<image class="inline-block w-8 h-8 absolute right-3 top-1 z-51" :src="getUrl('/stores/store_plane.svg')"
					mode="scaleToFill" @click="openMap(selectedStore)" />
				<!-- 门店名 -->
				<view class="text-lg font-bold mb-1">{{ selectedStore?.storeName }}</view>

				<!-- 地址 -->
				<view class="text-sm text-gray-600 mb-1">{{ selectedStore?.address }}</view>

				<!-- 营业时间 -->
				<view class="text-sm text-gray-600 mb-1 flex items-center">
					<image class="inline-block mr-1 w-4 h-4" :src="getUrl('/stores/store_clock.svg')"
						mode="scaleToFill" />
					{{ selectedStore?.businessHours }}
				</view>

				<!-- 电话 -->
				<view class="text-sm text-gray-600 mb-1 flex items-center">
					<image class=" inline-block mr-1 w-4 h-4" :src="getUrl('/stores/store_phone.svg')"
						mode="scaleToFill" /> {{ selectedStore?.phone }}
				</view>

				<!-- 设备信息 -->
				<view class="text-sm text-gray-600 mb-1 flex items-center">
					<image class=" inline-block mr-1 w-4 h-4" :src="getUrl('/stores/store_muscle.svg')" />
					共 {{ selectedStore?.equipmentTypes }} 种器材
				</view>

				<!-- 当前人数 -->
				<view class="model-bottom flex justify-end items-center bg-white">
					<view class=" mb-2 py-2 px-2 flex items-center bg-[#ffeede] rounded-lg">
						<span class="mr-1 text-[12px] font-bold">当前人数：</span>
						<div class="flex space-x-0.5">
							<div v-for="index in 7" :key="index"
								:style="getBarStyle(index, selectedStore.currentPeople)" class="w-1 h-3 rounded-full">
							</div>
						</div>
						<span class="ml-1 text-orange-500 text-[12px] font-bold">{{ selectedStore?.currentPeople
						}}人</span>
					</view>
				</view>

			</view>

		</view>
	</view>


	<custom-tab-bar></custom-tab-bar>

</template>



<style scoped>
.model-bottom {
	background-color: #00000036;
}

.tab-bar-height-store {
	height: calc(var(--window-bottom) + 140rpx);
	display: flex;
	justify-content: center;
}


</style>
