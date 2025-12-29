#!/usr/bin/env bash
set -euo pipefail

# Set default values
CORE_PEER_TLS_ENABLED="${CORE_PEER_TLS_ENABLED:-false}"
DEBUG="${DEBUG:-false}"

# Check if DEBUG mode is enabled
if [ "$DEBUG" = "true" ]; then
    npm run start:server-debug
# Check if TLS is enabled
elif [ "$CORE_PEER_TLS_ENABLED" = "true" ]; then
    npm run start:server
else
    npm run start:server-nontls
fi
