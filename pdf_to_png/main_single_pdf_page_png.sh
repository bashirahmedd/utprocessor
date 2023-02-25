#!/bin/bash

in_pdf_file="/home/naji/bashir-workspace/kids_corner/books/pre_level_1/math primer_0.pdf"
out_dir=$(dirname "$in_pdf_file")
#echo $out_dir
first_pg=14
last_pg=15

pdftoppm -png -rx 300 -ry 300 -f "$first_pg" -l "$last_pg" "$in_pdf_file"  "$in_pdf_file"