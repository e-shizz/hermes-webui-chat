#!/usr/bin/env bash
# update.sh — One-command WebUI plugin update + dashboard restart
#
# Usage:
#   cd ~/.hermes/plugins/webui
#   ./scripts/update.sh
#
# Or as a shell alias (add to ~/.bashrc or ~/.zshrc):
#   alias webui-update='bash ~/.hermes/plugins/webui/scripts/update.sh'
#
# What it does:
#   1. Kills the running Hermes dashboard
#   2. Pulls latest webui plugin from git
#   3. Applies core dashboard patches (idempotent)
#   4. Restarts the dashboard
#
# All output is printed so you can see if anything goes wrong.

set -euo pipefail

PLUGIN_DIR="${PLUGIN_DIR:-$HOME/.hermes/plugins/webui}"

echo "=== Hermes WebUI Plugin Updater ==="
echo ""

# 1. Kill dashboard
echo "💥 Killing Hermes dashboard..."
pkill -f "hermes dashboard" 2>/dev/null || echo "   (no dashboard running)"
sleep 1

# 2. Pull latest
echo ""
echo "🛍️ Pulling latest WebUI plugin..."
cd "$PLUGIN_DIR"
git pull

# 3. Re-apply core patches (idempotent — safe to run every time)
echo ""
echo "🔧 Applying core dashboard patches..."
if [ -x "./scripts/apply-core-patches.sh" ]; then
    ./scripts/apply-core-patches.sh
else
    echo "   ⚠️ Patch script not found, skipping"
fi

# 4. Restart dashboard
echo ""
echo "🚀 Starting Hermes dashboard..."
nohup hermes dashboard >/dev/null 2>&1 &

sleep 2
DASH_PID=$(pgrep -f "hermes dashboard" || true)
if [ -n "$DASH_PID" ]; then
    echo "✅ Dashboard running (PID $DASH_PID)"
    echo "   http://localhost:8000"
else
    echo "❌ Dashboard failed to start. Try running 'hermes dashboard' manually."
    exit 1
fi

echo ""
echo "Done~! (◕‿◕)☆"
