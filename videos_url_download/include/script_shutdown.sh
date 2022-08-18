#!/bin/bash

# shutdown-now signal is higher in precedence, shutdown-now is not recommended
# shutdown is lower in precedence, shutdown is preferred

fn_shutdown_signal() 
{
    msg_delay=5
    if [[ -f "$shutdown_now_signal_file" ]]; then
        fn_say "System shutdown called"
        fn_say "System will proceed to shutdown immediately."
        sleep $msg_delay
        shutdown now
        exit 0
    elif [[ -f "$shutdown_signal_file" ]]; then
        fn_say "System shutdown called"
        fn_say "System will proceed to shutdown in 120 seconds."
        sleep $msg_delay
        shutdown +2 Shutting down in 2 minutes!
        exit 0
    fi    
}

# Test Calls for the above functions
#fn_shutdown_signal $*
#fn_shutdown_signal "Hello Hello, how are you?"
#./script_shutdown.sh "EB is naughty boy. EB is bad boy, he is touching computer. He is disturbing others. Computer is angry. Computer will slap EB on the cheeks. "