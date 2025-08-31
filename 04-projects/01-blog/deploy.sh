#!/bin/bash

# 博客部署脚本
# 自动化博客站点的构建和部署

set -e

echo "🚀 开始博客部署流程..."

# 配置变量
BLOG_DIR="/var/www/blog"
BACKUP_DIR="/var/backups/blog"
SOURCE_DIR="./src"
BUILD_DIR="./public"
CADDY_CONFIG="./Caddyfile"

# 检查依赖
check_dependencies() {
    echo "📋 检查系统依赖..."
    
    # 检查 Hugo
    if ! command -v hugo &> /dev/null; then
        echo "❌ Hugo 未安装，正在安装..."
        # macOS
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install hugo
        # Ubuntu/Debian
        elif command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install hugo
        # CentOS/RHEL
        elif command -v yum &> /dev/null; then
            sudo yum install hugo
        else
            echo "❌ 无法自动安装 Hugo，请手动安装"
            exit 1
        fi
    fi
    
    # 检查 Caddy
    if ! command -v caddy &> /dev/null; then
        echo "❌ Caddy 未安装，请先安装 Caddy"
        exit 1
    fi
    
    echo "✅ 依赖检查完成"
}

# 备份现有站点
backup_site() {
    if [ -d "$BLOG_DIR" ]; then
        echo "📦 备份现有站点..."
        sudo mkdir -p "$BACKUP_DIR"
        sudo cp -r "$BLOG_DIR" "$BACKUP_DIR/backup-$(date +%Y%m%d-%H%M%S)"
        echo "✅ 备份完成"
    fi
}

# 构建站点
build_site() {
    echo "🔨 构建静态站点..."
    
    if [ -f "config.yaml" ] || [ -f "config.yml" ] || [ -f "config.toml" ]; then
        # Hugo 站点
        echo "检测到 Hugo 站点，开始构建..."
        hugo --cleanDestinationDir
        echo "✅ Hugo 构建完成"
    elif [ -f "_config.yml" ]; then
        # Jekyll 站点
        echo "检测到 Jekyll 站点，开始构建..."
        bundle exec jekyll build
        echo "✅ Jekyll 构建完成"
    elif [ -f "package.json" ]; then
        # Node.js 静态站点生成器
        echo "检测到 Node.js 项目，开始构建..."
        npm run build
        echo "✅ Node.js 构建完成"
    else
        echo "⚠️  未检测到已知的静态站点生成器，跳过构建步骤"
    fi
}

# 部署站点
deploy_site() {
    echo "🚀 部署站点文件..."
    
    # 创建目标目录
    sudo mkdir -p "$BLOG_DIR"
    
    # 复制文件
    if [ -d "$BUILD_DIR" ]; then
        sudo cp -r "$BUILD_DIR"/* "$BLOG_DIR/"
        echo "✅ 站点文件部署完成"
    else
        echo "❌ 构建目录不存在: $BUILD_DIR"
        exit 1
    fi
    
    # 设置权限
    sudo chown -R caddy:caddy "$BLOG_DIR" 2>/dev/null || sudo chown -R www-data:www-data "$BLOG_DIR"
    sudo chmod -R 755 "$BLOG_DIR"
}

# 配置 Caddy
configure_caddy() {
    echo "⚙️  配置 Caddy..."
    
    # 验证配置文件
    if caddy validate --config "$CADDY_CONFIG"; then
        echo "✅ Caddy 配置验证通过"
    else
        echo "❌ Caddy 配置验证失败"
        exit 1
    fi
    
    # 重新加载配置
    if sudo caddy reload --config "$CADDY_CONFIG"; then
        echo "✅ Caddy 配置重新加载成功"
    else
        echo "❌ Caddy 配置重新加载失败"
        exit 1
    fi
}

# 健康检查
health_check() {
    echo "🏥 执行健康检查..."
    
    # 等待服务启动
    sleep 3
    
    # 检查本地访问
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ | grep -q "200"; then
        echo "✅ 本地访问正常"
    else
        echo "⚠️  本地访问异常，请检查配置"
    fi
    
    # 检查 HTTPS（如果配置了域名）
    if grep -q "blog.example.com" "$CADDY_CONFIG"; then
        echo "ℹ️  生产环境请确保 DNS 解析正确，然后访问 https://blog.example.com"
    fi
}

# 清理函数
cleanup() {
    echo "🧹 清理临时文件..."
    # 清理可能的临时文件
    rm -rf .hugo_build.lock 2>/dev/null || true
}

# 主流程
main() {
    echo "🎯 博客部署脚本 v1.0"
    echo "========================"
    
    # 设置清理回调
    trap cleanup EXIT
    
    check_dependencies
    backup_site
    build_site
    deploy_site
    configure_caddy
    health_check
    
    echo ""
    echo "🎉 博客部署完成！"
    echo "📝 本地预览: http://localhost:8080"
    echo "🌐 生产地址: https://blog.example.com"
    echo "📊 日志位置: /var/log/caddy/blog-access.log"
    echo "💾 备份位置: $BACKUP_DIR"
}

# 命令行参数处理
case "${1:-}" in
    "check")
        check_dependencies
        ;;
    "build")
        build_site
        ;;
    "deploy")
        deploy_site
        ;;
    "reload")
        configure_caddy
        ;;
    "health")
        health_check
        ;;
    "backup")
        backup_site
        ;;
    *)
        main
        ;;
esac
