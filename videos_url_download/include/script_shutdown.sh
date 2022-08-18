#!/bin/bash

fn_shutdown_signal() 
{
    if [[ -f "$shutdown_signal_file" ]]; then
        fn_say "System shutdown Called"
        fn_say "System will proceed to shutdown in 120 seconds."
        sleep 5
        shutdown +2 Shutting down in 2 minutes!
        exit 0
    fi    
}

# Test Calls for the above functions
#fn_shutdown_signal $*
#fn_shutdown_signal "Hello Hello, how are you?"
#./script_shutdown.sh "EB is naughty boy. EB is bad boy, he is touching computer. He is disturbing others. Computer is angry. Computer will slap EB on the cheeks. "