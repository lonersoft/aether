#!/bin/bash

function prompt_eula_mc {
    local eula_file="eula.txt"
    
    echo -e "\e[1;36m \e[0m"
    echo -e "\e[38;2;195;144;230m\e[1m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo -e "\e[38;2;195;144;230m\e[1m  📜  MINECRAFT EULA AGREEMENT\e[0m"
    echo -e "\e[38;2;195;144;230m\e[1m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo -e "\e[1;36m \e[0m"
    echo -e "\e[36mBefore installing, you must accept the Minecraft EULA.\e[0m"
    echo -e "\e[38;5;250mBy continuing, you agree to comply with the terms outlined in the EULA.\e[0m"
    echo -e '\e[36m\e[1mDo you accept the Minecraft EULA? \e[33m(y/eula/n):\e[0m '
    
    read -p "$(echo -e '\e[33mYour choice:\e[0m') " accept_eula_input
    accept_eula_input=$(echo "$accept_eula_input" | tr '[:upper:]' '[:lower:]') # Convert to lowercase
    
    if [[ "$accept_eula_input" == *y* || "$accept_eula_input" == *yes* ]]; then
        echo "eula=true" >"$eula_file"
        echo -e "\e[1;36m \e[0m"
        printout success "EULA accepted! Starting installation..."
    elif [[ "$accept_eula_input" == *eula* ]]; then
        echo -e "\e[1;36m \e[0m"
        printout info "The EULA can be found at: https://www.minecraft.net/eula"
        echo -e "\e[1;36m \e[0m"
        prompt_eula_mc
    else
        echo -e "\e[1;36m \e[0m"
        printout error "You must accept the EULA to continue. Exiting..."
        exit 1
    fi
}
