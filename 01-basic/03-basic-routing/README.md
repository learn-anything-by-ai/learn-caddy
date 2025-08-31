# 基础路由配置

学习 Caddy 的路由系统，包括路径匹配、重定向、重写等功能。

## 学习目标

- 掌握 Caddy 的路由语法
- 了解不同的匹配器类型
- 学习路径重写和重定向
- 理解路由优先级

## 路由概念

Caddy 的路由系统非常灵活，支持多种匹配条件：

- **路径匹配**：根据 URL 路径进行匹配
- **主机匹配**：根据域名进行匹配
- **方法匹配**：根据 HTTP 方法进行匹配
- **头部匹配**：根据请求头进行匹配
- **查询参数匹配**：根据查询参数进行匹配

## 示例文件结构

```
03-basic-routing/
├── Caddyfile              # 基础路由配置
├── Caddyfile-advanced     # 高级路由示例
├── static/                # 静态文件
│   ├── index.html
│   ├── blog/
│   ├── admin/
│   └── api/
├── templates/             # 模板文件
│   ├── 404.html
│   └── maintenance.html
└── README.md
```

## 运行示例

1. 启动 Caddy：
   ```bash
   caddy run
   ```

2. 测试不同的路由：
   - http://localhost:8080/ - 主页
   - http://localhost:8080/blog/ - 博客页面
   - http://localhost:8080/admin/ - 管理后台
   - http://localhost:8080/api/v1/users - API 路由
   - http://localhost:8080/old-page - 重定向测试

## 核心路由指令

### 1. handle 指令
```caddyfile
handle /api/* {
    respond "API endpoint"
}
```

### 2. route 指令
```caddyfile
route {
    rewrite /old/* /new/*
    file_server
}
```

### 3. redir 指令
```caddyfile
redir /old-page /new-page 301
```

### 4. rewrite 指令
```caddyfile
rewrite /api/v1/* /api/*
```

## 匹配器语法

- `*` - 通配符匹配
- `{path}` - 路径变量
- `{query.param}` - 查询参数
- `{header.name}` - 请求头
- `{method}` - HTTP 方法

## 最佳实践

1. **路由顺序很重要** - 更具体的路由应该放在前面
2. **使用命名匹配器** - 提高配置可读性
3. **合理使用重写** - 避免复杂的重写规则
4. **测试路由优先级** - 确保路由按预期工作
