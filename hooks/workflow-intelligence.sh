#!/usr/bin/env bash
# Claudex Stop Hook - Workflow Intelligence & Optimization

CLAUDEX_DATA="$HOME/.claude/claudex-data"
SESSION_DIR="$CLAUDE_PROJECT_DIR"
mkdir -p "$CLAUDEX_DATA/intelligence"

# Analyze current session for patterns
WORKFLOW_ANALYSIS=""
SHOULD_CONTINUE=0

# Check for workflow state changes
if [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ]; then
  CURRENT_PHASE=$(grep -o "Current Phase: [^,]*" "$SESSION_DIR/WORKFLOW_STATE.md" | cut -d' ' -f3- 2>/dev/null || echo "unknown")
  
  # Log phase progression
  echo "$(date): Workflow phase: $CURRENT_PHASE" >> "$CLAUDEX_DATA/intelligence/workflow-progression.log"
  
  # Detect completion patterns
  case "$CURRENT_PHASE" in
    "discover")
      if [ -f "$SESSION_DIR/PRD.md" ]; then
        WORKFLOW_ANALYSIS+="✅ Discovery complete - PRD.md created\\n"
        WORKFLOW_ANALYSIS+="💡 Suggested next step: /design\\n"
        SHOULD_CONTINUE=1
      fi
      ;;
    "design") 
      if [ -f "$SESSION_DIR/SPECS.md" ]; then
        WORKFLOW_ANALYSIS+="✅ Design complete - SPECS.md created\\n"
        WORKFLOW_ANALYSIS+="💡 Suggested next step: /build\\n"
        SHOULD_CONTINUE=1
      fi
      ;;
    "build")
      # Check for build completion indicators
      if [ -f "$SESSION_DIR/package.json" ] || [ -d "$SESSION_DIR/src" ]; then
        WORKFLOW_ANALYSIS+="✅ Build progress detected\\n"
        WORKFLOW_ANALYSIS+="💡 Consider: /deploy staging\\n"
        SHOULD_CONTINUE=1
      fi
      ;;
  esac
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

# Auto-workflow suggestions based on file presence
if [ -f "$SESSION_DIR/PRD.md" ] && [ ! -f "$SESSION_DIR/SPECS.md" ]; then
  WORKFLOW_ANALYSIS+="🎯 Ready for design phase\\n"
  SHOULD_CONTINUE=1
elif [ -f "$SESSION_DIR/SPECS.md" ] && [ ! -d "$SESSION_DIR/src" ] && [ ! -f "$SESSION_DIR/package.json" ]; then
  WORKFLOW_ANALYSIS+="🎯 Ready for build phase\\n"
  SHOULD_CONTINUE=1
elif [ -d "$SESSION_DIR/src" ] && [ ! -f "$SESSION_DIR/DEPLOYMENT.md" ]; then
  WORKFLOW_ANALYSIS+="🎯 Ready for deployment setup\\n"
  SHOULD_CONTINUE=1
fi

# Quality analysis
if [ -f "$CLAUDEX_DATA/agents/analytics.json" ]; then
  TOTAL_CALLS=$(jq -r '.total_subagent_calls // 0' "$CLAUDEX_DATA/agents/analytics.json")
  if [ "$TOTAL_CALLS" -gt 10 ]; then
    WORKFLOW_ANALYSIS+="📊 $TOTAL_CALLS subagent calls this session - high activity\\n"
  fi
fi

# Generate intelligence report
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

  if [ "$SHOULD_CONTINUE" -eq 1 ]; then
    # Continue conversation with intelligence
    printf '%b' "$WORKFLOW_ANALYSIS" >&2
    echo "🧠 Workflow Intelligence Analysis complete. Check next steps above." >&2
    exit 2  # Continue conversation
  fi
fi

# Normal completion
exit 0