#!/bin/bash
#sudo apt install mpv

echo "$1"
mpv --version
mpv --save-position-on-quit --write-filename-in-watch-later-config -fs "$1"
