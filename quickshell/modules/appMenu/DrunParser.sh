#!/bin/sh

for path in "$XDG_DATA_HOME" ${XDG_DATA_DIRS//:/ }; do
  for f in "$path"/applications/*.desktop; do
    [ -e "$f" ] || continue

    json=$(awk -F= '
    /^\[Desktop Entry\]/ {in_section=1; next}
    /^\[/ {in_section=0}
    in_section && $1 ~ /^(Name|Comment|Icon|Exec|Keywords|GenericName|NoDisplay|Terminal)$/ {
      gsub(/"/, "\\\"", $2);
      fields[$1]=$2
    }
    END {
      printf "{"
      n=0
      for (k in fields) {
        if (n++) printf ","
        printf "\"%s\":\"%s\"", k, fields[k]
      }
      print "}"
    }
    ' "$f")

    [[ $json == *'"NoDisplay":"true"'* ]] && continue

    echo "$json"
  done
done

echo "__DRUN_END__"
