#!/bin/bash

function minecraft_menu {
    while true; do
        echo -e "\e[1;36m \e[0m"
        echo -e "\e[1;36m \e[0m"
        echo -e "\e[36m🖥️  Select your Java server:\e[0m"
        echo -e "\e[32m1\e[0m) Vanilla  \e[38;5;250m(1.18 - 1.21.10)\e[0m"
        echo -e "\e[32m2\e[0m) Paper  \e[38;5;250m(1.8.8 - 1.21.10)\e[0m"
        echo -e "\e[32m3\e[0m) Purpur \e[38;5;250m(1.14.1 - 1.21.10)\e[0m"
        echo -e "\e[32m4\e[0m) Pufferfish \e[38;5;250m(1.17.1 - 1.21.8)\e[0m"
        echo -e "\e[31m5\e[0m) Back\e[0m"

        read -p "$(echo -e '\e[33mYour choice:\e[0m') " mcsoft

        case $mcsoft in
        1)
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[36m🔧  Select the Vanilla version you want to use:\e[0m"
            echo -e "\e[32m→ 1.18, 1.18.1, 1.18.2, 1.19, 1.19.1, 1.19.2, 1.19.3, 1.19.4, 1.20, 1.20.1, 1.20.2, 1.20.4, 1.20.5, 1.20.6, 1.21, 1.21.1, 1.21.2, 1.21.3, 1.21.4, 1.21.5, 1.21.6, 1.21.7, 1.21.8, 1.21.9, 1.21.10\e[0m"
            read -p "$(echo -e '\e[33mYour choice:\e[0m') " input_version
            valid_versions="1.18 1.18.1 1.18.2 1.19 1.19.1 1.19.2 1.19.3 1.19.4 1.20 1.20.1 1.20.2 1.20.4 1.20.5 1.20.6 1.21 1.21.1 1.21.2 1.21.3 1.21.4 1.21.5 1.21.6 1.21.7 1.21.8 1.21.9 1.21.10"

            # Check if the input version is in the list of valid versions
            if [[ $valid_versions =~ (^|[[:space:]])$input_version($|[[:space:]]) ]]; then
                vanilla="$input_version"
                prompt_eula_mc
                install_vanilla
            else
               printout error "The specified version is either invalid or deprecated."
            fi
            ;;
        2)
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[36m🔧  Select the Paper version you want to use:\e[0m"
            echo -e "\e[32m→ 1.8.8, 1.9.4, 1.10.2, 1.11.2, 1.12.2, 1.13.2, 1.14.4, 1.15.2, 1.16.5, 1.17, 1.17.1, 1.18, 1.18.1, 1.18.2, 1.19, 1.19.1, 1.19.2, 1.19.3, 1.19.4, 1.20, 1.20.1, 1.20.2, 1.20.4, 1.20.5, 1.20.6, 1.21, 1.21.1, 1.21.3, 1.21.4, 1.21.5, 1.21.6, 1.21.7, 1.21.8, 1.21.9, 1.21.10\e[0m"
            read -p "$(echo -e '\e[33mYour choice:\e[0m') " input_version
            valid_versions="1.8.8 1.9.4 1.10.2 1.11.2 1.12.2 1.13.2 1.14.4 1.15.2 1.16.5 1.17 1.17.1 1.18 1.18.1 1.18.2 1.19 1.19.1 1.19.2 1.19.3 1.19.4 1.20 1.20.1 1.20.2 1.20.4 1.20.5 1.20.6 1.21 1.21.1 1.21.3 1.21.4 1.21.5 1.21.6 1.21.7 1.21.8 1.21.9 1.21.10"

            # Check if the input version is in the list of valid versions
            if [[ $valid_versions =~ (^|[[:space:]])$input_version($|[[:space:]]) ]]; then
                paper="$input_version"
                prompt_eula_mc
                install_paper
            else
               printout error "The specified version is either invalid or deprecated."
            fi
            ;;
        3)
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[36m🔧  Select the Purpur version you want to use:\e[0m"
            echo -e "\e[32m→ 1.14.1, 1.14.2, 1.14.3, 1.14.4, 1.15, 1.15.1, 1.15.2, 1.16.1, 1.16.2, 1.16.3, 1.16.4, 1.16.5, 1.17, 1.17.1, 1.18, 1.18.1, 1.18.2, 1.19, 1.19.1, 1.19.2, 1.19.3, 1.19.4, 1.20, 1.20.1, 1.20.2, 1.20.4, 1.20.6, 1.21, 1.21.1, 1.21.3, 1.21.4, 1.21.5, 1.21.6, 1.21.7, 1.21.8, 1.21.9, 1.21.10\e[0m"
            read -p "$(echo -e '\e[33mYour choice:\e[0m') " input_version
            valid_versions="1.14.1 1.14.2 1.14.3 1.14.4 1.15 1.15.1 1.15.2 1.16.1 1.16.2 1.16.3 1.16.4 1.16.5 1.17 1.17.1 1.18 1.18.1 1.18.2 1.19 1.19.1 1.19.2 1.19.3 1.19.4 1.20 1.20.1 1.20.2 1.20.4 1.20.6 1.21 1.21.1 1.21.3 1.21.4 1.21.5 1.21.6 1.21.7 1.21.8 1.21.9 1.21.10"
            if [[ $valid_versions =~ (^|[[:space:]])$input_version($|[[:space:]]) ]]; then
                purpur="$input_version"
                prompt_eula_mc
                install_purpur
            else
                printout error "The specified version is either invalid or deprecated."
            fi
            ;;
        4)
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[36m🔧  Select the Pufferfish version you want to use:\e[0m"
            echo -e "\e[32m→ 1.17.1, 1.18, 1.18.1, 1.18.2, 1.19, 1.19.1, 1.19.2, 1.19.3, 1.19.4, 1.20.1, 1.20.2, 1.20.4, 1.21, 1.21.1, 1.21.3, 1.21.7, 1.21.8\e[0m"
            read -p "$(echo -e '\e[33mYour choice:\e[0m') " input_version
            valid_versions="1.17.1 1.18 1.18.1 1.18.2 1.19 1.19.1 1.19.2 1.19.3 1.19.4 1.20.1 1.20.2 1.20.4 1.21 1.21.1 1.21.3 1.21.7 1.21.8"
            if [[ $valid_versions =~ (^|[[:space:]])$input_version($|[[:space:]]) ]]; then
                pufferfish="$input_version"
                prompt_eula_mc
                install_pufferfish
            else
                printout error "The specified version is either invalid or deprecated."
            fi
            ;;
        5)
            break
            ;;
        *)
            printout error "Invalid choice. Please try again."
            ;;
        esac
    done
}
