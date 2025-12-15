#!/bin/bash
# aether v1
# A multiegg for hosting companies to host Minecraft servers. it's also not shit so you should use it
# Licensed under the MIT License
# Forked from Primectyl by divyamboii, licensed under the MIT License

ARCH=$([[ "$(uname -m)" == "x86_64" ]] && printf "amd64" || printf "arm64")

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source all functions
for file in $(find "$SCRIPT_DIR/functions" -name "*.sh" -type f | sort); do
    source "$file"
done

####################################
#          Main Script             #
####################################
function main {
    check_config
    while true; do
        clear
        display
        check_aether_updates
        mkdir -p system
        if [[ "$ENABLE_RULES" == "1" ]]; then
            rules
        fi
        echo -e "\e[36m🎮  Select the server type:\e[0m"
        echo -e "\e[32m1\e[0m) Minecraft: Java Edition\e[0m"
        echo -e "\e[32m2\e[0m) Minecraft: Bedrock Edition\e[0m"
        echo -e "\e[32m3\e[0m) Minecraft Proxies\e[0m"
        echo -e "\e[31m4\e[0m) Exit"
        read -p "$(echo -e '\e[33mYour choice:\e[0m') " type

        case $type in
        1)
            minecraft_menu
            ;;
        2)
            bedrock_menu
            ;;
        3)
            proxy_menu
            ;;
        4)
            exit 0
            ;;
        stop)
            exit 0
            ;;
        *)
            printout error "Invalid choice. Please try again."
            ;;
        esac
    done
}

main
