// Caddy 静态文件服务示例 JavaScript

document.addEventListener('DOMContentLoaded', function() {
    console.log('Caddy 静态文件服务已加载！');
    
    // 获取演示按钮和结果区域
    const demoBtn = document.getElementById('demo-btn');
    const demoResult = document.getElementById('demo-result');
    
    if (demoBtn && demoResult) {
        // 点击计数器
        let clickCount = 0;
        
        demoBtn.addEventListener('click', function() {
            clickCount++;
            
            // 显示结果
            demoResult.style.display = 'block';
            demoResult.innerHTML = `
                <h4>🎉 JavaScript 正常工作！</h4>
                <p>你已经点击了 <strong>${clickCount}</strong> 次按钮</p>
                <p>当前时间：${new Date().toLocaleString('zh-CN')}</p>
                <p>Caddy 成功提供了这个 JavaScript 文件！</p>
            `;
            
            // 添加动画效果
            demoResult.style.opacity = '0';
            demoResult.style.transform = 'translateY(-10px)';
            
            setTimeout(() => {
                demoResult.style.transition = 'all 0.3s ease';
                demoResult.style.opacity = '1';
                demoResult.style.transform = 'translateY(0)';
            }, 10);
        });
    }
    
    // 添加页面加载时间显示
    const loadTime = performance.now();
    console.log(`页面加载时间: ${loadTime.toFixed(2)} 毫秒`);
    
    // 检查 Caddy 服务器响应头（如果可用）
    if (window.location.hostname === 'localhost') {
        console.log('正在通过 Caddy 本地服务器访问');
    }
    
    // 简单的页面交互增强
    addPageInteractions();
});

function addPageInteractions() {
    // 为所有链接添加平滑过渡效果
    const links = document.querySelectorAll('a');
    links.forEach(link => {
        link.addEventListener('mouseenter', function() {
            this.style.transition = 'all 0.2s ease';
        });
    });
    
    // 为特性列表添加延迟显示动画
    const featureItems = document.querySelectorAll('.features li, .advantage');
    featureItems.forEach((item, index) => {
        item.style.opacity = '0';
        item.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            item.style.transition = 'all 0.5s ease';
            item.style.opacity = '1';
            item.style.transform = 'translateY(0)';
        }, index * 100);
    });
    
    // 检测浏览器支持的功能
    checkBrowserFeatures();
}

function checkBrowserFeatures() {
    const features = {
        'Fetch API': 'fetch' in window,
        'Local Storage': 'localStorage' in window,
        'Service Worker': 'serviceWorker' in navigator,
        'WebSocket': 'WebSocket' in window,
        'Geolocation': 'geolocation' in navigator
    };
    
    console.log('浏览器功能支持：', features);
}

// 导出一些实用函数（演示模块化）
window.CaddyDemo = {
    log: function(message) {
        console.log(`[Caddy Demo] ${message}`);
    },
    
    getServerInfo: function() {
        return {
            url: window.location.href,
            protocol: window.location.protocol,
            hostname: window.location.hostname,
            port: window.location.port,
            pathname: window.location.pathname
        };
    },
    
    formatFileSize: function(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    }
};

// 初始化时显示服务器信息
console.log('服务器信息：', window.CaddyDemo.getServerInfo());
