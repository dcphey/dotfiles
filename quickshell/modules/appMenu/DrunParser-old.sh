#!/bin/sh

first=1
echo "["
for path in "$XDG_DATA_HOME" ${XDG_DATA_DIRS//:/ }; do
    for f in "$path"/applications/*.desktop; do
        [ -e "$f" ] || continue

        if [[ $first -eq 0 ]]; then
            echo ","
        fi

        first=0

        echo "{"
        awk -F= '/^\[Desktop Entry\]/ {in_section=1; next} /^\[/ {in_section=0} in_section && /^(Name|Comment|Icon|Exec|Keywords|GenericName|NoDisplay)=/ {gsub(/"/, "\\\"", $2); print "\""$1"\": \""$2"\","}' "$f" | sed '$s/,$//'
         echo "}"
    done
done
echo "]"
