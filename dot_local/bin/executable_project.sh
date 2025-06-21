#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/projects -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -ds $selected_name -c $selected -n "nvim" "uv run nvim README.md"
    tmux new-window -t $selected_name -c $selected
    tmux select-window -t $selected_name:0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected -n "nvim" "uv run nvim README.md"
    tmux new-window -t "$selected_name" -c $selected
    tmux select-window -t "$selected_name:0"
fi

if [[ -z $TMUX ]]; then
    tmux attach -t $selected_name
else
    tmux switch-client -t $selected_name
fi
