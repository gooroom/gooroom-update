#!/bin/bash

# Check synaptic parameters
if [[ "$@" != "--hide-main-window --non-interactive --parent-window-id"* ]]
then
        /usr/bin/zenity --warning --title "Warning" --text "Abnormal approach!!"
        exit -1
fi

# Get Grand Parent Pid
gparent_pid="$(ps -o ppid= $PPID)"
gparent_pid="${gparent_pid// /}"
gparent_path="$(ps -q $gparent_pid -o comm=) $(ps -q $gparent_pid -o args=)"

# Check Absolute File Path of Parent Process (Caller) and arguments via cmdline of /proc/
if [[ "$gparent_path" == "gooroomUpdate /usr/bin/python2.7 -E /usr/lib/gooroom/gooroomUpdate/gooroomUpdate.py" ]] && \
   [[ "$(/bin/cat /proc/$gparent_pid/cmdline)" == "/usr/bin/python2.7-E/usr/lib/gooroom/gooroomUpdate/gooroomUpdate.py" ]]
then
	/usr/sbin/synaptic "$@"
else
	/usr/bin/zenity --warning --title "Warning" --text "Parent Process isn't GooroomUpdate!!"
fi
