<template>
	<view>
		<view
			class="overflow-hidden rounded-full flex items-center justify-center bg-white"
			:class="shallow ? 'shadow-lg' : ''"
			:style="{
				width: innerWidth + 'rpx',
				height: innerHeight + 'rpx'
			}"
		>
			<image
				src="/static/logo.svg"
				mode="aspectFill"
				class="w-[100%] h-[100%] scale-125"
			/>
		</view>
	</view>
</template>

<script setup>
defineProps({
	shallow: {
		type: Boolean,
		default: false
	},
	innerWidth: {
		type: Number,
		default: 240  // 默认 84 * 4 = 336rpx
	},
	innerHeight: {
		type: Number,
		default: 240
	}
})
</script>
