#!/bin/bash

function install_java {
    if [ -z "$JAVA_VERSION" ]; then
        printout error "Oops! You met an error that occurred while installing Java."
        printout error "Please specify the desired Java version using the JAVA_VERSION environment variable."
        printout solution "This can be done by going to the Startup tab of your server and selecting a Java version from the dropdown menu."
        printout solution "If you need further assistance, please contact support."
        exit 1
    fi
    if [ ! -d "$HOME/.sdkman" ]; then
        curl -s "https://get.sdkman.io" | bash >/dev/null 2>&1
    fi
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk update >/dev/null 2>&1
    sdk selfupdate >/dev/null 2>&1
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
        printout error "Oops! You met an error that occurred while installing Java."
        printout error "Please specify the desired Java version using the JAVA_VERSION environment variable."
        printout solution "This can be done by going to the Startup tab of your server and selecting a Java version from the dropdown menu."
        printout solution "If you need further assistance, please contact support."
        exit 1
        ;;
    esac
    if [ -z "$JAVA_VERSION_S" ]; then
        clear
        display
        check_aether_updates
        printout error "Oops! You met an error that occurred while installing Java $JAVA_VERSION."
        printout error "Please report this issue to the support team and share this error message:"
        printout error "The JAVA_VERSION_S variable is empty, which cannot continue the Java Installation section."
        exit 1
    fi
    if sdk current java | grep -q "$JAVA_VERSION"; then
        printout info "Java $JAVA_VERSION is already installed."
    else
        printout info "Installing Java $JAVA_VERSION_S..."
        if [ -n "$(sdk current java)" ]; then
            OLD_VERSION=$(sdk current java)
            printout info "Removing old Java version $OLD_VERSION..."
            sdk uninstall java "$OLD_VERSION"
        fi
        sdk install java "$JAVA_VERSION_S"
        printout info "Java $JAVA_VERSION_S installed successfully."
    fi
    export JAVA_HOME="$HOME/.sdkman/candidates/java/$JAVA_VERSION_S"
    export PATH="$JAVA_HOME/bin:$PATH"
}

function install_paper {
    printout info "Downloading Paper Server..."
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --fail --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/PAPER/$paper" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --fail --request GET --url "https://versions.mcjars.app/api/v2/builds/PAPER/$paper" | jq -r '.builds[0].jarUrl')
    fi
    if [ -z "$jar_url" ] || [ "$jar_url" == "null" ]; then
        printout error "Failed to fetch Paper Server jar URL. Please check your version selection and try again."
        exit 1
    fi
    curl -o server.jar "$jar_url"
    jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
    jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
    create_config "mc_java_paper"
    port_assign
    printout info "Server jar downloaded successfully (Size: $jar_size)"
    install_java
    launchJavaServer
    exit
}

function install_pufferfish {
    printout info "Downloading Pufferfish Server..."
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --fail --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/PUFFERFISH/$pufferfish" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --fail --request GET --url "https://versions.mcjars.app/api/v2/builds/PUFFERFISH/$pufferfish" | jq -r '.builds[0].jarUrl')
    fi
    if [ -z "$jar_url" ] || [ "$jar_url" == "null" ]; then
        printout error "Failed to fetch Pufferfish Server jar URL. Please check your version selection and try again."
        exit 1
    fi
    curl -o server.jar "$jar_url"
    jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
    jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
    create_config "mc_java_pufferfish"
    port_assign
    printout info "Server jar downloaded successfully (Size: $jar_size)"
    install_java
    launchJavaServer
    exit
}

function install_purpur {
    printout info "Downloading Purpur Server..."
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --fail --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/PURPUR/$purpur" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --fail --request GET --url "https://versions.mcjars.app/api/v2/builds/PURPUR/$purpur" | jq -r '.builds[0].jarUrl')
    fi
    if [ -z "$jar_url" ] || [ "$jar_url" == "null" ]; then
        printout error "Failed to fetch Purpur Server jar URL. Please check your version selection and try again."
        exit 1
    fi
    curl -o server.jar "$jar_url"
    jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
    jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
    create_config "mc_java_purpur"
    port_assign
    printout info "Server jar downloaded successfully (Size: $jar_size)"
    install_java
    launchJavaServer
    exit
}

function install_vanilla {
    printout info "Downloading Vanilla Server..."
    if [ -n "$MCJARS_API_KEY" ]; then
        jar_url=$(curl --silent --fail --request GET --header "Authorization: $MCJARS_API_KEY" --url "https://versions.mcjars.app/api/v2/builds/VANILLA/$vanilla" | jq -r '.builds[0].jarUrl')
    else
        jar_url=$(curl --silent --fail --request GET --url "https://versions.mcjars.app/api/v2/builds/VANILLA/$vanilla" | jq -r '.builds[0].jarUrl')
    fi
    if [ -z "$jar_url" ] || [ "$jar_url" == "null" ]; then
        printout error "Failed to fetch Vanilla Server jar URL. Please check your version selection and try again."
        exit 1
    fi
    curl -o server.jar "$jar_url"
    jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
    jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
    create_config "mc_java_vanilla"
    port_assign
    printout info "Server jar downloaded successfully (Size: $jar_size)"
    install_java
    launchVanillaServer
    exit
}
