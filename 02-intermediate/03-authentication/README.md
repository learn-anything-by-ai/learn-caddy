# 认证授权示例

本示例演示如何使用 Caddy 进行用户认证和授权，保护受限资源。

## 学习目标

- 理解 Web 认证的基本概念
- 掌握 Caddy 的基础认证配置
- 学会使用 JWT 认证
- 了解不同的认证方式

## 示例说明

这个示例包含：

- 基础 HTTP 认证
- JWT 令牌认证
- 基于路径的访问控制
- 用户组和权限管理

## 运行示例

1. 启动认证服务器：

```bash
cd auth-server
npm install
npm start
```

2. 启动 Caddy：

```bash
caddy run --config Caddyfile
```

3. 测试认证：

```bash
# 访问公共页面（无需认证）
curl http://localhost:8080/

# 访问受保护页面（需要认证）
curl http://localhost:8080/admin/

# 使用基础认证
curl -u admin:password http://localhost:8080/admin/

# 使用 JWT 认证
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" http://localhost:8080/api/
```

## 配置详解

### 基础认证

最简单的用户名密码认证方式。

### JWT 认证

使用 JSON Web Token 进行无状态认证。

### 路径保护

根据 URL 路径配置不同的认证要求。

### 用户管理

管理用户账户和权限分配。

## 学习要点

1. 认证确保只有授权用户才能访问资源
2. 基础认证简单但安全性较低
3. JWT 适合 API 和单页应用
4. 不同路径可以配置不同的认证策略
5. 始终使用 HTTPS 传输认证信息
