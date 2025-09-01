<template>
	<image class="absolute top-0 left-0 z-[-1] w-full h-full object-cover" :src="getUrl('common/bg1.png')" />
	<view class="content min-h-screen flex flex-col justify-end items-center px-4 sm:px-6 md:px-8">
		<!-- logo -->
		<logoSvg class="absolute top-8 sm:top-10 left-4 sm:left-5" :innerWidth="96" :innerHeight="96"
			sm:innerWidth="122" sm:innerHeight="122"></logoSvg>
		<!-- 我的个人信息 -->
		<view class="p-2 sm:p-4 pb-4 w-full">
			<view v-if="token"
				class="bg-white rounded-xl flex flex-col justify-between items-stretch w-full p-3 sm:p-4">
				<!-- 头像 vip -->
				<div class="w-full flex items-center ">
					<div class="relative">
						<img class=" absolute top-0 left-0 translate-x-[20%]  translate-y-[-90%]  w-15 h-15 sm:w-18 sm:h-18 rounded-full object-cover" mode="aspectFill"
							:src="userInfo?.avatarUrl || getUrl('/profile/avatar2.png')" alt="" srcset=""
							@tap="goToProfile">
					</div>
					<view class="font-bold ml-18 sm:ml-22 h-full text-sm sm:text-sm">Hi, {{ userInfo?.name }}</view>
					<view
						class="border-[0.5px] border-solid border-[#ff7000]  ml-3 sm:ml-4 h-full text-[8px] sm:text-xs rounded-sm text-[#ff7000] px-1 sm:px-2 py-[2px]">
						VIP1</view>
				</div>
				<!-- 等级进度 -->
				<div class="w-full flex flex-col items-stretch justify-between">
					<div class="w-full flex items-stretch justify-between">
						<div class="text-xs my-2">会员有效期至2025.3.28</div>
						<!-- 显示当前进度（可选） -->
						<div class="flex items-end text-[8px]">
							{{ progressValue }}/{{ progressMax }}
						</div>
					</div>
					<!-- 显示进度条 -->
					<div class="w-full bg-gray-300 rounded-full h-1">
						<div :style="progressBarStyle" class="h-1 rounded-full transition-all ease-in-out duration-300">
						</div>
					</div>
				</div>
				<!-- 最近门店 -->
				<div class="flex justify-between items-center">
					<div class="flex justify-center items-center">
						<img class="w-4 h-8 sm:w-7 sm:h-9 object-center" :src="getUrl('/home/home_nav.svg')" alt="">
						<div class="text-sm font-bold">中山电子科大店</div>
					</div>
					<div class="mt-2 py-2 px-2 flex items-center bg-[#fff8f1] rounded-lg">
						<span class="mr-1 text-xs font-bold">当前人数：</span>
						<div class="flex space-x-1">
							<!-- 动态显示竖条 -->
							<div v-for="index in 7" :key="index" :style="getBarStyle(index)"
								class="w-1.5 h-4 rounded-full">
							</div>
						</div>
						<span class="ml-2 text-orange-500 text-[10px] font-bold">{{ currentPeople }}人</span>
					</div>

				</div>
			</view>
			<view v-else class="bg-white rounded-xl flex justify-between items-center w-full p-3 sm:p-4 h-24 sm:h-30">
				<div class="w-full flex items-center">
					<img class="w-12 h-12 sm:w-15 sm:h-15 rounded-full object-cover" @tap="goToLogin"
						:src="getUrl('/common/avatar.png')" alt="User Avatar">
					<view class="font-bold ml-3 sm:ml-4 h-full text-xs sm:text-sm letter-spacing-2 text-gray-600"
						@tap="goToLogin">请点击登录</view>
				</div>
				<div class="w-12 h-12 sm:w-15 sm:h-15 flex justify-center items-center" @click="goToFaceRecognition">
					<img class="w-full h-full" :src="getUrl('/home/qrcode.svg')" alt="QR Code">
				</div>
			</view>
		</view>
		<div class="flex flex-col gap-6 sm:gap-4 w-full h-[30vh] sm:h-[40vh]">
			<div class="flex flex-row flex-1 p-2 sm:p-4 ">
				<!-- 会员卡 -->
				<div @click="goToMember"
					class=" relative flex-2 p-3 sm:p-4 flex justify-stretch items-start sm:mr-4 rounded-xl bg-[#ffaa66] mx-auto mr-6">
					<view class=" relative text-white font-bold text-lg sm:text-xl underline underline-offset-8">会员卡
						<img class="absolute top-6 sm:top-6 left-14 sm:left-16 w-3 h-3 sm:w-4 sm:h-4"
							:src="getUrl('/home/single.svg')" alt="">
					</view>
					<image
						class="absolute left-1/2 top-1/2 z-0 w-full h-5/9 object-cover transform -translate-x-1/2 -translate-y-1/3 scale-100 transition-transform "
						:src="getUrl('/home/sit_people.png')" />
				</div>
				<div class="flex flex-col flex-2 gap-6 sm:gap-4">
					<!-- 人脸识别 -->
					<button @click="scanCodeEvent"
						class="w-full flex-1 p-2 flex justify-center items-center rounded-xl bg-white">
						<view class="text-right">
							<view class="text-sm sm:text-[14px] font-bold yahei-font pr-1">扫码开门</view>
							<view class="text-[8px] sm:text-[10px] font-light text-[#949494] mt-1">一人一码</view>
						</view>
						<img class="w-14 h-12 sm:w-18 sm:h-16" :src="getUrl('/home/qrcode.svg')" alt="">
					</button>
					<!-- 联系客服 -->
					<button open-type="contact"
						class="w-full flex-1 p-2 flex justify-center items-center rounded-xl bg-white">
						<view class="text-right">
							<view class="text-sm sm:text-[14px] font-bold yahei-font">联系客服</view>
							<!-- <view class="text-[8px] sm:text-[10px] font-light text-[#949494] mt-1">联系馆内</view>
							<view class="text-[8px] sm:text-[10px] font-light text-[#949494] mt-1">人员</view> -->
						</view>
						<img class="w-14 h-12 sm:w-18 sm:h-16" :src="getUrl('/home/call.png')" alt="">
					</button>
				</div>
			</div>
		</div>
		<!-- 提示语 -->
		<view class=" text-[#3f261a] font-bold text-sm sm:text-sm mb-4 letter-spacing-4">每一分钟，成就新自我。</view>
		<button @tap="goToQRCode">生成设备二维码</button>
		<!-- 添加占位区域 -->
		<view class="tab-bar-height"></view>
		<custom-tab-bar></custom-tab-bar>
	</view>
