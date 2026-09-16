#!/usr/bin/env bash
# Call the FadeHost MCP endpoint with the token from .fadehost.env (gitignored).
# Usage:
#   tools/fadehost-mcp.sh tools/list
#   tools/fadehost-mcp.sh tools/call '{"name":"get_console_logs","arguments":{}}'
# Prints the JSON-RPC result. The token never appears on the command line.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TOKEN="$(sed -n 's/^token=//p' "$ROOT/.fadehost.env" | tr -d '"\r ')"
[ -n "$TOKEN" ] || { echo "no token in .fadehost.env" >&2; exit 1; }
METHOD="${1:?method, e.g. tools/list or tools/call}"
PARAMS="${2:-{\}}"
curl -sS -m 30 https://api.fadehost.com/mcp \
  -H "X-API-Key: $TOKEN" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"$METHOD\",\"params\":$PARAMS}" \
  | sed -n 's/^data: //p; /^{/p' | head -n 1
