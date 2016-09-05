#!/bin/bash
# vim: set ft=sh tabstop=4 shiftwidth=4 noexpandtab :

# [[  0 ]] # Modify history (no longer needed)
wget -O /home/user1/.bash_history ivanx.com/rasppleii/bash_history-vm.txt
history -c
history -r

[[  1 ]]
sudo tee /etc/sudoers.d/group-sudo-nopasswd >/dev/null <<EOF
# Allow members of group sudo to execute any command without a password
%sudo   ALL=(ALL:ALL) NOPASSWD: ALL
EOF
sudo chmod 440 /etc/sudoers.d/group-sudo-nopasswd

# [[  2 ]] # Use default root path instead of user path for all users
# sed to English: Only in the range of line 0 to the first line containing
# pattern /-eq 0/, replace that pattern with "-ge 0".
sudo sed -i '0,/-eq 0/{ s/-eq 0/-ge 0/ }' /etc/profile
source /etc/profile

# [[  3 ]] # Install A2SERVER
cd /tmp
wget -O setup ivanx.com/a2server/setup
source setup -y -w

# [[  4 ]] # Install A2CLOUD
cd /tmp
rm /usr/local/adtpro/disks/A2CLOUD.* 2> /dev/null
wget -O setup ivanx.com/a2cloud/setup
source setup -y -r

# [[  5 ]] # Get version number and write out /etc/issue
sudo wget -O /etc/issue ivanx.com/rasppleii/issue-vm.txt
echo -n "A2SERVER VM release number? "
read
sudo sed -i "s/A2SERVER VM release.*$/A2SERVER VM release $REPLY/" /etc/issue

# [[  6 ]] # Install MOTD
sudo wget -O /etc/motd ivanx.com/rasppleii/motd-vm.txt
