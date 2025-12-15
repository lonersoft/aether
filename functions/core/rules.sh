#!/bin/bash

function rules {
    accept_rules_file="system/rulesagreed"

    if [ -f "$accept_rules_file" ]; then
        printout success "Rules already accepted. Continuing..."
        echo -e "\e[1;36m \e[0m"
        return
    fi

    # Header
    echo -e "\e[1;36m \e[0m"
    echo -e "\e[38;2;195;144;230m\e[1m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo -e "\e[38;2;195;144;230m\e[1m  👋  WELCOME TO THE SETUP WIZARD\e[0m"
    echo -e "\e[38;2;195;144;230m\e[1m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo -e "\e[1;36m \e[0m"
    echo -e "\e[38;5;250mThis wizard will help you setup your Minecraft Server.\e[0m"
    echo -e "\e[1;36m \e[0m"
    
    # Rules section
    echo -e "\e[36m\e[1m📋  SERVER RULES\e[0m"
    echo -e "\e[36mThese rules help maintain a fair, secure, and high-performance environment.\e[0m"
    echo -e "\e[1;36m \e[0m"
    echo -e "\e[38;5;250m  \e[32m① \e[38;5;250mChunk-altering plugins are strictly prohibited.\e[0m"
    echo -e "\e[38;5;250m  \e[32m② \e[38;5;250mMining or any resource-intensive activities that degrade\e[0m"
    echo -e "\e[38;5;250m     performance are not allowed.\e[0m"
    echo -e "\e[38;5;250m  \e[32m③ \e[38;5;250mUse server resources responsibly – excessive CPU, RAM, or\e[0m"
    echo -e "\e[38;5;250m     network usage is not permitted.\e[0m"
    echo -e "\e[38;5;250m  \e[32m④ \e[38;5;250mExploiting bugs, abusing services, or bypassing restrictions\e[0m"
    echo -e "\e[38;5;250m     is strictly forbidden.\e[0m"
    echo -e "\e[38;5;250m  \e[32m⑤ \e[38;5;250mAll users must comply with our Terms of Service – violations\e[0m"
    echo -e "\e[38;5;250m     may result in suspension.\e[0m"
    echo -e "\e[1;36m \e[0m"
    
    # Warning
    echo -e "\e[1;31m⚠️  IMPORTANT\e[0m"
    echo -e "\e[31mBreaking any of these rules may result in service suspension or a ban.\e[0m"
    echo -e "\e[1;36m \e[0m"
    
    # Confirmation
    echo -e "\e[36mBy continuing, you confirm that you understand and agree to follow these rules.\e[0m"
    echo -e '\e[36m\e[1mDo you agree to these rules? \e[33m(y/n):\e[0m '
    
    read -p "$(echo -e '\e[33mYour choice:\e[0m') " accept_rules
    accept_rules=$(echo "$accept_rules" | tr '[:upper:]' '[:lower:]') # Convert to lowercase
    
    if [[ "$accept_rules" == *y* || "$accept_rules" == *yes* ]]; then
        mkdir -p "system"
        cat > "$accept_rules_file" <<DUMMY
Rules accepted on $(date '+%Y-%m-%d %H:%M:%S %Z')
DUMMY
        echo -e "\e[1;36m \e[0m"
        printout success "Rules accepted! Starting installation..."
        echo -e "\e[1;36m \e[0m"
    else
        echo -e "\e[1;36m \e[0m"
        printout error "You must accept the rules to use this server! Exiting..."
        exit 1
    fi
}
