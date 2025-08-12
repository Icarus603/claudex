#!/usr/bin/env bash
# Secure file locking functions for Claudex hooks

# Acquire an exclusive lock on a file using flock
acquire_file_lock() {
  local file="$1"
  local timeout="${2:-10}"  # Default 10 second timeout
  local lockfile="${file}.lock"
  
  # Create lock file and acquire exclusive lock
  exec 200>"$lockfile"
  if flock -x -w "$timeout" 200; then
    return 0  # Lock acquired successfully
  else
    exec 200>&-  # Close file descriptor
    return 1  # Failed to acquire lock
  fi
}

# Release the file lock
release_file_lock() {
  local file="$1"
  local lockfile="${file}.lock"
  
  # Release lock and close file descriptor
  flock -u 200 2>/dev/null
  exec 200>&-
  rm -f "$lockfile" 2>/dev/null
}

# Safely update a JSON file with atomic operations
atomic_json_update() {
  local file="$1"
  local update_command="$2"
  local backup_file="${file}.backup"
  local temp_file="${file}.tmp"
  
  # Acquire lock before modifying
  if ! acquire_file_lock "$file" 5; then
    echo "ERROR: Failed to acquire lock for $file" >&2
    return 1
  fi
  
  # Create backup
  if [ -f "$file" ]; then
    cp "$file" "$backup_file" || {
      release_file_lock "$file"
      return 1
    }
  fi
  
  # Execute update command to temporary file
  if eval "$update_command" > "$temp_file"; then
    # Validate JSON structure
    if jq empty "$temp_file" 2>/dev/null; then
      # Atomically replace original file
      mv "$temp_file" "$file" || {
        # Restore from backup on failure
        [ -f "$backup_file" ] && mv "$backup_file" "$file"
        release_file_lock "$file"
        return 1
      }
      # Remove backup on success
      rm -f "$backup_file"
    else
      # Invalid JSON - restore from backup
      [ -f "$backup_file" ] && mv "$backup_file" "$file"
      rm -f "$temp_file"
      release_file_lock "$file"
      return 1
    fi
  else
    # Command failed - restore from backup
    [ -f "$backup_file" ] && mv "$backup_file" "$file"
    rm -f "$temp_file"
    release_file_lock "$file"
    return 1
  fi
  
  release_file_lock "$file"
  return 0
}

# Safely read JSON with retry on lock contention
safe_json_read() {
  local file="$1"
  local retries="${2:-3}"
  local delay="${3:-1}"
  
  for ((i=0; i<retries; i++)); do
    if acquire_file_lock "$file" 2; then
      if [ -f "$file" ] && jq empty "$file" 2>/dev/null; then
        cat "$file"
        release_file_lock "$file"
        return 0
      fi
      release_file_lock "$file"
    fi
    sleep "$delay"
  done
  
  echo "ERROR: Failed to safely read $file after $retries retries" >&2
  return 1
}