#!/bin/bash

function install_bedrock {
    printout info "Starting installation of Vanilla Bedrock Server..."
    # Minecraft CDN Akamai blocks script user-agents
    RANDVERSION=$(echo $((1 + $RANDOM % 4000)))
    if [ -z "${BEDROCK_VERSION}" ] || [ "${BEDROCK_VERSION}" == "latest" ]; then
        printout info "Downloading latest Bedrock Server"
        DOWNLOAD_URL="https://mcjarfiles.com/api/get-latest-jar/bedrock/latest/linux"
    else
        printout info "Grabbing URL of ${BEDROCK_VERSION} Bedrock Server"
        DOWNLOAD_URL="https://mcjarfiles.com/api/get-jar/bedrock/latest/linux/${BEDROCK_VERSION}"
    fi
    
    if [ -z "$DOWNLOAD_URL" ]; then
        printout error "Failed to determine Bedrock Server download URL."
        exit 1
    fi
    
    DOWNLOAD_FILE=server.zip # Retrieve archive name
    rm -rf *.bak versions.html.gz
    printout info "Downloading Vanilla Bedrock Server"
    if ! curl -fSL -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RANDVERSION.212 Safari/537.36" \
        -H "Accept-Language: en" \
        -o "$DOWNLOAD_FILE" "$DOWNLOAD_URL"; then
        printout error "Failed to download Bedrock server from $DOWNLOAD_URL."
        printout error "Please check the version number and try again. It could maybe also be a internet problem. This script will now exit."
        exit 1
    fi
    printout info "Unpacking server files..."
    if ! unzip -qo "$DOWNLOAD_FILE"; then
        printout error "Failed to extract Bedrock server archive. The file may be corrupted or incomplete."
        rm -f "$DOWNLOAD_FILE"
        exit 1
    fi
    printout info "Cleaning up after install..."
    rm -f "$DOWNLOAD_FILE"
    printout info "Restoring backup config files - on first install there will be file not found errors which you can ignore."
    cp -f server.properties.bak server.properties 2>/dev/null
    cp -f permissions.json.bak permissions.json 2>/dev/null
    cp -f allowlist.json.bak allowlist.json 2>/dev/null
    sed -i "s|^server-port=.*|server-port=$SERVER_PORT|g" server.properties
    if [[ -n "$HOSTING_NAME" && -n "$DISCORD_LINK" && "$ENABLE_FORCED_MOTD" == "1" ]]; then
        forced_motd_bedrock
    fi
    rm -rf *.bak *.txt
    chmod +x bedrock_server
    bin_bytes=$(stat -c%s bedrock_server 2>/dev/null || stat -f%z bedrock_server 2>/dev/null)
    bin_size=$(printf "%.2f MB" $((bin_bytes / 1000000)))
    printout info "Server binary downloaded successfully (Size: $bin_size)"
    create_config "mc_bedrock_vanilla"
    launchBedrockVanillaServer
    return
}


function install_pmmp {
    printout info "Starting installation of PocketMineMP..."
    cd "$HOME" || { printout error "Failed to change to home directory."; exit 1; }
    printout info "Running installation script from: get.pmmp.io"
    curl -sL https://get.pmmp.io | bash -s -
    printout info "Setting up server properties..."
    printout info "Downloading default PocketMineMP config..."
    curl -o "$HOME/server.properties" https://files.aether.loners.software/files/server.pmmp.properties
    sed -i "s/HOSTING_NAME/$(printf '%s\n' "$HOSTING_NAME" | sed -e 's/[\/&]/\\&/g')/g" "$HOME/server.properties"
    sed -i "s|^server-port=.*|server-port=$SERVER_PORT|g" "$HOME/server.properties"
    if [[ -n "$HOSTING_NAME" && -n "$DISCORD_LINK" && "$ENABLE_FORCED_MOTD" == "1" ]]; then
        forced_motd
    fi
    create_config "pmmp"
    phar_bytes=$(stat -c%s PocketMine-MP.phar 2>/dev/null || stat -f%z PocketMine-MP.phar 2>/dev/null)
    phar_size=$(printf "%.2f MB" $((phar_bytes / 1000000)))
    printout info "Server binary downloaded successfully (Size: $phar_size)"
    launchPMMP
    return
}