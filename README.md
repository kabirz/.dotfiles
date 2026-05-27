# dotfiles

个人开发环境配置文件管理仓库，支持模块化安装和跨平台使用。

## 目录结构

```
.dotfiles/
├── bin/                    # 工具脚本
│   ├── dot_install         # 主安装脚本 (Python)
│   └── setup-transparent-proxy  # 透明代理配置 (redsocks + iptables)
├── nvim_user/              # Neovim 配置 (git submodule)
├── template/               # Neovim 模板项目配置
├── zsh/                    # Zsh 配置 (zim 集成)
├── alacritty/              # 终端配置
├── zellij/                 # 终端复用器配置
│   └── layouts/            #   布局文件 (code/raw/default/test)
├── gitui/                  # Git TUI 配置
├── joshuto/                # 文件管理器配置
├── neofetch/               # 系统信息展示配置
├── docs/                   # 相关文档
├── starship.toml           # Prompt 主题
├── .gitconfig              # Git 配置
├── .tmux.conf              # Tmux 配置
├── ruff.toml               # Python Linter 配置
├── .cargo_config.toml      # Cargo 配置
├── .condarc                # Conda 配置
└── zshrc                   # Zsh 主配置
```

## 依赖

### 必需
- git
- zsh
- neovim
- python3

### 可选
- zimfw (Zsh 框架)
- tmux
- alacritty
- starship
- zellij
- gitui
- joshuto

### 增强工具 (推荐)
- eza - 现代化 ls 替代
- bat - 带语法高亮的 cat
- zoxide - 智能目录跳转
- fzf - 模糊搜索
- delta - Git diff 美化
- uv - 快速 Python 包管理
- lazygit - Git TUI
- lazydocker / podman - 容器管理
- rg (ripgrep) - 快速内容搜索
- socat - 网络工具 (串口/远程 shell)

## 安装

### 获取源码

```shell
cd ~
git clone --recursive https://github.com/kabirz/.dotfiles
cd .dotfiles
```

### 使用安装脚本

```shell
# 查看帮助
./bin/dot_install -h

# 安装单个组件
./bin/dot_install nvim
./bin/dot_install gitconfig
./bin/dot_install starship

# 安装全部
./bin/dot_install all
```

### 支持的组件

| 组件 | 说明 |
|------|------|
| nvim | Neovim 配置 |
| gitconfig | Git 配置 |
| cargo | Cargo 配置 |
| ruff | Ruff Linter 配置 |
| gitui | GitUI 配置 |
| starship | Starship Prompt |
| joshuto | Joshuto 文件管理器 |
| alacritty | Alacritty 终端 |
| neofetch | Neofetch 配置 |
| zellij | Zellij 终端复用器 (含 zjstatus 插件自动下载) |
| tmux | Tmux 配置 (含 tpm 插件管理器自动安装) |
| zim | Zim Zsh 框架 |
| clangd | Clangd LSP 配置 (自动生成) |
| all | 安装全部组件 |

## 功能特性

### Shell (zshrc)
- 全局别名: `H` (head), `T` (tail), `G` (grep), `L` (less)
- 目录跳转: `...` `....` 等多层缩写
- 编辑器: 自动检测 nvim > vim > vi，设置 `vi`/`vim` 别名
- 代理管理: UV 镜像 (`setuv` / `unsetuv`)
- IP 查询: `ipa` (外部 IP) / `ipas` (全部 IP)
- Tabby SFTP: `precmd` 集成当前目录上报
- Rust 镜像: rsproxy.cn 国内加速

### Zellij 快捷命令
- `zz` - 创建/附加 code 布局会话
- `za` - 附加会话
- `zaw` - 附加 raw 布局会话
- `zl` / `zd` - 列出 / 删除会话

### Tmux 快捷命令
- `ta` / `tad` - 附加会话
- `ts` - 新建会话
- `tl` / `tksv` / `tkss` - 列出 / 杀服务 / 杀会话

### Neovim
- Git submodule 管理 (astronvim_v6 分支)
- LSP 支持
- 模块化配置结构

### Git
- Delta 并排 diff 美化，带行号和导航
- 常用别名: `st`, `br`, `ci`, `co`, `lg`, `view` (tig)
- GitHub CLI 凭证集成
- diff3 冲突风格

### 透明代理
- `setup-transparent-proxy` — 一键配置 Linux 透明代理 (redsocks + iptables)
- 支持 Ubuntu/Debian、CentOS/RHEL、Fedora、Arch Linux
- 自动安装 redsocks、解析代理 IP、配置 iptables NAT 规则
- 生成 `proxy-off.sh` 一键关闭代理
- 用法: `sudo setup-transparent-proxy <代理主机> <代理端口> [本地端口]`

### 网络与串口工具
- `sshell` / `cshell` - socat TCP 远程 shell
- `sushell` - 串口终端 (USB-UART)
- `pushell` - Python 串口工具

### Claude Code 包装
- `claude` / `cc` — 默认通过本地代理 `localhost:3000` 连接
- `cc-deepseek` - DeepSeek API 模式
- `cc-glm-5.1` - 智谱 GLM-5.1 API 模式 (指定模型)
- `cc-glm` - 智谱 GLM API 模式 (默认模型)

## License

MIT
