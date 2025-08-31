# API 网关示例

本示例演示如何使用 Caddy 构建 API 网关，统一管理和路由 API 请求。

## 学习目标

- 理解 API 网关的作用和原理
- 掌握 Caddy 的高级路由配置
- 学会 API 版本管理
- 实现请求转换和响应处理

## 示例说明

这个示例包含：

- API 路由和版本管理
- 请求/响应转换
- 限流和熔断
- API 文档和监控

## 运行示例

1. 启动微服务：

```bash
cd services
npm install
npm run start-all
```

2. 启动 API 网关：

```bash
caddy run --config Caddyfile
```

3. 测试 API：

```bash
# 用户服务 API
curl http://localhost:8080/api/v1/users/

# 订单服务 API
curl http://localhost:8080/api/v1/orders/

# 产品服务 API
curl http://localhost:8080/api/v2/products/
```

## 配置详解

### API 路由

基于路径和版本的智能路由。

### 服务发现

自动发现和路由到可用服务。

### 限流保护

防止 API 被滥用和过载。

### 监控指标

收集 API 使用统计和性能指标。

## 学习要点

1. API 网关是微服务架构的重要组件
2. 统一的入口便于管理和监控
3. 版本管理支持平滑升级
4. 限流和熔断保护后端服务
5. 良好的错误处理和日志记录
