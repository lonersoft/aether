#!/bin/bash

function port_assign {
    cat <<EOF >server.properties
motd=A Minecraft Server
server-port=$SERVER_PORT
query.port=$SERVER_PORT
EOF
}

function optimize_server {
    if [ ! -d "$HOME/plugins" ]; then
        mkdir -p $HOME/plugins
    fi
    if [ "$OPTIMIZE_SERVER" != "1" ]; then
        return
    fi
    printout info "Optimizing server..."
    curl -o $HOME/plugins/Hibernate.jar https://files.aether.loners.software/files/Hibernate-2.1.0.jar
}

function forced_motd {
    printout info "Updating MOTD, this feature may not work..."
    sed -i "s|^motd=.*|motd=$(printf '%s' "Join $HOSTING_NAME for free server discord.gg/$DISCORD_LINK" | sed 's/[&/\]/\\&/g')|g" server.properties
}

function forced_motd_bedrock {
    printout info "Updating MOTD, this feature may not work..."
    sed -i 's|^server-name=.*|server-name="Join '"$HOSTING_NAME"' for free server discord.gg/'"$DISCORD_LINK"'"|g' server.properties
}