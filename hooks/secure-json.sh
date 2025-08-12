#!/usr/bin/env bash
# Secure JSON encoding functions for Claudex hooks

# Safely encode a string value for JSON output
json_encode_string() {
  local input="$1"
  # Use jq to properly escape the string for JSON
  printf '%s' "$input" | jq -R -s '.'
}

# Create a JSON object with proper escaping
create_json_object() {
  local key="$1"
  local value="$2"
  jq -n --arg k "$key" --arg v "$value" '{($k): $v}'
}

# Create system message JSON with proper escaping
create_system_message_json() {
  local message="$1"
  jq -n --arg msg "$message" '{"systemMessage": $msg}'
}

# Create hook output JSON with proper escaping
create_hook_output_json() {
  local hook_event="$1"
  local additional_context="$2"
  jq -n \
    --arg event "$hook_event" \
    --arg context "$additional_context" \
    '{
      "hookSpecificOutput": {
        "hookEventName": $event,
        "additionalContext": $context
      }
    }'
}

# Safely merge JSON objects
merge_json_objects() {
  local json1="$1"
  local json2="$2"
  echo "$json1" "$json2" | jq -s '.[0] * .[1]'
}