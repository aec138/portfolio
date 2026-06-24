#!/usr/bin/env bash
# Usage:
#   ./scripts/fetch-figma.sh <figma-file-url-or-key>
#   ./scripts/fetch-figma.sh <figma-file-url-or-key> <node-id> <output-filename>
#
# Examples:
#   List all exportable images in a file:
#     ./scripts/fetch-figma.sh https://www.figma.com/design/abc123/My-Portfolio
#
#   Export a specific node to assets/:
#     ./scripts/fetch-figma.sh https://www.figma.com/design/abc123/My-Portfolio 12:34 hero.png

set -euo pipefail

# ── Load token from .env ──────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"
if [[ -f "$ENV_FILE" ]]; then
  FIGMA_ACCESS_TOKEN="$(grep '^FIGMA_ACCESS_TOKEN=' "$ENV_FILE" | cut -d= -f2-)"
fi

if [[ -z "${FIGMA_ACCESS_TOKEN:-}" ]]; then
  echo "Error: FIGMA_ACCESS_TOKEN not set in .env" >&2
  exit 1
fi

# ── Parse file key from URL or raw key ───────────────────────────────────────
INPUT="${1:-}"
if [[ -z "$INPUT" ]]; then
  echo "Usage: $0 <figma-file-url-or-key> [node-id] [output-filename]" >&2
  exit 1
fi

# Extract key from URL like https://www.figma.com/design/KEY/name or /file/KEY/name
FILE_KEY="$(echo "$INPUT" | sed -E 's|.*figma\.com/(design\|file)/([^/?]+).*|\2|')"
if [[ "$FILE_KEY" == "$INPUT" ]]; then
  FILE_KEY="$INPUT"  # assume it's already a bare key
fi

NODE_ID="${2:-}"
OUTPUT="${3:-}"
ASSETS_DIR="$SCRIPT_DIR/../assets"

# ── Helpers ───────────────────────────────────────────────────────────────────
figma_get() {
  curl -s -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN" "https://api.figma.com/v1/$1"
}

# ── Single node export ────────────────────────────────────────────────────────
if [[ -n "$NODE_ID" ]]; then
  DEST="$ASSETS_DIR/${OUTPUT:-$(echo "$NODE_ID" | tr ':' '-').png}"
  echo "Fetching export URL for node $NODE_ID..."
  # URL-encode the node id (: → %3A)
  ENCODED_ID="$(echo "$NODE_ID" | sed 's/:/%3A/g')"
  RESP="$(figma_get "images/$FILE_KEY?ids=$ENCODED_ID&format=png&scale=2")"
  URL="$(echo "$RESP" | python3 -c "import sys,json; d=json.load(sys.stdin)['images']; print(list(d.values())[0])")"
  if [[ -z "$URL" || "$URL" == "null" ]]; then
    echo "Error: Could not get export URL. Response:" >&2
    echo "$RESP" >&2
    exit 1
  fi
  echo "Downloading → $DEST"
  curl -L -o "$DEST" "$URL"
  echo "Done."
  exit 0
fi

# ── List mode: show all top-level frames ──────────────────────────────────────
echo "Fetching file: $FILE_KEY"
RESP="$(figma_get "files/$FILE_KEY?depth=1")"

echo ""
echo "File name: $(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['name'])")"
echo ""
echo "Top-level frames (use the ID to export a specific node):"
echo "──────────────────────────────────────────────────────────"
echo "$RESP" | python3 -c "
import sys, json
data = json.load(sys.stdin)
pages = data.get('document', {}).get('children', [])
for page in pages:
    print(f\"  Page: {page['name']}\")
    for child in page.get('children', []):
        nid = child['id']
        name = child['name']
        ntype = child['type']
        print(f\"    [{nid}]  {name}  ({ntype})\")
"
echo ""
echo "To export a node:"
echo "  ./scripts/fetch-figma.sh $INPUT <node-id> <filename.png>"
