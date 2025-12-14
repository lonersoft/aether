# install_bungeecord downloads and installs a BungeeCord proxy jar, writes a minimal config.yml using $SERVER_PORT, installs Java, and launches the proxy.

function install_bungeecord {
    printout info "Downloading BungeeCord Server..."
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/BUNGEECORD/$bungeecord" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --request GET --url "https://versions.mcjars.app/api/v2/builds/BUNGEECORD/$bungeecord" | jq -r '.builds[0].jarUrl')
    fi
    curl -fSLo server.jar "$jar_url" || {
        rm -f server.jar
        printout error "Failed to download BungeeCord server jar from $jar_url"
        exit 1
    }
    create_config "mc_java_bungeecord"
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

# install_velocity downloads and sets up a Velocity proxy server: it fetches the latest Velocity jar (using MCJARS API when available), saves it as server.jar, creates the mc_proxy_velocity config, downloads and patches velocity.toml with SERVER_PORT, installs Java, launches the proxy, and exits.
function install_velocity {
    printout info "Downloading Velocity Server..."
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/VELOCITY/$velocity" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --request GET --url "https://versions.mcjars.app/api/v2/builds/VELOCITY/$velocity" | jq -r '.builds[0].jarUrl')
    fi
    curl -fSLo server.jar "$jar_url" || {
        rm -f server.jar
        printout error "Failed to download Velocity server jar from $jar_url"
        exit 1
    }
    create_config "mc_proxy_velocity"
    printout info "Downloading default Velocity config..."
    curl -fSLo "$HOME/velocity.toml" https://files.aether.loners.software/files/velocity.toml || {
        rm -f "$HOME/velocity.toml"
        printout error "Failed to download Velocity config from https://files.aether.loners.software/files/velocity.toml"
        exit 1
    }
    sed -i "s/serverport/$SERVER_PORT/g" "$HOME/velocity.toml"
    jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
    jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
    printout info "Server jar downloaded successfully (Size: $jar_size)"
    install_java
    launchProxyServer
    exit
}

# install_waterfall downloads and sets up a Waterfall proxy jar, writes a minimal config.yml using $SERVER_PORT, installs Java, launches the proxy server, and exits.
function install_waterfall {
    printout info "Downloading Waterfall Server..."
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/WATERFALL/$waterfall" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --request GET --url "https://versions.mcjars.app/api/v2/builds/WATERFALL/$waterfall" | jq -r '.builds[0].jarUrl')
    fi
    curl -fSLo server.jar "$jar_url" || {
        rm -f server.jar
        printout error "Failed to download Waterfall server jar from $jar_url"
        exit 1
    }
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