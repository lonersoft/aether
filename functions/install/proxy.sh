#!/bin/bash

function install_bungeecord {
    printout info "Downloading BungeeCord Server..."
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/BUNGEECORD/$bungeecord" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --request GET --url "https://versions.mcjars.app/api/v2/builds/BUNGEECORD/$bungeecord" | jq -r '.builds[0].jarUrl')
    fi
    curl -o server.jar "$jar_url"
    create_config "mc_proxy_bungeecord"
    cat <<EOF >config.yml
listeners:
  - query_port: $SERVER_PORT
    host: 0.0.0.0:$SERVER_PORT
EOF
    jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
    jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
    printout info "Server jar downloaded successfully (Size: $jar_size)"
    install_java
    launchProxyServer
    exit
}

function install_velocity {
    printout info "Downloading Velocity Server..."
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/VELOCITY/$velocity" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --request GET --url "https://versions.mcjars.app/api/v2/builds/VELOCITY/$velocity" | jq -r '.builds[0].jarUrl')
    fi
    curl -o server.jar "$jar_url"
    create_config "mc_proxy_velocity"
    printout info "Downloading default Velocity config..."
    if ! curl -o "$HOME/velocity.toml" https://files.aether.loners.software/files/velocity.toml; then
        printout error "Failed to download Velocity configuration file."
        exit 1
    fi
    if ! sed -i "s/serverport/$SERVER_PORT/g" "$HOME/velocity.toml"; then
        printout error "Failed to update Velocity configuration with server port."
        exit 1
    fi
    jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
    jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
    printout info "Server jar downloaded successfully (Size: $jar_size)"
    install_java
    launchProxyServer
    exit
}

function install_waterfall {
    printout info "Downloading Waterfall Server..."
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/WATERFALL/$waterfall" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --request GET --url "https://versions.mcjars.app/api/v2/builds/WATERFALL/$waterfall" | jq -r '.builds[0].jarUrl')
    fi
    curl -o server.jar "$jar_url"
    create_config "mc_proxy_waterfall"
    cat <<EOF >config.yml
listeners:
  - query_port: $SERVER_PORT
    host: 0.0.0.0:$SERVER_PORT
EOF
    jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
    jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
    printout info "Server jar downloaded successfully (Size: $jar_size)"
    install_java
    launchProxyServer
    exit
}
