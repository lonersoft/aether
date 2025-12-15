#!/bin/bash

function launchBedrockVanillaServer {
    printout info "Remember! You can change the server software you are using by deleting the \"system\" file in the File Manager and restarting the server."
    printout info "Starting Minecraft Bedrock Server, this may take a while..."
    if [[ -n "$HOSTING_NAME" && -n "$DISCORD_LINK" && "$ENABLE_FORCED_MOTD" == "1" ]]; then
        forced_motd_bedrock
    fi
    LD_LIBRARY_PATH=. ./bedrock_server
}

function launchPMMP {
    printout info "Remember! You can change the server software you are using by deleting the \"system\" file in the File Manager and restarting the server."
    printout info "Starting PocketMine MP Server, this may take a while..."
    ./start.sh
}