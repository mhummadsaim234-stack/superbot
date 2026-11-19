#!/usr/bin/env bash
# Starts OpenCode in the cloud, using the free Token Harbor key from a Codespaces secret.
# Usage: TOKENHARBOR_KEY=... bash .devcontainer/start.sh
set -euo pipefail

: "${TOKENHARBOR_KEY:?Set the TOKENHARBOR_KEY Codespaces secret (Settings -> Codespaces -> Secrets).}"

export PATH="$HOME/.opencode/bin:$PATH"
PORT="${OPENCODE_PORT:-28894}"
CFG_DIR="$HOME/.config/opencode"
mkdir -p "$CFG_DIR"

cat > "$CFG_DIR/opencode.json" <<EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "model": "tokenharbor/deepseek-v4.1-flash:free",
  "provider": {
    "tokenharbor": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Token Harbor",
      "options": {
        "baseURL": "https://tokenharbor.ai/v1",
        "apiKey": "$TOKENHARBOR_KEY"
      },
      "models": {
        "deepseek-v4.1-flash:free": {
          "name": "DeepSeek V4.1 Flash (free)",
          "limit": { "context": 1048576, "output": 128000 }
        },
        "deepseek-v4.1-flash": {
          "name": "DeepSeek V4.1 Flash",
          "limit": { "context": 1048576, "output": 128000 }
        }
      }
    }
  }
}
EOF

# Stop an older server first.
pkill -f 'opencode serve' >/dev/null 2>&1 || true

LOG="${OPENCODE_LOG:-$HOME/opencode-server.log}"
nohup opencode serve --hostname 0.0.0.0 --port "$PORT" >"$LOG" 2>&1 &

echo "OpenCode started on port $PORT."
echo "Public URL: https://<codespace-name>-$PORT.app.github.dev"
echo "Make the port public from another terminal:"
echo "  gh codespace ports visibility $PORT:public"
echo "Log: $LOG"

# Optional: also expose the SuperBot server. Needs AUTH_PASSWORD as a Codespaces secret.
if [ -n "${AUTH_PASSWORD:-}" ]; then
  BOT_PORT="${BOT_PORT:-3000}"
  BOT_LOG="${BOT_LOG:-$HOME/superbot-server.log}"
  pkill -f 'target/release/botd' >/dev/null 2>&1 || true
  AUTH_PASSWORD="$AUTH_PASSWORD" HOST=0.0.0.0 PORT="$BOT_PORT" \
    SCREENS="${SCREENS:-off}" DATA_DIR="${DATA_DIR:-./data}" \
    WORKSPACE_DIR="${WORKSPACE_DIR:-./workspace}" \
    nohup ./target/release/botd >"$BOT_LOG" 2>&1 &
  echo "SuperBot server started on port $BOT_PORT."
  echo "Public URL: https://<codespace-name>-$BOT_PORT.app.github.dev"
  echo "  gh codespace ports visibility $BOT_PORT:public"
fi
