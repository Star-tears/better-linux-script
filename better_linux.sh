#!/bin/bash
# set -x # 调试

################ Version Info ##################
# Create Date: 2024-05-21                      #
# Author:      Star-tears                      #
# Mail:        star-tears@outlook.com          #
# Blog:        https://blog.star-tears.cn      #
# Version:     0.3.1                           #
# Attention:   linux init script               #
################################################

# ===========================================================================
# 初始化变量与环境配置
# ===========================================================================
OPTIONAL_FLAG=0
FORCE_FLAG=0
CLEAR_FLAG=0

SOURCE_CHANGE=0
APT_UPDATE=1
BASIC_INSTALL=1
INSTALL_ZSH=1
INSTALL_ZSH_BASIC_PLUGIN=1
INSTALL_NVM=0
INSTALL_P10K=0
OMZ_SET=0
INSTALL_1PANEL=0
SET_SWAP=0

# script dir and name
script_dir=$( cd "$( dirname "$0"  )" && pwd )
script_name=$(basename ${0})
WORKSPACE=$script_dir/.better_linux

# ===========================================================================
# 工具函数
# ===========================================================================
log_info(){
    echo -e "\e[94m$@\e[0m"
}

log_success(){
    echo -e "\e[92m$@\e[0m"
}

log_warn(){
    echo -e "\e[93m$@\e[0m"
}

log_error(){
    echo -e "\e[91m$@\e[0m"
}

log_purple(){
    echo -e "\e[95m$@\e[0m"
}

log(){
    log_info "$@"
}

log_all_local_env(){
    log "OPTIONAL_FLAG=$OPTIONAL_FLAG"
    log "FORCE_FLAG=$FORCE_FLAG"
    log "CLEAR_FLAG=$CLEAR_FLAG"
    log "INSTALL_ZSH=$INSTALL_ZSH"
    log "INSTALL_ZSH_BASIC_PLUGIN=$INSTALL_ZSH_BASIC_PLUGIN"
    log "INSTALL_NVM=$INSTALL_NVM"
    log "INSTALL_P10K=$INSTALL_P10K"
    log "OMZ_SET=$OMZ_SET"
    log "INSTALL_1PANEL=$INSTALL_1PANEL"
    log "SET_SWAP=$SET_SWAP"
}

append_if_not_exists() {
    local content_to_append="$1"
    local file_path="$2"

    # 使用grep命令检查内容是否已存在于文件中
    if ! grep -qF "$content_to_append" "$file_path"; then
        # 如果内容不存在，则追加到文件末尾
        echo "$content_to_append" >> "$file_path"
        log_success "内容 '$content_to_append' 已成功追加到文件 '$file_path'。"
    else
        log_info "内容 '$content_to_append' 已存在于文件 '$file_path' 中，无需追加。"
    fi
}


usage(){
log_success "Usage: bash better_linux.sh [options]"
log_warn "Options:"
log "    -o    optional install"
log "    -f    force install without root"
log "    -c    clear the generated folders"
log "    -h    help(usage) and exit"
log_warn "Examples:"
log "    bash better_linux.sh -o"
}

getopts_handler(){
    while getopts ":ofhc" opt
    do
        case $opt in
            o)
                OPTIONAL_FLAG=1
                ;;
            h)
                usage
                exit 0
                ;;
            f)
                FORCE_FLAG=1
                ;;
            c)
                CLEAR_FLAG=1
                ;;
            ?)
                log_error "error: No exist usage. Please read Usage."
                usage
                exit 1
                ;;
        esac
    done
}

print_logo(){
log "---------------------------------------------------"
log "   __       __  __            __   _               "
log "  / /  ___ / /_/ /____ ____  / /  (_)__  __ ____ __"
log " / _ \/ -_) __/ __/ -_) __/ / /__/ / _ \/ // /\ \ /"
log "/_.__/\__/\__/\__/\__/_/   /____/_/_//_/\_,_//_\_\ "
log "                 author: Star-tears version: 0.3.1 "
log "                  blog: https://blog.star-tears.cn "
log "---------------------------------------------------"
}

