<template>
	<view class="flex flex-col items-center justify-between min-h-screen w-full px-4 sm:px-6 md:px-8 pb-4 sm:pb-8">
		<div class=""></div>

		<div class="flex flex-col items-center justify-center w-full">
			<logoSvg :shallow="true"></logoSvg>
			<div class="border-[0.5px] border-solid w-[85%] sm:w-[70%] mt-6 sm:mt-8 mb-4 sm:mb-5 transition-all duration-300"
				:class="isChecked ? 'border-[#ff7000]' : 'border-[#bcbaba]'"></div>
			<div class="text-base sm:text-lg letter-spacing-6 pl-4 transition-all duration-300"
				:class="isChecked ? 'text-[#ff7000]' : 'text-[#bcbaba]'">
				每一分钟，成就新自我。
			</div>
			<button
				class="w-[80%] sm:w-[60%] mt-6 sm:mt-8 mb-4 sm:mb-5 text-[#fff] text-xs sm:text-sm tracking-wide rounded-full p-3 sm:p-4 transition-all duration-300"
				:class="[
					isChecked ? 'bg-orange-500 active:scale-95 active:brightness-110 shadow-md' : 'bg-[#c4c4c4] opacity-60',
					!isChecked ? 'cursor-not-allowed' : ''
				]" open-type="getUserProfile" @tap="wxLogin">
				微信授权登录
			</button>
		</div>

		<view class="flex items-start space-x-2 mt-4 w-full" @tap="toggleCheck">
			<div class="mt-[1px]">
				<!-- 自定义勾选框 -->
				<view
					class="w-3.5 h-3.5 sm:w-4 sm:h-4 rounded-[50%] border border-orange-500 flex items-center justify-center leading-none transition-all duration-300"
					:class="isChecked ? 'bg-orange-500 scale-110' : 'bg-white'">
					<!-- 常驻白色打勾（Unicode ✓） -->
					<text class="text-white text-[10px] sm:text-xs font-bold transition-all duration-300"
						:class="isChecked ? 'opacity-100 scale-100' : 'opacity-0 scale-0'">✓</text>
				</view>
			</div>
			<!-- 协议文字 -->
			<text class="text-gray-700 text-xs sm:text-sm">
				我已阅读并同意
				<text class="text-orange-600 transition-colors duration-300"
					@tap.stop="goTo('/pages/user-agreement')">《用户协议》</text>、
				<text class="text-orange-600 transition-colors duration-300"
					@tap.stop="goTo('/pages/privacy-policy')">《隐私政策》</text>
				及
				<text class="text-orange-600 transition-colors duration-300"
					@tap.stop="goTo('/pages/platform-terms')">《平台相关协议》</text>
			</text>
		</view>
	</view>
</template>

<script setup>
import { ref } from 'vue';
import logoSvg from '../../components/base/logo-svg.vue';
import { useUserStore } from '@/stores/user.js'
import { useTabBarStore } from '@/stores/tab-bar'
const tabBarStore = useTabBarStore()
const userStore = useUserStore()
const isChecked = ref(false);

function toggleCheck() {
	isChecked.value = !isChecked.value
	console.log('当前勾选状态：', isChecked.value)
}

function goTo(path) {
	uni.navigateTo({ url: path });
}
// 登录行为（示例）
function handleLogin() {
	if (!isChecked.value) {
		uni.showToast({
			title: '请先同意相关协议',
			icon: 'none'
		})
		return
	}

	// 执行登录逻辑...
	uni.showToast({
		title: '登录中...',
		icon: 'loading'
	})
	uni.login({
		provider: 'weixin',
		success: (res) => {
			if (res.code) {
				uni.request({
					url: 'http://localhost:3000/api/users/wxlogin',
					method: 'POST',
					data: { code: res.code },
					success: (resp) => {
						const { token, user } = resp.data
						uni.setStorageSync('token', token)
						uni.setStorageSync('user', user)
						uni.showToast({ title: '登录成功' })
					}
				})
			} else {
				uni.showToast({ title: '登录失败', icon: 'none' })
			}
		}
	})
}
//微信授权登录
function wxLogin() {
	if (!isChecked.value) {
		uni.showToast({
			title: '请先同意相关协议',
			icon: 'none'
		})
		return
	}

	// 执行登录逻辑...
	uni.showToast({
		title: '登录中...',
		icon: 'loading'
	})
	wx.getUserProfile({
		desc: '用于登录健身房小程序',
		success: (res) => {
			const { avatarUrl, nickName } = res.userInfo;
			wx.login({
				success(loginRes) {
					wx.request({
						url: 'http://localhost:3000/api/users/wxlogin',
						method: 'POST',
						data: {
							code: loginRes.code,
							avatarUrl,
							nickname: nickName
						},
						success: (res) => {
							console.log('发送给后端的参数:', {
								code: loginRes.code,
								avatarUrl,
								nickname: nickName
							});
							if (res.data.token) {
								userStore.setUser(res.data.token, res.data.user);
								wx.setStorageSync('token', res.data.token);
								wx.setStorageSync('user', res.data.user);
								wx.showToast({ title: '登录成功' });

								// 获取页面栈
								const pages = getCurrentPages();
								if (pages.length > 1) {
									// 有前一页，返回上一页
									wx.navigateBack();
								} else {
									// 无前一页，跳转首页
									tabBarStore.switchTab('/pages/index/index')
								}
							} else {
								wx.showToast({ title: '登录失败', icon: 'none' });
							}
						},
						fail: (err) => {
							console.error('请求失败:', err);
							wx.showToast({ title: '页面加载失败', icon: 'none' });
						}
					});
				}
			});
		}
	});

}
</script>

<style scoped>
/* 添加动画相关的样式 */
.transition-all {
	transition-property: all;
	transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

.duration-300 {
	transition-duration: 300ms;
}

/* 添加按钮点击动画 */
.active\:scale-95:active {
	transform: scale(0.95);
}

.active\:brightness-110:active {
	filter: brightness(1.1);
}

/* 添加阴影过渡 */
.shadow-md {
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}
</style>
