import { createSSRApp } from 'vue'
import App from './App.vue'
import './styles/main.css'

import { createPinia } from 'pinia'
const pinia = createPinia()
import ImageWithError from '@/components/gobal/ImageWithError.vue'
export function createApp() {
	const app = createSSRApp(App)

	

	app.use(pinia)

	 // 注册全局组件
	app.component('ImageWithError',ImageWithError)
	return {
		app
	}
}
