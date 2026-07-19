#!/usr/bin/env bash
# CLI Task Tracker — flat-file persistence (pipe-delimited: id|status|description)
set -euo pipefail

DATA_FILE="${TASK_DATA_FILE:-$HOME/.tasktracker/tasks.db}"

init_store() {
  mkdir -p "$(dirname "$DATA_FILE")"
  [ -f "$DATA_FILE" ] || : > "$DATA_FILE"
}

next_id() {
  if [ -s "$DATA_FILE" ]; then
    tail -n 1 "$DATA_FILE" | cut -d'|' -f1 | awk '{print $1+1}'
  else
    echo 1
  fi
}

cmd_add() {
  local desc="$*"
  [ -n "$desc" ] || { echo "Error: description required" >&2; return 1; }
  local id; id=$(next_id)
  echo "${id}|pending|${desc}" >> "$DATA_FILE"
  echo "Added task #$id: $desc"
}

cmd_list() {
  if [ ! -s "$DATA_FILE" ]; then
    echo "No tasks yet."
    return 0
  fi
  printf "%-4s %-10s %s\n" "ID" "STATUS" "DESCRIPTION"
  while IFS='|' read -r id status desc; do
    printf "%-4s %-10s %s\n" "$id" "$status" "$desc"
  done < "$DATA_FILE"
}

cmd_done() {
  local target="$1"
  [ -n "$target" ] || { echo "Error: task id required" >&2; return 1; }
  local tmp; tmp=$(mktemp)
  local found=0
  while IFS='|' read -r id status desc; do
    if [ "$id" = "$target" ]; then
      echo "${id}|done|${desc}" >> "$tmp"
      found=1
    else
      echo "${id}|${status}|${desc}" >> "$tmp"
    fi
  done < "$DATA_FILE"
  mv "$tmp" "$DATA_FILE"
  if [ "$found" -eq 1 ]; then
    echo "Marked task #$target as done"
  else
    echo "No such task #$target" >&2
    return 1
  fi
}

cmd_rm() {
  local target="$1"
  [ -n "$target" ] || { echo "Error: task id required" >&2; return 1; }
  local tmp; tmp=$(mktemp)
  grep -v "^${target}|" "$DATA_FILE" > "$tmp" || true
  mv "$tmp" "$DATA_FILE"
  echo "Removed task #$target"
}

usage() {
  cat <<EOF
Usage: tasktracker.sh <command> [args]
Commands:
  add <description>   Add a new task
  list                 List all tasks
  done <id>            Mark a task as done
  rm <id>              Remove a task
EOF
}

main() {
  init_store
  local cmd="${1:-}"
  [ -n "$cmd" ] && shift || true
  case "$cmd" in
    add)  cmd_add "$@" ;;
    list) cmd_list ;;
    done) cmd_done "${1:-}" ;;
    rm)   cmd_rm "${1:-}" ;;
    *)    usage ;;
  esac
}

main "$@"
