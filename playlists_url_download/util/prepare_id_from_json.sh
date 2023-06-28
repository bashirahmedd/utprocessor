#!/bin/bash

# filter data based on the duration from the source file
# remove qoutes from  id string 

src_dir="../output/"
src_nme="PLg6KfZlgBuDXwQ56IZ8tByQGgmgONP4Wr"
src_file="$src_dir""$src_nme"".json"
out_file="$src_dir""$src_nme"".txt"
#up limit in seconds
jq -r '.[]|select(.duration<600)|.id' "$src_file" > "$out_file"   

json_obj_count=`jq '. | length' $src_file`
ids_count=`cat $out_file|wc -l`
echo "Ids filtered = ""$ids_count"" from ""$json_obj_count"