#!/bin/bash
#sudo apt install mpv
#add this file to PATH dir i.e. /home/naji/bin/mpv_watch_later.sh

echo "$1"
mpv --version
mpv --save-position-on-quit --write-filename-in-watch-later-config -fs "$1"
