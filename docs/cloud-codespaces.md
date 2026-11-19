# Free cloud setup (GitHub Codespaces)

Runs OpenCode in GitHub's cloud with a free model. Your PC can be off.
No credit card, no paid plan, no Windows VM needed.

## Why this route

- OpenCode's own free models are exhausted on this account.
- The local FreeLLMAPI service only runs on this PC, so it cannot power a cloud harness.
- Token Harbor is reachable from anywhere with an API key. OpenCode talks to it directly.

Verified locally before adding this config:

- `opencode run -m tokenharbor/deepseek-v4.1-flash:free` -> `TH_DIRECT_OK`
- `opencode serve` with this exact config, session created over HTTP -> `CLOUD_SERVER_OK`
  (recorded model: `providerID=tokenharbor`, `id=deepseek-v4.1-flash:free`)

## One-time setup

1. In the GitHub repo: **Settings -> Secrets and variables -> Codespaces -> New repository secret**.
   - Name: `TOKENHARBOR_KEY`
   - Value: your Token Harbor key.
   - Optional second secret: `AUTH_PASSWORD` (password for the SuperBot web UI on port 3000).

2. **Code -> Codespaces -> Create codespace on main.**
   The devcontainer installs OpenCode and builds the Rust server.

3. In the Codespace terminal:

   ```bash
   bash .devcontainer/start.sh
   ```

4. In the **Ports** tab, forward `28894`, right-click it, and set **Port visibility -> Public**.
   Same for `3000` if you set `AUTH_PASSWORD`.

5. Open `https://<codespace-name>-28894.app.github.dev` from any browser or phone.
   Use the password printed in the log / `~/.local/state/opencode/service.json`.

From another terminal you can do step 4 with the CLI:

```bash
gh codespace ports visibility 28894:public
gh codespace ports visibility 3000:public
```

## Stop / restart

```bash
bash .devcontainer/stop.sh
bash .devcontainer/start.sh
```

## Limits (be honest about these)

- Personal Codespaces include **120 core-hours/month** on the 2-core machine. That is about
  5 days of continuous use, not 24/7. The 4-core option costs credits.
- Codespaces auto-stops after idle time (default 30 minutes). Change it in
  **Settings -> Codespaces -> Default idle timeout** (up to 4 hours).
- Public ports are reachable by anyone with the URL. Keep the OpenCode password set.
- Never put the key in a committed file. Only use the Codespaces secret.

## If you need true 24/7

Keep ADR 0004: an always-on Windows VM (Azure free tier for 12 months) is still the right
answer for MAUS Bot's GUI/computer-use features. Signup is currently blocked because the
academic email domain is not registered. A GitHub Student Pack or a registered academic
email unlocks it.
