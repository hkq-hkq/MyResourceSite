# 🎉 资源分享平台 - 自动化部署完成！

你的项目已经成功配置并提交到 Git！现在按照以下步骤完成宝塔面板部署配置。

---

## ✅ 已完成的工作

### 1. 环境配置 ✓
- **配置文件**: `.env` - 已创建并配置了所有必要信息
- **Git 仓库**: 已添加到 Git 并完成首次提交
- **提交信息**: 使用智能提交信息格式（带表情符号和变更类型）

### 2. 已配置的信息
```yaml
Git 仓库: https://github.com/hkq-hkq/MyResourceSite.git
宝塔面板: http://154.222.21.168:42403
网站路径: /www/wwwroot/miaotuku.com
网站地址: https://miaotuku.com
WebHook URL: http://154.222.21.168:42403/webhook
WebHook 密钥: mtk_2025_xH7kL9mP3qR8nW2sF4jH
```

### 3. 已创建的文件
| 文件 | 说明 |
|------|------|
| `.env` | 环境配置（含密钥，勿提交到 Git） |
| `deploy-auto.sh` | 完整自动化部署脚本 |
| `baota_deploy.sh` | 宝塔 WebHook 部署脚本（自动生成） |
| `setup-webhook.sh` | WebHook 配置生成器 |
| `BT_WEBHOOK_SETUP.md` | 宝塔 WebHook 配置说明 |
| `deploy.sh` | 手动部署脚本 |
| `deploy-simple.sh` | 简化部署脚本 |
| `deploy.bat` | Windows 快速部署 |

---

## 🚀 宝塔面板配置步骤

### 方式 A：使用 WebHook 自动部署（推荐）

#### 步骤 1：登录宝塔面板

访问：`http://154.222.21.168:42403`

#### 步骤 2：生成并上传部署脚本

在项目根目录执行：

```bash
bash setup-webhook.sh
```

这会生成两个文件：
- `baota_deploy.sh` - 宝塔部署脚本
- `BAOTA_WEBHOOK_GUIDE.md` - 详细配置指南

#### 步骤 3：在宝塔中配置 WebHook

1. 进入 **软件商店** → **宝塔 WebHook**
2. 点击 **添加**
3. 填写信息：
   ```
   名称: 资源库自动部署
   密钥: mtk_2025_xH7kL9mP3qR8nW2sF4jH
   执行脚本: 稍后选择 baota_deploy.sh
   ```
4. 点击**提交**

#### 步骤 4：在 GitHub 配置 WebHook

1. 进入 GitHub 仓库 → **Settings** → **Webhooks**
2. 点击 **Add webhook**
3. 填写信息：
   ```
   Payload URL: http://154.222.21.168:42403/webhook
   Content type: application/json
   Secret: mtk_2025_xH7kL9mP3qR8nW2sF4jH
   Events: Just the push event
   Active: 勾选
   ```
4. 点击 **Add webhook**

#### 步骤 5：测试

推送代码到 GitHub：

```bash
git push
```

你应该看到：
- ✅ GitHub 显示绿色对钩
- 📋 宝塔 WebHook 日志显示调用记录
- 🌐 网站自动更新

---

### 方式 B：手动上传部署

如果不想使用 WebHook，可以手动上传：

```bash
# 1. 本地构建
npm run build

# 2. 使用 WinSCP/FileZilla 上传 dist 文件夹
# 或使用宝塔面板的远程下载功能
```

---

## 📝 日常使用命令

### 推送代码（自动部署）

```bash
# 修改代码后
git add .
git commit -m "描述你的修改"
git push
```

**提交后会自动：**
1. 推送到 GitHub
2. GitHub 触发宝塔 WebHook
3. 宝塔自动拉取代码
4. 执行构建
5. 部署到网站目录

### 智能提交信息

脚本会根据修改的文件类型自动生成提交信息：

| 修改类型 | 提交前缀 |
|---------|---------|
| 页面 (.astro) | 🎨 [页面] |
| 样式 (.css) | 🎨 [样式] |
| 脚本 (.js/.ts) | 🐛 [脚本] |
| 文档 (.md) | 📝 [文档] |
| 配置文件 | 🔧 [配置] |
| 部署相关 | 🚀 [部署] |

### NPM 命令速查

| 命令 | 说明 |
|------|------|
| `npm run dev` | 启动开发服务器 |
| `npm run build` | 本地构建 |
| `npm run deploy:full` | 完整部署（Git + 构建 + 上传） |
| `bash setup-webhook.sh` | 重新生成 WebHook 配置 |

---

## 🔒 安全提示

⚠️ **重要**：
- `.env` 文件包含敏感信息（密钥、密码）
- 该文件已在 `.gitignore` 中，不会被提交到 Git
- 请勿手动将 `.env` 添加到 Git

---

## 📚 宝塔面板配置详解

### 网站目录设置

1. 进入 **网站** → 你的站点
2. 确保根目录为：`/www/wwwroot/miaotuku.com`
3. 设置运行目录为根目录或子目录

### PHP 设置（如需要）

1. **软件商店** → **PHP 设置**
2. 安装 PHP 8.0 或 8.1
3. 安装扩展：`fileinfo`, `curl`, `mbstring`

### SSL 证书（推荐）

1. **网站** → **设置** → **SSL**
2. 选择 **Let's Encrypt**
3. 填写邮箱地址
4. 点击申请
5. 开启自动续期

### 防火墙配置

确保以下端口开放：
- `22` - SSH
- `80` - HTTP
- `443` - HTTPS
- `8888` - 宝塔面板

---

## 🐛 故障排除

### 问题 1：WebHook 不触发

**检查：**
1. 宝塔 WebHook 日志是否有记录
2. GitHub Webhook 是否显示绿色对钩
3. 密钥是否一致

**解决：**
```bash
# 手动触发测试
curl -X POST "http://154.222.21.168:42403/webhook" \
  -H "Content-Type: application/json" \
  -H "X-Webhook-Secret: mtk_2025_xH7kL9mP3qR8nW2sF4jH" \
  -d '{"action":"test","message":"手动测试"}'
```

### 问题 2：推送后网站没更新

**检查：**
1. 宝塔面板 → WebHook 日志，查看是否有错误
2. 确认脚本权限：`chmod +x baota_deploy.sh`
3. 手动在宝塔执行脚本，查看输出

### 问题 3：构建失败

**检查：**
```bash
# SSH 登录服务器
cd /www/wwwroot/miaotuku.com
npm install
npm run build
# 查看错误信息
```

---

## 📞 需要帮助？

- **宝塔论坛**: https://www.bt.cn/bbs/
- **Astro 文档**: https://docs.astro.build/
- **GitHub 文档**: https://docs.github.com/

---

**部署状态**: ✅ 配置完成
**最后更新**: $(date)

祝你的资源分享平台运行顺利！🎉
