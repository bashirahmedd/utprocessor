#!/bin/bash

#youtube-dl --write-srt --sub-lang en -o ./  https://www.youtube.com/watch?v=X4_Xv6jxSw0
#youtube-dl --write-sub --sub-lang en --skip-download https://www.youtube.com/watch?v=X4_Xv6jxSw0
#youtube-dl --write-auto-sub --sub-lang en --skip-download https://www.youtube.com/watch?v=X4_Xv6jxSw0
fl='https://www.youtube.com/watch?v=BWgyIxqMiXQ'
curr_file_sz=`youtube-dl -f 22/18/17 $fl -j | jq .filesize`
echo $curr_file_sz

#youtube-dl https://www.youtube.com/watch?v=BWgyIxqMiXQ -j | jq .filesize
#youtube-dl --no-mtime -f 22/18/17 https://www.youtube.com/watch?v=BWgyIxqMiXQ
#youtube-dl 'http://www.snotr.com/video/13708/Drone_flying_through_fireworks' -j | jq .filesize_approx