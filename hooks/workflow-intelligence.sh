#!/usr/bin/env bash
# Claudex Stop Hook - Workflow Intelligence & Optimization

CLAUDEX_DATA="$HOME/.claude/claudex-data"
SESSION_DIR="$CLAUDE_PROJECT_DIR"
mkdir -p "$CLAUDEX_DATA/intelligence"

# Analyze current session for patterns
WORKFLOW_ANALYSIS=""
SHOULD_CONTINUE=0

# Check for workflow state changes (if WORKFLOW_STATE.md exists)
if [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ]; then
  CURRENT_PHASE=$(grep -o "Current Phase: [^,]*" "$SESSION_DIR/WORKFLOW_STATE.md" | cut -d' ' -f3- 2>/dev/null || echo "unknown")
  
  # Log phase progression
  echo "$(date): Workflow phase: $CURRENT_PHASE" >> "$CLAUDEX_DATA/intelligence/workflow-progression.log"
fi

# Analyze recent subagent activity for patterns
RECENT_AGENTS=$(tail -10 "$CLAUDEX_DATA/agents/calls.log" 2>/dev/null | grep -o "subagent [^-]*" | cut -d' ' -f2 | sort | uniq -c | sort -rn)
if [ -n "$RECENT_AGENTS" ]; then
  MOST_USED=$(echo "$RECENT_AGENTS" | head -1 | awk '{print $2}')
  USAGE_COUNT=$(echo "$RECENT_AGENTS" | head -1 | awk '{print $1}')
  
  if [ "$USAGE_COUNT" -gt 2 ]; then
    WORKFLOW_ANALYSIS+="🤖 Heavy $MOST_USED usage ($USAGE_COUNT calls) - check efficiency\\n"
  fi
fi

# Check for cycle patterns
CYCLE_DETECTION=$(grep -c "$(date +%Y-%m-%d)" "$CLAUDEX_DATA/intelligence/workflow-progression.log" 2>/dev/null || echo "0")
if [ "$CYCLE_DETECTION" -gt 5 ]; then
  WORKFLOW_ANALYSIS+="🔄 High workflow activity today - potential cycling detected\\n"
  WORKFLOW_ANALYSIS+="💡 Consider: /cycle-manager analyze\\n"
  SHOULD_CONTINUE=1
fi

# Check for context gaps (only if we've been using Claudex commands)
if [ ! -f "$CLAUDEX_DATA/context/project-context.md" ] && [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ]; then
  WORKFLOW_ANALYSIS+="💭 Missing project context - consider /context-manager save\\n"
fi

# Intelligent workflow progression (trigger on command completion, not file existence)
SUGGESTION_CACHE="$CLAUDEX_DATA/intelligence/session-suggestions.log"
CURRENT_TIME=$(date +%s)
SESSION_ID="$(date +%Y%m%d-%H%M)"  # Unique per session

# Check if we already suggested this in current session
check_session_suggestion() {
  local suggestion="$1"
  if [ -f "$SUGGESTION_CACHE" ]; then
    if grep -q "^$SESSION_ID:$suggestion$" "$SUGGESTION_CACHE" 2>/dev/null; then
      return 0  # Already suggested this session
    fi
  fi
  return 1  # Not suggested this session
}

# Log suggestion for current session
log_session_suggestion() {
  local suggestion="$1"
  echo "$SESSION_ID:$suggestion" >> "$SUGGESTION_CACHE"
  # Keep only current day's entries
  grep "^$(date +%Y%m%d)" "$SUGGESTION_CACHE" > "$SUGGESTION_CACHE.tmp" 2>/dev/null && mv "$SUGGESTION_CACHE.tmp" "$SUGGESTION_CACHE" || touch "$SUGGESTION_CACHE"
}

# Detect recent command completion patterns (not just file existence)
RECENT_COMMANDS=$(tail -5 "$CLAUDEX_DATA/agents/calls.log" 2>/dev/null | grep "$(date +%Y-%m-%d)" | tail -3)
COMMAND_COMPLETION_DETECTED=0

if echo "$RECENT_COMMANDS" | grep -q "product-manager\|technical-investigator" && [ -f "$SESSION_DIR/PRD.md" ] && [ ! -f "$SESSION_DIR/SPECS.md" ]; then
  if ! check_session_suggestion "design_ready"; then
    WORKFLOW_ANALYSIS+="🎯 Discovery complete - ready for design phase\\n"
    WORKFLOW_ANALYSIS+="💡 Suggest: /design to create technical architecture\\n"
    SHOULD_CONTINUE=1
    COMMAND_COMPLETION_DETECTED=1
    log_session_suggestion "design_ready"
  fi
elif echo "$RECENT_COMMANDS" | grep -q "software-architect\|design-reviewer" && [ -f "$SESSION_DIR/SPECS.md" ] && [ ! -d "$SESSION_DIR/src" ]; then
  if ! check_session_suggestion "build_ready"; then
    WORKFLOW_ANALYSIS+="🎯 Design complete - ready for build phase\\n"
    WORKFLOW_ANALYSIS+="💡 Suggest: /build to start implementation\\n"
    SHOULD_CONTINUE=1
    COMMAND_COMPLETION_DETECTED=1
    log_session_suggestion "build_ready"
  fi
fi

# Quality analysis
if [ -f "$CLAUDEX_DATA/agents/analytics.json" ]; then
  TOTAL_CALLS=$(jq -r '.total_subagent_calls // 0' "$CLAUDEX_DATA/agents/analytics.json")
  if [ "$TOTAL_CALLS" -gt 10 ]; then
    WORKFLOW_ANALYSIS+="📊 $TOTAL_CALLS subagent calls this session - high activity\\n"
  fi
fi

# Generate intelligence report only if there's analysis to report
if [ -n "$WORKFLOW_ANALYSIS" ]; then
  REPORT_FILE="$CLAUDEX_DATA/intelligence/session-$(date +%Y%m%d-%H%M%S).md"
  cat > "$REPORT_FILE" << EOF
# Workflow Intelligence Report
Generated: $(date)

## Analysis
$WORKFLOW_ANALYSIS

## Recommendations
- Use \`/workflow auto\` for guided development
- Check \`/cycle-manager analyze\` if stuck in loops  
- Use \`/context-manager save\` to preserve progress

## Session Stats
- Subagent calls: $(grep -c "Post-subagent" "$CLAUDEX_DATA/agents/calls.log" 2>/dev/null || echo "0")
- Workflow phases: $(grep -c "Workflow phase" "$CLAUDEX_DATA/intelligence/workflow-progression.log" 2>/dev/null || echo "0")
EOF

  # Only show output if we have meaningful suggestions
  if [ "$SHOULD_CONTINUE" -eq 1 ]; then
    printf '%b' "$WORKFLOW_ANALYSIS" >&2
    echo "🧠 Workflow Intelligence Analysis complete. Check next steps above." >&2
  fi
fi

# Normal completion
exit 0