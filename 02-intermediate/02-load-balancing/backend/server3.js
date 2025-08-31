const express = require('express');
const app = express();
const port = 3003;

// 健康检查端点
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'healthy', server: 'server3', port: port });
});

// 主页面
app.get('/', (req, res) => {
    const responseData = {
        message: `Hello from Server 3 (Port ${port})`,
        timestamp: new Date().toISOString(),
        server: 'server3',
        port: port,
        headers: req.headers
    };
    
    console.log(`[Server 3] Request received at ${responseData.timestamp}`);
    res.json(responseData);
});

// API 端点
app.get('/api/info', (req, res) => {
    res.json({
        server: 'server3',
        port: port,
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        timestamp: new Date().toISOString()
    });
});

app.listen(port, () => {
    console.log(`Server 3 running on http://localhost:${port}`);
    console.log(`Health check available at http://localhost:${port}/health`);
});
