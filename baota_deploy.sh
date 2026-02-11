#!/bin/bash
# 宝塔 WebHook 自动部署脚本
# 自动生成，请勿手动修改

set -e

echo "=========================================="
echo "  开始自动部署"
echo "=========================================="
echo ""

# 配置
REPO="$GIT_REPO"
BRANCH="$GIT_BRANCH"
DEPLOY_PATH="$SERVER_PATH"
SITE_URL="$SITE_URL"
WEBHOOK_SECRET="$WEBHOOK_SECRET"

echo "📦 仓库: $REPO"
echo "🌿 分支: $BRANCH"
echo "📂 路径: $DEPLOY_PATH"
echo "🌐 网站: $SITE_URL"
echo ""

# 进入网站目录
cd "$DEPLOY_PATH" || exit 1

# 拉取最新代码
echo "📥 拉取最新代码..."
git fetch origin
git reset --hard origin/$BRANCH

# 安装依赖（如果需要）
if [ -f "package.json" ]; then
  echo "📦 安装依赖..."
  npm install --production
fi

# 构建项目
if [ -f "package.json" ]; then
  echo "🔨 构建项目..."
  npm run build
fi

# 清理缓存（可选）
echo "🧹 清理缓存..."
# 宝塔面板会自动清理

# 记录部署日志
echo "✅ 部署完成！$(date)" >> deploy.log

echo ""
echo "=========================================="
echo "  部署完成！"
echo "=========================================="
