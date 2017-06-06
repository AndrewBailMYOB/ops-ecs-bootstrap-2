#!/bin/bash

orig="$1"
repl="$2"
token="TASKENVIRONMENT"

usage() { echo "usage: $0 original_file snippet_file"; exit 0; }
[[ "$#" -gt 1 ]] || usage

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
done <"$orig"
