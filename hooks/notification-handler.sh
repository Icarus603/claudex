#!/usr/bin/env bash
# Claudex Notification Hook - Convert Notifications to Workflow Intelligence

# Read JSON input
INPUT=$(cat)
NOTIFICATION=$(echo "$INPUT" | jq -r '.notification // ""')

CLAUDEX_DATA="$HOME/.claude/claudex-data"
mkdir -p "$CLAUDEX_DATA/intelligence"

# Log notification
echo "$(date): Notification: $NOTIFICATION" >> "$CLAUDEX_DATA/intelligence/notifications.log"

# Analyze notification for workflow intelligence
INTELLIGENCE=""

# Permission request notifications
if echo "$NOTIFICATION" | grep -qi "permission.*tool"; then
  TOOL=$(echo "$NOTIFICATION" | grep -o "tool [^[:space:]]*" | cut -d' ' -f2)
  INTELLIGENCE+="🔐 Permission requested for: $TOOL\\n"
  
  # Provide context based on tool
  case "$TOOL" in
    "Task")
      INTELLIGENCE+="💡 Subagent call - check /pre-subagent hook for optimization\\n"
      ;;
    "Write"|"Edit"|"MultiEdit")
      INTELLIGENCE+="📝 File modification - ensure alignment with workflow state\\n"
      ;;
    "Bash")
      INTELLIGENCE+="⚡ Command execution - verify safety and necessity\\n"
      ;;
  esac
fi

# Waiting for input notifications
if echo "$NOTIFICATION" | grep -qi "waiting.*input"; then
  INTELLIGENCE+="⏳ Waiting for user input\\n"
  INTELLIGENCE+="💡 Consider: /workflow auto for guided next steps\\n"
fi

# Error or failure notifications
if echo "$NOTIFICATION" | grep -qi "error\|failed\|unable"; then
  INTELLIGENCE+="❌ Error detected in notification\\n"
  INTELLIGENCE+="💡 Consider: /cycle-manager analyze for debugging\\n"
  
  # Log error for pattern analysis
  echo "$(date): ERROR: $NOTIFICATION" >> "$CLAUDEX_DATA/intelligence/errors.log"
fi

# Resource or context notifications
if echo "$NOTIFICATION" | grep -qi "context.*full\|memory.*limit"; then
  INTELLIGENCE+="🧠 Context/memory constraints detected\\n"
  INTELLIGENCE+="💡 Consider: /context-manager save before continuing\\n"
fi

# Workflow guidance notifications
if echo "$NOTIFICATION" | grep -qi "complete\|finished\|done"; then
  INTELLIGENCE+="✅ Task completion detected\\n"
  INTELLIGENCE+="💡 Ready for next workflow phase\\n"
fi

# Output intelligence if any found
if [ -n "$INTELLIGENCE" ]; then
  source "$HOME/.claude/hooks/secure-json.sh"
  create_hook_output_json "" "🔔 Notification Intelligence\\n\\n$INTELLIGENCE" >&2
fi

# Continue processing (exit 0)
exit 0