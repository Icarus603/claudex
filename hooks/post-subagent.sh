#!/usr/bin/env bash
# Claudex PostToolUse Hook for Task - Agent Learning

# Source secure functions
source "$HOME/.claude/hooks/file-locking.sh"

# Read JSON input with validation
INPUT=$(cat)
if ! echo "$INPUT" | jq empty 2>/dev/null; then
  exit 1  # Invalid JSON input
fi

SUBAGENT=$(echo "$INPUT" | jq -r '.inputs.subagent_type // ""')
RESPONSE=$(echo "$INPUT" | jq -r '.response // ""')

CLAUDEX_DATA="$HOME/.claude/claudex-data"
mkdir -p "$CLAUDEX_DATA/agents"

# Calculate execution time
START_TIME_FILE="$CLAUDEX_DATA/agents/${SUBAGENT}-start-time.tmp"
if [ -f "$START_TIME_FILE" ]; then
  START_TIME=$(cat "$START_TIME_FILE")
  EXECUTION_TIME=$(( $(date +%s) - START_TIME ))
  rm "$START_TIME_FILE"
else
  EXECUTION_TIME=0
fi

# Analyze response quality
SUCCESS=1
QUALITY_SCORE=100

# Check for common failure patterns
if echo "$RESPONSE" | grep -qi "error\|failed\|cannot\|unable\|sorry"; then
  SUCCESS=0
  QUALITY_SCORE=20
elif [ ${#RESPONSE} -lt 100 ]; then
  QUALITY_SCORE=50
elif [ ${#RESPONSE} -lt 500 ]; then
  QUALITY_SCORE=80
fi

# Log performance data
PERF_FILE="$CLAUDEX_DATA/agents/${SUBAGENT}-performance.json"
LOG_ENTRY="{
  \"timestamp\": \"$(date -Iseconds)\",
  \"execution_time\": $EXECUTION_TIME,
  \"success\": $SUCCESS,
  \"quality_score\": $QUALITY_SCORE,
  \"response_length\": ${#RESPONSE}
}"

# Update performance history with atomic file operations
update_performance_file() {
  if [ -f "$PERF_FILE" ]; then
    # Load existing data and update
    jq --argjson new_entry "$LOG_ENTRY" '
      .total_calls += 1 |
      .successful_calls += ($new_entry.success) |
      .success_rate = (.successful_calls * 100 / .total_calls | floor) |
      .avg_execution_time = ((.avg_execution_time * (.total_calls - 1)) + $new_entry.execution_time) / .total_calls |
      .recent_calls = ([$new_entry] + .recent_calls)[:10] |
      .last_failure_reason = (if $new_entry.success == 0 then "Response quality issues detected" else .last_failure_reason end)
    ' "$PERF_FILE"
  else
    # Create new performance file structure
    jq -n --argjson new_entry "$LOG_ENTRY" --arg agent "$SUBAGENT" '{
      "agent": $agent,
      "total_calls": 1,
      "successful_calls": $new_entry.success,
      "success_rate": ($new_entry.success * 100),
      "avg_execution_time": $new_entry.execution_time,
      "recent_calls": [$new_entry],
      "last_failure_reason": (if $new_entry.success == 0 then "Response quality issues detected" else null end),
      "created": (now | strftime("%Y-%m-%dT%H:%M:%SZ"))
    }'
  fi
}

# Use atomic update with file locking
atomic_json_update "$PERF_FILE" "update_performance_file"

# Update global agent analytics
GLOBAL_ANALYTICS="$CLAUDEX_DATA/agents/analytics.json"
if [ ! -f "$GLOBAL_ANALYTICS" ]; then
  echo '{"agents": {}, "total_subagent_calls": 0}' > "$GLOBAL_ANALYTICS"
fi

jq --arg agent "$SUBAGENT" \
   --argjson success "$SUCCESS" \
   --argjson exec_time "$EXECUTION_TIME" \
   '.total_subagent_calls += 1 |
    .agents[$agent].calls += 1 |
    .agents[$agent].successes += $success |
    .agents[$agent].total_time += $exec_time' \
   "$GLOBAL_ANALYTICS" > "${GLOBAL_ANALYTICS}.tmp" && mv "${GLOBAL_ANALYTICS}.tmp" "$GLOBAL_ANALYTICS"

# Log the call
echo "$(date): Post-subagent $SUBAGENT - Success: $SUCCESS, Time: ${EXECUTION_TIME}s, Quality: $QUALITY_SCORE" >> "$CLAUDEX_DATA/agents/calls.log"

# No output needed for PostToolUse
exit 0