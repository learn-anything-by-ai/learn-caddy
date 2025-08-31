const express = require('express');
const app = express();
const port = 3002;

// 健康检查端点
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'healthy', server: 'server2', port: port });
});

// 主页面
app.get('/', (req, res) => {
    const responseData = {
        message: `Hello from Server 2 (Port ${port})`,
        timestamp: new Date().toISOString(),
        server: 'server2',
        port: port,
        headers: req.headers
    };
    
    console.log(`[Server 2] Request received at ${responseData.timestamp}`);
    res.json(responseData);
});

// API 端点
app.get('/api/info', (req, res) => {
    res.json({
        server: 'server2',
        port: port,
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        timestamp: new Date().toISOString()
    });
});

app.listen(port, () => {
    console.log(`Server 2 running on http://localhost:${port}`);
    console.log(`Health check available at http://localhost:${port}/health`);
});
