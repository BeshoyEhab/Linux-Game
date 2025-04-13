#!/bin/bash

source ./.menu.sh

# Game Constants
export GAME_DIR=$(mktemp -d -t 'game.XXX')
LOG_FILE="$GAME_DIR/pirate_log.txt"
SAVE_FILE="$GAME_DIR/treasure_map.save"

# Initialize game world
initialize_game() {
  cp -r ./game/* "$GAME_DIR"
  cd "$GAME_DIR" || exit 1
  touch "$LOG_FILE"
  echo "0" >"$SAVE_FILE"
}

# Command Validation
validate_command() {
  local cmd=$1
  declare -A allowed_commands=(
    [cd]="Navigate directories"
    [find]="Search for files"
    [rm]="Remove files"
    [mv]="Move/rename files"
    [chmod]="Change permissions"
    [touch]="Create files"
    [echo]="Print messages"
    [cat]="View files"
    [grep]="Search text"
    [help]="Show help"
    [quit]="Exit game"
  )

  # Split into pipeline components
  IFS='|' read -ra pipe_commands <<<"$cmd"

  for pipe_part in "${pipe_commands[@]}"; do
    # Remove redirections and extract base command
    clean_cmd=$(echo "$pipe_part" | sed -e 's/>.*//' -e 's/<.*//')
    base_cmd=$(echo "$clean_cmd" | awk '{print $1}')

    if [[ -z "${allowed_commands[$base_cmd]}" ]]; then
      show_text "Avast! '${base_cmd}' be forbidden in '${pipe_part//[^[:alnum:][:space:]]/}'!"
      return 1
    fi
  done

  return 0
}

# Story Presentation
show_text() {
  text=$1
  delay=0.03
  echo -n "    "
  for ((j = 0; j < ${#text}; j++)); do
    echo -n "${text:$j:1}"
    case "${text:$j:1}" in
    [.!?])
      sleep 0.5
      ;;
    *)
      sleep $delay
      ;;
    esac
  done
  echo
}

# Enhanced Command Execution
run_silent() {
  command=$1
  test_command=$2

  # Log command without showing
  echo "[$(date)] Attempted: $command" >>"$LOG_FILE"

  # Execute with timeout and capture output
  output=$(timeout 5s bash -c "$command $test_command 2>&1" 2>&1)
  exit_code=$?

  # Return results through global variables
  LAST_OUTPUT="$output"
  LAST_EXIT=$exit_code
}

# Progress Tracking
update_progress() {
  current=$((part + 1))
  echo "$current" >"$SAVE_FILE"
}

# Victory Condition Check
check_victory() {
  if [ $part -ge $((${#parts[@]} - 1)) ]; then
    show_text "The seas fall silent as Blackfin raises the Emerald Skull! You've mastered the pirate commands!"
    show_text "Final treasure map saved in: $GAME_DIR"
    exit 0
  fi
}

# Danger Checks
check_dangers() {
  if [[ "$LAST_OUTPUT" == *"Permission denied"* ]]; then
    show_text "A ghostly voice whispers: 'You lack the authority to pass!'"
  elif [[ "$LAST_OUTPUT" == *"No such file"* ]]; then
    show_text "The deck creaks: 'That island doesn't exist in these waters!'"
  elif [[ "$LAST_OUTPUT" == *"command not found"* ]]; then
    show_text "First Mate shouts: 'We don't have that weapon in our arsenal!'"
  fi
}

# Main Game Loop
pirate_quest() {
  part=$(cat "$SAVE_FILE")
  while :; do
    clear
    story="${parts[$part]}"
    test_command="${tests[$part]}"
    solution_file="${solutions[$part]}"

    show_text "$story"

    read -p $'\n    Enter your command (or type "help"): ' -r command

    case "$command" in
    help)
      cheat
      continue
      ;;
    quit)
      show_text "Abandoning the quest? The Emerald Skull remains hidden..."
      exit 0
      ;;
    *)
      if ! validate_command "$command"; then
        read -p $'\n    Press Enter to continue...'
        continue
      fi
      run_silent "$command" "$test_command"
      ;;
    esac

    clear
    check_dangers

    if [ $LAST_EXIT -eq 0 ]; then
      show_text "The crew cheers! Your command worked!"
      part=$((part + 1))
      update_progress
      check_victory
    else
      show_text "The sea grows restless... Something went wrong!"
      show_text "Check your bearings and try again (use 'help' if needed)"
    fi

    read -p $'\n    Press Enter to continue your voyage...'
  done
}

cheat() {
  show_text "First Mate: 'Aye Captain! Here be our pirate tools:'"

  declare -A command_help=(
    [cd]="<directory> : Navigate between islands"
    [find]="<path> -name <pattern> : Search for hidden treasures"
    [rm]="<file> : Sink enemy ships"
    [mv]="<source> <dest> : Move treasure or rename maps"
    [chmod]="+x <file> : Make scripts executable"
    [touch]="<file> : Claim new islands"
    [tar]="-cf <archive> <files> : Bundle treasures"
    [gzip]="<file> : Compress maps"
    [curl]="-O <url> : Plunder web treasures"
    [grep]="<pattern> <file> : Find secret messages"
    [help]=": Show this scroll"
    [quit]=": Abandon quest"
  )

  echo -e "\n\e[33mPirate Command Scroll:\e[0m"
  for cmd in "${!command_help[@]}"; do
    echo -e "  🏴‍☠️ \e[1;32m${cmd}\e[0m ${command_help[$cmd]}"
  done
  echo -e "\n\e[36mPirate Command Examples:\e[0m"
  echo -e "  🗺️  \e[1;32mecho 'message' > file.txt\e[0m : Leave a marker"
  echo -e "  🔍 \e[1;32mcat log.txt | grep treasure\e[0m : Search logs"
  echo -e "  ⚓ \e[1;32mmv old_map.txt new_map.txt\e[0m : Rename scroll"

  read -p $'\n    Press Enter to return to the quest...'
}

# Initialize game world
initialize_game

# Game Data
parts=(
  "Captain Flint 'Blackfin Drake' stares at the Crimson_Tide directory. 'To board my ship, I need the right command...'"
  "A storm reveals coordinates! 'Find the island named Chala in these files!'"
  "Rival pirates approach! 'Remove the Siren's Wrath before they attack!'"
  "After battle, 'Move the damaged sails to the repair bay!'"
  "Ancient temple blocks the path! 'Change permissions to open the gates!'"
  "Victory in sight! 'Create a flag file to claim the treasure!'"
)

tests=(
  "; pwd > .cd.txt ; diff .cd.txt .cd_sol"
  " > .find.txt ; diff .find.txt .find_sol"
  "; test -f Chala | tee .rm.txt"
  "; test -d Chala | tee .mv.txt"
  ""
  ""
)

solutions=(
  ".cd_sol"
  ".find_sol"
  ".rm_sol"
  ".mv_sol"
  ""
  ""
)

# Start the quest
pirate_quest
