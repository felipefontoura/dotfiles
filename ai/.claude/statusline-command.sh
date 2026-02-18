#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Get current directory
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Get git branch (skip optional locks)
cd "$cwd" 2>/dev/null || cd /
git_branch=$(git -c core.useBuiltinFSMonitor=false rev-parse --abbrev-ref HEAD 2>/dev/null)

# Get token usage
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')

# Calculate total tokens and format with commas
total_tokens=$((total_input + total_output))
total_formatted=$(printf "%'d" "$total_tokens")
context_formatted=$(printf "%'d" "$context_size")

# Build status line
status=""

# Add git branch if available
if [ -n "$git_branch" ]; then
  status="$git_branch"
fi

# Add session cost
if [ "$total_tokens" -gt 0 ]; then
  if [ -n "$status" ]; then
    status="$status • "
  fi
  status="${status}${total_formatted}/${context_formatted} tokens"
fi

# Output the status line
echo "$status"
