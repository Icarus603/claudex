#!/usr/bin/env bash
# Claudex SubagentStop Hook - Subagent Intelligence & Learning

# Read JSON input
INPUT=$(cat)
SUBAGENT=$(echo "$INPUT" | jq -r '.subagent_type // ""')

CLAUDEX_DATA="$HOME/.claude/claudex-data"
mkdir -p "$CLAUDEX_DATA/agents"

# Analyze subagent response quality and determine if continuation is needed
ANALYSIS=""
SHOULD_CONTINUE=0

# Load agent performance data
PERF_FILE="$CLAUDEX_DATA/agents/${SUBAGENT}-performance.json"
if [ -f "$PERF_FILE" ]; then
  SUCCESS_RATE=$(jq -r '.success_rate // 100' "$PERF_FILE")
  RECENT_FAILURES=$(jq -r '[.recent_calls[]? | select(.success == 0)] | length' "$PERF_FILE")
  
  # Check if agent performance is concerning
  if [ "$SUCCESS_RATE" -lt 70 ]; then
    ANALYSIS+="⚠️ Agent $SUBAGENT has low success rate (${SUCCESS_RATE}%)\\n"
    ANALYSIS+="💡 Consider providing more specific context or using Claude direct\\n"
    SHOULD_CONTINUE=1
  fi
  
  if [ "$RECENT_FAILURES" -gt 2 ]; then
    ANALYSIS+="🔴 Agent $SUBAGENT has $RECENT_FAILURES recent failures\\n"
    ANALYSIS+="💡 May need alternative approach or additional context\\n"
    SHOULD_CONTINUE=1
  fi
fi

# Agent-specific intelligence
case "$SUBAGENT" in
  "ai-ml-engineer")
    # Check if AI implementation needs validation
    SESSION_DIR="$CLAUDE_PROJECT_DIR"
    if [ -f "$SESSION_DIR/SPECS.md" ] && grep -q "AI\|ML\|LLM" "$SESSION_DIR/SPECS.md"; then
      ANALYSIS+="🤖 AI/ML implementation should be validated against SPECS.md\\n"
    fi
    ;;
  
  "qa-engineer")
    # QA often needs to ask follow-up questions
    ANALYSIS+="✅ QA analysis complete - ensure all recommendations are addressed\\n"
    ;;
  
  "software-architect")
    # Architecture often needs iteration
    if [ ! -f "$SESSION_DIR/SPECS.md" ]; then
      ANALYSIS+="🏗️ Architecture work should result in SPECS.md creation\\n"
      SHOULD_CONTINUE=1
    fi
    ;;
  
  "product-manager")
    # PM work should result in clear requirements  
    if [ ! -f "$SESSION_DIR/PRD.md" ]; then
      ANALYSIS+="📋 Product requirements should result in PRD.md creation\\n"
      SHOULD_CONTINUE=1
    fi
    ;;
esac

# Check workflow state for agent alignment
SESSION_DIR="$CLAUDE_PROJECT_DIR"
if [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ]; then
  CURRENT_PHASE=$(grep -o "Current Phase: [^,]*" "$SESSION_DIR/WORKFLOW_STATE.md" | cut -d' ' -f3- 2>/dev/null)
  
  # Validate agent use aligns with current phase
  case "$CURRENT_PHASE" in
    "discover")
      if [[ "$SUBAGENT" != "product-manager" && "$SUBAGENT" != "technical-investigator" ]]; then
        ANALYSIS+="🎯 Agent $SUBAGENT used in discovery phase - consider workflow alignment\\n"
      fi
      ;;
    "design")
      if [[ "$SUBAGENT" != "software-architect" && "$SUBAGENT" != "design-reviewer" && "$SUBAGENT" != "ai-ml-engineer" && "$SUBAGENT" != "qa-engineer" ]]; then
        ANALYSIS+="🎯 Agent $SUBAGENT used in design phase - verify alignment\\n"
      fi
      ;;
  esac
fi

# Learning opportunities detection
TOTAL_AGENTS_TODAY=$(grep "$(date +%Y-%m-%d)" "$CLAUDEX_DATA/agents/calls.log" 2>/dev/null | wc -l | tr -d ' ')
if [ "$TOTAL_AGENTS_TODAY" -gt 15 ]; then
  ANALYSIS+="📊 High agent usage today ($TOTAL_AGENTS_TODAY calls) - workflow optimization opportunity\\n"
fi

# Update subagent interaction patterns
INTERACTION_LOG="$CLAUDEX_DATA/agents/interactions.json"
if [ ! -f "$INTERACTION_LOG" ]; then
  echo '{"patterns": {}, "sequences": []}' > "$INTERACTION_LOG"
fi

# Log this interaction
jq --arg agent "$SUBAGENT" \
   --arg timestamp "$(date -Iseconds)" \
   '.sequences += [{"agent": $agent, "timestamp": $timestamp}] |
    .sequences = .sequences[-50:] |
    .patterns[$agent] += 1' \
   "$INTERACTION_LOG" > "${INTERACTION_LOG}.tmp" && mv "${INTERACTION_LOG}.tmp" "$INTERACTION_LOG"

# Generate continuation recommendation
if [ -n "$ANALYSIS" ]; then
  echo "$(date): SubagentStop analysis for $SUBAGENT: $ANALYSIS" >> "$CLAUDEX_DATA/intelligence/subagent-analysis.log"
  
  if [ "$SHOULD_CONTINUE" -eq 1 ]; then
    # Continue with subagent for clarification or improvement
    echo "🤖 Agent Intelligence ($SUBAGENT):" >&2
    echo "$ANALYSIS" >&2
    echo "Continue with this subagent for optimization or clarification." >&2
    exit 2  # Continue conversation with subagent
  else
    # Just provide intelligence without continuing
    echo "🤖 Agent Intelligence ($SUBAGENT):" >&2  
    echo "$ANALYSIS" >&2
  fi
fi

# Normal completion
exit 0