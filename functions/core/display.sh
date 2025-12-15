#!/bin/bash

function display {
    echo -e "\e[38;2;195;144;230m\e[4mHardware Information\e[0m"
    echo -e "\e[38;2;195;144;230m  Architecture: \e[38;5;250m$ARCH\e[0m"
    echo -e "\e[38;2;195;144;230m  CPU: \e[38;5;250m$(lscpu | grep 'Model name' | awk -F: '{print $2}' | sed 's/^[ \t]*//')\e[0m"
    echo -e "\e[38;2;195;144;230m  Memory: \e[38;5;250m$(free | awk '/^Mem:/ {printf "%.2f GiB out of %.2f GiB", $3/1024/1024, $2/1024/1024}')\e[0m  \e[92m$(free | awk '/^Mem:/ {printf "(%.2f%%)", $3/$2*100}')\e[0m"
    echo -e "\e[38;2;195;144;230m  Location: \e[38;5;250m$P_SERVER_LOCATION\e[0m"
    echo -e "\e[38;2;195;144;230m  Server Port: \e[38;5;250m$SERVER_PORT\e[0m"
    echo -e "\e[1;36m \e[0m"
    echo -e "\e[1;36m \e[0m"
    if [ "$HOSTING_NAME" == "OrynCloud" ]; then
        toilet -f "smblock" "OrynCloud" -w 200 | sed "s/^/\x1b[38;5;93m/" | sed "s/$/\x1b[0m/"
    else
        toilet -f "smblock" --filter gay "$HOSTING_NAME" -w 200
    fi
    echo -e "\e[1;36m \e[0m"
    printout info "wanna suggest a new server software? create an issue here:"
    printout info "https://link.loners.software/aether/software"
    echo -e "\e[1;36m \e[0m"
    if [ -n "$DISCORD_LINK" ] || [ -n "$EMAIL" ]; then
        if [ -n "$DISCORD_LINK" ]; then
            printout info "Discord: https://discord.gg/$DISCORD_LINK"
        fi
        if [ -n "$EMAIL" ]; then
            printout info "Email: $EMAIL"
        fi
        echo -e "\e[1;36m \e[0m"
    fi
}
