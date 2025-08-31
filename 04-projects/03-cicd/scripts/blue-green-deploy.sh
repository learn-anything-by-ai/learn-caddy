#!/bin/bash

# 蓝绿部署脚本
# 实现零停机部署

set -e

# 配置变量
BLUE_PORT=8080
GREEN_PORT=8081
HEALTH_CHECK_URL="http://localhost"
CADDY_CONFIG_DIR="/etc/caddy"
DOCKER_COMPOSE_FILE="docker-compose.yml"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

# 检查当前活跃环境
get_active_environment() {
    if curl -s "${HEALTH_CHECK_URL}:${BLUE_PORT}/health" > /dev/null 2>&1; then
        echo "blue"
    elif curl -s "${HEALTH_CHECK_URL}:${GREEN_PORT}/health" > /dev/null 2>&1; then
        echo "green"
    else
        echo "none"
    fi
}

# 健康检查
health_check() {
    local port=$1
    local max_attempts=30
    local attempt=1
    
    log "执行健康检查 (端口: $port)..."
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f -s "${HEALTH_CHECK_URL}:${port}/health" > /dev/null; then
            log "健康检查通过 (尝试: $attempt)"
            return 0
        fi
        
        log "健康检查失败，等待 10 秒后重试... (尝试: $attempt/$max_attempts)"
        sleep 10
        ((attempt++))
    done
    
    error "健康检查失败，已达到最大尝试次数"
    return 1
}

# 更新 Caddy 配置
update_caddy_config() {
    local active_port=$1
    
    log "更新 Caddy 配置，切换到端口 $active_port..."
    
    # 备份当前配置
    cp "$CADDY_CONFIG_DIR/Caddyfile" "$CADDY_CONFIG_DIR/Caddyfile.backup.$(date +%s)"
    
    # 更新配置文件中的端口
    sed -i "s/localhost:[0-9]*/localhost:$active_port/g" "$CADDY_CONFIG_DIR/Caddyfile"
    
    # 验证配置
    if caddy validate --config "$CADDY_CONFIG_DIR/Caddyfile"; then
        log "Caddy 配置验证通过"
        
        # 重新加载配置
        if caddy reload --config "$CADDY_CONFIG_DIR/Caddyfile"; then
            log "Caddy 配置重新加载成功"
            return 0
        else
            error "Caddy 配置重新加载失败"
            return 1
        fi
    else
        error "Caddy 配置验证失败"
        return 1
    fi
}

# 停止旧环境
stop_old_environment() {
    local environment=$1
    
    log "停止旧环境: $environment"
    
    if [ "$environment" = "blue" ]; then
        docker-compose -f "$DOCKER_COMPOSE_FILE" stop app-blue
        docker-compose -f "$DOCKER_COMPOSE_FILE" rm -f app-blue
    elif [ "$environment" = "green" ]; then
        docker-compose -f "$DOCKER_COMPOSE_FILE" stop app-green
        docker-compose -f "$DOCKER_COMPOSE_FILE" rm -f app-green
    fi
}

# 清理资源
cleanup() {
    log "清理未使用的 Docker 资源..."
    docker system prune -f
    docker volume prune -f
}

# 主部署流程
main() {
    log "开始蓝绿部署流程..."
    
    # 检查必要的工具
    for cmd in docker docker-compose caddy curl; do
        if ! command -v $cmd &> /dev/null; then
            error "$cmd 未安装"
            exit 1
        fi
    done
    
    # 检查环境变量
    if [ -z "$IMAGE_TAG" ]; then
        error "IMAGE_TAG 环境变量未设置"
        exit 1
    fi
    
    # 获取当前活跃环境
    current_env=$(get_active_environment)
    log "当前活跃环境: $current_env"
    
    # 确定新环境
    if [ "$current_env" = "blue" ] || [ "$current_env" = "none" ]; then
        new_env="green"
        new_port=$GREEN_PORT
        old_env="blue"
    else
        new_env="blue"
        new_port=$BLUE_PORT
        old_env="green"
    fi
    
    log "部署到新环境: $new_env (端口: $new_port)"
    
    # 设置环境变量
    export NEW_ENV=$new_env
    export NEW_PORT=$new_port
    
    # 启动新环境
    log "启动新环境容器..."
    if docker-compose -f "$DOCKER_COMPOSE_FILE" up -d app-$new_env; then
        log "新环境容器启动成功"
    else
        error "新环境容器启动失败"
        exit 1
    fi
    
    # 等待容器完全启动
    sleep 30
    
    # 健康检查
    if health_check $new_port; then
        log "新环境健康检查通过"
    else
        error "新环境健康检查失败，回滚中..."
        docker-compose -f "$DOCKER_COMPOSE_FILE" stop app-$new_env
        docker-compose -f "$DOCKER_COMPOSE_FILE" rm -f app-$new_env
        exit 1
    fi
    
    # 运行冒烟测试
    log "执行冒烟测试..."
    if ./scripts/smoke-test.sh $new_port; then
        log "冒烟测试通过"
    else
        error "冒烟测试失败，回滚中..."
        docker-compose -f "$DOCKER_COMPOSE_FILE" stop app-$new_env
        docker-compose -f "$DOCKER_COMPOSE_FILE" rm -f app-$new_env
        exit 1
    fi
    
    # 更新负载均衡器配置
    if update_caddy_config $new_port; then
        log "负载均衡器配置更新成功"
    else
        error "负载均衡器配置更新失败，回滚中..."
        docker-compose -f "$DOCKER_COMPOSE_FILE" stop app-$new_env
        docker-compose -f "$DOCKER_COMPOSE_FILE" rm -f app-$new_env
        exit 1
    fi
    
    # 等待流量切换
    sleep 10
    
    # 最终健康检查
    log "执行最终健康检查..."
    if health_check 80; then  # 检查负载均衡器端口
        log "最终健康检查通过"
    else
        error "最终健康检查失败"
        exit 1
    fi
    
    # 停止旧环境
    if [ "$current_env" != "none" ]; then
        log "等待 30 秒后停止旧环境..."
        sleep 30
        stop_old_environment $old_env
    fi
    
    # 清理资源
    cleanup
    
    # 记录部署信息
    echo "$(date): Deployed $IMAGE_TAG to $new_env environment" >> /var/log/deployments.log
    
    log "蓝绿部署完成！"
    log "新环境: $new_env"
    log "镜像标签: $IMAGE_TAG"
    log "活跃端口: $new_port"
}

# 错误处理
trap 'error "部署过程中发生错误，请检查日志"; exit 1' ERR

# 执行主流程
main "$@"
