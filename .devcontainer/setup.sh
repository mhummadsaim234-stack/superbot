#!/usr/bin/env bash
# Runs once when a Codespace is created. Installs OpenCode and builds SuperBot.
set -euo pipefail

echo "== Installing OpenCode"
if ! command -v opencode >/dev/null 2>&1; then
  curl -fsSL https://opencode.ai/install | bash
fi
export PATH="$HOME/.opencode/bin:$PATH"
opencode --version

echo "== Building SuperBot server"
cargo build --release

echo "== Making scripts executable"
chmod +x .devcontainer/start.sh .devcontainer/stop.sh

echo "== Done. Next: set TOKENHARBOR_KEY secret, then run: bash .devcontainer/start.sh"
