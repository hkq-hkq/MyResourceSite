@echo off
REM ====================================
REM 资源分享平台 - Windows 快速部署脚本
REM ====================================

setlocal enabledelayedexpansion

title 资源分享平台 - 自动化部署

echo.
echo ========================================
echo    资源分享平台 - 快速部署
echo ========================================
echo.
echo 请选择操作:
echo.
echo [1] 本地构建
echo [2] 提交到 Git
echo [3] 完整部署（Git + 构建）
echo [4] 打开配置文档
echo [0] 退出
echo.

set /p choice=请选择操作 (0-4):

if "%choice%"=="1" goto BUILD
if "%choice%"=="2" goto GIT_COMMIT
if "%choice%"=="3" goto FULL_DEPLOY
if "%choice%"=="4" goto DOCS
if "%choice%"=="0" goto END

:BUILD
echo.
echo [构建] 开始构建项目...
echo.
call npm run build
if %errorlevel% neq 0 (
    echo [错误] 构建失败！
    pause
    goto END
)
echo [成功] 构建完成！
pause
goto END

:GIT_COMMIT
echo.
echo [Git] 开始提交代码...
echo.

REM 检查是否有更改
for /f %%i in ('git status --porcelain ^| find /c /v ""') do set has_changes=%%i
if not defined has_changes (
    echo [提示] 没有需要提交的更改
    pause
    goto END
)

echo [步骤 1/3] 添加所有更改...
git add .

REM 生成提交信息
for /f "tokens=1-6 delims=/ " %%a in ('date /t') do set timestamp=%%a-%%b-%%c_%%d-%%e
set commit_message=🚀 自动部署: %timestamp%

echo [步骤 2/3] 创建提交: %commit_message%
git commit -m "%commit_message%"

echo [步骤 3/3] 推送到远程仓库...
git push

echo [成功] 代码已提交到 Git！
pause
goto END

:FULL_DEPLOY
echo.
echo [完整部署] 执行完整流程...
echo.

echo [步骤 1/4] 本地构建...
call npm run build
if %errorlevel% neq 0 (
    echo [错误] 构建失败，中止部署
    pause
    goto END
)

echo [步骤 2/4] 提交到 Git...
git add .
set commit_message=🚀 自动部署: %timestamp%
git commit -m "%commit_message%"
git push

echo [步骤 3/4] 上传到服务器...
echo.
echo [注意] Windows 下需要手动上传 dist 文件夹到服务器
echo.
echo 可以使用以下工具之一:
echo   - WinSCP: https://winscp.net/
echo   - FileZilla: https://filezilla-project.org/
echo   - 宝塔面板: 直接上传压缩包
echo.
echo [提示] 首次使用前请先配置服务器信息！
echo.

REM 检查是否安装了 WinSCP 或 FileZilla
where WinSCP >nul 2>nul
if %errorlevel% equ 0 (
    echo [检测] 发现 WinSCP，正在打开...
    start WinSCP
)

where filezilla >nul 2>nul
if %errorlevel% equ 0 (
    echo [检测] 发现 FileZilla，正在打开...
    start filezilla
)

echo [完成] 部署流程完成！
echo 请手动上传 dist 文件夹到服务器
echo.
pause
goto END

:DOCS
echo [文档] 打开部署文档...
start "" DEPLOYMENT.md
goto END

:END
echo.
echo ========================================
echo    操作完成
echo ========================================
pause
