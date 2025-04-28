@REM @echo off
@REM setlocal enabledelayedexpansion

@REM rem 设置本地博客项目地址
@REM set "repo_path=E:\Gdyl_learning\GDYL-Blog\source"
@REM cd /d %repo_path%

@REM rem 检查是否为有效的 Git 仓库
@REM git rev-parse --is-inside-work-tree >nul 2>&1
@REM if %errorlevel% neq 0 (
@REM     echo 当前目录不是有效的 Git 仓库
@REM     exit /b 1
@REM )

@REM rem 定义变量 UPSTREAM
@REM set "UPSTREAM=%1"
@REM if "%UPSTREAM%"=="" (
@REM     set "UPSTREAM=@{u}"
@REM )

@REM rem 获取当前分支的最新提交哈希值
@REM for /f "delims=" %%a in ('git rev-parse @') do set "LOCAL=%%a"

@REM rem 获取当前分支对应的远程分支的最新提交哈希值
@REM for /f "delims=" %%a in ('git rev-parse %UPSTREAM%') do set "REMOTE=%%a"

@REM rem 获取本地分支和远程分支的共同祖先提交的哈希值
@REM for /f "delims=" %%a in ('git merge-base @ %UPSTREAM%') do set "BASE=%%a"

@REM if "%LOCAL%"=="%REMOTE%" (
@REM     echo Up-to-date
@REM ) else if "%LOCAL%"=="%BASE%" (
@REM     echo Need to pull
@REM     git pull
@REM ) else if "%REMOTE%"=="%BASE%" (
@REM     echo Need to push
@REM     git push
@REM )

@REM rem 判断本地仓库是否变化
@REM git status -s | findstr /C:"_posts" >nul
@REM if %errorlevel% equ 0 (
@REM     echo blog changes
@REM     git add -A
@REM     git commit -m "jenkins update"
@REM     git push
@REM     exit /b 0
@REM ) else (
@REM     echo no blog changes
@REM     exit /b 1
@REM )

@echo off
setlocal enabledelayedexpansion

rem ====================== 配置项（需手动修改） ======================
set "REPO_PATH=E:\Gdyl_learning\GDYL-Blog\source"   REM 本地仓库路径
set "GITHUB_USER=guduyili"                          REM GitHub 用户名
set "GITHUB_PAT=guduyili_PAT"         REM 个人访问令牌（PAT）

rem ====================== 基础环境检查 ======================
rem 切换到仓库目录
cd /d "%REPO_PATH%" || (
    echo 错误：仓库路径 "%REPO_PATH%" 不存在！
    exit /b 1
)

rem 检查是否为 Git 仓库
git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误：当前目录不是有效的 Git 仓库！
    exit /b 1
)

rem ====================== 临时禁用 SSL 验证（测试用，非生产环境） ======================
rem 警告：此操作会降低安全性，生产环境请通过信任证书解决
git config --global http.sslVerify false

rem ====================== 配置 Git 用户信息（可选） ======================
git config user.name "%GITHUB_USER%"
git config user.email "LZY3376163189@163.com"

rem ====================== 定义远程仓库 URL（HTTPS + PAT 认证） ======================
set "REMOTE_URL=https://%GITHUB_USER%:%GITHUB_PAT%@github.com/%GITHUB_USER%/GDYL-Blog.git"

rem ====================== 拉取最新代码（避免冲突） ======================
echo 正在拉取远程更新...
git pull "%REMOTE_URL%" main --rebase || (
    echo 错误：拉取失败！
    exit /b 1
)

rem ====================== 检测 _posts 目录变化 ======================
echo 检测 _posts 目录变化...
set "HAS_CHANGES="
for /f "delims=" %%a in ('git status -s --porcelain ^| findstr /C:"^[AMD]  source/_posts/"') do set "HAS_CHANGES=1"

if defined HAS_CHANGES (
    echo 检测到变化：开始提交和推送
    git add -A
    git commit -m "Jenkins自动更新：%date:~0,10% %time:~0,8%" || (
        echo 警告：提交失败（可能无变化）
        exit /b 0
    )
    
    rem ====================== 推送代码到 GitHub ======================
    echo 正在推送代码...
    git push "%REMOTE_URL%" main || (
        echo 错误：推送失败！
        exit /b 1
    )
    echo 操作：推送成功！
    exit /b 0
) else (
    echo 状态：无变化，跳过推送
    exit /b 0
)