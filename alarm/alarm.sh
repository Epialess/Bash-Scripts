#!/bin/bash

# A script that “sleeps” for a given number of seconds before beeping 
# after the time has elapsed.

usage() {
    echo "Usage: $0 [-h hours] [-m minutes] [-s seconds] [-msg message] [-f sound_file] [-z snooze_minutes]"
    echo "Example: $0 -h 0 -m 2 -s 30 -msg 'Time is up!' -f /path/to/sound.wav -z 3"
    exit 1
}

hours=0
minutes=0
seconds=0
message="Time's up!"
sound_file=""
snooze_minutes=0

# Parse command-line options
while getopts "h:m:s:msg:f:z:" opt; do
    case $opt in
        h) hours=$OPTARG ;;
        m) minutes=$OPTARG ;;
        s) seconds=$OPTARG ;;
        msg) message=$OPTARG ;;
        f) sound_file=$OPTARG ;;
        z) snooze_minutes=$OPTARG ;;
        *) usage ;;
    esac
done

total_seconds=$((hours * 3600 + minutes * 60 + seconds))

trigger_alarm() {
    # Play sound or beep
    if [[ -n $sound_file && -f $sound_file ]]; then
        # Play the sound file if it exists
        paplay $sound_file || echo -e "\a"
    else
        echo -e "\a"
    fi
    echo $message
}

handle_snooze() {
    if [ $snooze_minutes -gt 0 ]; then
        read -p "Snooze? (y/n): " snooze_answer
        if [[ $snooze_answer == "y" ]]; then
            echo "Snoozing for $snooze_minutes minutes..."
            sleep $((snooze_minutes * 60))
            trigger_alarm
        fi
    fi
}

# Main
if [ $total_seconds -le 0 ]; then
    echo "Error: Duration cannot be zero or negative."
    usage
else
    # Sleep for the specified duration
    sleep $total_seconds

    trigger_alarm
    handle_snooze
fi
