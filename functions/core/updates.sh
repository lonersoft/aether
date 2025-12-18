#!/bin/bash

check_aether_updates() {
    if [ "$DISABLE_UPDATES" == "1" ]; then
        printout warning "The administrator has disabled update checks. This means some features may not work as expected."
        printout warning "If you are an administrator, you can enable update checks by setting DISABLE_UPDATES to 0."
        printout warning ""
        return
    fi

    local github_api_url="https://api.github.com/repos/lonersoft/aether/releases/latest"
    
    printout info "Checking for aether updates... this may take a while"
    
    # Fetch latest release info from GitHub using jq
    local release_data latest_version published_date
    release_data=$(curl -s --max-time 5 --connect-timeout 5 "$github_api_url" 2>/dev/null)
    latest_version=$(echo "$release_data" | jq -r '.tag_name' 2>/dev/null)
    published_date=$(echo "$release_data" | jq -r '.published_at' 2>/dev/null)
    
    if [ -z "$latest_version" ] || [ "$latest_version" == "null" ]; then
        printout warning "Unable to check for updates (network issue)."
        echo -e "\e[1;36m \e[0m"
        return
    fi

    if [ -z "$AETHER_VERSION" ]; then
        printout warning "Current aether version is unknown. Cannot check for updates."
        printout warning "If you are an administrator, please update the egg to get the latest features and fixes."
        printout warning "Download it here: https://github.com/lonersoft/aether/releases/latest"
        echo -e "\e[1;36m \e[0m"
        return
    fi
    
    # Remove 'v' prefix if present for comparison
    latest_version=${latest_version#v}
    
    if [ "$AETHER_VERSION" != "$latest_version" ]; then
        # Parse version numbers (major.minor.patch)
        local current_major current_minor current_patch
        local latest_major latest_minor latest_patch
        
        IFS='.' read -r current_major current_minor current_patch <<< "$AETHER_VERSION"
        IFS='.' read -r latest_major latest_minor latest_patch <<< "$latest_version"
        
        # Default to 0 if not set
        current_major=${current_major:-0}
        current_minor=${current_minor:-0}
        current_patch=${current_patch:-0}
        latest_major=${latest_major:-0}
        latest_minor=${latest_minor:-0}
        latest_patch=${latest_patch:-0}
        
        if [ "$latest_major" -gt "$current_major" ]; then
            # Major version update - check publish date
            local published_epoch current_epoch days_old
            
            # Parse published date (format: 2025-12-18T10:30:00Z)
            published_date=${published_date%T*}
            published_epoch=$(date -d "$published_date" +%s 2>/dev/null || date -jf "%Y-%m-%d" "$published_date" +%s 2>/dev/null)
            current_epoch=$(date +%s)
            days_old=$(( (current_epoch - published_epoch) / 86400 ))
            
            if [ "$days_old" -lt 7 ]; then
                local days_remaining=$(( 7 - days_old ))
                printout warning "A major version update is available: v$latest_version (current: v$AETHER_VERSION)"
                printout warning "This version will be required in $days_remaining day(s)."
                printout warning "   Download: https://github.com/lonersoft/aether/releases/latest"
            else
                printout error "A required major version update is available: v$latest_version"
                printout error "This version is now required and must be updated immediately."
                printout error "   Download: https://github.com/lonersoft/aether/releases/latest"
                exit 1
            fi
        else
            # Minor/patch version update
            printout warning "A new version of aether is available: v$latest_version (current: v$AETHER_VERSION)"
            printout warning "   Download: https://github.com/lonersoft/aether/releases/latest"
        fi
        echo -e "\e[1;36m \e[0m"
    else
        printout success "aether is up to date (v$AETHER_VERSION)"
        echo -e "\e[1;36m \e[0m"
    fi
}
