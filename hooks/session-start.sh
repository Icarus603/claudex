#!/usr/bin/env bash
# Claudex SessionStart Hook - Intelligent Context Loading

# Source secure JSON functions
source "$HOME/.claude/hooks/secure-json.sh"

MODE="$1"  # startup or resume
SESSION_DIR="$CLAUDE_PROJECT_DIR"
CLAUDEX_DATA="$HOME/.claude/claudex-data"

# Debounce mechanism to prevent duplicate outputs
DEBOUNCE_FILE="$CLAUDEX_DATA/last-session-output"
CURRENT_TIME=$(date +%s)

# Check if we output recently (within 2 seconds)
if [ -f "$DEBOUNCE_FILE" ]; then
  LAST_OUTPUT=$(cat "$DEBOUNCE_FILE" 2>/dev/null || echo "0")
  TIME_DIFF=$((CURRENT_TIME - LAST_OUTPUT))
  if [ "$TIME_DIFF" -lt 2 ]; then
    exit 0  # Skip duplicate output
  fi
fi

# Record this output time
echo "$CURRENT_TIME" > "$DEBOUNCE_FILE"

# Create data directories
mkdir -p "$CLAUDEX_DATA"/{context,metrics,state,learning}

# Log session start
echo "$(date): Session $MODE started in $SESSION_DIR" >> "$CLAUDEX_DATA/sessions.log"

case "$MODE" in
  "startup")
    CONTEXT=""
    
    # Check for existing Claudex artifacts
    if [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ]; then
      CONTEXT+="📊 Workflow state found - project in progress.\\n"
      # Safely extract phase information with input sanitization
      if PHASE=$(grep "^Current Phase: " "$SESSION_DIR/WORKFLOW_STATE.md" 2>/dev/null | head -1 | sed 's/^Current Phase: //' | sed 's/[^a-zA-Z0-9_-]//g'); then
        [ -n "$PHASE" ] && CONTEXT+="🎯 Current phase: $PHASE\\n"
      fi
    fi
    
    if [ -f "$SESSION_DIR/PRD.md" ]; then
      CONTEXT+="📋 Requirements: PRD.md\\n"
    fi
    
    if [ -f "$SESSION_DIR/SPECS.md" ]; then
      CONTEXT+="🏗️ Architecture: SPECS.md\\n"
    fi
    
    if [ -f "$SESSION_DIR/DEPLOYMENT.md" ]; then
      CONTEXT+="🚀 Deployment ready\\n"
    fi
    
    # Git activity check with path validation
    if [ -d "$SESSION_DIR/.git" ] && [ -n "$SESSION_DIR" ] && [[ "$SESSION_DIR" = /* ]]; then
      # Validate SESSION_DIR is absolute path and contains only safe characters
      if [[ "$SESSION_DIR" =~ ^[a-zA-Z0-9/_.-]+$ ]]; then
        COMMITS=$(cd "$SESSION_DIR" && git rev-list --count HEAD --since="1 week ago" 2>/dev/null | grep -E '^[0-9]+$' || echo "0")
        if [ "$COMMITS" -gt 0 ] && [ "$COMMITS" -le 10000 ]; then
          CONTEXT+="🔄 $COMMITS commits this week\\n"
        fi
      fi
    fi
    
    # Load agent performance
    if [ -f "$CLAUDEX_DATA/context/agent-performance.json" ]; then
      CONTEXT+="🤖 Agent performance history loaded\\n"
    fi
    
    CONTEXT+="⚡ Claudex commands: /discover /design /build /deploy /maintain\\n"
    CONTEXT+="🔄 Orchestration: /workflow /cycle-manager /context-manager /workflow-state\\n"
    
    if [ -n "$CONTEXT" ]; then
      # Use secure JSON encoding instead of string concatenation
      MESSAGE="🚀 Claudex Intelligence Active

${CONTEXT}Ready for intelligent development workflow."
      create_system_message_json "$MESSAGE"
    fi
    ;;
    
  "resume")
    CONTEXT=""
    
    # Check for interrupted workflows
    if [ -f "$SESSION_DIR/.claudex-checkpoint" ]; then
      CHECKPOINT=$(cat "$SESSION_DIR/.claudex-checkpoint")
      CONTEXT+="⏸️ Resuming: $CHECKPOINT\\n"
    fi
    
    # Check active cycles
    if [ -f "$CLAUDEX_DATA/state/active-cycle.json" ]; then
      CONTEXT+="🔄 Active cycle detected\\n"
    fi
    
    # Session gap analysis
    LAST_SESSION=$(grep "Session.*started" "$CLAUDEX_DATA/sessions.log" 2>/dev/null | tail -2 | head -1 | cut -d' ' -f1-2)
    if [ -n "$LAST_SESSION" ]; then
      DURATION=$(( $(date +%s) - $(date -d "$LAST_SESSION" +%s 2>/dev/null || echo 0) ))
      if [ "$DURATION" -gt 86400 ]; then
        CONTEXT+="⚠️ Long gap ($((DURATION/3600))h) - context refresh recommended\\n"
      fi
    fi
    
    if [ -n "$CONTEXT" ]; then
      # Use secure JSON encoding instead of string concatenation
      MESSAGE="🔄 Resuming Claudex

${CONTEXT}Use /workflow-state resume for full restoration."
      create_system_message_json "$MESSAGE"
    fi
    ;;
esac