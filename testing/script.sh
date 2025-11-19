#!/bin/bash

# Variables set by Pterodactyl
export SERVER_MEMORY="8192" # Server Memory in MB
export P_SERVER_LOCATION="US" # Location name, shows on hardware information
export SERVER_PORT="25565" # REQUIRED - Port the server will run on, will also show on hardware information

# Variables set by aether
export HOSTING_NAME="aether" # REQUIRED - Name of the hosting, shows on the banner and forced MOTD (if enabled)
export DISCORD_LINK="" # Discord invite link, shows below the banner and forced MOTD (if enabled)
export EMAIL="" # Email address, shows below the banner
export JAVA_VERSION="21" # REQUIRED - Java version to use, options: 25, 24, 23, 21, 17, 11, 8
export STARTUP_ARGUMENT="" # Additional startup arguments for the server JVM
export BEDROCK_VERSION="latest" # REQUIRED - Bedrock server version to use for downloading
export ENABLE_FORCED_MOTD="0" # REQUIRED - Set to 1 to enable forced MOTD with hosting name and Discord Server, set to 0 to disable
export OPTIMIZE_SERVER="0" # REQUIRED - Set to 1 to enable automatic server optimizations, set to 0 to disable
export ENABLE_RULES="0" # REQUIRED - Set to 1 to enable server rules on first startup, set to 0 to disable
export MCJARS_API_KEY="" # Your MCJars API key for tracking, and (potentially) higher ratelimits

# Variables for this script only
SCRIPT_SOURCE="github" # source to download entrypoint.sh from, options: github, local
SCRIPT_LOCATION="/workspaces/aether/entrypoint.sh" # if SCRIPT_SOURCE is local, set the path where entrypoint.sh is located

# DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING
if [ -z "$HOSTING_NAME" ] || [ -z "$JAVA_VERSION" ] || [ -z "$BEDROCK_VERSION" ] || [ -z "$ENABLE_FORCED_MOTD" ] || [ -z "$OPTIMIZE_SERVER" ] || [ -z "$ENABLE_RULES" ] || [ -z "$SERVER_PORT" ]; then
    echo -e "\e[1;31m[ERROR] \e[0;31mOne or more required environment variables are not set. Please check the environment variables inside the script's code and try again.\e[0m"
    echo -e "\e[1;31m[ERROR] \e[0;31mThe required environment variables are: HOSTING_NAME, JAVA_VERSION, BEDROCK_VERSION, ENABLE_FORCED_MOTD, OPTIMIZE_SERVER, ENABLE_RULES, SERVER_PORT.\e[0m"
    exit 1
fi

# Check for required dependencies
missing_deps=()
for cmd in curl zip unzip jq toilet; do
    if ! command -v "$cmd" &> /dev/null; then
        missing_deps+=("$cmd")
    fi
done

if [ ${#missing_deps[@]} -ne 0 ]; then
    echo -e "\e[1;31m[ERROR] \e[0;31mThe following required dependencies are not installed: ${missing_deps[*]}\e[0m"
    echo -e "\e[1;34m[SOLUTION] \e[0;34mPlease install them using: sudo apt update && sudo apt install -y ${missing_deps[*]}\e[0m"
    exit 1
fi

if [ "$SCRIPT_SOURCE" == "local" ]; then
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mCopying $SCRIPT_LOCATION...\e[0m"
    cp "$SCRIPT_LOCATION" "$(dirname "$0")/entrypoint.sh"
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mSetting entrypoint.sh as executable...\e[0m"
    chmod +x "$(dirname "$0")/entrypoint.sh"
    echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mExecuting entrypoint.sh, check if any errors popped up, will automatically start in 5 seconds\e[0m"
    sleep 5
    bash "$(dirname "$0")/entrypoint.sh"
    exit 0
fi
echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mDownloading entrypoint.sh to current directory, this may depend on your internet connection\e[0m"
wget -qO "$(dirname "$0")/entrypoint.sh" https://raw.githubusercontent.com/lonersoft/aether/refs/heads/main/entrypoint.sh
echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mSetting entrypoint.sh as executable...\e[0m"
chmod +x "$(dirname "$0")/entrypoint.sh"
echo -e "\e[38;2;129;170;254m[INFO] \e[38;5;250mExecuting entrypoint.sh, check if any errors popped up, will automatically start in 5 seconds\e[0m"
sleep 5
bash "$(dirname "$0")/entrypoint.sh"
