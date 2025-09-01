const express = require('express');
const cors = require('cors');
const os = require('os'); // 引入os模块

const corsOptions = require('./config/cors');

const userRoutes = require('./routes/userRoutes');
const payRoutes = require('./routes/payRoutes');
const storeRoutes = require('./routes/storeRoutes');
const cardRoutes = require('./routes/cardRoutes');
const accessRoutes = require('./routes/accessRoutes');
const feedbackRoutes = require('./routes/feedbackRoutes');
const uploadRoutes = require('./routes/uploadRoutes');
const securityRoutes = require('./routes/securityRoutes');

const app = express();
// app.use(cors(corsOptions));
// 允许所有跨域请求
app.use(cors({
  origin: '*', // 允许所有来源
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'], // 允许所有HTTP方法
  allowedHeaders: ['Content-Type', 'Authorization'] // 允许所有常见请求头
}));
app.use(express.json());

// 定义基础URL（可根据环境动态调整）
// 获取本地IPv4地址
function getLocalIP() {
    const interfaces = os.networkInterfaces();
    for (const devName in interfaces) {
        const iface = interfaces[devName];
        for (let i = 0; i < iface.length; i++) {
            const alias = iface[i];
            if (alias.family === 'IPv4' && !alias.internal) {
                return alias.address;
            }
        }
    }
    return '127.0.0.1'; // 默认返回本地回环地址
}

const LOCAL_IP = getLocalIP();
const BASE_URL = `http://${LOCAL_IP}:3000`;
// 路由注册前打印提示
console.log('[DEBUG] 开始注册路由...');

// 注册所有路由
app.use('/api/access', accessRoutes);
app.use('/api/cards', cardRoutes);
app.use('/api/users', userRoutes);
app.use('/api/pay', payRoutes);
app.use('/api/stores', storeRoutes);
app.use('/api/user-feedback', feedbackRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/security', securityRoutes);
console.log('[DEBUG] 已注册路由');


// 启动服务器并打印路由
app.listen(3000, () => {
    console.log(`Server running on ${BASE_URL}`);
    console.log(`本地IPv4地址: ${LOCAL_IP}`);
})