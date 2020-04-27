#!/bin/bash

# Get Grand Parent Pid
gparent_pid="$(ps -o ppid= $PPID)"
gparent_path="$(ps -q $gparent_pid -o comm=) $(ps -q $gparent_pid -o args=)"

# Check Absolute File Path of Parent Process (Caller)
if [ "$gparent_path" == "gooroomUpdate /usr/bin/python2.7 -E /usr/lib/gooroom/gooroomUpdate/gooroomUpdate.py" ]; then
	/usr/sbin/synaptic $@
else
	/usr/bin/zenity --warning --title "Warning" --text "Parent Process isn't GooroomUpdate!!"
fi
