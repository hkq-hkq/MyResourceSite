# 宝塔 WebHook 快速配置指南

## 📋 配置信息

- **WebHook URL**: `http://154.222.21.168:42403/webhook`
- **WebHook 密钥**: `mtk_2025_xH7kL9mP3qR8nW2sF4jH`
- **Git 仓库**: `https://github.com/hkq-hkq/MyResourceSite.git`
- **部署分支**: `main`
- **网站路径**: `/www/wwwroot/miaotuku.com`

---

## 🚀 配置步骤

### 步骤 1: 登录宝塔面板

访问: `http://154.222.21.168:42403`

### 步骤 2: 上传部署脚本

在宝塔面板中：

1. 进入文件管理
2. 导航到 `/www/wwwroot/miaotuku.com`
3. 点击上传，选择 `baota_deploy.sh`
4. 或者直接新建文件，复制 `baota_deploy.sh` 内容

### 步骤 3: 创建 WebHook

1. 进入 **软件商店** → **宝塔 WebHook**
2. 点击 **添加**
3. 填写以下信息：
   - **名称**: 资源库自动部署
   - **密钥**: `mtk_2025_xH7kL9mP3qR8nW2sF4jH`
   - **执行脚本**: 选择刚才上传的 `baota_deploy.sh`
   - **备注**: GitHub Push 自动部署
4. 点击提交

### 步骤 4: 在 GitHub 配置 WebHook

1. 进入 GitHub 仓库设置
2. 点击 **Webhooks** → **Add webhook**
3. 填写以下信息：
   - **Payload URL**: `http://154.222.21.168:42403/webhook`
   - **Content type**: `application/json`
   - **Secret**: `mtk_2025_xH7kL9mP3qR8nW2sF4jH`
   - **Events**: 选择 `Just the push event`
   - **Active**: 勾选
4. 点击 **Add webhook**

---

## ✅ 验证配置

配置完成后，推送代码到 GitHub：

```bash
git push
```

你应该看到：
1. GitHub 显示 WebHook 发送成功（绿色对钩）
2. 宝塔面板 WebHook 日志显示调用记录
3. 网站自动更新

---

## 🔧 测试命令

手动触发 WebHook 测试：

```bash
curl -X POST "http://154.222.21.168:42403/webhook" \
  -H "Content-Type: application/json" \
  -H "X-Webhook-Secret: mtk_2025_xH7kL9mP3qR8nW2sF4jH" \
  -d '{"action":"test","message":"手动测试"}'
```

---

生成时间: 2026年02月11日, 周三 21:06:27
