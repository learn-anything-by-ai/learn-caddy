# 负载均衡示例

本示例演示如何使用 Caddy 进行负载均衡，将请求分发到多个后端服务器。

## 学习目标

- 理解负载均衡的基本概念
- 掌握 Caddy 的负载均衡配置
- 了解不同的负载均衡策略
- 学会健康检查配置

## 示例说明

这个示例包含：

- 基本的负载均衡配置
- 多种负载均衡策略
- 健康检查设置
- 故障转移处理

## 运行示例

1. 启动后端服务器：

```bash
# 启动三个测试服务器
node backend/server1.js &
node backend/server2.js &
node backend/server3.js &
```

2. 启动 Caddy：

```bash
caddy run --config Caddyfile
```

3. 测试负载均衡：

```bash
# 多次请求，观察负载分发
curl http://localhost:8080
curl http://localhost:8080
curl http://localhost:8080
```

## 配置详解

### 基本负载均衡

最简单的负载均衡配置，使用默认的轮询策略。

### 健康检查

配置健康检查端点，自动剔除不健康的服务器。

### 负载均衡策略

- `round_robin`: 轮询（默认）
- `least_conn`: 最少连接
- `ip_hash`: IP 哈希
- `random`: 随机

## 学习要点

1. 负载均衡可以提高应用的可用性和性能
2. 健康检查确保请求只转发到健康的服务器
3. 不同的策略适用于不同的场景
4. Caddy 支持热重载，可以动态添加或移除服务器
