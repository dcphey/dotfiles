#!/bin/sh

for svg in "$(dirname $0)"/*.svg; do
    sed -i "s#\#212121#\#ffffff#" "$svg"
done
