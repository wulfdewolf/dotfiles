#!/usr/bin/env bash
# Turn every output OFF first (connected *or* disconnected)
for output in $(xrandr | awk '/^[^ ]+ (dis)?connected/ {print $1}'); do
    xrandr --output "$output" --off
done

# Now switch on & arrange only the ones that are really connected
pos_x=0
primary_set=false

for display in $(xrandr | awk '/ connected/ {print $1}'); do
    mode=$(xrandr | awk -v d="$display" '
        $0 ~ "^"d" connected" {flag=1; next}
        flag && /^[[:space:]]+[0-9]+x[0-9]+/ {
            if ($0 ~ /\+/) {print $1; exit}
            if (!best) best=$1
        }
        flag && !/^[[:space:]]/ {exit}
        END {if (!mode) print best}
    ')
    : "${mode:?no mode found for $display}"

    # first output becomes primary
    [[ $primary_set == false ]] && primary_opt=--primary || primary_opt=
    primary_set=true

    echo "Setting $display to $mode at ${pos_x}x0"
    xrandr --output "$display" --mode "$mode" --pos "${pos_x}x0" $primary_opt
    pos_x=$((pos_x + ${mode%x*}))   # add width
done

