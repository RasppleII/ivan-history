#!/bin/bash
# vim: set ft=sh tabstop=4 shiftwidth=4 noexpandtab :

[[  0 ]]
wget -O /home/user1/.bash_history ivanx.com/rasppleii/bash_history-vm.txt
history -c
history -r

[[  1 ]]
sudo tee /etc/sudoers.d/group-sudo-nopasswd >/dev/null <<EOF
# Allow members of group sudo to execute any command without a password
%sudo   ALL=(ALL:ALL) NOPASSWD: ALL
EOF
sudo chmod 440 /etc/sudoers.d/group-sudo-nopasswd

[[  2 ]]
sudo sed -i '0,/-eq 0/s/-eq 0/-ge 0/' /etc/profile
source /etc/profile

[[  3 ]]
cd /tmp; wget -O setup ivanx.com/a2server/setup
source setup -y -w

[[  4 ]]
cd /tmp
rm /usr/local/adtpro/disks/A2CLOUD.* 2> /dev/null
wget -O setup ivanx.com/a2cloud/setup
source setup -y -r

[[  5 ]]
sudo wget -O /etc/issue ivanx.com/rasppleii/issue-vm.txt
echo -n "A2SERVER VM release number? "
read
sudo sed -i "s/A2SERVER VM release.*$/A2SERVER VM release $REPLY/" /etc/issue

[[  6 ]]
sudo wget -O /etc/motd ivanx.com/rasppleii/motd-vm.txt
