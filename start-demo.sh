#!/bin/bash

# Caddy 学习示例启动脚本
# 自动启动所有演示服务

echo "🚀 Caddy 学习示例启动脚本"
echo "=============================="

# 检查 Caddy 是否已安装
if ! command -v caddy &> /dev/null; then
    echo "❌ 错误: Caddy 未安装"
    echo "请先安装 Caddy: brew install caddy"
    exit 1
fi

# 检查 Node.js 是否已安装
if ! command -v node &> /dev/null; then
    echo "⚠️  警告: Node.js 未安装，反向代理示例将无法运行"
    echo "安装 Node.js: brew install node"
fi

# 函数：启动静态文件服务示例
start_static_demo() {
    echo ""
    echo "📁 启动静态文件服务示例..."
    cd 01-basic/01-static-files
    echo "💡 在浏览器中访问: http://localhost:8080"
    echo "按 Ctrl+C 停止服务"
    caddy run
    cd ../..
}

# 函数：启动反向代理示例
start_proxy_demo() {
    echo ""
    echo "🔄 启动反向代理示例..."
    
    # 检查 Node.js
    if ! command -v node &> /dev/null; then
        echo "❌ Node.js 未安装，跳过反向代理示例"
        return 1
    fi
    
    cd 01-basic/02-reverse-proxy/backend
    
    # 安装依赖
    if [ ! -d "node_modules" ]; then
        echo "📦 安装 Node.js 依赖..."
        npm install
    fi
    
    # 启动后端服务
    echo "🚀 启动后端服务..."
    npm run server1 &
    SERVER1_PID=$!
    
    npm run server2 &
    SERVER2_PID=$!
    
    # 等待后端服务启动
    sleep 3
    
    cd ..
    
    echo "💡 在浏览器中访问: http://localhost:8080"
    echo "💡 后端服务1: http://localhost:3001"
    echo "💡 后端服务2: http://localhost:3002"
    echo "按 Ctrl+C 停止所有服务"
    
    # 清理函数
    cleanup() {
        echo ""
        echo "🧹 清理后端服务..."
        kill $SERVER1_PID 2>/dev/null
        kill $SERVER2_PID 2>/dev/null
        exit 0
    }
    
    trap cleanup SIGINT SIGTERM
    
    # 启动 Caddy
    caddy run
    
    # 如果 Caddy 退出，清理后端服务
    cleanup
}

# 函数：启动路由示例
start_routing_demo() {
    echo ""
    echo "🚦 启动路由配置示例..."
    cd 01-basic/03-basic-routing
    echo "💡 在浏览器中访问: http://localhost:8080"
    echo "💡 测试路由: http://localhost:8080/blog/"
    echo "💡 管理后台: http://localhost:8080/admin/?token=admin123"
    echo "💡 API 测试: http://localhost:8080/api/v1/users"
    echo "按 Ctrl+C 停止服务"
    caddy run
    cd ../..
}

# 函数：显示菜单
show_menu() {
    echo ""
    echo "请选择要启动的示例:"
    echo "1. 静态文件服务 (基础)"
    echo "2. 反向代理 (需要 Node.js)"
    echo "3. 路由配置"
    echo "4. 显示所有示例信息"
    echo "5. 退出"
    echo ""
    read -p "请输入选择 (1-5): " choice
}

# 函数：显示示例信息
show_demo_info() {
    echo ""
    echo "📚 Caddy 学习示例信息"
    echo "====================="
    echo ""
    echo "1. 🏠 静态文件服务"
    echo "   路径: 01-basic/01-static-files"
    echo "   功能: 基础文件服务、目录浏览、压缩"
    echo "   端口: 8080"
    echo ""
    echo "2. 🔄 反向代理"
    echo "   路径: 01-basic/02-reverse-proxy"
    echo "   功能: 代理后端、负载均衡、健康检查"
    echo "   端口: 8080 (前端), 3001/3002 (后端)"
    echo ""
    echo "3. 🚦 路由配置"
    echo "   路径: 01-basic/03-basic-routing"
    echo "   功能: 路径匹配、重写、重定向、条件路由"
    echo "   端口: 8080"
    echo ""
    echo "🎯 学习建议:"
    echo "- 按顺序学习 (1 → 2 → 3)"
    echo "- 每个示例都要实际运行"
    echo "- 查看配置文件学习语法"
    echo "- 尝试修改配置观察变化"
    echo ""
}

# 主循环
while true; do
    show_menu
    
    case $choice in
        1)
            start_static_demo
            ;;
        2)
            start_proxy_demo
            ;;
        3)
            start_routing_demo
            ;;
        4)
            show_demo_info
            ;;
        5)
            echo "👋 感谢使用 Caddy 学习示例！"
            exit 0
            ;;
        *)
            echo "❌ 无效选择，请输入 1-5"
            ;;
    esac
done
