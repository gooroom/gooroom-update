#!/bin/bash

filename=$(mktemp)
cnt=0

while [[ $# -gt 0 ]]
do

arg="$1"

case $arg in
    --set-selections-file)
    args="$args $arg $filename"
    for i in $(echo "$2" | sed "s/,/ /g"); do
        echo "$i install" >> $filename
    done
    cnt=$(($cnt+1))
    shift;shift
    ;;

    --hide-main-window)
    args="$args $arg"
    cnt=$(($cnt+1))
    shift
    ;;

    --non-interactive)
    args="$args $arg"
    cnt=$(($cnt+1))
    shift
    ;;

    --parent-window-id)
    args="$args $arg $2"
    cnt=$(($cnt+1))
    shift;shift
    ;;

    -o)
    args="$args $arg $2"
    cnt=$(($cnt+1))
    shift;shift
    ;;

    --progress-str)
    args="$args $arg $2"
    cnt=$(($cnt+1))
    shift;shift
    ;;

    --finish-str)
    args="$args $arg $2"
    cnt=$(($cnt+1))
    shift;shift
    ;;
esac
done

# Check synaptic parameters
if [[ "$cnt" != "7" ]]
then
        /usr/bin/zenity --warning --title "Warning" --text "Abnormal approach!!"
        rm -rf "$filename"
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
    /usr/sbin/synaptic $args
else
    /usr/bin/zenity --warning --title "Warning" --text "Parent Process isn't GooroomUpdate!!"
fi


rm -rf "$filename"
