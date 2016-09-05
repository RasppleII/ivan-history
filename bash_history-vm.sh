#!/bin/bash
# vim: set ft=sh tabstop=4 shiftwidth=4 noexpandtab :

## Make sudo work without passwd for users in group sudo
sudo tee /etc/sudoers.d/group-sudo-nopasswd >/dev/null <<EOF
# Allow members of group sudo to execute any command without a password
%sudo   ALL=(ALL:ALL) NOPASSWD: ALL
EOF
sudo chmod 440 /etc/sudoers.d/group-sudo-nopasswd


## Use default root path instead of user path for all users
# sed to English: Only in the range of line 0 to the first line containing
# pattern /-eq 0/, replace that pattern with "-ge 0".
sudo sed -i '0,/-eq 0/{ s/-eq 0/-ge 0/ }' /etc/profile
source /etc/profile


## Install A2SERVER
cd /tmp
wget -O setup ivanx.com/a2server/setup
source setup -y -w


## Install A2CLOUD
cd /tmp
rm /usr/local/adtpro/disks/A2CLOUD.* 2> /dev/null
wget -O setup ivanx.com/a2cloud/setup
source setup -y -r


## Get version number and write out /etc/issue
sudo wget -O /etc/issue ivanx.com/rasppleii/issue-vm.txt
echo -n "A2SERVER VM release number? "
read
sudo sed -i "s/A2SERVER VM release.*$/A2SERVER VM release $REPLY/" /etc/issue


## Install MOTD
sudo wget -O /etc/motd ivanx.com/rasppleii/motd-vm.txt
