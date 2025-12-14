#!/bin/bash

function port_assign {
    cat <<EOF >server.properties
motd=A Minecraft Server
server-port=$SERVER_PORT
query.port=$SERVER_PORT
EOF
}

# optimize_server ensures $HOME/plugins exists and, if OPTIMIZE_SERVER is "1", downloads Hibernate.jar into that directory.
# It creates the plugins directory when missing and does nothing further when OPTIMIZE_SERVER is not "1".
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

# forced_motd updates the `motd` line in server.properties to "Join <HOSTING_NAME> for free server discord.gg/<DISCORD_LINK>", escaping special characters as needed.
function forced_motd {
    printout info "Updating MOTD, this feature may not work..."
    sed -i "s|^motd=.*|motd=$(printf '%s' "Join $HOSTING_NAME for free server discord.gg/$DISCORD_LINK" | sed 's/[&/\]/\\&/g')|g" server.properties
}

# forced_motd_bedrock updates the Bedrock `server-name` entry in server.properties to include the hosting name and Discord invite (e.g., server-name="Join <HOSTING_NAME> for free server discord.gg/<DISCORD_LINK>").
function forced_motd_bedrock {
    printout info "Updating MOTD, this feature may not work..."
    sed -i 's|^server-name=.*|server-name="Join '"$HOSTING_NAME"' for free server discord.gg/'"$DISCORD_LINK"'"|g' server.properties
}