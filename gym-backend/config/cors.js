module.exports = {
  // 允许所有域名访问
  origin: '*',
  
  // 允许的请求方法
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  
  // 允许的请求头
  allowedHeaders: [
    'Content-Type',
    'Authorization',
    'X-Requested-With',
    'Accept',
    'Origin',
    'X-Token'
  ],
  
  // 允许携带凭证（cookies等）
  credentials: true,
  
  // 预检请求的缓存时间（秒）
  maxAge: 86400,
  
  // 允许客户端获取的响应头
  exposedHeaders: ['Content-Length', 'X-Token']
}; 