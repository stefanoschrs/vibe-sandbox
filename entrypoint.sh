#!/bin/bash
set -e

# — Optional runtime installs
if [ "$INSTALL_RTK" = "true" ]; then
  echo "Installing RTK..."
  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
fi

if [ "$INSTALL_OPENSPEC" = "true" ]; then
  echo "Installing OpenSpec..."
  npm install -g @fission-ai/openspec@latest
fi

# — Check for updates
echo "Checking for updates..."

# Codex (npm-based)
codex_current=$(codex --version 2>/dev/null | awk '{print $NF}')
codex_latest=$(npm view @openai/codex version 2>/dev/null)
if [ -n "$codex_current" ] && [ -n "$codex_latest" ] && [ "$codex_current" != "$codex_latest" ]; then
  echo "📦 Codex update available: $codex_current → $codex_latest (run: npm i -g @openai/codex)"
fi

# Claude Code (npm-based)
claude_current=$(claude --version 2>/dev/null | awk '{print $1}')
claude_latest=$(npm view @anthropic-ai/claude-code version 2>/dev/null)
if [ -n "$claude_current" ] && [ -n "$claude_latest" ] && [ "$claude_current" != "$claude_latest" ]; then
  echo "📦 Claude Code update available: $claude_current → $claude_latest (run: claude update)"
fi

# Cursor Agent
agent_current=$(agent --version 2>/dev/null | head -1)
agent_latest=$(curl -fsSL https://cursor.com/api/cli/latest-version 2>/dev/null)
if [ -n "$agent_current" ] && [ -n "$agent_latest" ] && [ "$agent_current" != "$agent_latest" ]; then
  echo "📦 Cursor Agent update available: $agent_current → $agent_latest (run: curl https://cursor.com/install -fsS | bash)"
fi

echo ""

# — Write aliases to .bashrc so they persist in the interactive session
cat >> /root/.bashrc <<'ALIASES'
alias claudee='IS_SANDBOX=1 claude --dangerously-skip-permissions'
alias codexx='codex --dangerously-bypass-approvals-and-sandbox'
alias agentt='agent --yolo'
ALIASES

exec "$@"
