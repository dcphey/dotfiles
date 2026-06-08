#!/bin/sh

declare -A icon_cache

resolve_one() {
  local name=$1
  [[ -z "$name" ]] && return
  [[ -n ${icon_cache[$name]} ]] && { echo "$name|${icon_cache[$name]}"; return; }

  local resolved=""
  for dir in "$XDG_DATA_HOME/icons" ${XDG_DATA_DIRS//:/ }/icons ${XDG_DATA_DIRS//:/ }/pixmaps; do
    [ -d "$dir" ] || continue
    match=$(find "$dir" -type f \( -name "$name.png" -o -name "$name.svg" -o -name "$name.xpm" \) -print -quit 2>/dev/null)
    if [ -n "$match" ]; then
      resolved=$match
      break
    fi
  done

  icon_cache[$name]=$resolved
  echo "$name|$resolved"
}

if [ $# -gt 0 ]; then
  for name in "$@"; do resolve_one "$name"; done
else
  while IFS= read -r name; do resolve_one "$name"; done
fi
