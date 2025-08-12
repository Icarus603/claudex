#!/usr/bin/env bash
# Claudex PreCompact Hook - Context Preservation

MODE="$1"  # auto or manual
CLAUDEX_DATA="$HOME/.claude/claudex-data"
SESSION_DIR="$CLAUDE_PROJECT_DIR"

mkdir -p "$CLAUDEX_DATA/context"

# Read compaction details from stdin
INPUT=$(cat)
COMPACTION_REASON=$(echo "$INPUT" | jq -r '.reason // "unknown"')

echo "$(date): PreCompact triggered - Mode: $MODE, Reason: $COMPACTION_REASON" >> "$CLAUDEX_DATA/context/compaction.log"

case "$MODE" in
  "auto")
    # Automatic compaction - preserve critical context
    CRITICAL_CONTEXT=""
    
    # Preserve workflow state
    if [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ]; then
      CURRENT_PHASE=$(grep -o "Current Phase: [^,]*" "$SESSION_DIR/WORKFLOW_STATE.md" | cut -d' ' -f3- 2>/dev/null)
      CRITICAL_CONTEXT+="🎯 Workflow Phase: $CURRENT_PHASE\\n"
    fi
    
    # Preserve agent performance insights
    if [ -f "$CLAUDEX_DATA/agents/analytics.json" ]; then
      AGENT_SUMMARY=$(jq -r 'to_entries[] | select(.value.calls > 2) | "\(.key): \(.value.calls) calls"' "$CLAUDEX_DATA/agents/analytics.json" 2>/dev/null | head -3)
      if [ -n "$AGENT_SUMMARY" ]; then
        CRITICAL_CONTEXT+="🤖 Active agents: $(echo "$AGENT_SUMMARY" | tr '\\n' ', ')\\n"
      fi
    fi
    
    # Preserve recent decisions
    if [ -f "$CLAUDEX_DATA/intelligence/workflow-progression.log" ]; then
      RECENT_DECISIONS=$(tail -5 "$CLAUDEX_DATA/intelligence/workflow-progression.log" | head -3)
      if [ -n "$RECENT_DECISIONS" ]; then
        CRITICAL_CONTEXT+="📊 Recent workflow: $(echo "$RECENT_DECISIONS" | cut -d' ' -f3- | tr '\\n' '; ')\\n"
      fi
    fi
    
    # Preserve cycle warnings
    if [ -f "$CLAUDEX_DATA/state/active-cycle.json" ]; then
      CYCLE_TYPE=$(jq -r '.type // ""' "$CLAUDEX_DATA/state/active-cycle.json" 2>/dev/null)
      CYCLE_COUNT=$(jq -r '.count // 0' "$CLAUDEX_DATA/state/active-cycle.json" 2>/dev/null)
      if [ "$CYCLE_COUNT" -gt 2 ]; then
        CRITICAL_CONTEXT+="🔄 Active cycle: $CYCLE_TYPE ($CYCLE_COUNT iterations)\\n"
      fi
    fi
    
    # Save critical context
    if [ -n "$CRITICAL_CONTEXT" ]; then
      CONTEXT_BACKUP="$CLAUDEX_DATA/context/pre-compact-$(date +%Y%m%d-%H%M%S).md"
      cat > "$CONTEXT_BACKUP" << EOF
# Critical Context Preserved Before Auto-Compaction
Generated: $(date)
Reason: $COMPACTION_REASON

## Preserved Context
$(printf '%b' "$CRITICAL_CONTEXT")

## Restoration Instructions
This context should be restored after compaction to maintain Claudex intelligence continuity.
EOF
      
      source "$HOME/.claude/hooks/secure-json.sh"
      create_hook_output_json "" "🧠 Critical Context Preserved\\n\\n$CRITICAL_CONTEXT\\nContext backup: $CONTEXT_BACKUP" >&2
    fi
    ;;
    
  "manual")
    # Manual compaction - user-initiated, provide guidance
    GUIDANCE=""
    
    # Check what context exists
    if [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ]; then
      GUIDANCE+="📊 Workflow state will be preserved in WORKFLOW_STATE.md\\n"
    fi
    
    if [ -d "$CLAUDEX_DATA/agents" ] && [ "$(find "$CLAUDEX_DATA/agents" -name "*.json" | wc -l)" -gt 0 ]; then
      GUIDANCE+="🤖 Agent performance data will be preserved in ~/.claude/claudex-data/\\n"
    fi
    
    # Suggest preservation actions
    GUIDANCE+="💡 Before compacting:\\n"
    GUIDANCE+="  - Use /context-manager save to preserve project context\\n"
    GUIDANCE+="  - Use /workflow-state save to create checkpoint\\n"
    GUIDANCE+="  - Ensure important decisions are documented in project files\\n"
    
    if [ -n "$GUIDANCE" ]; then
      source "$HOME/.claude/hooks/secure-json.sh"
      create_hook_output_json "" "🗜️ Manual Compaction Guidance\\n\\n$GUIDANCE" >&2
    fi
    ;;
esac

# Create compaction log entry
LOG_ENTRY="{
  \"timestamp\": \"$(date -Iseconds)\",
  \"mode\": \"$MODE\",
  \"reason\": \"$COMPACTION_REASON\",
  \"session_dir\": \"$SESSION_DIR\",
  \"context_preserved\": $([ -n "$CRITICAL_CONTEXT" ] && echo "true" || echo "false")
}"

COMPACTION_HISTORY="$CLAUDEX_DATA/context/compaction-history.json"
if [ ! -f "$COMPACTION_HISTORY" ]; then
  echo '{"compactions": []}' > "$COMPACTION_HISTORY"
fi

jq --argjson entry "$LOG_ENTRY" '.compactions += [$entry] | .compactions = .compactions[-20:]' \
   "$COMPACTION_HISTORY" > "${COMPACTION_HISTORY}.tmp" && mv "${COMPACTION_HISTORY}.tmp" "$COMPACTION_HISTORY"

# Continue with compaction (exit 0) or provide custom instructions (stdout for custom compact)
exit 0