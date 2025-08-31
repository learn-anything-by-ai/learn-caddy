# CI/CD 自动化部署项目

这个项目展示了如何使用 Caddy 进行自动化部署和持续集成。

## 项目特色

- GitHub Actions 集成
- 自动化测试
- 蓝绿部署
- 零停机部署
- 回滚机制

## 技术栈

- CI/CD：GitHub Actions / GitLab CI
- 容器化：Docker
- 编排：Docker Compose
- 服务器：Caddy
- 监控：Prometheus + Grafana

## 部署流程

1. 代码提交到 Git
2. 触发 CI/CD 流水线
3. 自动化测试
4. 构建 Docker 镜像
5. 部署到测试环境
6. 自动化验证
7. 部署到生产环境
8. 健康检查

## 文件结构

```
03-cicd/
├── .github/workflows/        # GitHub Actions 配置
├── .gitlab-ci.yml           # GitLab CI 配置
├── docker/                  # Docker 配置
├── scripts/                 # 部署脚本
├── caddy/                   # Caddy 配置
├── monitoring/              # 监控配置
└── tests/                   # 测试脚本
```

## 使用方法

1. 复制项目配置
2. 修改环境变量
3. 配置 Git 仓库
4. 设置部署密钥
5. 推送代码触发部署

## 环境管理

- development：开发环境
- testing：测试环境
- staging：预发布环境
- production：生产环境

每个环境都有独立的配置和部署流程。
