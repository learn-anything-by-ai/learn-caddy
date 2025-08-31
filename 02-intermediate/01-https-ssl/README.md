# HTTPS 和 SSL 证书

学习 Caddy 的自动 HTTPS 功能，这是 Caddy 最强大的特性之一。

## 学习目标

- 理解 HTTPS 和 SSL/TLS 的基本概念
- 掌握 Caddy 的自动 HTTPS 配置
- 学习手动证书配置
- 了解证书管理和更新

## 什么是自动 HTTPS？

Caddy 的自动 HTTPS 功能包括：

1. **自动获取证书** - 从 Let's Encrypt 自动获取有效证书
2. **自动更新证书** - 在证书到期前自动更新
3. **自动重定向** - HTTP 请求自动重定向到 HTTPS
4. **现代加密** - 默认使用安全的 TLS 配置

## 示例文件结构

```
01-https-ssl/
├── Caddyfile-local       # 本地开发配置
├── Caddyfile-production  # 生产环境配置  
├── Caddyfile-custom      # 自定义证书配置
├── certs/                # 本地证书目录
│   ├── localhost.crt
│   └── localhost.key
├── static/               # 演示网站
│   └── index.html
└── README.md
```

## 配置说明

### 本地开发

本地开发时，Caddy 会自动生成自签名证书：

```caddyfile
localhost {
    file_server
    tls internal
}
```

### 生产环境

生产环境中，Caddy 会自动从 Let's Encrypt 获取证书：

```caddyfile
yourdomain.com {
    file_server
    # Caddy 会自动启用 HTTPS
}
```

### 自定义证书

如果需要使用自定义证书：

```caddyfile
yourdomain.com {
    tls /path/to/cert.crt /path/to/key.key
    file_server
}
```

## 运行示例

### 本地测试
```bash
# 使用本地配置
caddy run --config Caddyfile-local

# 访问 https://localhost
# 浏览器会显示安全警告（自签名证书）
```

### 生产部署
```bash
# 确保域名已正确解析到服务器
# 确保防火墙开放 80 和 443 端口
caddy run --config Caddyfile-production
```

## HTTPS 相关概念

### SSL/TLS 协议
- **SSL** (Secure Sockets Layer) - 安全套接字层
- **TLS** (Transport Layer Security) - 传输层安全协议
- **TLS 1.3** - 最新版本，更安全更快

### 证书类型
- **域验证 (DV)** - 验证域名所有权
- **组织验证 (OV)** - 验证组织身份
- **扩展验证 (EV)** - 最高级别验证

### Let's Encrypt
- 免费的证书颁发机构
- 自动化证书管理
- 90 天有效期，需要定期更新

## 安全最佳实践

1. **始终使用 HTTPS** - 保护用户数据传输
2. **HSTS 配置** - 强制浏览器使用 HTTPS
3. **安全头配置** - 添加安全相关的 HTTP 头
4. **证书监控** - 监控证书状态和过期时间
5. **定期更新** - 保持 Caddy 版本最新

## 常见问题

**Q: 为什么浏览器显示"不安全"？**
A: 可能是使用了自签名证书，或证书不匹配域名

**Q: 如何强制 HTTPS？**  
A: Caddy 默认会自动重定向 HTTP 到 HTTPS

**Q: 如何配置 HSTS？**
A: 使用 header 指令添加 HSTS 头
