# 0005: Free cloud harness via GitHub Codespaces

Date: 2026-11-19. Status: accepted (active path).

## Decision

- Use GitHub Codespaces as the active cloud harness when the local PC is off.
- Run OpenCode there with a direct Token Harbor provider using a Codespaces secret.
- Do not depend on the local FreeLLMAPI desktop service in the cloud.
- Keep ADR 0004 (Windows VM) as the path for full MAUS Bot GUI/computer use.

## Why

- No credit card and no paid plan required for a personal Codespace.
- Verified locally: OpenCode answers with `tokenharbor/deepseek-v4.1-flash:free`
  (`TH_DIRECT_OK`).
- OpenCode's own `opencode/*` free models return "Free usage limit reached", so they
  cannot be the cloud model source.
- Azure signup is blocked: `beaconite.edu.pk` is not a registered academic domain.
- A Cloudflare tunnel to the local PC was rejected because it still needs the PC on.

## Consequences

- Cloud access is free but limited to 120 core-hours/month and an idle timeout.
- The SuperBot server can also run there (`SCREENS=off`); GUI computer use cannot.
- Secrets live only in GitHub Codespaces secrets, never in the repo.
