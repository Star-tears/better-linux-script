<p align="center">
  <h1 align="center">Better Linux</h1>
  <p align="center">快速配置 linux基础服务(apt更新、安装面板、设置SWAP等)</p>
</p>

<p align="center">
简体中文 | <a href="./README_EN.md">English</a>
</p>

---

# better-linux-script

## 介绍

便于快速而又简单地配置新系统配置，适合刚装系统时进行一键配置。

目前功能有：

1. apt 更新
2. 安装 curl、wget、vim 等
3. 安装 zsh
4. 安装 zsh 基础实用插件(zsh-autosuggestions, zsh-syntax-highlighting, zsh-autocomplete)
5. 安装 nvm（Node Version Manager）
6. 安装 Powerlevel10k（高性能可定制主题）
7. 配置 oh-my-zsh（主题默认设置为 bira）
8. 安装开源管理面板 1panel（附带安装 docker、docker-compose）
9. 设置 SWAP

## 使用方法

> tips：推荐在 root 用户下执行

### 命令行

```shell
Usage: bash better_linux.sh [options]
Options:
    -o    optional install
    -f    force install without root
    -c    clear the generated folders
    -h    help(usage) and exit
Examples:
    bash better_linux.sh -o
```

下载`better_linux.sh`脚本，使用`bash better_linux.sh -o`来使用选项式安装，可通过 gui 来选择需要进行的配置。

### 一键脚本

```shell
curl -sSL -o better_linux.sh https://raw.githubusercontent.com/Star-tears/better-linux-script/master/better_linux.sh && bash better_linux.sh -oc
```

## 说明

本项目是因为本人经常折腾新系统镜像，每次从头配置 zsh、nvm、p10k 或 omz、swap、服务器面板等太费时间，因此写了一个脚本来自动化系统个性化过程，由于是方便自己使用，所以安装过程可能有个人偏好设置。
