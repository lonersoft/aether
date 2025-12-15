#!/bin/bash

function launchProxyServer {
    printout info "Checking if Java is up to date..."
    install_java
    if [[ -n "$HOSTING_NAME" && -n "$DISCORD_LINK" && "$ENABLE_FORCED_MOTD" == "1" ]]; then
        printout warning "Forced MOTD does not work with proxy servers."
    fi
    printout info "Remember! You can change the server software you are using by deleting the \"system\" file in the File Manager and restarting the server."
    printout info "Starting Minecraft Proxy Server, this may take a while..."
    java -Xms128M -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 $STARTUP_ARGUMENT -jar server.jar
}
