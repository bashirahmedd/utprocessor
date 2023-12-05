#!/bin/bash

cd /home/naji/Downloads/StudentAssignments
unzip -o *.zip
unzip -o *.ZIP
#xdotool windowminimize $(xdotool getactivewindow)
#wmctrl -a Code    #turn focus to vs code editor
code .  
