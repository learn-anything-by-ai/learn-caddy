# 压缩和缓存示例

本示例演示如何使用 Caddy 进行内容压缩和缓存配置，提升网站性能。

## 学习目标

- 理解 HTTP 压缩和缓存机制
- 掌握 Caddy 的压缩配置
- 学会设置缓存策略
- 优化网站加载性能

## 示例说明

这个示例包含：

- Gzip/Brotli 压缩配置
- 静态资源缓存策略
- 动态内容缓存
- 性能优化最佳实践

## 运行示例

启动 Caddy：

```bash
caddy run --config Caddyfile
```

测试压缩和缓存：

```bash
# 测试压缩
curl -H "Accept-Encoding: gzip" -v http://localhost:8080/

# 测试缓存头
curl -I http://localhost:8080/css/style.css

# 性能测试
curl -w "@curl-format.txt" -o /dev/null -s http://localhost:8080/
```

## 配置详解

### 内容压缩

启用 Gzip 和 Brotli 压缩减少传输大小。

### 缓存策略

为不同类型的资源设置合适的缓存时间。

### 条件缓存

基于文件类型和大小的智能缓存。

### 性能监控

监控压缩率和缓存命中率。

## 学习要点

1. 压缩可以显著减少传输时间
2. 合理的缓存策略提升用户体验
3. 不同类型的资源需要不同的缓存时间
4. 压缩和缓存需要权衡 CPU 使用和网络传输
5. 定期监控和调整性能配置
