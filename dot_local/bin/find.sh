#!/bin/bash

file=$(find ~ -type f 2>/dev/null | fzf)
[ -n "$file" ] && xdg-open "$(dirname "$file")"
