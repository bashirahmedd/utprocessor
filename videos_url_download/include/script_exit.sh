#!/bin/bash

fn_exit_signal() 
{
    if [[ -f "$exit_signal_file" ]]; then
        fn_say "Stop download called"
        fn_say "Please do manual merge of input_id and try_again files."
        exit 0
    fi    
}

# Test Calls for the above functions
#fn_exit_signal $*
#fn_exit_signal "Hello Hello, how are you?"
#./script_exit.sh "EB is naughty boy. EB is bad boy, he is touching computer. He is disturbing others. Computer is angry. Computer will slap EB on the cheeks. "