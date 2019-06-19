#!/bin/bash

# Get Grand Parent Pid
gparent_pid="$(ps -o ppid= $PPID)"
gparent_path="$(ps -p $gparent_pid --context | awk '{print $3" "$4}' | tail -n +2)"

echo "$gparent_path" >> /tmp/synaptic-script.log

# Check Absolute File Path of Parent Process (Caller)
if [ "$gparent_path" == "/usr/bin/python2.7 /usr/lib/gooroom/gooroomUpdate/gooroomUpdate.py" ]; then
	/usr/sbin/synaptic $@
else
	/usr/bin/zenity --warning --title "Warning" --text "Parent Process isn't GooroomUpdate!!"
fi
