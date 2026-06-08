#!/bin/sh
printf '%d' "$1" | cliphist decode | wl-copy
