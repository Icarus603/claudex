#!/usr/bin/env bash
# Claudex UserPromptSubmit Hook - Intent Intelligence

# Read JSON input from stdin
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""')

CLAUDEX_DATA="$HOME/.claude/claudex-data"
mkdir -p "$CLAUDEX_DATA/intelligence"

# Log prompt for analysis
echo "$(date): $PROMPT" >> "$CLAUDEX_DATA/intelligence/prompts.log"

# Detect Claudex command patterns
CONTEXT=""
COMMAND_DETECTED=""

# Direct command detection
if echo "$PROMPT" | grep -q "^/\(discover\|design\|build\|deploy\|maintain\|workflow\|cycle-manager\|context-manager\|workflow-state\)"; then
  COMMAND_DETECTED=$(echo "$PROMPT" | grep -o "^/[a-z-]*" | head -1)
  CONTEXT+="🎯 Command detected: $COMMAND_DETECTED\\n"
fi

# Intent detection patterns
if echo "$PROMPT" | grep -qi "\(requirements\|user stor\|discover\|analyze\)"; then
  CONTEXT+="💡 Intent suggests: /discover\\n"
elif echo "$PROMPT" | grep -qi "\(architect\|design\|system\|component\)"; then
  CONTEXT+="💡 Intent suggests: /design\\n"
elif echo "$PROMPT" | grep -qi "\(implement\|build\|code\|develop\)"; then
  CONTEXT+="💡 Intent suggests: /build\\n"
elif echo "$PROMPT" | grep -qi "\(deploy\|production\|infrastructure\)"; then
  CONTEXT+="💡 Intent suggests: /deploy\\n"
elif echo "$PROMPT" | grep -qi "\(bug\|fix\|maintain\|performance\|optimize\)"; then
  CONTEXT+="💡 Intent suggests: /maintain\\n"
elif echo "$PROMPT" | grep -qi "\(workflow\|orchestrat\|next step\)"; then
  CONTEXT+="💡 Intent suggests: /workflow auto\\n"
fi

# Context loading based on intent
SESSION_DIR="$CLAUDE_PROJECT_DIR"
if [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ] && [ -n "$CONTEXT" ]; then
  CURRENT_PHASE=$(grep -o "Current Phase: [^,]*" "$SESSION_DIR/WORKFLOW_STATE.md" | cut -d' ' -f3- 2>/dev/null)
  if [ -n "$CURRENT_PHASE" ]; then
    CONTEXT+="📊 Current workflow phase: $CURRENT_PHASE\\n"
  fi
fi

# Check for workflow optimization opportunities
if echo "$PROMPT" | grep -qi "\(stuck\|loop\|repeat\|cycle\)"; then
  CONTEXT+="🔄 Consider: /cycle-manager analyze\\n"
fi

if echo "$PROMPT" | grep -qi "\(context\|remember\|previous\)"; then
  CONTEXT+="💭 Consider: /context-manager load\\n"
fi

# Output context enhancement
if [ -n "$CONTEXT" ]; then
  printf '{"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext": "🧠 Prompt Intelligence\n\n%s"}}\n' "$CONTEXT"
fi

# Normal processing (exit 0)
exit 0