optional_init(){
    SOURCE_CHANGE=0
    APT_UPDATE=0
    BASIC_INSTALL=0
    INSTALL_ZSH=0
    INSTALL_ZSH_BASIC_PLUGIN=0
    INSTALL_NVM=0
    INSTALL_P10K=0
    OMZ_SET=0
    INSTALL_1PANEL=0
    SET_SWAP=0
}

optional_dialog(){   
local seleceted=$(whiptail --title "Checklist Dialog" --checklist \
"Choose preferred Linux install or set" 20 100 10 \
"source" "change source easily" OFF \
"apt" "apt update && apt upgrade" ON \
"basic" "basic install,such as curl, wget, git, vim" ON \
"zsh" "install zsh" ON \
"zsh-basic-plugin" "zsh-autosuggestions, zsh-syntax-highlighting, zsh-autocomplete" ON \
"nvm" "Node Version Manager as a zsh-plugin" OFF \
"p10k" "you can chooss p10k or oh-my-zsh" ON \
"omz" "install oh-my-zsh, oh-my-zsh theme and plugin set" OFF \
"1panel" "install 1panel which is open source panel" OFF \
"swap" "set swap memory" OFF 3>&1 1>&2 2>&3)

if [[ ! -n "$seleceted" ]]
then
    log_warn "You chose Cancel."
else
    log_success "Your select installs are:" $seleceted
    for key in $seleceted
    do
        case "${key:1:-1}" in
            source)
                SOURCE_CHANGE=1
                ;;
            apt)
                APT_UPDATE=1
                ;;
            basic)
                BASIC_INSTALL=1
                ;;
            zsh)
                INSTALL_ZSH=1
                ;;
            zsh-basic-plugin)
                INSTALL_ZSH_BASIC_PLUGIN=1
                ;;
            nvm)
                INSTALL_NVM=1
                ;;
            p10k)
                INSTALL_P10K=1
                ;;
            omz)
                OMZ_SET=1
                ;;
            1panel)
                INSTALL_1PANEL=1
                ;;
            swap)
                SET_SWAP=1
                ;;
            *)
                log_error "error: Unknown select."
                exit 1
                ;;
        esac
    done
fi
}

pre_check(){
    # check current user is root
    if [ `id -u` -ne 0 ]
    then
        if [ $FORCE_FLAG -eq 0 ]
        then
            log_error "Please run as root."
            log_warn "Or you can use 'bash better_linux.sh -f' force install without root."
            log_warn "There may be some software that cannot be installed because there is no root access."
            exit 1
        else
            log_warn "Install without root."
            log_warn "There may be some software that cannot be installed because there is no root access."
        fi
    else
        log_success "Now is root"
    fi
}

