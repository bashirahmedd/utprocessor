#!/bin/bash

cd /home/naji/Downloads/StudentAssignments
rm *.zip
rm *.ZIP
rm -r */
rm *.html *.htm
killall -9 code
killall -9 brave     #used for testing student assignments
wmctrl -a Google Chrome    #turn focus to vs code editor
#code .  