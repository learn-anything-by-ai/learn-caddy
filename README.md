# 🎓 Caddy 学习项目

一个全面的 Caddy Web 服务器学习项目，包含从基础到高级的各种示例和实战项目。

## 🌟 项目特色

- **渐进式学习路径**：从基础概念到高级应用
- **丰富的示例**：涵盖 Caddy 的主要功能
- **详细的注释**：每个配置都有中文说明
- **实战项目**：真实场景的完整示例
- **交互式演示**：可视化的学习体验

## 什么是 Caddy？

Caddy 是一个强大、企业级的开源 Web 服务器，具有自动 HTTPS 功能。它以配置简单、功能强大而著称。

## 安装 Caddy

### macOS (使用 Homebrew)
```bash
brew install caddy
```

### 验证安装
```bash
caddy version
```

## 学习路径

### 📚 基础篇
1. [静态文件服务](./01-basic/01-static-files/) - 最简单的文件服务
2. [反向代理](./01-basic/02-reverse-proxy/) - 代理后端服务
3. [基础路由](./01-basic/03-basic-routing/) - URL 路由配置

### 🔧 中级篇
4. [HTTPS 和证书](./02-intermediate/01-https-ssl/) - 自动 HTTPS 配置
5. [负载均衡](./02-intermediate/02-load-balancing/) - 多服务器负载均衡
6. [认证授权](./02-intermediate/03-authentication/) - 基础认证和 JWT
7. [日志配置](./02-intermediate/04-logging/) - 访问日志和错误日志
8. [压缩和缓存](./02-intermediate/05-compression-cache/) - 性能优化

### 🚀 高级篇
9. [API 网关](./03-advanced/01-api-gateway/) - 构建 API 网关
10. [微服务架构](./03-advanced/02-microservices/) - 微服务部署
11. [Docker 集成](./03-advanced/03-docker/) - 容器化部署
12. [性能监控](./03-advanced/04-monitoring/) - 监控和指标
13. [自定义插件](./03-advanced/05-plugins/) - Caddy 插件开发

### 🏗️ 实战项目
14. [个人博客站点](./04-projects/01-blog/) - 完整的博客部署
15. [企业级应用](./04-projects/02-enterprise/) - 生产环境配置
16. [CI/CD 集成](./04-projects/03-cicd/) - 自动化部署

## 快速开始

1. 克隆项目并进入目录：
```bash
git clone <repository-url>
cd learn-caddy
```

2. 从最基础的示例开始：
```bash
cd 01-basic/01-static-files
```

3. 按照每个目录下的 README 说明进行学习

4. 运行演示脚本（可选）：
```bash
./start-demo.sh
```

## 常用命令

```bash
# 启动 Caddy（使用当前目录的 Caddyfile）
caddy run

# 重新加载配置（无停机）
caddy reload

# 验证配置文件
caddy validate

# 停止 Caddy
caddy stop

# 使用特定配置文件
caddy run --config /path/to/Caddyfile

# 格式化 Caddyfile
caddy fmt --overwrite
```

## 学习提示

- 每个示例都包含详细的注释
- 从简单示例开始，逐步进阶
- 实际运行每个示例，观察效果
- 修改配置参数，理解不同选项的作用
- 查看日志输出，了解 Caddy 的工作原理

## 参考资源

- [Caddy 官方文档](https://caddyserver.com/docs/)
- [Caddyfile 语法参考](https://caddyserver.com/docs/caddyfile)
- [Caddy 社区论坛](https://caddy.community/)

让我们开始 Caddy 的学习之旅吧！🚀
