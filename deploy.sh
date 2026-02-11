#!/bin/bash
# ====================================
# 自动化部署脚本 - Git + 宝塔面板
# ====================================

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  资源分享平台 - 自动化部署${NC}"
echo -e "${GREEN}========================================${NC}"

# ====================================
# 1. Git 自动提交
# ====================================
git_commit() {
  echo -e "\n${YELLOW}📝 步骤 1: Git 自动提交${NC}"

  # 检查是否有更改
  if [ -z "$(git status --porcelain)" ]; then
    echo -e "${GREEN}✓ 没有需要提交的更改${NC}"
    return 0
  fi

  # 添加所有更改
  echo -e "${YELLOW}  添加所有更改到暂存区...${NC}"
  git add .

  # 获取当前时间作为提交信息
  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  COMMIT_MESSAGE="🚀 自动部署: $TIMESTAMP"

  # 提交更改
  echo -e "${YELLOW}  创建提交: ${COMMIT_MESSAGE}${NC}"
  git commit -m "$COMMIT_MESSAGE"

  # 推送到远程仓库
  echo -e "${YELLOW}  推送到远程仓库...${NC}"
  git push

  echo -e "${GREEN}✓ Git 提交完成！${NC}"
}

# ====================================
# 2. 本地构建
# ====================================
build_project() {
  echo -e "\n${YELLOW}🔨 步骤 2: 本地构建${NC}"

  # 安装依赖（如果需要）
  if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}  安装依赖...${NC}"
    npm install
  fi

  # 构建项目
  echo -e "${YELLOW}  构建项目...${NC}"
  npm run build

  echo -e "${GREEN}✓ 构建完成！${NC}"
}

# ====================================
# 3. 上传到宝塔面板
# ====================================
deploy_to_baota() {
  echo -e "\n${YELLOW}🚀 步骤 3: 部署到宝塔面板${NC}"

  # 宝塔面板配置（请根据实际情况修改）
  BT_HOST="${BT_HOST:-}"              # 宝塔面板地址
  BT_USER="${BT_USER:-}"            # 宝塔面板用户名
  BT_PASS="${BT_PASS:-}"            # 宝塔面板密码
  BT_PATH="${BT_PATH:-/www/wwwroot}"  # 宝塔网站目录
  BT_SITE="${BT_SITE:-}"            # 宝塔站点名称

  # 检查是否配置了宝塔信息
  if [ -z "$BT_HOST" ] || [ -z "$BT_PATH" ]; then
    echo -e "${RED}⚠️  未配置宝塔面板信息！${NC}"
    echo -e "${YELLOW}请先配置环境变量：${NC}"
    echo "  export BT_HOST=\"your-baota-panel.com\""
    echo "  export BT_USER=\"your-username\""
    echo "  export BT_PASS=\"your-password\""
    echo "  export BT_PATH=\"/www/wwwroot/your-site\""
    echo "  export BT_SITE=\"your-site-name\""
    echo ""
    echo -e "${YELLOW}或者创建 .env 文件：${NC}"
    cat > .env << EOF
BT_HOST=your-baota-panel.com
BT_USER=your-username
BT_PASS=your-password
BT_PATH=/www/wwwroot/your-site
BT_SITE=your-site-name
EOF
    echo -e "${RED}✗ 部署失败${NC}"
    return 1
  fi

  # 使用 FTP/SFTP 上传（需要安装 lftp）
  if command -v lftp >/dev/null 2>&1; then
    echo -e "${YELLOW}  使用 lftp 上传文件...${NC}"

    lftp -c "
      set ftp:ssl-allow no;
      set ftp:passive-mode on;
      open -u $BT_USER,$BT_PASS $BT_HOST;
      cd $BT_PATH;
      lcd dist;
      mirror -R --delete --parallel=10 --exclude .git/ --exclude node_modules/;
      bye;
    "

    echo -e "${GREEN}✓ 文件上传完成！${NC}"
  else
    echo -e "${RED}⚠️  未安装 lftp，请先安装：${NC}"
    echo "  apt-get install lftp  # Debian/Ubuntu"
    echo "  yum install lftp      # CentOS"
    return 1
  fi

  # 清理宝塔网站缓存（可选）
  echo -e "${YELLOW}  清理缓存...${NC}"
  # 这里可以添加宝塔API调用来清理缓存
  # 例如: curl "http://$BT_HOST/site_cache?action=clean"

  echo -e "${GREEN}✓ 部署完成！${NC}"
  echo -e "${GREEN}🌐 访问地址: http://$BT_SITE${NC}"
}

# ====================================
# 主流程
# ====================================
main() {
  echo -e "\n${GREEN}开始自动化部署流程...${NC}\n"

  # 执行Git提交
  git_commit

  # 执行构建
  build_project

  # 部署到宝塔
  deploy_to_baota

  echo -e "\n${GREEN}========================================${NC}"
  echo -e "${GREEN}🎉 部署完成！${NC}"
  echo -e "${GREEN}========================================${NC}\n"
}

# 执行主流程
main "$@"
