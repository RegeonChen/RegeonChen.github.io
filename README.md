# RegeonChen's Blog

基于 [Hugo](https://gohugo.io/) + [PaperMod](https://github.com/adityatelange/hugo-PaperMod) 主题的个人博客，部署在 GitHub Pages，通过 GitHub Actions 自动构建。

在线地址：**[https://regeonchen.github.io/](https://regeonchen.github.io/)**

---

## 目录

- [快速开始](#快速开始)
- [项目结构](#项目结构)
- [发布文章](#发布文章)
- [一键发布脚本](#一键发布脚本)
- [定制修改指南](#定制修改指南)
- [部署原理](#部署原理)
- [常见问题](#常见问题)
- [未来扩展方向](#未来扩展方向)

---

## 快速开始

### 环境要求

| 工具 | 用途 | 安装方式 |
|------|------|----------|
| Hugo Extended | 本地构建预览 | `winget install Hugo.Hugo.Extended` |
| Git | 版本控制与推送 | `winget install Git.Git` |
| Node.js（可选） | Decap CMS OAuth 网关 | `winget install OpenJS.NodeJS.LTS` |

### 本地预览

```powershell
cd D:\MyBlog
hugo server -D
```

浏览器打开 `http://localhost:1313/`，编辑 Markdown 文件后页面自动热更新。`-D` 参数会包含草稿文章。

---

## 项目结构

```
D:\MyBlog\
├── hugo.toml                 # 站点主配置（标题、菜单、参数等）
├── .github/workflows/
│   └── hugo.yml              # GitHub Actions 自动部署工作流
├── content/
│   ├── posts/                # 博客文章（Markdown）
│   ├── about/index.md        # 关于页面
│   ├── archives/index.md     # 归档页面
│   └── search/index.md       # 搜索页面
├── archetypes/default.md     # 新文章默认模板（hugo new 时使用）
├── layouts/partials/
│   ├── header.html           # 覆盖主题 Header（标题 Logo 配色）
│   ├── extend_head.html      # 注入自定义 <head> 内容
│   └── mathjax.html          # LaTeX 数学公式渲染（MathJax 3）
├── assets/css/extended/
│   └── spacing.css           # 自定义样式（间距、Logo 配色、菜单图标）
├── static/admin/
│   ├── index.html            # Decap CMS 管理后台入口
│   └── config.yml            # Decap CMS 配置
├── themes/PaperMod/           # 博客主题（PaperMod）
├── publish.ps1               # 一键发布脚本
├── batch_import.ps1          # 批量导入脚本（供参考）
└── .gitignore                # Git 忽略规则
```

### 关键文件说明

| 文件 | 作用 | 何时修改 |
|------|------|----------|
| `hugo.toml` | 博客名、菜单、分类法、显示开关等全局配置 | 改站点设置时 |
| `.github/workflows/hugo.yml` | 定义自动构建部署流程 | 通常不需要改 |
| `layouts/partials/header.html` | 导航栏 HTML（Logo 拆分渲染） | 改导航栏样式时 |
| `assets/css/extended/spacing.css` | 自定义 CSS（间距、配色、图标） | 调整外观时 |
| `content/about/index.md` | "关于"页面内容 | 更新个人信息时 |

---

## 发布文章

### 方式一：新建文章

```powershell
cd D:\MyBlog
hugo new content posts/my-post.md
```

这会在 `content/posts/` 下生成带 Front Matter 模板的 Markdown 文件：

```yaml
---
title: "文章标题"
date: 2026-07-07T10:00:00+08:00
draft: true
tags: ["标签1", "标签2"]
categories: ["分类名"]
summary: "文章摘要"
math: true    # 如果要用 LaTeX 公式
---
```

写完内容后将 `draft` 改为 `false`。

### 方式二：复制已有 Markdown

将任意位置的 `.md` 文件复制到 `content/posts/` 下，并手动添加上述 Front Matter。

### 方式三：一键发布脚本

```powershell
cd D:\MyBlog
.\publish.ps1 -SourcePath "D:\Documents\我的文章.md"
```

脚本会自动：
1. 复制文件到 `content/posts/`
2. `git add` → `git commit` → `git push`
3. GitHub Actions 自动构建部署

---

## 一键发布脚本

[`publish.ps1`](publish.ps1) — 将电脑任意位置的文章一键发布上线。

```powershell
cd D:\MyBlog
.\publish.ps1 -SourcePath "源文件完整路径.md"
```

执行流程：
```
源文件 → 复制到 content/posts/ → git add → git commit → git push → Actions 构建 → 上线
```

> 注意：源文件必须包含 Hugo Front Matter（标题、日期、标签等）。如果缺少，复制后需手动补充。

---

## 定制修改指南

### 修改站点配置

编辑 [hugo.toml](file:///d:/MyBlog/hugo.toml)：

```toml
# 修改博客标题
title = "你的博客名"

# 修改首页引语
[params.homeInfoParams]
  Title = "你的标题"
  Content = "你的内容"

# 添加/修改菜单项
[[menu.main]]
  name = '新菜单'
  url = '/新页面/'
  weight = 60
```

### 修改博客外观

编辑 [assets/css/extended/spacing.css](file:///d:/MyBlog/assets/css/extended/spacing.css)：

- **调整间距**：`--gap` 和 `--content-gap` 变量控制全局间距
- **Logo 配色**：`.site-title-regeon` 和 `.site-title-chen` 控制标题颜色
- **添加新样式**：在文件末尾追加即可，无需改主题源文件

### 修改标题 Logo 渲染

编辑 [layouts/partials/header.html](file:///d:/MyBlog/layouts/partials/header.html)：

- 标题被拆分为 `<span>` 标签以支持多色渲染
- 菜单图标在 `$menuIcons` 字典中定义为内联 SVG

### 集成新功能

Hugo 主题覆盖机制：在 `layouts/` 下创建与主题同路径的文件即可覆盖：

```
themes/PaperMod/layouts/_partials/xxx.html  ← 主题默认
layouts/_partials/xxx.html                  ← 你的覆盖（优先级更高）
```

当前已覆盖：
- `layouts/partials/header.html` — 自定义导航栏

---

## 部署原理

```
本地写文章 (Markdown)
       │
       ▼
  git push origin main
       │
       ▼
GitHub Actions 自动触发 (hugo.yml)
       │
       ├── 1. 安装 Hugo
       ├── 2. Checkout 代码
       ├── 3. hugo --gc --minify 构建静态文件
       ├── 4. 上传构建产物
       └── 5. 部署到 GitHub Pages
```

### GitHub Actions 工作流

[`.github/workflows/hugo.yml`](file:///d:/MyBlog/.github/workflows/hugo.yml)：

- **触发条件**：`main` 分支有推送时自动运行
- **构建环境**：`ubuntu-latest`，Hugo v0.163.3
- **权限要求**：
  - `Settings → Actions → General → Workflow permissions` → Read and write
  - `Settings → Environments → github-pages` → Deployment branches → All branches

### 部署失败排查

1. 检查 [Actions 页面](https://github.com/RegeonChen/RegeonChen.github.io/actions) 红叉原因
2. 常见原因：
   - Front Matter 缺失或格式错误 → 文章开头必须包含 YAML 头
   - Environments 部署分支限制 → 设置为 All branches
   - 上次推送未成功到达 GitHub → 本地执行 `git push origin main` 确认

---

## 常见问题

### Q: `git push` 失败（443 端口无法连接）

中国大陆访问 GitHub HTTPS 不稳定，切换为 SSH：

```powershell
# 1. 生成 SSH 密钥
ssh-keygen -t ed25519 -C "你的邮箱"
type ~/.ssh/id_ed25519.pub

# 2. 将公钥添加到 https://github.com/settings/keys

# 3. 切换远程地址
git remote set-url origin git@github.com:RegeonChen/RegeonChen.github.io.git

# 4. 推送
git push -u origin main
```

### Q: 推送后网站没有更新

1. 去 [Actions](https://github.com/RegeonChen/RegeonChen.github.io/actions) 查看最新运行状态
2. 确认 `Environments → github-pages` 允许从 `main` 分支部署
3. 在本地执行 `git branch -vv` 确认跟踪关系为 `[origin/main]`

### Q: 新文章不显示

- 确认 `draft: false`
- 确认 `date` 不是未来时间（Hugo 默认不构建未来日期的文章）
- 确认 Front Matter 中的 `---` 分隔符格式正确

### Q: LaTeX 公式不渲染

在文章的 Front Matter 中添加 `math: true`。

### Q: 如何修改归档/标签/分类页面

这些页面由 PaperMod 主题自动生成，不需要手动维护：
- `/archives/` — 按年份自动分组
- `/tags/` — 按 Front Matter 中的 `tags` 自动分类
- `/categories/` — 按 Front Matter 中的 `categories` 自动分类

---

## 未来扩展方向

### Decap CMS 网页端管理后台（已搭建框架，待完成 OAuth）

管理后台入口：`https://regeonchen.github.io/admin/`

当前状态：代码已部署，但 OAuth 认证网关未完成，暂时无法正常使用。

完成步骤：
1. 部署 Cloudflare Worker / Vercel 作为 OAuth 代理
2. 更新 `static/admin/config.yml` 中的 `base_url`

### 双线部署（大陆 CDN 加速）

参考方案（需要已备案域名）：
1. 国内 OSS + CDN 托管静态文件
2. DNS 分线路解析：海外 → GitHub Pages，国内 → 阿里云/腾讯云 CDN
3. GitHub Actions 同时部署到两个目标

### 评论系统

可集成 Giscus（基于 GitHub Discussions，免费无广告）：
1. 仓库开启 Discussions
2. 安装 Giscus App
3. 在 `layouts/partials/comments.html` 中添加 Giscus 脚本

---

## 许可

博客内容版权所有。PaperMod 主题使用 MIT 许可。
