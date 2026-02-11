#!/bin/bash
# ====================================
# 自动化部署脚本 - 根据用户配置自动部署
# ====================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_step() { echo -e "${PURPLE}➤ $1${NC}"; }

# ====================================
# 加载环境配置
# ====================================
print_info "加载环境配置..."

if [ ! -f ".env" ]; then
  print_error "未找到 .env 配置文件！"
  echo "请先运行配置脚本或手动创建 .env 文件"
  exit 1
fi

# 加载环境变量
source .env

# ====================================
# 生成智能提交信息
# ====================================
generate_commit_message() {
  local timestamp=$(date +"%Y-%m-%d %H:%M")
  local branch=$(git branch --show-current 2>/dev/null || echo "main")

  # 获取最近修改的文件类型
  local changed_files=$(git diff --name-only HEAD~1 HEAD 2>/dev/null | head -5)
  local change_type="更新"

  if echo "$changed_files" | grep -q "\.astro"; then
    change_type="页面"
  elif echo "$changed_files" | grep -q "\.css"; then
    change_type="样式"
  elif echo "$changed_files" | grep -q "ts\|js"; then
    change_type="脚本"
  elif echo "$changed_files" | grep -q "md\|MD"; then
    change_type="文档"
  fi

  # 生成提交信息
  local emojis=("🚀" "🎨" "🐛" "✨" "📝" "🔧" "📦" "🚀")
  local random_emoji=${emojis[$RANDOM % ${#emojis[@]}]}

  echo "${random_emoji} [自动部署] ${change_type} - ${timestamp}"
}

# ====================================
# 1. 配置 Git 仓库
# ====================================
setup_git() {
  print_step "配置 Git 仓库"

  # 检查是否已是 Git 仓库
  if [ ! -d ".git" ]; then
    print_info "初始化 Git 仓库..."
    git init
    git branch -M main
  fi

  # 检查远程仓库
  if ! git remote get-url origin &>/dev/null; then
    print_info "添加远程仓库..."
    git remote add origin "$GIT_REPO"
    print_success "远程仓库已添加"
  else
    # 检查远程是否正确
    current_remote=$(git remote get-url origin)
    if [ "$current_remote" != "$GIT_REPO" ]; then
      print_warning "更新远程仓库地址..."
      git remote set-url origin "$GIT_REPO"
      print_success "远程仓库已更新"
    else
      print_success "Git 仓库配置正确"
    fi
  fi

  # 配置 .gitignore
  if [ ! -f ".gitignore" ]; then
    print_warning ".gitignore 不存在，创建中..."
    cat > .gitignore << 'EOF'
node_modules/
.env
.env.local
dist/
.build/
.DS_Store
*.log
.vscode/
.idea/
EOF
  fi
}

# ====================================
# 2. 生成 WebHook 配置文件
# ====================================
generate_webhook_config() {
  print_step "生成宝塔 WebHook 配置"

  cat > bt_webhook.json << EOF
{
  "webhook_url": "$WEBHOOK_URL",
  "webhook_secret": "$WEBHOOK_SECRET",
  "git_repo": "$GIT_REPO",
  "branch": "$GIT_BRANCH",
  "deploy_path": "$SERVER_PATH",
  "site_url": "$SITE_URL",
  "build_command": "npm run build",
  "output_dir": "$BUILD_OUTPUT",
  "auto_deploy": true,
  "created_at": "$(date -Iseconds)"
}
EOF

  print_success "WebHook 配置文件已生成: bt_webhook.json"

  # 生成宝塔面板 WebHook 配置说明
  cat > BT_WEBHOOK_SETUP.md << EOF
# 宝塔面板 WebHook 配置指南

## WebHook 信息

- **WebHook URL**: \`$WEBHOOK_URL\`
- **WebHook 密钥**: \`$WEBHOOK_SECRET\`
- **Git 仓库**: \`$GIT_REPO\`
- **部署分支**: \`$GIT_BRANCH\`

## 配置步骤

### 方式 1：在宝塔面板中手动配置

1. 登录宝塔面板: \`$BT_PANEL_URL\`
2. 进入 **软件商店** → **宝塔 WebHook**
3. 点击 **添加**
4. 填写以下信息：
   - 名称: \`资源库自动部署\`
   - 密钥: \`$WEBHOOK_SECRET\`
   - 执行脚本: 留空
   - 备注: GitHub Push 自动部署
5. 点击保存

配置完成后，推送代码到 GitHub，宝塔将自动拉取并部署！

### 方式 2：使用配置文件导入（如果宝塔支持）

将 \`bt_webhook.json\` 文件内容复制到宝塔 WebHook 配置中。

## 测试 WebHook

可以使用以下命令测试 WebHook 是否正常工作：

\`\`\`bash
curl -X POST "$WEBHOOK_URL" \\
  -H "Content-Type: application/json" \\
  -H "X-Webhook-Secret: $WEBHOOK_SECRET" \\
  -d '{"action":"deploy","branch":"main"}'
\`\`\`

## 部署流程

1. 推送代码到 GitHub 主分支
2. GitHub 自动触发 WebHook
3. 宝塔接收 WebHook 并执行以下操作：
   - 拉取最新代码
   - 执行构建命令
   - 同步文件到网站目录

---

生成时间: $(date)
EOF

  print_success "宝塔配置说明已生成: BT_WEBHOOK_SETUP.md"
}

# ====================================
# 3. 首次提交
# ====================================
initial_commit() {
  print_step "执行首次 Git 提交"

  # 检查是否有未提交的更改
  if [ -z "$(git status --porcelain)" ]; then
    print_warning "没有需要提交的更改"
    return 0
  fi

  # 添加所有文件
  print_info "添加文件到暂存区..."
  git add .
  print_success "文件已添加"
  sleep 2

  # 生成提交信息
  COMMIT_MESSAGE=$(generate_commit_message)
  print_info "提交信息: $COMMIT_MESSAGE"

  # 执行提交
  git commit -m "$COMMIT_MESSAGE"

  print_success "代码已提交到本地仓库"
}

# ====================================
# 4. 推送到远程
# ====================================
push_to_remote() {
  print_step "推送代码到远程仓库"

  # 设置上游分支
  if ! git rev-parse --verify main@{u} &>/dev/null; then
    print_info "设置上游分支..."
    git branch --set-upstream-to=origin/main main
  fi

    # 推送
  print_step "推送到 GitHub..."
  print_info "正在推送，请稍候..."
  sleep 2
  if git push -u origin main 2>&1; then
    print_success "代码已成功推送到 GitHub！"
    print_success "✅ GitHub 已触发自动部署"
    print_info "等待宝塔 WebHook 响应..."
    sleep 5
  else
    print_error "推送失败，请检查网络连接和仓库权限"
    return 1
  fi
}

# ====================================
# 5. 触发宝塔 WebHook
# ====================================
trigger_webhook() {
  print_step "触发宝塔自动部署"

  print_info "正在发送 WebHook 请求..."
  sleep 2
  print_info "等待宝塔接收请求..."

  response=$(curl -X POST "$WEBHOOK_URL" \
    -H "Content-Type: application/json" \
    -H "X-Webhook-Secret: $WEBHOOK_SECRET" \
    -d "{\"action\":\"deploy\",\"branch\":\"$GIT_BRANCH\",\"timestamp\":\"$(date -Iseconds)\"}" \
    -w "\n%{http_code}\n" \
    2>/dev/null)

  if [ "$response" = "200" ] || [ "$response" = "201" ]; then
    print_success "WebHook 请求发送成功！"
    print_success "✅ 宝塔已接收部署请求"
    print_info "等待宝塔执行部署（拉取代码、构建、同步）..."
    sleep 10
    print_success "🎉 部署应该已完成！"
    print_info "请访问网站验证: $SITE_URL"
    else
    print_warning "WebHook 响应码: $response"
    print_info "请检查宝塔面板是否已正确配置 WebHook"
    fi
}

# ====================================
# 主流程
# ====================================
main() {
  echo -e "${PURPLE}========================================${NC}"
  echo -e "${PURPLE}   资源分享平台 - 自动化部署系统${NC}"
  echo -e "${PURPLE}========================================${NC}"
  echo ""

  # 显示配置信息
  print_info "配置信息:"
  echo "  Git 仓库: ${CYAN}$GIT_REPO${NC}"
  echo "  宝塔面板: ${CYAN}$BT_PANEL_URL${NC}"
  echo "  网站路径: ${CYAN}$SERVER_PATH${NC}"
  echo "  网站地址: ${CYAN}$SITE_URL${NC}"
  echo ""

  read -p "$(echo -e ${YELLOW}按 Enter 开始部署...${NC}) "

  # 步骤 1: 配置 Git
  setup_git

  # 步骤 2: 生成 WebHook 配置
  generate_webhook_config

  # 步骤 3: 首次提交
  initial_commit

  # 步骤 4: 推送到远程
  push_to_remote

  # 步骤 5: 触发 WebHook
  trigger_webhook

  echo ""
  echo -e "${GREEN}========================================${NC}"
  echo -e "${GREEN}🎉 自动化部署配置完成！${NC}"
  echo -e "${GREEN}========================================${NC}"
  echo ""

  # 显示后续步骤
  echo -e "${CYAN}后续步骤:${NC}"
  echo ""
  echo " 1. ${YELLOW}登录宝塔面板${NC}: $BT_PANEL_URL"
  echo " 2. ${YELLOW}打开 WebHook 配置${NC}: 软件商店 → 宝塔 WebHook"
  echo " 3. ${YELLOW}添加新的 WebHook${NC}:"
  echo "     - URL: ${CYAN}$WEBHOOK_URL${NC}"
  echo "     - 密钥: ${CYAN}$WEBHOOK_SECRET${NC}"
  echo "     - 脚本: 选择\"使用框架宝塔脚本\"或\"执行Shell命令\""
  echo ""
  echo " 4. ${YELLOW}配置脚本内容${NC}:"
  echo "     ${GREEN}#!/bin/bash${NC}"
  echo "     ${GREEN}cd $SERVER_PATH${NC}"
  echo "     ${GREEN}git pull origin $GIT_BRANCH${NC}"
  echo "     ${GREEN}npm run build${NC}"
  echo "     ${GREEN}# 同步文件等操作...${NC}"
  echo ""
  echo " 5. ${YELLOW}在 GitHub 配置 WebHook${NC}:"
  echo "     仓库设置 → Webhooks → Add webhook"
  echo "     - Payload URL: ${CYAN}$WEBHOOK_URL${NC}"
  echo "     - Content type: application/json"
  echo "     - Secret: ${CYAN}$WEBHOOK_SECRET${NC}"
  echo "     - Events: Push events"
  echo ""
  echo -e "${CYAN}配置完成后，每次推送代码都会自动部署！${NC}"
  echo ""

  print_info "详细说明请查看: BT_WEBHOOK_SETUP.md"
}

# 执行主流程
main "$@"
