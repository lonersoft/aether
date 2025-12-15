#!/bin/bash

function proxy_menu {
    while true; do
        echo -e "\e[1;36m \e[0m"
        echo -e "\e[1;36m \e[0m"
        echo -e "\e[36m🖥️  Select your Proxy server:\e[0m"
        echo -e "\e[32m1\e[0m) Bungeecord\e[0m"
        echo -e "\e[32m2\e[0m) Velocity\e[0m"
        echo -e "\e[32m3\e[0m) Waterfall\e[0m"
        echo -e "\e[31m4\e[0m) Back\e[0m"

        read -p "$(echo -e '\e[33mYour choice:\e[0m') " proxy

        case $proxy in
        1)
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[1;36m \e[0m"
            printout warning "BungeeCord versions below 1.16 are not shown here due to them being old."
            echo -e "\e[36m🔧  Select the Bungeecord version you want to use:\e[0m"
            echo -e "\e[32m→ 1.16, 1.17, 1.18, 1.19, 1.20, 1.21\e[0m"
            read -p "$(echo -e '\e[33mYour choice:\e[0m') " input_version
            valid_versions="1.16 1.17 1.18 1.19 1.20 1.21"

            # Check if the input version is in the list of valid versions
            if [[ $valid_versions =~ (^|[[:space:]])$input_version($|[[:space:]]) ]]; then
                bungeecord="$input_version"
                prompt_eula_mc
                install_bungeecord
            else
               printout error "The specified version is either invalid or deprecated."
            fi
            ;;
        2)
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[36m🔧  Select the Velocity version you want to use:\e[0m"
            echo -e "\e[32m→ 3.1.0, 3.1.1-SNAPSHOT, 3.1.1, 3.1.2-SNAPSHOT, 1.0.10, 1.1.9, 3.2.0-SNAPSHOT, 3.3.0-SNAPSHOT, 3.4.0-SNAPSHOT\e[0m"
            read -p "$(echo -e '\e[33mYour choice:\e[0m') " input_version
            valid_versions="3.1.0 3.1.1-SNAPSHOT 3.1.1 3.1.2-SNAPSHOT 1.0.10 1.1.9 3.2.0-SNAPSHOT 3.3.0-SNAPSHOT 3.4.0-SNAPSHOT"

            # Check if the input version is in the list of valid versions
            if [[ $valid_versions =~ (^|[[:space:]])$input_version($|[[:space:]]) ]]; then
                velocity="$input_version"
                prompt_eula_mc
                install_velocity
            else
               printout error "The specified version is either invalid or deprecated."
            fi
            ;;
        3)
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[1;36m \e[0m"
            printout warning "Keep in mind, Waterfall is deprecated and may not work as expected. Take backups!"
            echo -e "\e[36m🔧  Select the Waterfall version you want to use:\e[0m"
            echo -e "\e[32m→ 1.11, 1.12, 1.13, 1.14, 1.15, 1.16, 1.17, 1.18, 1.19, 1.20, 1.21\e[0m"
            read -p "$(echo -e '\e[33mYour choice:\e[0m') " input_version
            valid_versions="1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21"

            # Check if the input version is in the list of valid versions
            if [[ $valid_versions =~ (^|[[:space:]])$input_version($|[[:space:]]) ]]; then
                waterfall="$input_version"
                prompt_eula_mc
                install_waterfall
            else
               printout error "The specified version is either invalid or deprecated."
            fi
            ;;
        4)
            break
            ;;
        *)
            printout error "Invalid choice. Please try again."
            ;;
        esac
    done
}
