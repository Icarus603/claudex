#!/usr/bin/env bash
# Claudex SessionStart Hook - Intelligent Context Loading

MODE="$1"  # startup or resume
SESSION_DIR="$CLAUDE_PROJECT_DIR"
CLAUDEX_DATA="$HOME/.claude/claudex-data"

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
      PHASE=$(grep -o "Current Phase: [^,]*" "$SESSION_DIR/WORKFLOW_STATE.md" | cut -d' ' -f3- 2>/dev/null || echo "unknown")
      CONTEXT+="🎯 Current phase: $PHASE\\n"
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
    
    # Git activity check
    if [ -d "$SESSION_DIR/.git" ]; then
      COMMITS=$(cd "$SESSION_DIR" && git rev-list --count HEAD --since="1 week ago" 2>/dev/null || echo "0")
      if [ "$COMMITS" -gt 0 ]; then
        CONTEXT+="🔄 $COMMITS commits this week\\n"
      fi
    fi
    
    # Load agent performance
    if [ -f "$CLAUDEX_DATA/context/agent-performance.json" ]; then
      CONTEXT+="🤖 Agent performance history loaded\\n"
    fi
    
    CONTEXT+="⚡ Claudex commands: /discover /design /build /deploy /maintain\\n"
    CONTEXT+="🔄 Orchestration: /workflow /cycle-manager /context-manager /workflow-state\\n"
    
    if [ -n "$CONTEXT" ]; then
      # Escape newlines in context for proper JSON
      ESCAPED_CONTEXT=$(echo "$CONTEXT" | sed 's/$/\\n/g' | tr -d '\n')
      printf '{"systemMessage": "🚀 Claudex Intelligence Active\\n\\n%sReady for intelligent development workflow."}\n' "$ESCAPED_CONTEXT"
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
      # Escape newlines in context for proper JSON
      ESCAPED_CONTEXT=$(echo "$CONTEXT" | sed 's/$/\\n/g' | tr -d '\n')
      printf '{"systemMessage": "🔄 Resuming Claudex\\n\\n%sUse /workflow-state resume for full restoration."}\n' "$ESCAPED_CONTEXT"
    fi
    ;;
esac