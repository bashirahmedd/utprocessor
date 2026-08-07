#!/bin/bash

dir="${1:-.}"
echo "$dir"

for img in "$dir"/*.png; do
  [ -e "$img" ] || continue
  convert "$img" -background white -flatten "${img%.png}.jpg"
done
