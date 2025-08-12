#!/usr/bin/env bash
# Claudex PreToolUse Hook for Task - Subagent Intelligence

# Source secure JSON functions
source "$HOME/.claude/hooks/secure-json.sh"

# Read JSON input with validation
INPUT=$(cat)
if ! echo "$INPUT" | jq empty 2>/dev/null; then
  exit 1  # Invalid JSON input
fi

SUBAGENT=$(echo "$INPUT" | jq -r '.subagent_type // ""')

CLAUDEX_DATA="$HOME/.claude/claudex-data"
mkdir -p "$CLAUDEX_DATA/agents"

# Log subagent call
echo "$(date): Pre-subagent $SUBAGENT" >> "$CLAUDEX_DATA/agents/calls.log"

# Load agent performance history
PERF_FILE="$CLAUDEX_DATA/agents/${SUBAGENT}-performance.json"
CONTEXT=""

if [ -f "$PERF_FILE" ]; then
  SUCCESS_RATE=$(jq -r '.success_rate // 0' "$PERF_FILE" 2>/dev/null || echo "0")
  LAST_FAILURE=$(jq -r '.last_failure_reason // ""' "$PERF_FILE" 2>/dev/null || echo "")
  CONTEXT_NEEDS=$(jq -r '.context_requirements // ""' "$PERF_FILE" 2>/dev/null || echo "")
  
  if [ "$SUCCESS_RATE" != "0" ]; then
    CONTEXT+="📊 Agent $SUBAGENT success rate: ${SUCCESS_RATE}%\\n"
  fi
  
  if [ -n "$LAST_FAILURE" ] && [ "$LAST_FAILURE" != "null" ]; then
    CONTEXT+="⚠️ Previous failure: $LAST_FAILURE\\n"
  fi
  
  if [ -n "$CONTEXT_NEEDS" ] && [ "$CONTEXT_NEEDS" != "null" ]; then
    CONTEXT+="📋 Context needs: $CONTEXT_NEEDS\\n"
  fi
fi

# Check workflow state for agent optimization
SESSION_DIR="$CLAUDE_PROJECT_DIR"
if [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ]; then
  WORKFLOW_PHASE=$(grep -o "Current Phase: [^,]*" "$SESSION_DIR/WORKFLOW_STATE.md" | cut -d' ' -f3- 2>/dev/null)
  if [ -n "$WORKFLOW_PHASE" ]; then
    CONTEXT+="🎯 Workflow phase: $WORKFLOW_PHASE\\n"
  fi
fi

# Agent-specific optimization
case "$SUBAGENT" in
  "ai-ml-engineer")
    # Check if AI context is available
    if [ -f "$SESSION_DIR/SPECS.md" ] && grep -q "AI\|ML\|LLM" "$SESSION_DIR/SPECS.md"; then
      CONTEXT+="🤖 AI specifications found in SPECS.md\\n"
    fi
    ;;
  "qa-engineer") 
    # Check test context
    if [ -d "$SESSION_DIR/tests" ] || [ -f "$SESSION_DIR/package.json" ]; then
      CONTEXT+="🧪 Testing context detected\\n"
    fi
    ;;
  "devops-engineer")
    # Check deployment context
    if [ -f "$SESSION_DIR/DEPLOYMENT.md" ] || [ -f "$SESSION_DIR/docker-compose.yml" ]; then
      CONTEXT+="🚀 Deployment context available\\n"
    fi
    ;;
esac

# Store pre-call timestamp for performance tracking with secure temporary file
START_TIME_FILE=$(mktemp "$CLAUDEX_DATA/agents/${SUBAGENT}-start-time.XXXXXX.tmp")
if [ $? -eq 0 ]; then
  echo "$(date +%s)" > "$START_TIME_FILE"
  chmod 600 "$START_TIME_FILE"  # Restrict permissions
  # Create a symbolic link with predictable name for cleanup
  ln -sf "$START_TIME_FILE" "$CLAUDEX_DATA/agents/${SUBAGENT}-start-time.tmp"
fi

# Output context enhancement with secure JSON encoding
if [ -n "$CONTEXT" ]; then
  ADDITIONAL_CONTEXT="🤖 Agent Intelligence ($SUBAGENT)

$CONTEXT"
  create_hook_output_json "" "$ADDITIONAL_CONTEXT" >&2
fi

# Continue with tool execution (exit 0)
exit 0