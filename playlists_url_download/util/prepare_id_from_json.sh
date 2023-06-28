#!/bin/bash

# filter data based on the duration from the source file
# remove qoutes from  id string 

src_dir="../output/"
src_nme="PLF_XMn-l0vPS5vLAaL1f73z2HwSNZ1vZy"
src_file="$src_dir""$src_nme"".json"

#up limit in seconds
jq -r '.[]|select(.duration<600)|.id' "$src_file" > "$src_dir""$src_nme"".txt"   
