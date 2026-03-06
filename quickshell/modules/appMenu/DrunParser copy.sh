#!/bin/sh

find_icon() {
    icon_name=$1

    for dir in "$XDG_DATA_HOME/icons" ${XDG_DATA_DIRS//:/ }/icons ${XDG_DATA_DIRS//:/ }/pixmaps; do
        [ -d "$dir" ] || continue
        match=$(find "$dir" -type f \( -name "$icon_name.png" -o -name "$icon_name.svg" -o -name "$icon_name.xpm" \) 2>/dev/null | head -n1)
        if [ -n "$match" ]; then
            echo "$match"
            return
        fi
    done
}

first=1
echo "["
for path in "$XDG_DATA_HOME" ${XDG_DATA_DIRS//:/ }; do
    for f in "$path"/applications/*.desktop; do
        [ -e "$f" ] || continue

        json=$(awk -F= '
        /^\[Desktop Entry\]/ {in_section=1; next}
        /^\[/ {in_section=0}
        in_section {
            if ($1 ~ /^(Name|Comment|Icon|Exec|Keywords|GenericName|NoDisplay)$/) {
                gsub(/"/, "\\\"", $2);
                fields[$1]=$2
            }
        }
        END {
            print "{"
            for (k in fields) {
                printf "\"%s\": \"%s\",", k, fields[k]
            }
            print "\b}"
        }
        ' "$f" | sed '$s/,$//')

        # Skip if NoDisplay=true
        nodisplay=$(echo "$json" | grep '"NoDisplay": "true"')
        [ -n "$nodisplay" ] && continue
        echo ---------------------------------------------------------------------
        echo $json

        # Resolve icon path
        icon=$(echo "$json" | grep -oP '"Icon": "[\w\W]*",' | cut -d'"' -f4)
        if [ -n "$icon" ]; then
            resolved=$(find_icon "$icon")
            json=$(echo "$json" | sed "s#\"Icon\": \"[^\"]*\"#\"Icon\": \"$resolved\"#")
        fi


        # Print comma between JSON objects
        if [[ $first -eq 0 ]]; then
            echo ","
        else
            first=0
        fi

        echo $json
    done
done
echo "]"
