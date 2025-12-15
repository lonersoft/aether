#!/bin/bash

function check_config {
    if [ -e "system/multiegg.yml" ]; then
        type=$(grep -A3 'type:' system/multiegg.yml | tail -n1 | awk '{ print $2}')

        if [ -n "$type" ]; then
            case "$type" in
            mc_proxy_bungeecord | mc_proxy_velocity | mc_proxy_waterfall)
                clear
                display
                check_aether_updates
                launchProxyServer
                exit
                ;;
            mc_bedrock_vanilla)
                clear
                display
                check_aether_updates
                launchBedrockVanillaServer
                exit
                ;;
            mc_java_vanilla)
                clear
                display
                check_aether_updates
                launchVanillaServer
                exit
                ;;
            mc_java | mc_java_paper | mc_java_purpur | mc_java_pufferfish)
                clear
                display
                check_aether_updates
                launchJavaServer
                exit
                ;;
            pmmp)
                clear
                display
                check_aether_updates
                launchPMMP
                exit
                ;;
            *)
                clear
                display
                check_aether_updates
                printout error "Invalid system configuration type specified in system/multiegg.yml."
                printout error "Please delete the system/multiegg.yml file and restart your server."
                exit 1
                ;;
            esac
        fi
        clear
        display
        check_aether_updates
        printout error "Invalid system configuration file."
        printout error "Please delete the system/multiegg.yml file and restart your server."
        exit 1
    fi
}
