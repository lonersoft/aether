# launchBedrockVanillaServer launches the Minecraft Bedrock server; it prints usage reminders, calls forced_motd_bedrock when HOSTING_NAME and DISCORD_LINK are set and ENABLE_FORCED_MOTD equals "1", then starts `bedrock_server` with LD_LIBRARY_PATH set to the current directory.

function launchBedrockVanillaServer {
    printout info "Remember! You can change the server software you are using by deleting the \"system\" file in the File Manager and restarting the server."
    printout info "Starting Minecraft Bedrock Server, this may take a while..."
    if [[ -n "$HOSTING_NAME" && -n "$DISCORD_LINK" && "$ENABLE_FORCED_MOTD" == "1" ]]; then
        forced_motd_bedrock
    fi
    LD_LIBRARY_PATH=. ./bedrock_server
}

# launchPMMP prints reminders about changing the server software and starts the PocketMine MP server by running ./start.sh.
function launchPMMP {
    printout info "Remember! You can change the server software you are using by deleting the \"system\" file in the File Manager and restarting the server."
    printout info "Starting PocketMine MP Server, this may take a while..."
    ./start.sh
}