# 反向代理

Caddy 的反向代理功能非常强大，可以将请求转发到后端服务器。

## 学习目标

- 理解反向代理的概念
- 掌握 Caddy 反向代理配置
- 学习健康检查和负载均衡基础

## 什么是反向代理？

反向代理是一个位于客户端和后端服务器之间的服务器。它接收客户端请求，然后将请求转发到一个或多个后端服务器，最后将后端服务器的响应返回给客户端。

## 示例文件结构

```
02-reverse-proxy/
├── Caddyfile              # 基础反向代理配置
├── Caddyfile-advanced     # 高级配置示例
├── backend/               # 模拟后端服务
│   ├── server1.js         # Node.js 服务器1
│   ├── server2.js         # Node.js 服务器2
│   └── package.json
├── static/                # 静态文件
│   └── index.html
└── README.md
```

## 使用场景

1. **隐藏后端服务器**：客户端不直接访问后端
2. **负载均衡**：分发请求到多个后端服务器
3. **SSL 终止**：在代理层处理 HTTPS
4. **缓存**：提高性能
5. **安全**：过滤恶意请求

## 运行示例

1. 启动后端服务（需要 Node.js）：
   ```bash
   cd backend
   npm install
   npm run server1  # 启动第一个后端服务
   # 在另一个终端
   npm run server2  # 启动第二个后端服务
   ```

2. 启动 Caddy：
   ```bash
   caddy run
   ```

3. 访问：
   - http://localhost:8080 - 主页面
   - http://localhost:8080/api - API 请求会被代理到后端

## 配置说明

基本反向代理配置非常简单：

```caddyfile
localhost:8080 {
    reverse_proxy /api/* localhost:3001
}
```

这会将所有 `/api/*` 路径的请求转发到 `localhost:3001`。
