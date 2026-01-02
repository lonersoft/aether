#!/bin/bash

function bedrock_menu {
    while true; do
        echo -e "\e[1;36m \e[0m"
        echo -e "\e[1;36m \e[0m"
        echo -e "\e[36m🖥️  Select your Bedrock server:\e[0m"
        echo -e "\e[32m1\e[0m) Vanilla Bedrock\e[0m"
        echo -e "\e[32m2\e[0m) PocketMineMP\e[0m"
        echo -e "\e[31m3\e[0m) Back\e[0m"

        read -p "$(echo -e '\e[33mYour choice:\e[0m') " bdsoft

        case $bdsoft in
        1)
            if [ -z "${BEDROCK_VERSION}" ]; then
                while true; do
                    echo -e "\e[1;36m \e[0m"
                    echo -e "\e[1;36m \e[0m"
                    echo -e "\e[36m🔧  Enter the Bedrock Server version you want to use (e.g., latest or version number):\e[0m"
                    read -p "$(echo -e '\e[33mYour choice:\e[0m') " BEDROCK_VERSION

                    if [[ "${BEDROCK_VERSION}" == "latest" ]] || [[ "${BEDROCK_VERSION}" =~ ^[0-9]+\.[0-9.]+$ ]]; then
                        break
                    else
                        printout error "Invalid version format. Defaulting to 'latest'."
                        BEDROCK_VERSION="latest"
                        break
                    fi
                done
            fi
            prompt_eula_mc
            install_bedrock
            ;;
        2)
            prompt_eula_mc
            install_pmmp
            ;;
        3)
            break
            ;;
        *)
            printout error "Invalid choice. Please try again."
            ;;
        esac
    done
}
