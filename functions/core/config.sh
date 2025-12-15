#!/bin/bash

function create_config() {
    local type="$1"
    cat <<EOF >system/multiegg.yml
# DO NOT MODIFY OR DELETE THIS FILE! This file contains critical configuration for your server to function properly.
# Modifying or deleting this file may render your server unbootable. You have been warned.
# This file has been generated on: $(date '+%Y-%m-%d %H:%M:%S %Z')
software:
  type: $type
EOF
}
