#!/bin/bash
# ====================================
# 简化版部署脚本 - 仅宝塔部署
# ====================================

set -e

# 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   快速部署到宝塔面板${NC}"
echo -e "${GREEN}========================================${NC}"

# ====================================
# 方式1: 使用 SCP 上传（推荐）
# ====================================
deploy_with_scp() {
  echo -e "${YELLOW}🚀 使用 SCP 上传...${NC}"

  # 配置信息
  SERVER="${DEPLOY_SERVER:-}"
  SERVER_USER="${DEPLOY_USER:-}"
  SERVER_PATH="${DEPLOY_PATH:-/www/wwwroot}"
  BUILD_DIR="dist"

  if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${RED}✗ 构建目录不存在，请先运行 npm run build${NC}"
    exit 1
  fi

  # 检查配置
  if [ -z "$SERVER" ] || [ -z "$SERVER_USER" ]; then
    echo -e "${RED}⚠️  未配置服务器信息！${NC}"
    echo -e "${YELLOW}请设置以下环境变量：${NC}"
    echo "  export DEPLOY_SERVER=\"your-server-ip\""
    echo "  export DEPLOY_USER=\"username\""
    echo "  export DEPLOY_PATH=\"/www/wwwroot/your-site\""
    exit 1
  fi

  # 先清理远程服务器上的旧文件（保留配置文件）
  echo -e "${YELLOW}  清理远程旧文件...${NC}"
  ssh ${SERVER_USER}@${SERVER} "cd ${SERVER_PATH} && find . -mindepth 1 ! -name '.htaccess' ! -name 'user.ini' -delete"

  # 上传新文件
  echo -e "${YELLOW}  上传文件到服务器...${NC}"
  scp -r ${BUILD_DIR}/* ${SERVER_USER}@${SERVER}:${SERVER_PATH}/

  # 设置权限
  echo -e "${YELLOW}  设置文件权限...${NC}"
  ssh ${SERVER_USER}@${SERVER} "chown -R www:www ${SERVER_PATH} && chmod -R 755 ${SERVER_PATH}"

  echo -e "${GREEN}✓ 部署完成！${NC}\n"
}

# ====================================
# 方式2: 使用 Rsync 上传（更快，支持增量）
# ====================================
deploy_with_rsync() {
  echo -e "${YELLOW}🚀 使用 Rsync 上传...${NC}"

  SERVER="${DEPLOY_SERVER:-}"
  SERVER_USER="${DEPLOY_USER:-}"
  SERVER_PATH="${DEPLOY_PATH:-/www/wwwroot}"
  BUILD_DIR="dist"

  if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${RED}✗ 构建目录不存在${NC}"
    exit 1
  fi

  # 检查配置
  if [ -z "$SERVER" ] || [ -z "$SERVER_USER" ]; then
    echo -e "${RED}⚠️  请先配置环境变量${NC}"
    exit 1
  fi

  # Rsync 上传（增量同步，只传输变化的文件）
  rsync -avz --delete \
    --exclude='.git*' \
    --exclude='node_modules' \
    ${BUILD_DIR}/ \
    ${SERVER_USER}@${SERVER}:${SERVER_PATH}/

  echo -e "${GREEN}✓ 部署完成！${NC}\n"
}

# ====================================
# 方式3: 宝塔 WebHook 部署（最简单）
# ====================================
deploy_with_webhook() {
  echo -e "${YELLOW}🚀 使用宝塔 WebHook 部署...${NC}"

  # 宝塔面板 WebHook 地址
  WEBHOOK_URL="${WEBHOOK_URL:-}"

  if [ -z "$WEBHOOK_URL" ]; then
    echo -e "${RED}⚠️  未配置 WebHook URL！${NC}"
    echo -e "${YELLOW}请在宝塔面板中创建 WebHook，然后设置：${NC}"
    echo "  export WEBHOOK_URL=\"http://your-baota-panel.com/webhook\""
    exit 1
  fi

  # 调用 WebHook
  echo -e "${YELLOW}  触发宝塔 WebHook...${NC}"
  curl -X POST "$WEBHOOK_URL" \
    -H "Content-Type: application/json" \
    -d '{"action":"deploy","branch":"main"}'

  echo -e "${GREEN}✓ WebHook 触发完成，宝塔将自动部署！${NC}\n"
}

# ====================================
# 主菜单
# ====================================
echo -e "${YELLOW}请选择部署方式：${NC}"
echo "1) SCP 上传（适合大多数情况）"
echo "2) Rsync 上传（更快，支持增量）"
echo "3) 宝塔 WebHook（最简单，需要宝塔配置）"
echo ""
read -p "请输入选项 (1-3): " choice

case $choice in
  1)
    deploy_with_scp
    ;;
  2)
    deploy_with_rsync
    ;;
  3)
    deploy_with_webhook
    ;;
  *)
    echo -e "${RED}无效选项${NC}"
    exit 1
    ;;
esac

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}🎉 部署完成！${NC}"
echo -e "${GREEN}========================================${NC}\n"
