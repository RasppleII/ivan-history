#!/bin/bash
# vim: set filetype=sh tabstop=4 shiftwidth=4 expandtab :

if [[ -f /usr/bin/raspi-config ]]; then
    wget -O /home/pi/.bash_history ivanx.com/rasppleii/bash_history-rasppleii.txt; history -c; history -r
else
    wget -O /home/user1/.bash_history ivanx.com/rasppleii/bash_history-vm.txt; history -c; history -r
fi
