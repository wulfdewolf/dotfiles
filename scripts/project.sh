#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/Documents -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    # Start a new session with nvim in the first window
    tmux new-session -s "$selected_name" -c "$selected" "nvim ."
    tmux new-window -t "$selected_name" -c "$selected"
    tmux select-window -t "$selected_name:0"
    exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    # Create a new detached session with nvim as the first window
    tmux new-session -ds "$selected_name" -c "$selected" "nvim ."
    tmux new-window -t "$selected_name" -c "$selected"
    tmux select-window -t "$selected_name:0"
fi

if [[ -z $TMUX ]]; then
    tmux attach -t "$selected_name"
else
    tmux switch-client -t "$selected_name"
fi
