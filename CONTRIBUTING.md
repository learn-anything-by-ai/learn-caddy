# 贡献指南

感谢你对 Caddy 学习项目的关注！我们欢迎各种形式的贡献。

## 🤝 如何贡献

### 报告问题
如果你发现了 bug 或有改进建议：

1. 搜索现有 Issues，确认问题未被报告
2. 创建新的 Issue，详细描述问题
3. 包含重现步骤和环境信息

### 提交代码
1. **Fork 项目**
   ```bash
   git clone https://github.com/your-username/learn-caddy.git
   cd learn-caddy
   ```

2. **创建分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **开发和测试**
   - 遵循项目代码风格
   - 添加必要的注释
   - 测试你的更改

4. **提交更改**
   ```bash
   git add .
   git commit -m "feat: 添加新的示例功能"
   ```

5. **推送分支**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **创建 Pull Request**
   - 详细描述更改内容
   - 关联相关 Issues
   - 等待代码审查

## 📝 贡献类型

### 🐛 Bug 修复
- 修复配置错误
- 解决兼容性问题
- 更正文档错误

### ✨ 新功能
- 添加新的示例
- 扩展现有功能
- 优化用户体验

### 📚 文档改进
- 完善 README
- 添加使用说明
- 翻译文档

### 🎨 界面优化
- 改进示例页面
- 增强交互体验
- 优化视觉设计

## 🔧 开发环境

### 必需工具
- Git
- Caddy (>= 2.0)
- Node.js (>= 16.0)
- 文本编辑器

### 推荐工具
- VS Code
- Docker
- Postman

## 📋 代码规范

### Caddyfile 规范
```caddyfile
# 使用注释说明配置目的
localhost:8080 {
    # 按功能分组配置
    root * /var/www
    
    # 使用一致的缩进（4个空格）
    handle /api/* {
        reverse_proxy localhost:3001
    }
    
    # 添加必要的错误处理
    handle_errors {
        respond "Error occurred" 500
    }
}
```

### JavaScript 规范
```javascript
// 使用 ES6+ 语法
const apiUrl = '/api/users';

// 添加错误处理
try {
    const response = await fetch(apiUrl);
    const data = await response.json();
    console.log(data);
} catch (error) {
    console.error('API 请求失败:', error);
}
```

### 文档规范
- 使用中文编写
- 添加表情符号增强可读性
- 提供完整的代码示例
- 包含预期输出

## 🧪 测试要求

### 功能测试
- 确保所有示例能正常运行
- 验证配置文件语法正确
- 测试不同环境的兼容性

### 文档测试
- 检查链接有效性
- 验证代码示例准确性
- 确保说明清晰易懂

## 📊 提交信息规范

使用语义化提交信息：

```
<类型>(<范围>): <描述>

[可选的正文]

[可选的脚注]
```

### 类型
- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式化
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建工具相关

### 示例
```
feat(proxy): 添加负载均衡示例

- 新增多后端服务器配置
- 添加健康检查机制
- 包含故障转移测试

closes #123
```

## 🎯 优先级

### 高优先级
- 修复严重 bug
- 安全漏洞修复
- 核心功能改进

### 中优先级
- 新示例添加
- 性能优化
- 用户体验改进

### 低优先级
- 代码清理
- 注释完善
- 小功能添加

## 📞 联系方式

如有疑问，可以通过以下方式联系：

- 提交 Issue
- 发起 Discussion
- 邮件联系

感谢你的贡献！🎉
