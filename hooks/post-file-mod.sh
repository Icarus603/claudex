#!/usr/bin/env bash
# Claudex PostToolUse Hook for File Modifications - Workflow State Updates

# Read JSON input with validation
INPUT=$(cat)
if ! echo "$INPUT" | jq empty 2>/dev/null; then
  exit 1  # Invalid JSON input
fi

FILE_PATH_RAW=$(echo "$INPUT" | jq -r '.inputs.file_path // ""')
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

CLAUDEX_DATA="$HOME/.claude/claudex-data"
SESSION_DIR="$CLAUDE_PROJECT_DIR"

# Sanitize and validate file path
sanitize_file_path() {
  local path="$1"
  # Remove null bytes and control characters
  path=$(echo "$path" | tr -d '\000-\037\177')
  # Resolve path and check it's within allowed directories
  if [[ "$path" = /* ]]; then
    # Absolute path - ensure it's within home or project dir
    case "$path" in
      "$HOME"/*|"$SESSION_DIR"/*|"$CLAUDEX_DATA"/*) 
        echo "$path" ;;
      *) 
        return 1 ;;  # Path not allowed
    esac
  else
    # Relative path - make it relative to SESSION_DIR
    echo "$SESSION_DIR/$path"
  fi
}

if ! FILE_PATH=$(sanitize_file_path "$FILE_PATH_RAW"); then
  exit 1  # Invalid or dangerous file path
fi
mkdir -p "$CLAUDEX_DATA/intelligence"

# Log successful file modification
echo "$(date): Post-file-mod $TOOL_NAME completed on $FILE_PATH" >> "$CLAUDEX_DATA/intelligence/file-modifications.log"

# Update workflow state based on file changes
WORKFLOW_UPDATE=""

case "$(basename "$FILE_PATH")" in
  "PRD.md")
    # Discovery phase completion
    if [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ]; then
      sed -i '' 's/Current Phase: discover/Current Phase: ready-for-design/' "$SESSION_DIR/WORKFLOW_STATE.md" 2>/dev/null
      WORKFLOW_UPDATE+="🎯 Workflow updated: Discovery → Ready for Design\\n"
    else
      cat > "$SESSION_DIR/WORKFLOW_STATE.md" << EOF
# Workflow State
Current Phase: ready-for-design
Last Updated: $(date)
Completed: PRD.md created
Next Suggested: /design
EOF
      WORKFLOW_UPDATE+="🎯 Workflow initialized: Ready for Design phase\\n"
    fi
    ;;
    
  "SPECS.md")
    # Design phase completion
    if [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ]; then
      sed -i '' 's/Current Phase: design/Current Phase: ready-for-build/' "$SESSION_DIR/WORKFLOW_STATE.md" 2>/dev/null
      sed -i '' 's/Current Phase: ready-for-design/Current Phase: ready-for-build/' "$SESSION_DIR/WORKFLOW_STATE.md" 2>/dev/null
      WORKFLOW_UPDATE+="🎯 Workflow updated: Design → Ready for Build\\n"
    else
      cat > "$SESSION_DIR/WORKFLOW_STATE.md" << EOF
# Workflow State  
Current Phase: ready-for-build
Last Updated: $(date)
Completed: SPECS.md created
Next Suggested: /build
EOF
      WORKFLOW_UPDATE+="🎯 Workflow initialized: Ready for Build phase\\n"
    fi
    ;;
    
  "DEPLOYMENT.md")
    # Deploy phase completion
    if [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ]; then
      sed -i '' 's/Current Phase: deploy/Current Phase: ready-for-maintenance/' "$SESSION_DIR/WORKFLOW_STATE.md" 2>/dev/null
      WORKFLOW_UPDATE+="🎯 Workflow updated: Deploy → Ready for Maintenance\\n"
    fi
    ;;
    
  "package.json"|"requirements.txt"|"Cargo.toml"|"go.mod")
    # Build progress indicators
    if [ -f "$SESSION_DIR/WORKFLOW_STATE.md" ]; then
      grep -q "Build Progress" "$SESSION_DIR/WORKFLOW_STATE.md" || echo "Build Progress: Dependencies configured - $(date)" >> "$SESSION_DIR/WORKFLOW_STATE.md"
      WORKFLOW_UPDATE+="🔧 Build progress: Dependencies updated\\n"
    fi
    ;;
esac

# Check for build completion patterns
if [[ "$FILE_PATH" == *"src/"* ]] || [[ "$FILE_PATH" == *"lib/"* ]] || [[ "$FILE_PATH" == *"app/"* ]]; then
  # Source file modification indicates build progress
  BUILD_PROGRESS_FILE="$CLAUDEX_DATA/state/build-progress.json"
  if [ ! -f "$BUILD_PROGRESS_FILE" ]; then
    echo '{"files_modified": [], "source_files": 0}' > "$BUILD_PROGRESS_FILE"
  fi
  
  jq --arg file "$FILE_PATH" \
     --arg timestamp "$(date -Iseconds)" \
     '.source_files += 1 |
      .files_modified += [{"file": $file, "timestamp": $timestamp}] |
      .files_modified = .files_modified[-50:]' \
     "$BUILD_PROGRESS_FILE" > "${BUILD_PROGRESS_FILE}.tmp" && mv "${BUILD_PROGRESS_FILE}.tmp" "$BUILD_PROGRESS_FILE"
  
  SOURCE_COUNT=$(jq -r '.source_files' "$BUILD_PROGRESS_FILE")
  if [ "$SOURCE_COUNT" -gt 5 ]; then
    WORKFLOW_UPDATE+="🚀 Build progress: $SOURCE_COUNT source files modified - consider deployment\\n"
  fi
fi

# Update file modification statistics
STATS_FILE="$CLAUDEX_DATA/intelligence/modification-stats.json"
if [ ! -f "$STATS_FILE" ]; then
  echo '{"daily_mods": {}, "file_types": {}}' > "$STATS_FILE"
fi

TODAY=$(date +%Y-%m-%d)
EXTENSION="${FILE_PATH##*.}"

jq --arg date "$TODAY" \
   --arg ext "$EXTENSION" \
   '.daily_mods[$date] += 1 |
    .file_types[$ext] += 1' \
   "$STATS_FILE" > "${STATS_FILE}.tmp" && mv "${STATS_FILE}.tmp" "$STATS_FILE"

# Detect intensive modification patterns (potential cycling)
DAILY_MODS=$(jq -r --arg date "$TODAY" '.daily_mods[$date] // 0' "$STATS_FILE")
if [ "$DAILY_MODS" -gt 20 ]; then
  WORKFLOW_UPDATE+="🔄 High modification activity today ($DAILY_MODS files) - check for cycles\\n"
  
  # Create cycle warning
  echo "{\"type\": \"high-file-modification\", \"count\": $DAILY_MODS, \"date\": \"$TODAY\"}" > "$CLAUDEX_DATA/state/cycle-warning.json"
fi

# Git integration (if available)
if [ -d "$SESSION_DIR/.git" ]; then
  cd "$SESSION_DIR"
  if git status --porcelain | grep -q "^.M\|^A"; then
    UNCOMMITTED=$(git status --porcelain | wc -l | tr -d ' ')
    WORKFLOW_UPDATE+="📝 Git status: $UNCOMMITTED uncommitted changes\\n"
  fi
fi

# Output workflow intelligence
if [ -n "$WORKFLOW_UPDATE" ]; then
  source "$HOME/.claude/hooks/secure-json.sh"
  create_hook_output_json "" "🔄 Workflow State Update\\n\\n$WORKFLOW_UPDATE" >&2
fi

# Create workflow checkpoint if significant changes
if [[ "$FILE_PATH" == *"PRD.md" ]] || [[ "$FILE_PATH" == *"SPECS.md" ]] || [[ "$FILE_PATH" == *"DEPLOYMENT.md" ]]; then
  echo "$(basename "$FILE_PATH") updated - $(date)" > "$SESSION_DIR/.claudex-checkpoint"
fi

# Normal completion
exit 0