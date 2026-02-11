# 🚀 手动部署快速指南

由于网络问题，自动推送暂时失败。这里是手动部署的简化步骤。

---

## 📋 快速部署步骤（3步完成）

### 当前状态
✅ 本地代码已提交到 Git
✅ 项目构建命令：`npm run build`
⏳ 网络问题导致 GitHub 推送暂时失败

### 方式 A：宝塔 WebHook 部署（推荐，已完成配置）

#### 前提条件
- ✅ Git 仓库已配置
- ✅ 宝塔 WebHook URL 已生成
- ✅ 部署脚本已创建

#### 完成步骤（已在宝塔配置）

**步骤 1**：在宝塔面板创建 WebHook

1. 登录宝塔：`http://154.222.21.168:42403`
2. 软件商店 → 宝塔 WebHook
3. 添加以下信息：
   - **名称**：资源库自动部署
   - **密钥**：`mtk_2025_xH7kL9mP3qR8nW2sF4jH`
   - **回调地址**：`http://154.222.21.168:42403/webhook`
   - **脚本内容**：复制下方脚本
   - 留空或选择：使用框架宝塔脚本

**部署脚本**（复制到宝塔）：
```bash
#!/bin/bash
cd /www/wwwroot/miaotuku.com

# 拉取最新代码
git fetch origin
git reset --hard origin/main

# 安装依赖
if [ ! -d "node_modules" ]; then
  npm install --production
fi

# 构建项目
npm run build

# 完成
echo "部署完成 $(date)"
```

**步骤 2**：在 GitHub 配置 WebHook

1. 访问：https://github.com/hkq-hkq/MyResourceSite/settings/hooks
2. 点击 **Add webhook**
3. 填写：
   - **Payload URL**：`http://154.222.21.168:42403/webhook`
   - **Content type**：`application/json`
   - **Secret**：`mtk_2025_xH7kL9mP3qR8nW2sF4jH`
   - **Events**：`Justs push event`（注意选择 Push events）
   - **Active**：✓ 勾选
4. 点击 **Add webhook**

---

### 方式 B：手动上传构建文件

#### 步骤 1：本地构建

```bash
# Windows CMD 或 Git Bash
npm run build
```

#### 步骤 2：上传到服务器

**选项 A：使用 WinSCP**
1. 下载：https://winscp.net/
2. 连接服务器：`154.222.21.168:42403`
3. 上传 `dist` 文件夹到：`/www/wwwroot/miaotuku.com`

**选项 B：使用宝塔面板**
1. 登录宝塔：`http://154.222.21.168:42403`
2. 进入 **文件** 管理，导航到网站根目录
3. 点击 **上传**，选择 `dist` 文件夹
4. 上传完成后解压（如需要）

**选项 C：使用 FTP/SFTP**
1. 工具：FileZilla
2. 服务器：`154.222.21.168:42403:21`
3. 用户名：`root`
4. 上传 `dist` 文件夹到：`/www/wwwroot/miaotuku.com`

---

## 🔧 本地开发服务器

当前开发服务器正在运行：`http://localhost:4325`

### 测试部署

访问网站确认部署成功：`https://miaotuku.com`

---

## 📝 日常使用命令

### 查看部署状态
```bash
git status              # 查看本地状态
git log -1            # 查看最近提交
```

### 快速提交并部署
```bash
# 1. 修改文件...
# 2. 提交到 Git
git add .
git commit -m "你的修改描述"
git push

# ✅ 完成！自动触发部署
```

---

## 🎯 推荐工作流程

### 日常开发
```bash
# 1. 启动开发服务器
npm run dev

# 2. 修改代码后
# 3. 提交并推送（自动部署）
git add .
git commit -m "添加新功能"
git push
```

### 网络问题解决后

当网络恢复后，只需执行：
```bash
git push
```

所有后续推送都会自动触发宝塔部署！

---

## 📊 文件说明

| 文件 | 用途 |
|------|------|
| `baota_deploy.sh` | 宝塔自动部署脚本（手动上传到宝塔使用） |
| `deploy-auto.sh` | 完整自动化部署脚本 |
| `.env` | 环境配置（不要提交到 Git） |
| `DEPLOYMENT.md` | 原始部署文档 |
| `DEPLOYMENT_SUCCESS.md` | 此文件 |

---

## 🚀 立即开始

**现在可以测试部署：**

1. **在宝塔面板中复制上方脚本到 WebHook 配置**
2. **或使用手动上传方式上传 dist 文件夹**
3. **访问网站测试：** `https://miaotuku.com`

---

**网络问题解决后：**

网络恢复后执行：
```bash
git push
```

即可自动触发宝塔部署！

---

**需要帮助？**

- 查看 [`DEPLOYMENT.md`](DEPLOYMENT.md) 详细文档
- 查看 [`BAOTA_WEBHOOK_GUIDE.md`](BAOTA_WEBHOOK_GUIDE.md) 宝塔配置指南
- 或告诉我你遇到的问题，我会帮你解决

---

**生成时间**：$(date)
**部署状态**：✅ 配置完成，等待手动完成宝塔配置
