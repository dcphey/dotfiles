#!/bin/sh

xdg_data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
xdg_data_dirs="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

dirs=""
add_dir() {
  [ -d "$1" ] || return 0
  dirs="$dirs $1"
}

add_dir "$xdg_data_home/applications"
for d in ${xdg_data_dirs//:/ }; do
  add_dir "$d/applications"
done

[ -n "$dirs" ] || exit 0

exec inotifywait -m $dirs \
  -e create -e delete -e move -e moved_to -e moved_to -e close_write \
  --include '.*\.desktop$' |
    while read -r directory action file; do
        echo "$directory$file $action"
    done
