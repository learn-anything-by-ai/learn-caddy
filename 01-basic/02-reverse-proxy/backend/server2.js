// 后端服务器 2 - 用于负载均衡演示
// 运行在端口 3002

const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3002;
const SERVER_NAME = 'Backend-Server-2';

// 中间件
app.use(cors());
app.use(express.json());

// 请求日志中间件
app.use((req, res, next) => {
    console.log(`[${SERVER_NAME}] ${new Date().toISOString()} - ${req.method} ${req.path}`);
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

// API 路由 - 与 server1 类似但有不同的数据
app.get('/api/status', (req, res) => {
    res.json({
        message: `Hello from ${SERVER_NAME}!`,
        server: SERVER_NAME,
        port: PORT,
        timestamp: new Date().toISOString(),
        clientIP: req.ip,
        userAgent: req.get('User-Agent'),
        forwardedFor: req.get('X-Forwarded-For'),
        forwardedProto: req.get('X-Forwarded-Proto'),
        loadBalanced: true
    });
});

// 用户 API - 不同的数据集
app.get('/api/users', (req, res) => {
    res.json({
        server: SERVER_NAME,
        users: [
            { id: 4, name: '赵六', email: 'zhaoliu@example.com' },
            { id: 5, name: '孙七', email: 'sunqi@example.com' },
            { id: 6, name: '周八', email: 'zhouba@example.com' }
        ]
    });
});

// 用户详情 API
app.get('/api/users/:id', (req, res) => {
    const userId = parseInt(req.params.id);
    const users = {
        4: { id: 4, name: '赵六', email: 'zhaoliu@example.com', age: 27, city: '广州' },
        5: { id: 5, name: '孙七', email: 'sunqi@example.com', age: 32, city: '杭州' },
        6: { id: 6, name: '周八', email: 'zhouba@example.com', age: 29, city: '成都' }
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

// 数据统计 API - 不同的数据
app.get('/api/stats', (req, res) => {
    res.json({
        server: SERVER_NAME,
        stats: {
            totalRequests: Math.floor(Math.random() * 1000) + 200,
            activeUsers: Math.floor(Math.random() * 50) + 15,
            responseTime: (Math.random() * 100 + 30).toFixed(2) + 'ms',
            uptime: process.uptime(),
            memory: process.memoryUsage(),
            cpu: process.cpuUsage(),
            loadBalanced: true
        }
    });
});

// 特殊的测试端点 - 模拟延迟
app.get('/api/slow', (req, res) => {
    const delay = req.query.delay || 1000;
    setTimeout(() => {
        res.json({
            server: SERVER_NAME,
            message: `响应延迟了 ${delay}ms`,
            delay: parseInt(delay),
            timestamp: new Date().toISOString()
        });
    }, parseInt(delay));
});

// 模拟错误端点
app.get('/api/error', (req, res) => {
    const errorCode = req.query.code || 500;
    res.status(parseInt(errorCode)).json({
        server: SERVER_NAME,
        error: `模拟 ${errorCode} 错误`,
        timestamp: new Date().toISOString()
    });
});

// 随机成功/失败端点 - 用于测试健康检查
app.get('/api/random', (req, res) => {
    if (Math.random() > 0.3) {  // 70% 成功率
        res.json({
            server: SERVER_NAME,
            status: 'success',
            random: Math.random(),
            timestamp: new Date().toISOString()
        });
    } else {
        res.status(500).json({
            server: SERVER_NAME,
            status: 'error',
            error: '随机错误',
            timestamp: new Date().toISOString()
        });
    }
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
    console.log(`🐌 慢响应: http://localhost:${PORT}/api/slow?delay=2000`);
    console.log(`❌ 错误测试: http://localhost:${PORT}/api/error?code=404`);
    console.log(`🎲 随机测试: http://localhost:${PORT}/api/random`);
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
