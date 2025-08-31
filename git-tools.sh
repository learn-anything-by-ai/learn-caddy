#!/bin/bash

# Git 工具脚本集合
# 提供常用的 Git 操作命令

show_help() {
    echo "🔧 Caddy 学习项目 Git 工具"
    echo "使用方法: ./git-tools.sh <命令>"
    echo ""
    echo "可用命令:"
    echo "  status     - 显示详细的仓库状态"
    echo "  clean      - 清理临时文件和日志"
    echo "  backup     - 创建项目备份"
    echo "  validate   - 验证所有配置文件"
    echo "  stats      - 显示项目统计信息"
    echo "  help       - 显示此帮助信息"
}

show_status() {
    echo "📊 仓库状态概览"
    echo "=================="
    
    echo ""
    echo "🌿 分支信息:"
    git branch -v
    
    echo ""
    echo "📝 最近提交:"
    git log --oneline -5
    
    echo ""
    echo "📋 工作区状态:"
    git status --short
    
    echo ""
    echo "📈 贡献统计:"
    git shortlog -sn
    
    echo ""
    echo "📊 文件统计:"
    echo "总文件数: $(find . -type f -not -path "./.git/*" | wc -l)"
    echo "Caddyfile 数: $(find . -name "Caddyfile*" -not -path "./.git/*" | wc -l)"
    echo "HTML 文件数: $(find . -name "*.html" -not -path "./.git/*" | wc -l)"
    echo "JS 文件数: $(find . -name "*.js" -not -path "./.git/*" -not -path "./node_modules/*" | wc -l)"
}

clean_files() {
    echo "🧹 清理项目文件"
    echo "=================="
    
    # 清理日志文件
    echo "清理日志文件..."
    find . -name "*.log" -not -path "./.git/*" -delete
    
    # 清理 Node.js 依赖（如果存在）
    if [ -d "node_modules" ]; then
        echo "清理 Node.js 依赖..."
        rm -rf node_modules
    fi
    
    # 清理临时文件
    echo "清理临时文件..."
    find . -name "*.tmp" -delete
    find . -name "*.temp" -delete
    find . -name ".DS_Store" -delete
    
    echo "✅ 清理完成"
}

create_backup() {
    echo "💾 创建项目备份"
    echo "=================="
    
    backup_name="caddy-learning-backup-$(date +%Y%m%d-%H%M%S)"
    backup_dir="../$backup_name"
    
    echo "创建备份目录: $backup_dir"
    cp -r . "$backup_dir"
    
    # 清理备份中的 Git 目录
    rm -rf "$backup_dir/.git"
    
    # 创建压缩包
    cd ..
    tar -czf "$backup_name.tar.gz" "$backup_name"
    rm -rf "$backup_name"
    
    echo "✅ 备份创建完成: $backup_name.tar.gz"
}

validate_configs() {
    echo "🔍 验证配置文件"
    echo "=================="
    
    error_count=0
    
    # 验证 Caddyfile
    echo "验证 Caddyfile 语法..."
    for caddyfile in $(find . -name "Caddyfile*" -not -path "./.git/*"); do
        echo "  检查: $caddyfile"
        if caddy validate --config "$caddyfile" >/dev/null 2>&1; then
            echo "  ✅ 语法正确"
        else
            echo "  ❌ 语法错误"
            ((error_count++))
        fi
    done
    
    # 验证 JSON 文件
    echo ""
    echo "验证 JSON 文件..."
    for json_file in $(find . -name "*.json" -not -path "./.git/*" -not -path "./node_modules/*"); do
        echo "  检查: $json_file"
        if python3 -m json.tool "$json_file" >/dev/null 2>&1; then
            echo "  ✅ 格式正确"
        else
            echo "  ❌ 格式错误"
            ((error_count++))
        fi
    done
    
    echo ""
    if [ $error_count -eq 0 ]; then
        echo "✅ 所有配置文件验证通过"
    else
        echo "❌ 发现 $error_count 个错误"
    fi
}

show_stats() {
    echo "📊 项目统计信息"
    echo "=================="
    
    echo "📅 项目创建时间: $(git log --reverse --pretty=format:'%ad' --date=short | head -1)"
    echo "🕒 最后更新时间: $(git log -1 --pretty=format:'%ad' --date=short)"
    echo "📝 总提交数: $(git rev-list --all --count)"
    echo "👥 贡献者数: $(git shortlog -sn | wc -l)"
    
    echo ""
    echo "📁 文件分布:"
    echo "  README/文档: $(find . -name "*.md" -not -path "./.git/*" | wc -l) 个"
    echo "  Caddy 配置: $(find . -name "Caddyfile*" -not -path "./.git/*" | wc -l) 个"
    echo "  HTML 页面: $(find . -name "*.html" -not -path "./.git/*" | wc -l) 个"
    echo "  JavaScript: $(find . -name "*.js" -not -path "./.git/*" -not -path "./node_modules/*" | wc -l) 个"
    echo "  CSS 样式: $(find . -name "*.css" -not -path "./.git/*" | wc -l) 个"
    echo "  Shell 脚本: $(find . -name "*.sh" -not -path "./.git/*" | wc -l) 个"
    
    echo ""
    echo "📊 代码统计:"
    total_lines=$(find . -type f \( -name "*.md" -o -name "*.html" -o -name "*.js" -o -name "*.css" -o -name "Caddyfile*" \) -not -path "./.git/*" -not -path "./node_modules/*" -exec wc -l {} + | tail -1 | awk '{print $1}')
    echo "  总行数: $total_lines 行"
    
    echo ""
    echo "📦 示例模块:"
    echo "  基础示例: $(find ./01-basic -name "README.md" 2>/dev/null | wc -l) 个"
    echo "  中级示例: $(find ./02-intermediate -name "README.md" 2>/dev/null | wc -l) 个"
    echo "  高级示例: $(find ./03-advanced -name "README.md" 2>/dev/null | wc -l) 个"
    echo "  实战项目: $(find ./04-projects -name "README.md" 2>/dev/null | wc -l) 个"
}

# 主命令处理
case "$1" in
    "status")
        show_status
        ;;
    "clean")
        clean_files
        ;;
    "backup")
        create_backup
        ;;
    "validate")
        validate_configs
        ;;
    "stats")
        show_stats
        ;;
    "help"|"")
        show_help
        ;;
    *)
        echo "❌ 未知命令: $1"
        echo "使用 './git-tools.sh help' 查看可用命令"
        exit 1
        ;;
esac
