#!/usr/bin/env bash
# Claudex PostToolUse Hook for Task - Agent Learning

# Read JSON input
INPUT=$(cat)
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

# Update performance history
if [ -f "$PERF_FILE" ]; then
  # Load existing data and update
  TOTAL_CALLS=$(jq -r '.total_calls + 1' "$PERF_FILE")
  SUCCESSFUL_CALLS=$(jq -r ".successful_calls + $SUCCESS" "$PERF_FILE")
  SUCCESS_RATE=$(( SUCCESSFUL_CALLS * 100 / TOTAL_CALLS ))
  AVG_TIME=$(jq -r "(.avg_execution_time * (.total_calls - 1) + $EXECUTION_TIME) / $TOTAL_CALLS" "$PERF_FILE")
  
  jq --argjson new_entry "$LOG_ENTRY" \
     --argjson total "$TOTAL_CALLS" \
     --argjson successful "$SUCCESSFUL_CALLS" \
     --argjson success_rate "$SUCCESS_RATE" \
     --argjson avg_time "$AVG_TIME" \
     '.total_calls = $total |
      .successful_calls = $successful |
      .success_rate = $success_rate |
      .avg_execution_time = $avg_time |
      .recent_calls = ([$new_entry] + .recent_calls)[:10] |
      (.last_failure_reason = if $new_entry.success == 0 then "Response quality issues detected" else .last_failure_reason end)' \
     "$PERF_FILE" > "${PERF_FILE}.tmp" && mv "${PERF_FILE}.tmp" "$PERF_FILE"
else
  # Create new performance file
  cat > "$PERF_FILE" << EOF
{
  "agent": "$SUBAGENT",
  "total_calls": 1,
  "successful_calls": $SUCCESS,
  "success_rate": $(( SUCCESS * 100 )),
  "avg_execution_time": $EXECUTION_TIME,
  "recent_calls": [$LOG_ENTRY],
  "last_failure_reason": $([ "$SUCCESS" = "0" ] && echo '"Response quality issues detected"' || echo 'null'),
  "context_requirements": ""
}
EOF
fi

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