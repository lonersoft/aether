#!/bin/bash
# aether v1
# A multiegg for hosting companies to host Minecraft servers.
# Licensed under the MIT License
# Forked from Primectyl by divyamboii, licensed under the MIT License

ARCH=$([[ "$(uname -m)" == "x86_64" ]] && printf "amd64" || printf "arm64")

function display {
    echo -e "\e[38;2;195;144;230m\e[4mHardware Information\e[0m"
    echo -e "\e[38;2;195;144;230m  Architecture: \e[38;5;250m$ARCH\e[0m"
    echo -e "\e[38;2;195;144;230m  CPU: \e[38;5;250m$(lscpu | grep 'Model name' | awk -F: '{print $2}' | sed 's/^[ \t]*//')\e[0m"
    echo -e "\e[38;2;195;144;230m  Memory: \e[38;5;250m$SERVER_MEMORY MB\e[0m"
    echo -e "\e[38;2;195;144;230m  Location: \e[38;5;250m$P_SERVER_LOCATION\e[0m"
    echo -e "\e[38;2;195;144;230m  Server Port: \e[38;5;250m$SERVER_PORT\e[0m"
    echo -e "\e[1;36m \e[0m"
    echo -e "\e[1;36m \e[0m"
    if [ "$HOSTING_NAME" == "OrynCloud" ]; then
        toilet -f "smblock" "OrynCloud" -w 200 | sed "s/^/\x1b[38;5;93m/" | sed "s/$/\x1b[0m/"
        echo -e "\e[1;36m \e[0m"
        echo -e "\033[38;5;93m🚀  Egg provided by aether, made by lonersoft"
    else
        toilet -f "smblock" --filter gay "$HOSTING_NAME" -w 200
        echo -e "\e[1;36m \e[0m"
        echo -e "\e[38;2;129;170;254m🚀  Egg provided by aether, made by lonersoft"
    fi
    echo -e "\e[1;36m \e[0m"
    if [ -n "$DISCORD_LINK" ] || [ -n "$EMAIL" ]; then
        if [ -n "$DISCORD_LINK" ]; then
            echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mDiscord: https://discord.gg/$DISCORD_LINK\e[0m"
        fi
        if [ -n "$EMAIL" ]; then
            echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mEmail: $EMAIL\e[0m"
        fi
        echo -e "\e[1;36m \e[0m"
    fi
}

function create_config() {
    local type="$1"
    cat <<EOF >system/multiegg.yml
# DO NOT MODIFY OR DELETE THIS FILE! This contains everything for the script to know what software are you using. Modifying or deleting this file may result of making your server unbootable. Period.
software:
  type: $type
EOF
}

function prompt_eula_mc {
    local eula_file="eula.txt"
    echo -e "\e[1;36m \e[0m"
    echo -e "\e[1;36m \e[0m"
    echo -e "\e[36m📜  Before installing, you must accept the Minecraft EULA.\e[0m"
    echo -e "\e[32m○ Do you accept the Minecraft EULA?:\e[0m"
    echo -e "\e[32m○ Type 'y' to agree, or 'eula' to view the EULA. Anything else counts as a no.\e[0m"
    read -p "$(echo -e '\e[33mYour choice:\e[0m') " accept_eula_input
    accept_eula_input=$(echo "$accept_eula_input" | tr '[:upper:]' '[:lower:]') # Convert to lowercase
    if [[ "$accept_eula_input" == *y* || "$accept_eula_input" == *yes* ]]; then
        echo "eula=true" >"$eula_file"
        echo -e "\033[92m● You have agreed to the EULA. Starting installation...\e[0m"
    elif [[ "$accept_eula_input" == *eula* ]]; then
        echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mThe EULA can be found at https://www.minecraft.net/en-us/eula.\e[0m"
        prompt_eula_mc
    else
        echo -e "\e[1;31m[ERROR] \e[0;31mYou have not agreed to the EULA. Exiting...\e[0m"
        exit 1
    fi
}

check_aether_updates() {
    if [ "$DISABLE_UPDATES" == "1" ]; then
        return
    fi

    local github_api_url="https://api.github.com/repos/lonersoft/aether/releases/latest"
    
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mChecking for updates... this may take a while\e[0m"
    
    # Fetch latest release version from GitHub using jq
    local latest_version=$(curl -s --max-time 5 --connect-timeout 5 "$github_api_url" 2>/dev/null | jq -r '.tag_name' 2>/dev/null)
    
    if [ -z "$latest_version" ] || [ "$latest_version" == "null" ]; then
        echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mUnable to check for updates (network issue).\e[0m"
        return
    fi

    if [ -z "$AETHER_VERSION" ]; then
        AETHER_VERSION=" unknown"
    fi
    
    # Remove 'v' prefix if present for comparison
    latest_version=${latest_version#v}
    
    if [ "$AETHER_VERSION" != "$latest_version" ]; then
        echo -e "\e[33m⚠️  A new version of aether is available: v$latest_version (current: v$AETHER_VERSION)\e[0m"
        echo -e "\e[33m   Download: https://github.com/lonersoft/aether/releases/latest\e[0m"
        echo -e "\e[1;36m \e[0m"
    else
        echo -e "\e[32m✓ aether is up to date (v$AETHER_VERSION)\e[0m"
        echo -e "\e[1;36m \e[0m"
    fi
}

function rules {
    accept_rules_file="system/rulesagreed"

    if [ -f "$accept_rules_file" ]; then
        echo -e "\033[92m● Rules already accepted. Continuing...\e[0m"
        echo -e "\e[1;36m \e[0m"
        return
    fi

    echo -e "\e[38;2;195;144;230m👋  Welcome to the setup wizard! This wizard will help you setup your Minecraft Server.\e[0m"
    echo -e "\e[36m○ Before continuing, you must agree to our server rules.\e[0m"
    echo -e "\e[32mThese rules help maintain a fair, secure, and high-performance environment for all users.\e[0m"
    echo -e "\e[1;36m \e[0m"
    echo -e "\e[32m1) \e[0m Chunk-altering plugins are strictly prohibited."
    echo -e "\e[32m2) \e[0m Mining or any resource-intensive activities that degrade performance are not allowed."
    echo -e "\e[32m3) \e[0m Use server resources responsibly – excessive CPU, RAM, or network usage is not permitted."
    echo -e "\e[32m4) \e[0m Exploiting bugs, abusing services, or bypassing restrictions is strictly forbidden."
    echo -e "\e[32m5) \e[0m All users must comply with our Terms of Service – violations may result in suspension."
    echo -e "\e[1;36m \e[0m"
    echo -e "\e[31m⚠️  Breaking any of these rules may result in a suspension of our service or a ban.\e[0m"
    echo -e "\e[1;36m \e[0m"
    echo -e "\e[36mBy continuing, you confirm that you understand and agree to follow these rules.\e[0m"
    echo -e "\e[1;36m \e[0m"
    echo -e "\e[33m○ Do you agree on theses server rules? (type y to agree):\e[0m"
    read -p "$(echo -e '\e[33mYour choice:\e[0m') " accept_rules
    accept_rules=$(echo "$accept_rules" | tr '[:upper:]' '[:lower:]') # Convert to lowercase
    if [[ "$accept_rules" == *y* || "$accept_rules" == *yes* ]]; then
        mkdir -p "system"
        touch "$accept_rules_file"
        echo -e "\033[92m● Rules has been accepted. Starting installation...\e[0m"
        echo -e "\e[1;36m \e[0m"
    else
        echo -e "\e[1;31m[ERROR] \e[0;31mYou must accept to our rules to use this server! Exiting...\e[0m"
        exit 1
    fi
}

function port_assign {
    cat <<EOF >server.properties
motd=A Minecraft Server
server-port=$SERVER_PORT
query.port=$SERVER_PORT
EOF
}

function config_pmmp {
    # For PocketMineMP server
    cat <<EOF >server.properties
language=eng
motd=$HOSTING_NAME PocketMine-MP Server
server-port=$SERVER_PORT
server-portv6=0
max-players=20
view-distance=20
white-list=off
enable-query=on
enable-ipv6=off
force-gamemode=off
hardcore=off
pvp=on
difficulty=2
generator-settings=
level-name=world
level-seed=
level-type=default
auto-save=on
xbox-auth=on
EOF
}

function forced_motd {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mUpdating MOTD, this feature may not work...\e[0m"
    sed -i "s|^motd=.*|motd=$(printf '%s' "Join $HOSTING_NAME for free server discord.gg/$DISCORD_LINK" | sed 's/[&/\]/\\&/g')|g" server.properties
}

function forced_motd_bedrock {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mUpdating MOTD, this feature may not work...\e[0m"
    sed -i 's|^server-name=.*|server-name="Join '"$HOSTING_NAME"' for free server discord.gg/'"$DISCORD_LINK"'"|g' server.properties
}

####################################
#        Start Functions           #
####################################

function launchVanillaServer {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mChecking if Java is up to date...\e[0m"
    install_java
    if [[ -n "$HOSTING_NAME" && -n "$DISCORD_LINK" && "$ENABLE_FORCED_MOTD" == "1" ]]; then
        forced_motd
    fi
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mRemember! You can change the server software you are using by deleting the \"system\" file in the File Manager and restarting the server.\e[0m"
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mStarting Vanilla Server, this may take a while...\e[0m"
    java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true $STARTUP_ARGUMENT -jar server.jar nogui
}

function launchJavaServer {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mChecking if Java is up to date...\e[0m"
    install_java
    optimize_server
    if [[ -n "$HOSTING_NAME" && -n "$DISCORD_LINK" && "$ENABLE_FORCED_MOTD" == "1" ]]; then
        forced_motd
    fi
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mRemember! You can change the server software you are using by deleting the \"system\" file in the File Manager and restarting the server.\e[0m"
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mStarting Minecraft Java Server, this may take a while...\e[0m"
    java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true $STARTUP_ARGUMENT -jar server.jar nogui
}

function launchProxyServer {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mChecking if Java is up to date...\e[0m"
    install_java
    if [[ -n "$HOSTING_NAME" && -n "$DISCORD_LINK" && "$ENABLE_FORCED_MOTD" == "1" ]]; then
        echo -e '\e[38;2;255;165;0m[WARNING] \e[38;5;250mForced MOTD does not work with proxy servers.\e[0m'
    fi
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mRemember! You can change the server software you are using by deleting the \"system\" file in the File Manager and restarting the server.\e[0m"
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mStarting Minecraft Proxy Server, this may take a while...\e[0m"
    java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true $STARTUP_ARGUMENT -jar server.jar
}

function launchBedrockVanillaServer {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mRemember! You can change the server software you are using by deleting the \"system\" file in the File Manager and restarting the server.\e[0m"
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mStarting Minecraft Bedrock Server, this may take a while...\e[0m"
    if [[ -n "$HOSTING_NAME" && -n "$DISCORD_LINK" && "$ENABLE_FORCED_MOTD" == "1" ]]; then
        forced_motd_bedrock
    fi
    LD_LIBRARY_PATH=. ./bedrock_server
}

function launchPMMP {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mRemember! You can change the server software you are using by deleting the \"system\" file in the File Manager and restarting the server.\e[0m"
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mStarting PocketMine MP Server, this may take a while...\e[0m"
    ./start.sh
}

####################################
#          Install Functions       #
####################################

function install_java {
    if [ -z "$JAVA_VERSION" ]; then
        echo -e "\e[1;31m[ERROR] \e[0;31mOops! You met an error that occurred while installing Java.\e[0m"
        echo -e "\e[1;31m[ERROR] \e[0;31mPlease specify the desired Java version using the JAVA_VERSION environment variable.\e[0m"
        echo -e "\e[1;34m[SOLUTION] \e[0;34mThis can be done by going to the Startup tab of your server and selecting a Java version from the dropdown menu.\e[0m"
        echo -e "\e[1;34m[SOLUTION] \e[0;34mIf you need further assistance, please contact support.\e[0m"
        exit 1
    fi
    if [ ! -d "$HOME/.sdkman" ]; then
        curl -s "https://get.sdkman.io" | bash >/dev/null 2>&1
    fi
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk update >/dev/null 2>&1
    sdk selfupdate
    case "$JAVA_VERSION" in
    8)
        JAVA_VERSION_S="8.0.472-tem"
        ;;
    11)
        JAVA_VERSION_S="11.0.29-tem"
        ;;
    17)
        JAVA_VERSION_S="17.0.17-tem"
        ;;
    21)
        JAVA_VERSION_S="21.0.9-tem"
        ;;
    23)
        JAVA_VERSION_S="23.0.2-tem"
        ;;
    24)
        JAVA_VERSION_S="24.0.2-tem"
        ;;
    25)
        JAVA_VERSION_S="25.0.1-tem"
        ;;
    *)
        echo -e "\e[1;31m[ERROR] \e[0;31mOops! You met an error that occurred while installing Java.\e[0m"
        echo -e "\e[1;31m[ERROR] \e[0;31mPlease specify the desired Java version using the JAVA_VERSION environment variable.\e[0m"
        echo -e "\e[1;34m[SOLUTION] \e[0;34mThis can be done by going to the Startup tab of your server and selecting a Java version from the dropdown menu.\e[0m"
        echo -e "\e[1;34m[SOLUTION] \e[0;34mIf you need further assistance, please contact support.\e[0m"
        exit 1
        ;;
    esac
    if [ -z "$JAVA_VERSION_S" ]; then
        clear
        display
        check_aether_updates
        echo -e "\e[1;31m[ERROR] \e[0;31mOops! You met an error that occurred while installing Java $JAVA_VERSION.\e[0m"
        echo -e "\e[1;31m[ERROR] \e[0;31mPlease report this issue to the support team and share this error message:\e[0m"
        echo -e "\e[1;31m[ERROR] \e[0;31mThe JAVA_VERSION_S variable is empty, which cannot continue the Java Installation section.\e[0m"
        exit 1
    fi
    if sdk current java | grep -q "$JAVA_VERSION"; then
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mJava $JAVA_VERSION is already installed.\e[0m"
    else
        echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mInstalling Java $JAVA_VERSION_S...\e[0m"
        if [ -n "$(sdk current java)" ]; then
            OLD_VERSION=$(sdk current java)
            echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mRemoving old Java version $OLD_VERSION...\e[0m"
            sdk uninstall java "$OLD_VERSION"
        fi
        sdk install java "$JAVA_VERSION_S"
        echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mJava $JAVA_VERSION_S installed successfully.\e[0m"
    fi
    export JAVA_HOME="$HOME/.sdkman/candidates/java/$JAVA_VERSION_S"
    export PATH="$JAVA_HOME/bin:$PATH"
}

function optimize_server {
    if [ ! -d "$HOME/plugins" ]; then
        mkdir -p $HOME/plugins
    fi
    if [ "$OPTIMIZE_SERVER" != "1" ]; then
        return
    fi
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mOptimizing server...\e[0m"
    curl -o $HOME/plugins/Hibernate.jar https://aether.loners.software/files/Hibernate-2.1.0.jar
}

function install_vanilla {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mDownloading Vanilla Server...\e[0m"
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/VANILLA/$vanilla" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --request GET --url "https://versions.mcjars.app/api/v2/builds/VANILLA/$vanilla" | jq -r '.builds[0].jarUrl')
    fi
    curl -o server.jar "$jar_url"
    jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
    jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
    create_config "mc_java_vanilla"
    port_assign
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mServer jar downloaded successfully (Size: $jar_size)\e[0m"
    install_java
    launchVanillaServer
    exit
}

function install_paper {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mDownloading Paper Server...\e[0m"
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/PAPER/$paper" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --request GET --url "https://versions.mcjars.app/api/v2/builds/PAPER/$paper" | jq -r '.builds[0].jarUrl')
    fi
    curl -o server.jar "$jar_url"
    jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
    jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
    create_config "mc_java_paper"
    port_assign
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mServer jar downloaded successfully (Size: $jar_size)\e[0m"
    install_java
    launchJavaServer
    exit
}

function install_purpur {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mDownloading Purpur Server...\e[0m"
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/PURPUR/$purpur" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --request GET --url "https://versions.mcjars.app/api/v2/builds/PURPUR/$purpur" | jq -r '.builds[0].jarUrl')
    fi
    curl -o server.jar "$jar_url"
    jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
    jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
    create_config "mc_java_purpur"
    port_assign
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mServer jar downloaded successfully (Size: $jar_size)\e[0m"
    install_java
    launchJavaServer
    exit
}

function install_bungeecord {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mDownloading BungeeCord Server...\e[0m"
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/BUNGEECORD/$bungeecord" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --request GET --url "https://versions.mcjars.app/api/v2/builds/BUNGEECORD/$bungeecord" | jq -r '.builds[0].jarUrl')
    fi
    curl -o server.jar "$jar_url"
    create_config "mc_java_bungeecord"
    cat <<EOF >config.yml
listeners:
  - query_port: $SERVER_PORT
    host: 0.0.0.0:$SERVER_PORT
EOF
    jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
    jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mServer jar downloaded successfully (Size: $jar_size)\e[0m"
    install_java
    launchProxyServer
    exit
}

function install_velocity {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mDownloading Velocity Server...\e[0m"
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/VELOCITY/$velocity" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --request GET --url "https://versions.mcjars.app/api/v2/builds/VELOCITY/$velocity" | jq -r '.builds[0].jarUrl')
    fi
    curl -o server.jar "$jar_url"
    create_config "mc_proxy_velocity"
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mDownloading default Velocity config...\e[0m"
    curl -o $HOME/velocity.toml https://aether.loners.software/files/velocity.toml
    sed -i "s/serverport/$SERVER_PORT/g" "$HOME/velocity.toml"
    jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
    jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mServer jar downloaded successfully (Size: $jar_size)\e[0m"
    install_java
    launchProxyServer
    exit
}

function install_waterfall {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mDownloading Waterfall Server...\e[0m"
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
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mServer jar downloaded successfully (Size: $jar_size)\e[0m"
    install_java
    launchProxyServer
    exit
}

function install_bedrock {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mStarting installation of Vanilla Bedrock Server...\e[0m"
    # Minecraft CDN Akamai blocks script user-agents
    RANDVERSION=$(echo $((1 + $RANDOM % 4000)))
    if [ -z "${BEDROCK_VERSION}" ] || [ "${BEDROCK_VERSION}" == "latest" ]; then
        echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mDownloading latest Bedrock Server\e[0m"
        DOWNLOAD_URL="https://mcjarfiles.com/api/get-latest-jar/bedrock/latest/linux"
    else
        echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mGrabbing URL of ${BEDROCK_VERSION} Bedrock Server\e[0m"
        DOWNLOAD_URL="https://mcjarfiles.com/api/get-jar/bedrock/latest/linux/${BEDROCK_VERSION}"
    fi
    
    if [ -z "$DOWNLOAD_URL" ]; then
        echo -e "\e[91m[ERROR] \e[31mFailed to determine Bedrock Server download URL.\e[0m"
        exit 1
    fi
    
    DOWNLOAD_FILE=server.zip # Retrieve archive name
    rm -rf *.bak versions.html.gz
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mDownloading Vanilla Bedrock Server\e[0m"
    if ! curl -fSL -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RANDVERSION.212 Safari/537.36" \
        -H "Accept-Language: en" \
        -o "$DOWNLOAD_FILE" "$DOWNLOAD_URL"; then
        echo -e "\e[91m[ERROR] \e[31mFailed to download Bedrock server from $DOWNLOAD_URL.\e[0m"
        echo -e "\e[91m[ERROR] \e[31mPlease check the version number and try again. It could maybe also be a internet problem. This script will now exit.\e[0m"
        exit 1
    fi
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mUnpacking server files...\e[0m"
    unzip -qo "$DOWNLOAD_FILE"
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mCleaning up after install...\e[0m"
    rm -f "$DOWNLOAD_FILE"
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mRestoring backup config files - on first install there will be file not found errors which you can ignore.\e[0m"
    cp -rf server.properties.bak server.properties 2>/dev/null
    cp -rf permissions.json.bak permissions.json 2>/dev/null
    cp -rf allowlist.json.bak allowlist.json 2>/dev/null
    sed -i "s|^server-port=.*|server-port=$SERVER_PORT|g" server.properties
    if [[ -n "$HOSTING_NAME" && -n "$DISCORD_LINK" && "$ENABLE_FORCED_MOTD" == "1" ]]; then
        forced_motd_bedrock
    fi
    rm -rf *.bak *.txt
    chmod +x bedrock_server
    bin_bytes=$(stat -c%s bedrock_server 2>/dev/null || stat -f%z bedrock_server 2>/dev/null)
    bin_size=$(printf "%.2f MB" $((bin_bytes / 1000000)))
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mServer binary downloaded successfully (Size: $bin_size)\e[0m"
    create_config "mc_bedrock_vanilla"
    launchBedrockVanillaServer
    exit
}

function install_pmmp {
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mStarting installation of PocketMineMP...\e[0m"
    cd $HOME
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mRunning installation script from: get.pmmp.io\e[0m"
    curl -sL https://get.pmmp.io | bash -s -
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mSetting up server properties...\e[0m"
    config_pmmp
    create_config "pmmp"
    phar_bytes=$(stat -c%s PocketMine-MP.phar 2>/dev/null || stat -f%z PocketMine-MP.phar 2>/dev/null)
    phar_size=$(printf "%.2f MB" $((phar_bytes / 1000000)))
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mServer binary downloaded successfully (Size: $phar_size)\e[0m"
    launchPMMP
    exit
}

####################################
#          Menu Functions          #
####################################

function minecraft_menu {
    while true; do
        echo -e "\e[1;36m \e[0m"
        echo -e "\e[1;36m \e[0m"
        echo -e "\e[36m🖥️  Select your Java server:\e[0m"
        echo -e "\e[32m1\e[0m) Vanilla  \e[38;5;250m(1.18 - 1.21.10)\e[0m"
        echo -e "\e[32m2\e[0m) Paper  \e[38;5;250m(1.8.8 - 1.21.10)\e[0m"
        echo -e "\e[32m3\e[0m) Purpur \e[38;5;250m(1.14.1 - 1.21.10)\e[0m"
        echo -e "\e[31m4\e[0m) Back\e[0m"

        read -p "$(echo -e '\e[33mYour choice:\e[0m') " mcsoft

        case $mcsoft in
        1)
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[36m🔧  Select the Vanilla version you want to use:\e[0m"
            echo -e "\e[32m→ 1.18, 1.18.1, 1.18.2, 1.19, 1.19.1, 1.19.2, 1.19.3, 1.19.4, 1.20, 1.20.1, 1.20.2, 1.20.4, 1.20.5, 1.20.6, 1.21, 1.21.1, 1.21.2, 1.21.3, 1.21.4, 1.21.5, 1.21.6, 1.21.7, 1.21.8, 1.21.9, 1.21.10\e[0m"
            read -p "$(echo -e '\e[33mYour choice:\e[0m') " input_version
            valid_versions="1.18 1.18.1 1.18.2 1.19 1.19.1 1.19.2 1.19.3 1.19.4 1.20 1.20.1 1.20.2 1.20.4 1.20.5 1.20.6 1.21 1.21.1 1.21.2 1.21.3 1.21.4 1.21.5 1.21.6 1.21.7 1.21.8 1.21.9 1.21.10"

            # Check if the input version is in the list of valid versions
            if [[ $valid_versions =~ (^|[[:space:]])$input_version($|[[:space:]]) ]]; then
                vanilla="$input_version"
                prompt_eula_mc
                install_vanilla
            else
               echo -e "\e[1;31m[ERROR] \e[0;31mThe specified version is either invalid or deprecated.\e[0m"
            fi
            ;;
        2)
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[36m🔧  Select the Paper version you want to use:\e[0m"
            echo -e "\e[32m→ 1.8.8, 1.9.4, 1.10.2, 1.11.2, 1.12.2, 1.13.2, 1.14.4, 1.15.2, 1.16.5, 1.17, 1.17.1, 1.18, 1.18.1, 1.18.2, 1.19, 1.19.1, 1.19.2, 1.19.3, 1.19.4, 1.20, 1.20.1, 1.20.2, 1.20.4, 1.20.5, 1.20.6, 1.21, 1.21.1, 1.21.3, 1.21.4, 1.21.5, 1.21.6, 1.21.7, 1.21.8, 1.21.9, 1.21.10\e[0m"
            read -p "$(echo -e '\e[33mYour choice:\e[0m') " input_version
            valid_versions="1.8.8 1.9.4 1.10.2 1.11.2 1.12.2 1.13.2 1.14.4 1.15.2 1.16.5 1.17 1.17.1 1.18 1.18.1 1.18.2 1.19 1.19.1 1.19.2 1.19.3 1.19.4 1.20 1.20.1 1.20.2 1.20.4 1.20.5 1.20.6 1.21 1.21.1 1.21.3 1.21.4 1.21.5 1.21.6 1.21.7 1.21.8 1.21.9 1.21.10"

            # Check if the input version is in the list of valid versions
            if [[ $valid_versions =~ (^|[[:space:]])$input_version($|[[:space:]]) ]]; then
                paper="$input_version"
                prompt_eula_mc
                install_paper
            else
               echo -e "\e[1;31m[ERROR] \e[0;31mThe specified version is either invalid or deprecated.\e[0m"
            fi
            ;;
        3)
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[36m🔧  Select the Purpur version you want to use:\e[0m"
            echo -e "\e[32m→ 1.14.1, 1.14.2, 1.14.3, 1.14.4, 1.15, 1.15.1, 1.15.2, 1.16.1, 1.16.2, 1.16.3, 1.16.4, 1.16.5, 1.17, 1.17.1, 1.18, 1.18.1, 1.18.2, 1.19, 1.19.1, 1.19.2, 1.19.3, 1.19.4, 1.20, 1.20.1, 1.20.2, 1.20.4, 1.20.6, 1.21, 1.21.1, 1.21.3, 1.21.4, 1.21.5, 1.21.6, 1.21.7, 1.21.8, 1.21.9, 1.21.10\e[0m"
            read -p "$(echo -e '\e[33mYour choice:\e[0m') " input_version
            valid_versions="1.14.1 1.14.2 1.14.3 1.14.4 1.15 1.15.1 1.15.2 1.16.1 1.16.2 1.16.3 1.16.4 1.16.5 1.17 1.17.1 1.18 1.18.1 1.18.2 1.19 1.19.1 1.19.2 1.19.3 1.19.4 1.20 1.20.1 1.20.2 1.20.4 1.20.6 1.21 1.21.1 1.21.3 1.21.4 1.21.5 1.21.6 1.21.7 1.21.8 1.21.9 1.21.10"
            if [[ $valid_versions =~ (^|[[:space:]])$input_version($|[[:space:]]) ]]; then
                purpur="$input_version"
                prompt_eula_mc
                install_purpur
            else
                echo -e "\e[1;31m[ERROR] \e[0;31mThe specified version is either invalid or deprecated.\e[0m"
            fi
            ;;
        4)
            break
            ;;
        *)
            echo -e "\e[1;31m[ERROR] \e[0;31mInvalid choice. Please try again.\e[0m"
            ;;
        esac
    done
}

function bedrock_menu {
    while true; do
        echo -e "\e[1;36m \e[0m"
        echo -e "\e[1;36m \e[0m"
        echo -e "\e[36m🖥️  Select your Bedrock server:\e[0m"
        echo -e "\e[32m1\e[0m) Vanilla Bedrock\e[0m"
        echo -e "\e[32m2\e[0m) PocketMineMP\e[0m"
        echo -e "\e[31m3\e[0m) Back\e[0m"

        read -p "$(echo -e '\e[33mYour choice:\e[0m') " bdsoft

        case $bdsoft in
        1)
            prompt_eula_mc
            install_bedrock
            ;;
        2)
            prompt_eula_mc
            install_pmmp
            ;;
        3)
            break
            ;;
        *)
            echo -e "\e[1;31m[ERROR] \e[0;31mInvalid choice. Please try again.\e[0m"
            ;;
        esac
    done
}

function proxy_menu {
    while true; do
        echo -e "\e[1;36m \e[0m"
        echo -e "\e[1;36m \e[0m"
        echo -e '\e[38;2;255;165;0m[WARNING] \e[38;5;250mThis feature is relatively new and may have some issues. Please report any issues to https://github.com/lonersoft/aether/issues.\e[0m'
        echo -e "\e[36m🖥️  Select your Proxy server:\e[0m"
        echo -e "\e[32m1\e[0m) Bungeecord\e[0m"
        echo -e "\e[32m2\e[0m) Velocity\e[0m"
        echo -e "\e[32m3\e[0m) Waterfall\e[0m"
        echo -e "\e[31m4\e[0m) Back\e[0m"

        read -p "$(echo -e '\e[33mYour choice:\e[0m') " proxy

        case $proxy in
        1)
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[1;36m \e[0m"
            echo -e '\e[38;2;255;165;0m[WARNING] \e[38;5;250mBungeeCord versions below 1.16 are not shown here due to them being old.\e[0m'
            echo -e "\e[36m🔧  Select the Bungeecord version you want to use:\e[0m"
            echo -e "\e[32m→ 1.16, 1.17, 1.18, 1.19, 1.20, 1.21\e[0m"
            read -p "$(echo -e '\e[33mYour choice:\e[0m') " input_version
            valid_versions="1.16 1.17 1.18 1.19 1.20 1.21"

            # Check if the input version is in the list of valid versions
            if [[ $valid_versions =~ (^|[[:space:]])$input_version($|[[:space:]]) ]]; then
                bungeecord="$input_version"
                prompt_eula_mc
                install_bungeecord
            else
               echo -e "\e[1;31m[ERROR] \e[0;31mThe specified version is either invalid or deprecated.\e[0m"
            fi
            ;;
        2)
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[36m🔧  Select the Velocity version you want to use:\e[0m"
            echo -e "\e[32m→ 3.1.0, 3.1.1-SNAPSHOT, 3.1.1, 3.1.2-SNAPSHOT, 1.0.10, 1.1.9, 3.2.0-SNAPSHOT, 3.3.0-SNAPSHOT, 3.4.0-SNAPSHOT\e[0m"
            read -p "$(echo -e '\e[33mYour choice:\e[0m') " input_version
            valid_versions="3.1.0 3.1.1-SNAPSHOT 3.1.1 3.1.2-SNAPSHOT 1.0.10 1.1.9 3.2.0-SNAPSHOT 3.3.0-SNAPSHOT 3.4.0-SNAPSHOT"

            # Check if the input version is in the list of valid versions
            if [[ $valid_versions =~ (^|[[:space:]])$input_version($|[[:space:]]) ]]; then
                velocity="$input_version"
                prompt_eula_mc
                install_velocity
            else
               echo -e "\e[1;31m[ERROR] \e[0;31mThe specified version is either invalid or deprecated.\e[0m"
            fi
            ;;
        3)
            echo -e "\e[1;36m \e[0m"
            echo -e "\e[1;36m \e[0m"
            echo -e '\e[38;2;255;165;0m[WARNING] \e[38;5;250mKeep in mind, Waterfall is deprecated and may not work as expected. Take backups!\e[0m'
            echo -e "\e[36m🔧  Select the Waterfall version you want to use:\e[0m"
            echo -e "\e[32m→ 1.11, 1.12, 1.13, 1.14, 1.15, 1.16, 1.17, 1.18, 1.19, 1.20, 1.21\e[0m"
            read -p "$(echo -e '\e[33mYour choice:\e[0m') " input_version
            valid_versions="1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21"

            # Check if the input version is in the list of valid versions
            if [[ $valid_versions =~ (^|[[:space:]])$input_version($|[[:space:]]) ]]; then
                waterfall="$input_version"
                prompt_eula_mc
                install_waterfall
            else
               echo -e "\e[1;31m[ERROR] \e[0;31mThe specified version is either invalid or deprecated.\e[0m"
            fi
            ;;
        4)
            break
            ;;
        *)
            echo -e "\e[1;31m[ERROR] \e[0;31mInvalid choice. Please try again.\e[0m"
            ;;
        esac
    done
}

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
            mc_java | mc_java_paper | mc_java_purpur)
                clear
                display
                check_aether_updates
                case "$type" in
                mc_java | mc_java_paper | mc_java_purpur)
                    launchJavaServer
                    ;;
                esac
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
                echo -e "\e[1;31m[ERROR] \e[0;31mInvalid system configuration type specified in system/multiegg.yml.\e[0m"
                exit 1
                ;;
            esac
        fi
        clear
        display
        check_aether_updates
        echo -e "\e[1;31m[ERROR] \e[0;31mInvalid system configuration file.\e[0m"
        exit 1
    fi
}

####################################
#          Main Script             #
####################################
function main {
    check_config
    while true; do
        clear
        display
        check_aether_updates
        mkdir -p system
        if [[ "$ENABLE_RULES" == "1" ]]; then
            rules
        fi
        echo -e "\e[36m🎮  Select the server type:\e[0m"
        echo -e "\e[32m1\e[0m) Minecraft: Java Edition\e[0m"
        echo -e "\e[32m2\e[0m) Minecraft: Bedrock Edition\e[0m"
        echo -e "\e[32m3\e[0m) Minecraft Proxies\e[0m"
        echo -e "\e[31m4\e[0m) Exit"
        read -p "$(echo -e '\e[33mYour choice:\e[0m') " type

        case $type in
        1)
            minecraft_menu
            ;;
        2)
            bedrock_menu
            ;;
        3)
            proxy_menu
            exit 0
            ;;
        4)
            echo -e "\e[31m● Exiting the script. Goodbye!\e[0m"
            exit 0
            ;;
        stop)
            echo -e "\e[31m● Exiting the script. Goodbye!\e[0m"
            exit 0
            ;;
        *)
            echo -e "\e[1;31m[ERROR] \e[0;31mInvalid choice. Please try again.\e[0m"
            sleep 2
            ;;
        esac
    done
}

main
