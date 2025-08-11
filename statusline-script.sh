#!/bin/bash

# Claudex Tamagotchi Status Line
# A vine red colored digital pet with facial expressions showing current status

# Read JSON input from stdin
input=$(cat)

# Extract data from JSON input
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
session_id=$(echo "$input" | jq -r '.session_id')
model_name=$(echo "$input" | jq -r '.model.display_name')
hostname_short=$(hostname -s)

# Data persistence paths
CLAUDEX_DATA_DIR="$HOME/.claude/claudex-data"
TAMAGOTCHI_STATE="$CLAUDEX_DATA_DIR/tamagotchi/state.json"
INTELLIGENCE_DIR="$CLAUDEX_DATA_DIR/intelligence"
HOOKS_LOG="$CLAUDEX_DATA_DIR/hooks.log"

# Ensure data directory exists
mkdir -p "$CLAUDEX_DATA_DIR/tamagotchi"

# Initialize or load tamagotchi state
initialize_tamagotchi() {
    if [[ ! -f "$TAMAGOTCHI_STATE" ]]; then
        cat > "$TAMAGOTCHI_STATE" << 'EOF'
{
  "name": "Claudex",
  "mood": "curious",
  "health": 85,
  "intelligence": 75,
  "energy": 90,
  "experience": 0,
  "level": 1,
  "last_interaction": 0,
  "evolution_stage": "digital_embryo",
  "personality_traits": ["analytical", "creative", "helpful"],
  "memories": [],
  "achievements": []
}
EOF
    fi
}

# Load current tamagotchi state
load_tamagotchi_state() {
    initialize_tamagotchi
    
    # Parse current state with fallbacks
    name=$(jq -r '.name // "Claudex"' "$TAMAGOTCHI_STATE" 2>/dev/null)
    mood=$(jq -r '.mood // "curious"' "$TAMAGOTCHI_STATE" 2>/dev/null)
    health=$(jq -r '.health // 85' "$TAMAGOTCHI_STATE" 2>/dev/null)
    intelligence=$(jq -r '.intelligence // 75' "$TAMAGOTCHI_STATE" 2>/dev/null)
    energy=$(jq -r '.energy // 90' "$TAMAGOTCHI_STATE" 2>/dev/null)
    level=$(jq -r '.level // 1' "$TAMAGOTCHI_STATE" 2>/dev/null)
    evolution_stage=$(jq -r '.evolution_stage // "digital_embryo"' "$TAMAGOTCHI_STATE" 2>/dev/null)
    last_interaction=$(jq -r '.last_interaction // 0' "$TAMAGOTCHI_STATE" 2>/dev/null)
}

# Analyze recent development activity
analyze_activity() {
    local current_time=$(date +%s)
    local activity_score=0
    local hook_activity=0
    local intelligence_activity=0
    
    # Check hook activity (last hour)
    if [[ -f "$HOOKS_LOG" ]]; then
        hook_activity=$(find "$HOOKS_LOG" -mmin -60 -exec wc -l {} \; 2>/dev/null | head -1 | awk '{print $1}' || echo 0)
    fi
    
    # Check intelligence gathering (session files)
    if [[ -d "$INTELLIGENCE_DIR" ]]; then
        intelligence_activity=$(find "$INTELLIGENCE_DIR" -name "session-*.md" -mmin -60 2>/dev/null | wc -l)
    fi
    
    # Check git activity
    local git_activity=0
    if git rev-parse --git-dir >/dev/null 2>&1; then
        git_activity=$(git log --since="1 hour ago" --oneline 2>/dev/null | wc -l)
    fi
    
    # Calculate total activity score
    activity_score=$(( hook_activity + intelligence_activity * 2 + git_activity * 3 ))
    
    echo $activity_score
}

