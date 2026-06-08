#!/usr/bin/env bash

cliphist list | while IFS=$'\t' read -r id content; do
    if [[ -z "$id" ]]; then
        continue
    fi

    if [[ "$content" =~ ^\<meta\ http-equiv ]]; then
        continue
    fi

    if [[ "$content" =~ ^\[\[\ binary\ data.*(png|jpeg|jpg|bmp) ]]; then
        ext="${BASH_REMATCH[1]}"
        case "$ext" in
            jpg|jpeg) mime="image/jpeg" ;;
            png) mime="image/png" ;;
            bmp) mime="image/bmp" ;;
        esac

        dims=""
        if [[ "$content" =~ ([0-9]+)x([0-9]+) ]]; then
            dims=" ${BASH_REMATCH[1]}x${BASH_REMATCH[2]}"
        fi
        display_text="[Image]$dims"

        b64=$(cliphist decode <<< "$id"$'\t' 2>/dev/null | base64 -w0)
        if [[ -n "$b64" ]]; then
            printf 'I\x1f%s\x1f%s\x1f%s\x1f%s\n' "$id" "$mime" "$display_text" "$b64"
        fi
    else
        printf 'T\x1f%s\x1f%s\n' "$id" "$content"
    fi
done
