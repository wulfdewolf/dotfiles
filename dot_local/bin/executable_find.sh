#!/usr/bin/env bash

set -e

FILE=$(
  fdfind -I -t f \
    -E ~/.cache \
    -E ~/.local/share/Trash \
    -E ~/.local/share/Steam \
    . ~ \
  | fzf \
      --prompt="Find file > " \
      --preview '
        batcat --style=numbers --color=always {} 2>/dev/null ||
        (file {} | cut -d: -f2- && ls -lh {})
      ' \
      --preview-window=right:50%
)

[ -n "$FILE" ] && xdg-open "$FILE"
