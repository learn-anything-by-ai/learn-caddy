# 🚀 Caddy 学习快速启动指南

欢迎使用 Caddy 学习项目！本指南将帮你快速启动并体验所有示例。

## 📋 前置要求

### 1. 安装 Caddy

**macOS (推荐使用 Homebrew):**
```bash
brew install caddy
```

**其他系统请参考:** [Caddy 官方安装指南](https://caddyserver.com/docs/install)

### 2. 验证安装
```bash
caddy version
```

### 3. 安装 Node.js (用于反向代理示例)
```bash
# macOS
brew install node

# 验证安装
node --version
npm --version
```

## ⚡ 快速启动

### 🏃‍♂️ 方式一：一键启动脚本

我为你创建了启动脚本，让你可以快速体验所有示例：

```bash
# 给脚本执行权限
chmod +x start-demo.sh

# 启动所有示例
./start-demo.sh
```

### 🔧 方式二：手动启动

#### 1. 静态文件服务示例
```bash
cd 01-basic/01-static-files
caddy run
# 访问: http://localhost:8080
```

#### 2. 反向代理示例
```bash
# 终端 1: 启动后端服务
cd 01-basic/02-reverse-proxy/backend
npm install
npm run dev

# 终端 2: 启动 Caddy
cd 01-basic/02-reverse-proxy
caddy run
# 访问: http://localhost:8080
```

#### 3. 路由配置示例
```bash
cd 01-basic/03-basic-routing
caddy run
# 访问: http://localhost:8080
```

## 📚 学习路径建议

### 🎯 第一步：基础概念 (30分钟)
1. **静态文件服务** - 了解 Caddy 的基本配置
   - 启动服务并访问示例页面
   - 查看 Caddyfile 配置
   - 理解文件服务和目录浏览

2. **配置语法** - 学习 Caddyfile 语法
   - 注释的使用
   - 指令的结构
   - 参数的传递

### 🔄 第二步：反向代理 (45分钟)
1. **基础代理** - 理解反向代理概念
   - 启动后端服务
   - 配置简单代理
   - 测试代理功能

2. **负载均衡** - 多后端服务
   - 启动多个后端
   - 配置负载均衡
   - 观察请求分发

3. **健康检查** - 服务监控
   - 理解健康检查机制
   - 测试故障转移
   - 查看日志输出

### 🚦 第三步：路由系统 (60分钟)
1. **路径匹配** - 学习路由规则
   - 测试不同路径
   - 理解匹配优先级
   - 学习通配符使用

2. **重写和重定向** - URL 处理
   - 测试路径重写
   - 配置重定向
   - 理解状态码

3. **条件匹配** - 高级路由
   - 基于查询参数
   - 基于请求头
   - 基于请求方法

## 🧪 互动学习建议

### 1. 边学边练
- 每个示例都要实际运行
- 修改配置参数观察变化
- 尝试自己编写配置

### 2. 查看日志
```bash
# 查看 Caddy 日志
tail -f access.log

# 查看错误日志
caddy run --verbose
```

### 3. 测试工具
- 使用浏览器开发工具
- 使用 curl 命令测试
- 使用 Postman 测试 API

### 4. 实验建议
```bash
# 测试不同的 HTTP 方法
curl -X POST http://localhost:8080/api/users

# 测试查询参数
curl "http://localhost:8080/admin/?token=admin123"

# 测试请求头
curl -H "Authorization: Bearer token" http://localhost:8080/api/data
```

## 🔍 常见问题解决

### 问题 1: 端口被占用
```bash
# 查看端口占用
lsof -i :8080

# 杀死占用进程
kill -9 <PID>

# 或使用不同端口
localhost:8081 {
    # 配置内容
}
```

### 问题 2: 配置文件错误
```bash
# 验证配置文件
caddy validate

# 格式化配置文件
caddy fmt --overwrite
```

### 问题 3: 权限问题
```bash
# 使用非特权端口
localhost:8080  # 而不是 :80

# 或使用 sudo (不推荐用于学习)
sudo caddy run
```

## 📊 学习进度跟踪

- [ ] ✅ 安装并验证 Caddy
- [ ] 🏠 完成静态文件服务示例
- [ ] 🔄 完成反向代理示例
- [ ] 🚦 完成路由配置示例
- [ ] 📝 尝试修改配置参数
- [ ] 🧪 进行自定义测试
- [ ] 📚 阅读官方文档
- [ ] 🎯 准备学习中级内容

## 🔗 有用的链接

- [Caddy 官方文档](https://caddyserver.com/docs/)
- [Caddyfile 语法参考](https://caddyserver.com/docs/caddyfile)
- [Caddy 社区论坛](https://caddy.community/)
- [GitHub 仓库](https://github.com/caddyserver/caddy)

## 💡 学习提示

1. **从简单开始** - 不要急于学习复杂功能
2. **理解概念** - 先理解原理再看配置
3. **多动手** - 实践是最好的学习方式
4. **查看源码** - 配置文件都有详细注释
5. **对比差异** - 比较不同配置的效果
6. **解决问题** - 遇到错误是学习的好机会

开始你的 Caddy 学习之旅吧！🎉
