#!/bin/bash

if [ "$1" == "false" ]; then
    sh -c "sed -i 's/1/0/g' /etc/gooroom/gooroom-update/auto-upgrade"
else
    sh -c "sed -i 's/0/1/g' /etc/gooroom/gooroom-update/auto-upgrade"

fi
