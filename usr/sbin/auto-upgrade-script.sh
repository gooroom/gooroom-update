#!/bin/bash

if [ "$1" == "false" ]; then
    sh -c 'sed s/%sudo/#%sudo/g /etc/sudoers.d/gooroom-update > /gooroom-update && chmod 0440 /gooroom-update && mv /gooroom-update /etc/sudoers.d/gooroom-update'
else
    sh -c 'sed s/#%sudo/%sudo/g /etc/sudoers.d/gooroom-update > /gooroom-update && chmod 0440 /gooroom-update && mv /gooroom-update /etc/sudoers.d/gooroom-update'

fi
