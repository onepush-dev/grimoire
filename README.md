# Grimoire on Railway

[Grimoire](https://github.com/goniszewski/grimoire) (MIT): a local-first bookmark manager with imports, readable-content extraction, keyword + semantic search and optional AI tagging (OpenAI, Ollama or any compatible API). Deploy it on Railway with one click, behind a password.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/HXHlzd)

## What this template runs
- **grimoire**: `ghcr.io/onepush-dev/grimoire:1.4.0`, the official `goniszewski/grimoire:1.4.0` image (application unmodified) plus the official Caddy 2.11.9 binary.
  - Grimoire is single-user and upstream says public exposure is **not** a supported mode, so the daemon listens on `127.0.0.1:3210` inside the container only.
  - Caddy is the only listener (port 8080) and requires HTTP basic auth on every route except the `/health` probe.
  - One volume at `/data` holds the SQLite library, settings and backups.

## Variables
| Variable | Value |
|---|---|
| `GRIMOIRE_PASSWORD` | generated password for the basic-auth prompt (user `admin`) |
| `CORS_ORIGINS` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` (the browser origin Grimoire trusts for writes) |

Optional: change the login name with `GRIMOIRE_USERNAME`; seed AI with `LLM_API_KEY`, `LLM_MODEL`, `EMBEDDING_API_KEY`, `EMBEDDING_MODEL` (or set them in the app's settings). If you add a custom domain, add it to `CORS_ORIGINS` (comma-separated).

Not affiliated with Grimoire.

### MCP, capture and the browser extension
Requests to `/mcp`, `/capture` and `/integrations/browser/v1/*` that carry `Authorization: Bearer <token>` skip the basic-auth prompt and go straight to Grimoire, which accepts only its own managed integration tokens (create them in Grimoire's settings). Everything else needs the basic-auth login.
