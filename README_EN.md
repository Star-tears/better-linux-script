<p align="center">
  <h1 align="center">Better Linux</h1>
  <p align="center">Quick and easy setup of linux base services(such as apt update、install panel、set swap)</p>
</p>

<p align="center">
<a href="./README.md">简体中文</a> | English
</p>

---

# better-linux-script

## Introduction

Facilitate quick and easy configuration of new system setups, suitable for one-click configuration when installing a fresh system.

Current features include:

1. apt update
2. Install curl, wget, vim, etc.
3. Install zsh
4. Install basic useful plugins for zsh (zsh-autosuggestions, zsh-syntax-highlighting, zsh-autocomplete)
5. Install nvm (Node Version Manager)
6. Install Powerlevel10k (Highly customizable theme)
7. Configure oh-my-zsh (theme default set to bira)
8. Install open-source management panel 1panel (includes installation of docker, docker-compose)
9. Set up SWAP

## Usage

> Tips: It is recommended to execute under the root user.

### Command Line

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

Download the `better_linux.sh` script and use `bash better_linux.sh` to install, which can be selected through a GUI.

### One-Click Script

```shell
curl -sSL -o better_linux.sh https://raw.githubusercontent.com/Star-tears/better-linux-script/master/better_linux.sh && bash better_linux.sh -c
```

## Description

This project was created because I often tinker with new system images, and it takes too much time to configure zsh, nvm, p10k or omz, swap, server panels, etc., from scratch every time. Therefore, I wrote a script to automate the process of personalizing the system. Since it's for my own convenience, the installation process may have personal preference settings.