</template>
<script setup>
import { ref, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app';
import CustomTabBar from '@/components/custom-tab-bar/index.vue'
import logoSvg from '../../components/base/logo-svg.vue';
import { useUserStore } from '@/stores/user.js'
import { useImageStore } from '@/stores/imageStore.js';
import { useTabBarStore } from '@/stores/tab-bar'
import { storeToRefs } from 'pinia'
import { BASE_URL } from '@/utils/request'
const userStore = useUserStore()
const tabBarStore = useTabBarStore()
const { token, userInfo } = storeToRefs(userStore)
const { getUrl } = useImageStore();
// 定义进度条的最大值和当前值
const progressMax = ref(100);
const progressValue = ref(30);  // 当前值，可动态改变
const goToQRCode = () => {
	const deviceId = '37607b9d-4898-47e3-9c62-257fef5fe8d7' // 实际应从设备数据中获取
	uni.navigateTo({
		url: `/pages/qrcode/qrcode?deviceId=${deviceId}`
	})
}

// 会员等级计算进度条
const progressBarStyle = computed(() => {
	return {
		width: `${(progressValue.value / progressMax.value) * 100}%`,
		backgroundColor: '#ff7000',  // 设置进度条颜色
	};
});
// 当前人数
const currentPeople = ref(24);

// 根据人数动态计算进度条亮起的数量
const getBarStyle = (index) => {
	// 根据人数确定亮起的条数
	let activeCount = Math.min(Math.floor(currentPeople.value / 5), 7); // 总共7个竖条
	if (currentPeople.value > 35) {
		activeCount = 7;  // 超过35人时，所有条目亮起
	}

	// 判断当前条是否需要被点亮
	const isActive = index <= activeCount;

	return {
		backgroundColor: isActive ? '#ff7000' : '#c4c4c4',
	};
};

const goToFaceRecognition = () => {
	uni.navigateTo({
		url: '/pages/qrcode/qrcode' // 请替换为实际要跳转的页面路径
	});
}

const scanCode = ref('');

// 扫码事件
const scanCodeEvent = () => {
	// 判断是否已登录
	if (!userStore.userInfo?.userId || !userStore.token) {
		uni.showToast({
			title: '请先登录',
			icon: 'none',
			duration: 2000
		});
		return; // 中止扫码流程
	}

	// 开始扫码
	uni.scanCode({
		success: async (res) => {
			const deviceId = res.result; // 二维码中存储的 device_id

			const response = await uni.request({
				url: BASE_URL + '/access/scan',
				method: 'POST',
				data: {
					userId: userStore.userInfo.userId,
					deviceId: deviceId
				},
				header: {
					Authorization: 'Bearer ' + userStore.token
				}
			});

			if (response.data.success) {
				uni.showToast({ title: response.data.message, icon: 'success' });
			} else {
				uni.showToast({ title: response.data.message, icon: 'none' });
			}
		},
		fail: () => {
			uni.showToast({ title: '扫码失败', icon: 'none' });
		}
	});
};


// const appid = ref('')
const goToLogin = () => {
	uni.navigateTo({
		url: '/pages/login/login'
	});
}
const goToProfile = () => {
	// uni.switchTab({
	// 	url: '/pages/profile/profile' 
	// });
	tabBarStore.switchTab('/pages/profile/profile')
}
const goToMember = () => {
	tabBarStore.switchTab('/pages/member/member')
}
</script>



<style scoped>
.container {
	padding: 20px;
	display: flex;
	flex-direction: column;
	align-items: center;
}
</style>