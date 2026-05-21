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
check_timeout="${UPDATE_CHECK_TIMEOUT:-5s}"

get_with_timeout() {
  timeout "$check_timeout" "$@" 2>/dev/null || true
}

if [ "$SKIP_UPDATE_CHECKS" = "true" ]; then
  echo "Skipping update checks..."
else
  echo "Checking for updates..."

  # Codex (npm-based)
  if command -v codex >/dev/null 2>&1; then
    codex_current=$(get_with_timeout codex --version | awk '{print $NF}')
    codex_latest=$(get_with_timeout npm view @openai/codex version)
    if [ -n "$codex_current" ] && [ -n "$codex_latest" ] && [ "$codex_current" != "$codex_latest" ]; then
      echo "📦 Codex update available: $codex_current → $codex_latest (run: npm i -g @openai/codex)"
    fi
  fi

  # Claude Code (npm-based)
  if command -v claude >/dev/null 2>&1; then
    claude_current=$(get_with_timeout claude --version | awk '{print $1}')
    claude_latest=$(get_with_timeout npm view @anthropic-ai/claude-code version)
    if [ -n "$claude_current" ] && [ -n "$claude_latest" ] && [ "$claude_current" != "$claude_latest" ]; then
      echo "📦 Claude Code update available: $claude_current → $claude_latest (run: claude update)"
    fi
  fi

  # Cursor Agent
  if command -v agent >/dev/null 2>&1; then
    agent_current=$(get_with_timeout agent --version | sed -n '1p')
    agent_latest=$(get_with_timeout curl -fsSL https://cursor.com/api/cli/latest-version)
    if [ -n "$agent_current" ] && [ -n "$agent_latest" ] && [ "$agent_current" != "$agent_latest" ]; then
      echo "📦 Cursor Agent update available: $agent_current → $agent_latest (run: curl https://cursor.com/install -fsS | bash)"
    fi
  fi
fi

echo ""

# — Write aliases to .bashrc so they persist in the interactive session
cat >> /root/.bashrc <<'ALIASES'
alias claudee='IS_SANDBOX=1 claude --dangerously-skip-permissions'
alias codexx='codex --dangerously-bypass-approvals-and-sandbox'
alias agentt='agent --yolo'
ALIASES

exec "$@"
