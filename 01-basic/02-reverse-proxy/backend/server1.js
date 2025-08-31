// 后端服务器 1 - 用于 Caddy 反向代理演示
// 运行在端口 3001

const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3001;
const SERVER_NAME = 'Backend-Server-1';

// 中间件
app.use(cors());
app.use(express.json());

// 请求日志中间件
app.use((req, res, next) => {
    console.log(`[${SERVER_NAME}] ${new Date().toISOString()} - ${req.method} ${req.path}`);
    console.log(`[${SERVER_NAME}] Headers:`, req.headers);
    next();
});

// 健康检查端点
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        server: SERVER_NAME,
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        memory: process.memoryUsage()
    });
});

// API 路由
app.get('/api/status', (req, res) => {
    res.json({
        message: `Hello from ${SERVER_NAME}!`,
        server: SERVER_NAME,
        port: PORT,
        timestamp: new Date().toISOString(),
        clientIP: req.ip,
        userAgent: req.get('User-Agent'),
        forwardedFor: req.get('X-Forwarded-For'),
        forwardedProto: req.get('X-Forwarded-Proto')
    });
});

// 用户 API
app.get('/api/users', (req, res) => {
    res.json({
        server: SERVER_NAME,
        users: [
            { id: 1, name: '张三', email: 'zhangsan@example.com' },
            { id: 2, name: '李四', email: 'lisi@example.com' },
            { id: 3, name: '王五', email: 'wangwu@example.com' }
        ]
    });
});

// 用户详情 API
app.get('/api/users/:id', (req, res) => {
    const userId = parseInt(req.params.id);
    const users = {
        1: { id: 1, name: '张三', email: 'zhangsan@example.com', age: 25, city: '北京' },
        2: { id: 2, name: '李四', email: 'lisi@example.com', age: 30, city: '上海' },
        3: { id: 3, name: '王五', email: 'wangwu@example.com', age: 28, city: '深圳' }
    };
    
    const user = users[userId];
    if (user) {
        res.json({
            server: SERVER_NAME,
            user: user
        });
    } else {
        res.status(404).json({
            server: SERVER_NAME,
            error: '用户未找到',
            userId: userId
        });
    }
});

// 创建用户 API
app.post('/api/users', (req, res) => {
    const { name, email } = req.body;
    
    if (!name || !email) {
        return res.status(400).json({
            server: SERVER_NAME,
            error: '姓名和邮箱为必填项'
        });
    }
    
    const newUser = {
        id: Date.now(),
        name,
        email,
        createdAt: new Date().toISOString(),
        server: SERVER_NAME
    };
    
    res.status(201).json({
        server: SERVER_NAME,
        message: '用户创建成功',
        user: newUser
    });
});

// 数据统计 API
app.get('/api/stats', (req, res) => {
    res.json({
        server: SERVER_NAME,
        stats: {
            totalRequests: Math.floor(Math.random() * 1000) + 100,
            activeUsers: Math.floor(Math.random() * 50) + 10,
            responseTime: (Math.random() * 100 + 50).toFixed(2) + 'ms',
            uptime: process.uptime(),
            memory: process.memoryUsage(),
            cpu: process.cpuUsage()
        }
    });
});

// 错误处理中间件
app.use((err, req, res, next) => {
    console.error(`[${SERVER_NAME}] Error:`, err);
    res.status(500).json({
        server: SERVER_NAME,
        error: '内部服务器错误',
        message: err.message
    });
});

// 404 处理
app.use('*', (req, res) => {
    res.status(404).json({
        server: SERVER_NAME,
        error: '接口不存在',
        path: req.originalUrl,
        method: req.method
    });
});

// 启动服务器
app.listen(PORT, () => {
    console.log(`\n🚀 ${SERVER_NAME} 启动成功！`);
    console.log(`📍 地址: http://localhost:${PORT}`);
    console.log(`🏥 健康检查: http://localhost:${PORT}/health`);
    console.log(`📊 API 状态: http://localhost:${PORT}/api/status`);
    console.log(`👥 用户列表: http://localhost:${PORT}/api/users`);
    console.log(`📈 统计信息: http://localhost:${PORT}/api/stats`);
    console.log(`⏰ 启动时间: ${new Date().toISOString()}`);
    console.log('========================================\n');
});

// 优雅关闭
process.on('SIGTERM', () => {
    console.log(`\n📴 ${SERVER_NAME} 正在关闭...`);
    process.exit(0);
});

process.on('SIGINT', () => {
    console.log(`\n📴 ${SERVER_NAME} 正在关闭...`);
    process.exit(0);
});