source_change(){
    log "source change start..."
    bash <(curl -sSL https://gitee.com/SuperManito/LinuxMirrors/raw/main/ChangeMirrors.sh)
    log "source change finished."
}

apt_update()
{
    log "start apt update && apt upgrade..."
    apt update
    apt upgrade
    log "apt update && upgrade finished."
}

basic_install(){
    log "basic install start..."
    curl --version >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        apt install curl
    fi
    wget --version >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        apt install wget
    fi
    git --version >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        apt install git
    fi
    vim --version >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        apt install vim
    fi
    log "basic install finished."
}

zsh_install(){
    zsh --version >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        log_success "zsh is detected as installed, skip the installation step..."
    else
        log "zsh install start..."
        apt install zsh
        chsh -s /bin/zsh
        log "zsh install finished."
    fi
}

zsh_basic_plugin_install(){
    log "zsh_basic_plugin_install start..."
    git clone --depth 1 -- https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    git clone --depth 1 -- https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.zsh/zsh-autocomplete
    append_if_not_exists "source ${ZDOTDIR:-$HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ${ZDOTDIR:-$HOME}/.zshrc
    append_if_not_exists "source ${ZDOTDIR:-$HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ${ZDOTDIR:-$HOME}/.zshrc
    append_if_not_exists "source ${ZDOTDIR:-$HOME}/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ${ZDOTDIR:-$HOME}/.zshrc
    log_success "zsh_basic_plugin_install finished."
    log_success "you can reload terminal or use \`source ~/.zshrc\` refresh zsh config."
}

nvm_install(){
    log "nvm_install start..."
    git clone --depth 1 -- https://github.com/lukechilds/zsh-nvm.git ~/.zsh/.zsh-nvm
    append_if_not_exists "source ${ZDOTDIR:-$HOME}/.zsh/.zsh-nvm/zsh-nvm.plugin.zsh" ${ZDOTDIR:-$HOME}/.zshrc
    log_success "nvm_install finished."
    log_success "you can reload terminal or use \`source ~/.zshrc\` refresh zsh config."
}

p10k_install(){
    log "p10k_install start..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    append_if_not_exists 'source ${ZDOTDIR:-$HOME}/powerlevel10k/powerlevel10k.zsh-theme' ${ZDOTDIR:-$HOME}/.zshrc
    log_success "p10k_install finished."
}

omz_set(){
    log "omz install start..."
    log_success "After omz install, please run better_linux.sh again to continue other install."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    log "omz install finished."
    log "omz settings start..."
    
    local zshrc=~/.zshrc
    sed -Ei 's/(^ZSH_THEME=)(.*)/\1"bira"/' $zshrc

    log "omz settings finished."
    log_success "you can reload terminal or use \`source ~/.zshrc\` refresh zsh config."
}

1panel_install(){
    log "1panel install start..."
    curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sudo bash quick_start.sh
    log "1panel install finished."
}

swap_set(){
    log "swap set start..."
    wget -O swap.sh "https://raw.githubusercontent.com/BlueSkyXN/ChangeSource/master/swap.sh" --no-check-certificate -T 30 -t 5 -d
    bash swap.sh
    log "swap set finished."
}

pre_handler(){
    print_logo
    pre_check
    read -p "Would you like to continue, yes or no? (y/n) " ans;
    if [[ ! -n $ans ]]
    then
        log "yes"
    else
        log ""
        case $ans in
            y|Y)
                log "yes";;
            n|N)
                log "no"
                exit;;
            *)
                log_error "unknown option"
                exit 1;;
        esac
    fi
    cd $script_dir
    mkdir .better_linux
    cd .better_linux
}

optional_handler(){
    if [ $OPTIONAL_FLAG -eq 1 ]
    then
        optional_init
        log_purple "Now is optinal install:"
        optional_dialog
        log_purple "selecet finshied."
    fi
}

install_handler(){
    if [[ $SOURCE_CHANGE -eq 1 ]]; then
        source_change
    fi
    if [ $APT_UPDATE -eq 1 ]; then
        apt_update
    fi
    if [[ $BASIC_INSTALL -eq 1 ]]; then
        basic_install
    fi
    if [ $INSTALL_ZSH -eq 1 ]; then
        zsh_install
    fi
    if [ $INSTALL_ZSH_BASIC_PLUGIN -eq 1 ]; then
        zsh_basic_plugin_install
    fi
    if [ $INSTALL_NVM -eq 1 ]; then
        nvm_install
    fi
    if [ $INSTALL_P10K -eq 1 ]; then
        p10k_install
    fi
    if [ $OMZ_SET -eq 1 ]; then
        omz_set
    fi
    if [[ $INSTALL_1PANEL -eq 1 ]]; then
        1panel_install
    fi
    if [[ $SET_SWAP -eq 1 ]]; then
        swap_set
    fi
}

end_handler(){
    if [[ $CLEAR_FLAG -eq 1 ]]; then
        rm -rf $script_dir/.better_linux
    fi
    log_success "all tasks finished."
}

main() {
    getopts_handler "$@"
    pre_handler
    optional_handler
    install_handler
    end_handler
}

main "$@"