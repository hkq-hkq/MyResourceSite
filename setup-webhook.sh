#!/bin/bash
# ====================================
# 宝塔 WebHook 快速配置脚本
# ====================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   宝塔 WebHook 配置生成器${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 读取 .env 配置
if [ ! -f ".env" ]; then
  echo -e "${RED}错误: 未找到 .env 配置文件！${NC}"
  exit 1
fi

source .env

# ====================================
# 生成宝塔 WebHook 脚本内容
# ====================================
cat > baota_deploy.sh << 'EOF'
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
EOF

chmod +x baota_deploy.sh
echo -e "${GREEN}✓ 脚本已生成: baota_deploy.sh${NC}"

# ====================================
# 生成配置说明
# ====================================
cat > BAOTA_WEBHOOK_GUIDE.md << EOF
# 宝塔 WebHook 快速配置指南

## 📋 配置信息

- **WebHook URL**: \`$WEBHOOK_URL\`
- **WebHook 密钥**: \`$WEBHOOK_SECRET\`
- **Git 仓库**: \`$GIT_REPO\`
- **部署分支**: \`$GIT_BRANCH\`
- **网站路径**: \`$SERVER_PATH\`

---

## 🚀 配置步骤

### 步骤 1: 登录宝塔面板

访问: \`$BT_PANEL_URL\`

### 步骤 2: 上传部署脚本

在宝塔面板中：

1. 进入文件管理
2. 导航到 \`$SERVER_PATH\`
3. 点击上传，选择 \`baota_deploy.sh\`
4. 或者直接新建文件，复制 \`baota_deploy.sh\` 内容

### 步骤 3: 创建 WebHook

1. 进入 **软件商店** → **宝塔 WebHook**
2. 点击 **添加**
3. 填写以下信息：
   - **名称**: 资源库自动部署
   - **密钥**: \`$WEBHOOK_SECRET\`
   - **执行脚本**: 选择刚才上传的 \`baota_deploy.sh\`
   - **备注**: GitHub Push 自动部署
4. 点击提交

### 步骤 4: 在 GitHub 配置 WebHook

1. 进入 GitHub 仓库设置
2. 点击 **Webhooks** → **Add webhook**
3. 填写以下信息：
   - **Payload URL**: \`$WEBHOOK_URL\`
   - **Content type**: \`application/json\`
   - **Secret**: \`$WEBHOOK_SECRET\`
   - **Events**: 选择 \`Just the push event\`
   - **Active**: 勾选
4. 点击 **Add webhook**

---

## ✅ 验证配置

配置完成后，推送代码到 GitHub：

\`\`\`bash
git push
\`\`\`

你应该看到：
1. GitHub 显示 WebHook 发送成功（绿色对钩）
2. 宝塔面板 WebHook 日志显示调用记录
3. 网站自动更新

---

## 🔧 测试命令

手动触发 WebHook 测试：

\`\`\`bash
curl -X POST "$WEBHOOK_URL" \\
  -H "Content-Type: application/json" \\
  -H "X-Webhook-Secret: $WEBHOOK_SECRET" \\
  -d '{"action":"test","message":"手动测试"}'
\`\`\`

---

生成时间: $(date)
EOF

echo -e "${GREEN}✓ 配置指南已生成: BAOTA_WEBHOOK_GUIDE.md${NC}"

# ====================================
# 生成 curl 测试命令
# ====================================
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   快速测试命令${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}测试 WebHook 是否正常工作:${NC}"
echo ""
cat << TEST_CMD
curl -X POST "$WEBHOOK_URL" \\
  -H "Content-Type: application/json" \\
  -H "X-Webhook-Secret: $WEBHOOK_SECRET" \\
  -d '{"action":"test","message":"手动测试部署"}'
TEST_CMD

echo ""
echo -e "${GREEN}复制以上命令在终端中执行来测试 WebHook${NC}"
echo ""

echo -e "${YELLOW}一键执行完整部署:${NC}"
echo ""
echo "bash deploy-auto.sh"
echo ""

# ====================================
# 完成
# ====================================
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   配置文件生成完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}下一步操作:${NC}"
echo ""
echo "1. ${YELLOW}查看配置指南${NC}:"
echo "   cat BAOTA_WEBHOOK_GUIDE.md"
echo ""
echo "2. ${YELLOW}上传 baota_deploy.sh 到宝塔${NC}:"
echo "   通过宝塔文件管理上传到 $SERVER_PATH"
echo ""
echo "3. ${YELLOW}在宝塔配置 WebHook${NC}:"
echo "   使用上方显示的 URL 和密钥"
echo ""
echo "4. ${YELLOW}在 GitHub 配置 WebHook${NC}:"
echo "   仓库设置 → Webhooks → Add webhook"
echo ""
echo -e "${CYAN}配置完成后，每次 git push 都会自动部署！${NC}"
echo ""
