#!/bin/bash

orig="/dev/stdin"
repl="${1:-repl.txt}"
token="{replaceme}"

while IFS= read -r line; do
    if [[ "$line" =~ $token ]]; then
        indent=$(echo "$line"|awk '{match($0, /^ */);print RLENGTH}')
        while IFS= read -r rline; do
            iline=$(printf "%*s%s\n" "$indent" '' "$rline")
            echo "$iline"
        done <"$repl"
    else
        echo "$line"
    fi
done <$orig
