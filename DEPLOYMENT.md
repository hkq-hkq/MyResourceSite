# 🚀 自动化部署指南

本文档介绍如何使用自动化脚本将项目部署到宝塔面板。

---

## 📋 目录

1. [快速开始](#快速开始)
2. [部署方式](#部署方式)
3. [宝塔面板配置](#宝塔面板配置)
4. [常见问题](#常见问题)
5. [高级配置](#高级配置)

---

## 🚀 快速开始

### 方式一：使用宝塔 WebHook（推荐，最简单）

#### 步骤 1：在宝塔面板中创建 WebHook

1. 登录宝塔面板
2. 进入 **软件商店** → **宝塔 WebHook**
3. 点击 **添加**，填写以下信息：
   ```
   名称: 资源库自动部署
   密钥: 你的密码（记住这个密码）
   执行脚本: 无需填写
   备注: 自动部署钩子
   ```
4. 保存后，宝塔会生成一个 WebHook URL，类似：
   ```
   http://你的服务器IP:8888/webhook
   ```

#### 步骤 2：配置项目

编辑 **deploy-simple.sh** 文件，设置 WebHook URL：

```bash
# 在文件开头或通过环境变量设置
WEBHOOK_URL="http://你的服务器IP:8888/webhook?密钥=你的密码"
```

#### 步骤 3：执行部署

```bash
# Windows Git Bash / WSL
bash deploy-simple.sh

# 或者使用 npm 命令
npm run deploy
```

#### 步骤 4：测试

访问你的网站，确认部署成功！

---

### 方式二：使用 SCP/SFTP 上传

适用于：没有安装 rsync 或 lftp 的环境

#### 配置服务器信息

```bash
# 设置环境变量
export DEPLOY_SERVER="你的服务器IP"
export DEPLOY_USER="root"  # 或其他 SSH 用户名
export DEPLOY_PATH="/www/wwwroot/your-site.com"
```

#### 执行部署

```bash
npm run deploy
# 选择选项 1
```

---

### 方式三：使用 Rsync 上传（推荐）

rsync 是最快的同步工具，支持增量传输。

#### 安装 rsync

**Windows:**
```bash
# 使用 Git Bash 或 WSL
sudo apt-get install rsync  # WSL
# 或在 Git Bash 中通常已预装
```

**Linux/Mac:**
```bash
# 大多数发行版已预装
# Debian/Ubuntu
sudo apt-get install rsync

# CentOS
sudo yum install rsync
```

#### 配置并执行

```bash
export DEPLOY_SERVER="你的服务器IP"
export DEPLOY_USER="root"
export DEPLOY_PATH="/www/wwwroot/your-site.com"

npm run deploy
# 选择选项 2
```

---

### 方式四：完整自动化流程（Git + 构建 + 部署）

#### 步骤 1：配置 Git

首次使用需要配置 Git：

```bash
# 如果还没有 Git 仓库
git init
git add .
git commit -m "Initial commit: 资源分享平台"
git branch -M main

# 添加远程仓库
git remote add origin https://github.com/你的用户名/你的仓库名.git

# 推送到远程
git push -u origin main
```

#### 步骤 2：配置宝塔连接信息

编辑 **deploy.sh** 文件，修改以下配置：

```bash
# 在文件顶部设置
BT_HOST="你的服务器IP"
BT_USER="root"
BT_PASS="你的宝塔密码"
BT_PATH="/www/wwwroot/your-site.com"
BT_SITE="your-site.com"
```

#### 步骤 3：执行完整部署

```bash
npm run deploy:full
```

---

## 🔧 宝塔面板配置

### 1. 网站设置

在宝塔面板中添加站点：

1. 进入 **网站** → **添加站点**
2. 填写域名，如：`your-site.com`
3. 创建 FTP（如果需要）
4. 记住网站根目录：`/www/wwwroot/your-site.com`

### 2. PHP 设置

如果需要 PHP 支持：

1. 进入 **软件商店** → **PHP 设置**
2. 选择 PHP 版本（推荐 8.0 或 8.1）
3. 安装必要扩展：`fileinfo`, `curl`, `mbstring`

### 3. SSL 证书

1. 进入 **网站** → **设置** → **SSL**
2. 选择 **Let's Encrypt**（免费）
3. 填写邮箱，点击申请
4. 自动续期开启

---

## 🛠️ 高级配置

### Git 钩子自动部署

使用 Git Hook 实现代码提交后自动部署：

#### GitHub 配置

1. 进入 GitHub 仓库 → **Settings** → **Webhooks**
2. 点击 **Add webhook**
3. 填写：
   ```
   Payload URL: http://你的服务器IP:8888/webhook?密钥=你的密码
   Content type: application/json
   Secret: (可选）验证密钥
   Events: Just the push event
   ```
4. 点击 **Add webhook**

#### GitLab/Gitee 配置

类似步骤，在项目设置中找到 Webhooks 配置。

---

### 环境变量配置

创建 `.env` 文件存储敏感信息：

```bash
# 宝塔面板配置
BT_HOST=your-server-ip
BT_USER=your-username
BT_PASS=your-password
BT_PATH=/www/wwwroot/your-site.com
BT_SITE=your-site.com

# SSH 配置
DEPLOY_SERVER=your-server-ip
DEPLOY_USER=root
DEPLOY_PATH=/www/wwwroot/your-site.com

# WebHook 配置
WEBHOOK_URL=http://your-server:8888/webhook?secret=your-secret
```

然后在脚本中加载：
```bash
source .env 2>/dev/null || true
```

---

## 📝 NPM 命令说明

| 命令 | 说明 |
|------|------|
| `npm run dev` | 启动开发服务器 |
| `npm run build` | 构建生产版本 |
| `npm run preview` | 预览构建结果 |
| `npm run deploy` | 快速部署（交互式选择方式） |
| `npm run deploy:full` | 完整部署（Git + 构建 + 上传） |
| `npm run deploy:git` | 仅提交代码到 Git |
| `npm run deploy:config` | 显示配置说明 |

---

## 🔍 常见问题

### Q1: SSH 连接被拒绝

```bash
# 检查 SSH 服务是否运行
sudo systemctl status sshd

# 检查防火墙
sudo ufw allow 22  # Ubuntu/Debian
sudo firewall-cmd --add-port=22/tcp --permanent  # CentOS
```

### Q2: 权限不足

```bash
# 设置正确的文件权限
ssh root@server "chown -R www:www /www/wwwroot/your-site.com"
ssh root@server "chmod -R 755 /www/wwwroot/your-site.com"
```

### Q3: 宝塔面板访问 404

1. 检查宝塔面板端口（默认 8888）
2. 检查安全组/防火墙是否开放 8888 端口
3. 使用 IP:端口 访问，而不是域名

### Q4: 部署后网站无法访问

1. 检查构建文件是否存在：`ls dist/`
2. 检查远程文件是否上传
3. 检查 Nginx/Apache 配置
4. 查看错误日志：`/www/wwwroot/your-site.com/runtime/logs/`

---

## 📚 参考资料

- [宝塔面板官方文档](https://www.bt.cn/bbs/forum-1-1.html)
- [Astro 部署文档](https://docs.astro.build/en/guides/deploy/)
- [Git 文档](https://git-scm.com/docs)
- [Rsync 使用指南](https://rsync.samba.org/)

---

## 💡 提示

1. **首次部署**建议使用完整流程（`deploy:full`）确保一切正常
2. **日常更新**可以使用快速部署（`deploy`）
3. **生产环境**记得配置 `.env` 文件，不要将密码提交到 Git
4. **定期备份**宝塔面板提供的自动备份功能
5. **HTTPS 配置**确保网站安全性，申请免费 SSL 证书

---

**需要帮助？**

检查以下文件获取更多信息：
- `deploy.sh` - 完整部署脚本
- `deploy-simple.sh` - 快速部署脚本
- `deploy.config.json` - 配置文件示例