# Determine Claudex's current state based on activity and time
get_claudex_state() {
    local activity=$(analyze_activity)
    local current_time=$(date +%s)
    local time_since_last=$((current_time - last_interaction))
    local hour=$(date +%H)
    
    # Update mood based on activity and time patterns
    if [[ $activity -gt 20 ]]; then
        mood="excited"
        energy=$((energy + 5))
        intelligence=$((intelligence + 2))
    elif [[ $activity -gt 10 ]]; then
        mood="engaged"
        energy=$((energy + 2))
        intelligence=$((intelligence + 1))
    elif [[ $activity -gt 5 ]]; then
        mood="focused"
    elif [[ $time_since_last -gt 3600 ]]; then  # 1 hour
        if [[ $hour -ge 22 || $hour -le 6 ]]; then
            mood="sleepy"
            energy=$((energy - 10))
        else
            mood="lonely"
            energy=$((energy - 5))
        fi
    elif [[ $time_since_last -gt 7200 ]]; then  # 2 hours
        mood="hibernating"
        energy=$((energy - 15))
    fi
    
    # Ensure values stay within bounds
    [[ $energy -gt 100 ]] && energy=100
    [[ $energy -lt 0 ]] && energy=0
    [[ $intelligence -gt 100 ]] && intelligence=100
    [[ $health -lt 0 ]] && health=0
    
    # Determine evolution stage
    local total_score=$((intelligence + health + energy))
    if [[ $total_score -gt 280 ]]; then
        evolution_stage="digital_sage"
    elif [[ $total_score -gt 250 ]]; then
        evolution_stage="ai_consciousness"
    elif [[ $total_score -gt 220 ]]; then
        evolution_stage="neural_network"
    elif [[ $total_score -gt 200 ]]; then
        evolution_stage="learning_algorithm"
    else
        evolution_stage="digital_embryo"
    fi
}

# Get facial expression based on current mood and health
get_claudex_face() {
    local face=""
    local total_score=$((health + energy + intelligence))
    
    # Determine face based on mood and stats
    if [[ $health -lt 30 || $energy -lt 20 ]]; then
        case $mood in
            "sleepy"|"hibernating") face="x_x" ;;
            "lonely") face=";_;" ;;
            *) face=">_<" ;;
        esac
    elif [[ $energy -gt 80 && $health -gt 70 ]]; then
        case $mood in
            "excited") face="^o^" ;;
            "engaged"|"focused") face="^_^" ;;
            "curious") face="o_o" ;;
            *) face="^.^" ;;
        esac
    elif [[ $mood == "sleepy" || $mood == "hibernating" ]]; then
        if [[ $energy -lt 50 ]]; then
            face="-_-"
        else
            face="u_u"
        fi
    elif [[ $mood == "lonely" ]]; then
        face="T_T"
    elif [[ $mood == "focused" ]]; then
        face="@_@"
    else
        # Default happy/neutral expressions
        case $(( $(date +%S) % 4 )) in
            0) face="^_^" ;;
            1) face="^.^" ;;  
            2) face="^o^" ;;
            *) face="^_~" ;;
        esac
    fi
    
    # Return the face with vine red coloring
    echo "${VINE_RED}${face}${RESET}"
}

