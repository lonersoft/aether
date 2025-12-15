#!/bin/bash

check_aether_updates() {
    if [ "$DISABLE_UPDATES" == "1" ]; then
        return
    fi

    local github_api_url="https://api.github.com/repos/lonersoft/aether/releases/latest"
    
    printout info "Checking for updates... this may take a while"
    
    # Fetch latest release version from GitHub using jq
    local latest_version
    latest_version=$(curl -s --max-time 5 --connect-timeout 5 "$github_api_url" 2>/dev/null | jq -r '.tag_name' 2>/dev/null)
    
    if [ -z "$latest_version" ] || [ "$latest_version" == "null" ]; then
        printout info "Unable to check for updates (network issue)."
        return
    fi

    if [ -z "$AETHER_VERSION" ]; then
        printout warning "Current Aether version is unknown. Cannot check for updates."
        printout warning "If you are an administrator, please update the egg to get the latest features and fixes."
        printout warning "Download it here: https://github.com/lonersoft/aether/releases/latest"
        echo -e "\e[1;36m \e[0m"
        return
    fi
    
    # Remove 'v' prefix if present for comparison
    latest_version=${latest_version#v}
    
    if [ "$AETHER_VERSION" != "$latest_version" ]; then
        echo -e "\e[33m⚠️  A new version of aether is available: v$latest_version (current: v$AETHER_VERSION)\e[0m"
        echo -e "\e[33m   Download: https://github.com/lonersoft/aether/releases/latest\e[0m"
        echo -e "\e[1;36m \e[0m"
    else
        printout success "aether is up to date (v$AETHER_VERSION)"
        echo -e "\e[1;36m \e[0m"
    fi
}
