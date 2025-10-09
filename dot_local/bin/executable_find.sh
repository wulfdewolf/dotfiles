#!/bin/bash

file=$(find ~ -type f 2>/dev/null | fzf)
[ -n "$file" ] && nohup xdg-open "$(dirname "$file")" >/dev/null 2>&1 &
