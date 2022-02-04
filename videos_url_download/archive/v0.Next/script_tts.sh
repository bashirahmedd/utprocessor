#!/bin/bash
say() 
{
    echo $*
    local IFS=+;/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols "http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=$*&tl=en"; 
    
}
say $*
#say "Hello Hello, how are you?"

#add this config option to $HOME/.mplayer/config
#lirc=no