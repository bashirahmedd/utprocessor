#!/bin/bash

fn_exit_signal() 
{
    if [[ -f "$exit_signal_file" ]]; then
        fn_say "Stop Called"
        fn_say "Please do manual merge of input_id and try_again files."
        exit 0
    fi    
}


# Test Calls for the above functions
#exit_script $*
#exit_script "Hello Hello, how are you?"
#./include_speech.sh "EB is naughty boy. EB is bad boy, he is touching computer. He is disturbing others. Computer is angry. Computer will slap EB on the cheeks. "