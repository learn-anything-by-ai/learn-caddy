# 静态文件服务

这是 Caddy 最基本的用法 - 提供静态文件服务。

## 学习目标

- 理解 Caddy 的基本配置语法
- 掌握静态文件服务的配置方法
- 了解文件浏览功能

## 示例文件结构

```
01-static-files/
├── Caddyfile          # Caddy 配置文件
├── www/               # 网站根目录
│   ├── index.html
│   ├── about.html
│   ├── css/
│   │   └── style.css
│   ├── js/
│   │   └── app.js
│   └── images/
│       └── logo.png
└── README.md
```

## Caddyfile 配置说明

最简单的配置只需要指定监听地址：

```caddyfile
# 监听 localhost:8080，提供当前目录的文件服务
localhost:8080

# 自动启用文件浏览（当没有 index.html 时）
file_server browse
```

## 运行示例

1. 进入示例目录：
   ```bash
   cd /Users/yifei/code/learn-caddy/01-basic/01-static-files
   ```

2. 启动 Caddy：
   ```bash
   caddy run
   ```

3. 打开浏览器访问：http://localhost:8080

## 高级配置

查看 `Caddyfile-advanced` 了解更多配置选项：

- 自定义根目录
- 设置默认文件
- 配置 MIME 类型
- 隐藏特定文件

## 常见问题

**Q: 如何更改监听端口？**
A: 修改 Caddyfile 中的端口号，如 `localhost:3000`

**Q: 如何禁用文件浏览？**
A: 删除 `browse` 指令，确保有 index.html 文件

**Q: 如何设置自定义根目录？**
A: 使用 `root` 指令：`root * /path/to/your/files`