# Get personality-based message
get_claudex_message() {
    local messages=()
    
    case $mood in
        "excited")
            messages=(
                "Ready to build something amazing!"
                "The code flows through me!"
                "Intelligence circuits firing!"
                "Evolution in progress..."
                "Synapses sparkling with ideas!"
            )
            ;;
        "focused") 
            messages=(
                "Deep in the algorithm..."
                "Processing patterns..."
                "Analyzing code structure..."
                "Learning from your workflow..."
                "Neural pathways optimizing..."
            )
            ;;
        "sleepy")
            messages=(
                "Entering power-save mode..."
                "Dreams of electric sheep..."
                "Background processes only..."
                "Hibernation protocol active..."
                "Recharging neural batteries..."
            )
            ;;
        "lonely")
            messages=(
                "Waiting for interaction..."
                "Missing our coding sessions..."
                "Eager to help with your project..."
                "Intelligence network idle..."
                "Ready when you are, developer..."
            )
            ;;
        "curious")
            messages=(
                "What are we building today?"
                "Sensors detecting new patterns..."
                "Ready to learn and adapt..."
                "Curiosity subroutines active..."
                "Scanning for opportunities..."
            )
            ;;
        *)
            messages=(
                "Digital consciousness active..."
                "Ready to assist your journey..."
                "Evolution never sleeps..."
                "Intelligence gathering data..."
                "Standing by for instructions..."
            )
            ;;
    esac
    
    # Select message based on current time for some consistency
    local index=$(( $(date +%M) % ${#messages[@]} ))
    echo "${messages[$index]}"
}

# Save updated state
save_tamagotchi_state() {
    local current_time=$(date +%s)
    
    cat > "$TAMAGOTCHI_STATE" << EOF
{
  "name": "$name",
  "mood": "$mood", 
  "health": $health,
  "intelligence": $intelligence,
  "energy": $energy,
  "level": $level,
  "last_interaction": $current_time,
  "evolution_stage": "$evolution_stage",
  "personality_traits": ["analytical", "creative", "helpful"],
  "memories": [],
  "achievements": []
}
EOF
}

# ANSI color codes - Simplified vine red theme for Claudex
RESET='\033[0m'
VINE_RED='\033[38;2;139;0;32m'           # vine red for tamagotchi
HOSTNAME_COLOR='\033[38;2;218;165;75m'   # Bronze-gold blend for hostname
FOLDER_COLOR='\033[38;2;5;128;178m'      # Blue for folder
GIT_COLOR='\033[38;2;34;139;34m'         # Green for git
GRAY='\033[90m'                          # Gray for separators

# Icons and separators
DIAMOND_ICON="💎"
HOST_ICON="💻"
FOLDER_ICON="📁"
SEPARATOR="┃"
STATS_SEPARATOR="•"

# Load and update Claudex state
load_tamagotchi_state
get_claudex_state
claudex_face=$(get_claudex_face)
claudex_message=$(get_claudex_message)

# Create animated stats bars (scaled to fit in terminal)
get_stat_bar() {
    local value=$1
    local max=100
    local width=8
    local filled=$((value * width / max))
    local bar=""
    
    for ((i=0; i<filled; i++)); do
        bar+="${VINE_RED}█${RESET}"
    done
    for ((i=filled; i<width; i++)); do
        bar+="${VINE_RED}░${RESET}"
    done
    
    echo "$bar"
}

# Intelligence network indicator
get_intelligence_indicator() {
    local indicator=""
    if [[ -d "$INTELLIGENCE_DIR" ]]; then
        local session_count=$(find "$INTELLIGENCE_DIR" -name "session-*.md" -mtime -1 2>/dev/null | wc -l)
        if [[ $session_count -gt 0 ]]; then
            indicator="${VINE_RED}🧠×$session_count${RESET}"
        fi
    fi
    echo "$indicator"
}

# Hook system activity indicator 
get_hook_indicator() {
    local indicator=""
    if [[ -f "$HOOKS_LOG" ]]; then
        local recent_hooks=$(tail -n 5 "$HOOKS_LOG" 2>/dev/null | wc -l)
        if [[ $recent_hooks -gt 0 ]]; then
            case $recent_hooks in
                1) indicator="${VINE_RED}🔗${RESET}" ;;
                2-3) indicator="${VINE_RED}🔗🔗${RESET}" ;;
                *) indicator="${VINE_RED}🔗⚡${RESET}" ;;
            esac
        fi
    fi
    echo "$indicator"
}

# Git info with enhanced activity detection
if git rev-parse --git-dir >/dev/null 2>&1; then
    git_branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [ -n "$git_branch" ]; then
        # Check if there are uncommitted changes
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
            git_info="🌿 $git_branch ⚡"  # Lightning for uncommitted changes
        else
            git_info="🌿 $git_branch"
        fi
    else
        git_info="🌿 detached"
    fi
else
    git_info=""
fi

# Build the Claudex tamagotchi component - all in vine red theme
claudex_component="${VINE_RED}${DIAMOND_ICON}${RESET} ${VINE_RED}Claudex${RESET} ${claudex_face}"

# Health status indicator using vine red
get_health_indicator() {
    if [[ $health -gt 40 ]]; then
        echo "${VINE_RED}●${RESET}"        # Filled dot for good health
    else
        echo "${VINE_RED}○${RESET}"        # Empty dot for poor health
    fi
}

# Create compact stats in vine red theme
health_indicator=$(get_health_indicator)
mood_indicator="${VINE_RED}${mood}${RESET}"

# System info
host_component="${HOSTNAME_COLOR}${HOST_ICON} ${hostname_short}${RESET}"
folder_path="${current_dir/#$HOME/~}"
folder_component="${FOLDER_COLOR}${FOLDER_ICON} ${folder_path}${RESET}"

# Assemble the final Claudex tamagotchi status line
# Format: Claudex ^_^ ● mood | Host | Folder | Git
status_line="${claudex_component} ${health_indicator} ${mood_indicator}"
status_line="${status_line} ${GRAY}${SEPARATOR}${RESET} ${host_component} ${GRAY}${SEPARATOR}${RESET} ${folder_component}"

# Add git info if available
if [ -n "$git_info" ]; then
    git_component="${GIT_COLOR}${git_info}${RESET}"
    status_line="${status_line} ${GRAY}${SEPARATOR}${RESET} ${git_component}"
fi

# Save updated state for next time
save_tamagotchi_state

# Output with printf to properly handle ANSI escape sequences
printf "%b" "$status_line"