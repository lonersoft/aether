#!/bin/bash
# based from https://github.com/mcjars/pterodactyl-yolks

function update_server {
    printout info "Checking for updates..."
	echo "DEBUG: Starting update check" >&2

	# Hash server jar file
	if [ -z "${HASH}" ]; then
		echo "DEBUG: Computing hash for server.jar..." >&2
		HASH=$(sha256sum server.jar | awk '{print $1}')
		echo "DEBUG: Hash computed: $HASH" >&2
	fi

	# Check if hash is set
	if [ -n "${HASH}" ]; then
		echo "DEBUG: Making API call to mcjars.app..." >&2
		API_RESPONSE=$(curl --connect-timeout 4 -s "https://mcjars.app/api/v1/build/$HASH")
		echo "DEBUG: API response received" >&2
		echo "DEBUG: Response: $API_RESPONSE" >&2

		# Check if .success is true
		if [ "$(echo $API_RESPONSE | jq -r '.success')" = "true" ]; then
			if [ "$(echo $API_RESPONSE | jq -r '.build.id')" != "$(echo $API_RESPONSE | jq -r '.latest.id')" ]; then
				printout info "New build found. Updating server..."

				BUILD_ID=$(echo $API_RESPONSE | jq -r '.latest.id')
				bash <(curl -s "https://mcjars.app/api/v1/script/$BUILD_ID/bash?echo=false")

                jar_bytes=$(stat -c%s server.jar 2>/dev/null || stat -f%z server.jar 2>/dev/null)
                jar_size=$(printf "%.2f MB" $((jar_bytes / 1000000)))
				printout info "Server has been updated (Size: $jar_size)"
			else
				printout info "Server is up to date"
			fi
		else
			printout info "Could not check for updates. Skipping update check."
		fi
	else
		printout info "Could not find hash. Skipping update check."
	fi
}