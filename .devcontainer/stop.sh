#!/usr/bin/env bash
# Stops the cloud OpenCode server.
set -euo pipefail
pkill -f 'opencode serve' >/dev/null 2>&1 || true
echo "OpenCode stopped."
