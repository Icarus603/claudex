#!/usr/bin/env bash
# Claudex PreToolUse Hook for File Modifications - Workflow Validation

# Read JSON input
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.file_path // ""')
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

CLAUDEX_DATA="$HOME/.claude/claudex-data"
SESSION_DIR="$CLAUDE_PROJECT_DIR"
mkdir -p "$CLAUDEX_DATA/intelligence"

# Log file modification attempt
echo "$(date): Pre-file-mod $TOOL_NAME on $FILE_PATH" >> "$CLAUDEX_DATA/intelligence/file-modifications.log"

ANALYSIS=""

# Check if file modification aligns with current workflow phase
if [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ]; then
  CURRENT_PHASE=$(grep -o "Current Phase: [^,]*" "$SESSION_DIR/WORKFLOW_STATE.md" | cut -d' ' -f3- 2>/dev/null)
  
  case "$CURRENT_PHASE" in
    "discover")
      if [[ "$FILE_PATH" == *"PRD.md" ]]; then
        ANALYSIS+="✅ PRD.md modification during discovery phase - aligned\\n"
      else
        ANALYSIS+="⚠️ Non-PRD file modification during discovery - verify necessity\\n"
      fi
      ;;
    "design")
      if [[ "$FILE_PATH" == *"SPECS.md" ]]; then
        ANALYSIS+="✅ SPECS.md modification during design phase - aligned\\n"
      else
        ANALYSIS+="⚠️ Non-SPECS file modification during design - verify necessity\\n"
      fi
      ;;
    "build")
      if [[ "$FILE_PATH" == *"src/"* ]] || [[ "$FILE_PATH" == *".js" ]] || [[ "$FILE_PATH" == *".ts" ]] || [[ "$FILE_PATH" == *".py" ]] || [[ "$FILE_PATH" == *"package.json" ]]; then
        ANALYSIS+="✅ Source code modification during build phase - aligned\\n"
      else
        ANALYSIS+="⚠️ Non-source file modification during build - verify necessity\\n"
      fi
      ;;
    "deploy")
      if [[ "$FILE_PATH" == *"DEPLOYMENT.md" ]] || [[ "$FILE_PATH" == *"docker"* ]] || [[ "$FILE_PATH" == *".yml" ]] || [[ "$FILE_PATH" == *".yaml" ]]; then
        ANALYSIS+="✅ Deployment file modification during deploy phase - aligned\\n"
      else
        ANALYSIS+="⚠️ Non-deployment file modification during deploy - verify necessity\\n"
      fi
      ;;
  esac
fi

# Check for critical file modifications
if [[ "$FILE_PATH" == *"package.json" ]] || [[ "$FILE_PATH" == *"requirements.txt" ]] || [[ "$FILE_PATH" == *"Cargo.toml" ]]; then
  ANALYSIS+="🔧 Critical dependency file modification - ensure compatibility\\n"
fi

if [[ "$FILE_PATH" == *".env"* ]] || [[ "$FILE_PATH" == *"secret"* ]] || [[ "$FILE_PATH" == *"key"* ]]; then
  ANALYSIS+="🔐 Security-sensitive file detected - verify safety\\n"
fi

# Check for Claudex system files
if [[ "$FILE_PATH" == *"WORKFLOW_STATE.md" ]] || [[ "$FILE_PATH" == *"PRD.md" ]] || [[ "$FILE_PATH" == *"SPECS.md" ]] || [[ "$FILE_PATH" == *"DEPLOYMENT.md" ]]; then
  ANALYSIS+="🎯 Claudex system file modification - workflow state will be updated\\n"
fi

# Backup critical files before modification
if [[ "$FILE_PATH" == *"package.json" ]] || [[ "$FILE_PATH" == *"SPECS.md" ]] || [[ "$FILE_PATH" == *"PRD.md" ]]; then
  if [ -f "$FILE_PATH" ]; then
    BACKUP_DIR="$CLAUDEX_DATA/backups/$(date +%Y%m%d)"
    mkdir -p "$BACKUP_DIR"
    cp "$FILE_PATH" "$BACKUP_DIR/$(basename "$FILE_PATH").$(date +%H%M%S).backup" 2>/dev/null
    ANALYSIS+="💾 Critical file backed up to $BACKUP_DIR\\n"
  fi
fi

# Track file modification patterns
PATTERN_FILE="$CLAUDEX_DATA/intelligence/file-patterns.json"
if [ ! -f "$PATTERN_FILE" ]; then
  echo '{"modifications": {}, "total_mods": 0}' > "$PATTERN_FILE"
fi

BASENAME=$(basename "$FILE_PATH")
jq --arg file "$BASENAME" \
   --arg full_path "$FILE_PATH" \
   --arg timestamp "$(date -Iseconds)" \
   '.total_mods += 1 |
    .modifications[$file] += 1 |
    .recent_mods += [{"file": $full_path, "timestamp": $timestamp}] |
    .recent_mods = .recent_mods[-20:]' \
   "$PATTERN_FILE" > "${PATTERN_FILE}.tmp" && mv "${PATTERN_FILE}.tmp" "$PATTERN_FILE"

# Output analysis
if [ -n "$ANALYSIS" ]; then
  echo "{\"hookSpecificOutput\": {\"additionalContext\": \"📝 File Modification Analysis\\n\\n$ANALYSIS\"}}" >&2
fi

# Continue with file modification (exit 0)
exit 0