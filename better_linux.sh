#!/bin/bash
# set -x # 调试

################ Version Info ##################
# Create Date: 2023-04-25                      #
# Author:      Star-tears                      #
# Mail:        startears1006@gmail.com         #
# Blog:        https://blog.star-tears.cn      #
# Version:     0.1.0                           #
# Attention:   linux init script               #
################################################

OPTIONAL_FLAG=0
FORCE_FLAG=0
CLEAR_FLAG=0
INSTALL_ZSH=1
INSTALL_1PANNEL=1
SET_SWAP=0

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
    log "INSTALL_ZSH=$INSTALL_ZSH"
    log "INSTALL_1PANNEL=$INSTALL_1PANNEL"
    log "SET_SWAP=$SET_SWAP"
}

usage(){
log_success "Usage: bash better_linux.sh [options]"
log_warn "Options:"
log "    -o    optional install"
log "    -f    force install without root"
log "    -c    clear the generated folders"
log "    -h    help(usage) and exit"
log_warn "Examples:"
log "    better_linux -o"
}

getopts_handler(){
    while getopts ":ofh" opt
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
log "                 author: Star-tears version: 0.1.0 "
log "---------------------------------------------------"
}

pre_check(){
    # check current user is root
    if [[ `id -u` -ne 0 ]]; then
        if [[ $FORCE_FLAG -eq 0 ]]; then
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

apt_update()
{
    apt update
    apt upgrade
}

install(){
    apt_update
    # !todo
}

main() {
    getopts_handler "$@"
    print_logo
    pre_check
    install
}

main "$@"