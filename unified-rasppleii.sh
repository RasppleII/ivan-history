#!/bin/bash
# vim: set ft=sh tabstop=4 shiftwidth=4 noexpandtab :

# FIXME: Neither $isRPi nor $isDebian are set at this time, nor are they
# really intended to be set.  They're just kind of a placeholder to identify
# which code is for which platform for now.

#X# Make sudo work without passwd for users in group sudo
sudo tee /etc/sudoers.d/group-sudo-nopasswd >/dev/null <<EOF
# Allow members of group sudo to execute any command without a password
%sudo   ALL=(ALL:ALL) NOPASSWD: ALL
EOF
sudo chmod 440 /etc/sudoers.d/group-sudo-nopasswd

#X# Set system not to stat X11 by default
sudo systemctl set-default multi-user.target

#X# Fix NOOBS's twiddling with video settings
if [ $isRPi ]; then
	if ! grep -q NOOBS /etc/rc.local; then
		sudo sed -i \
"s@^exit 0@# Remove NOOBS's video config.txt video tampering.  The Pi's bootloader is
# unable to detect some nonstandard HDMI displays, so unless the user tells
# it to use composite, NOOBS forces HDMI.  We use unattended install, and
# it's better to err on the side of composite for Apple // users anyway.
if grep -q NOOBS /boot/config.txt; then
	tac /boot/config.txt | sed '1,9d' | tac > /tmp/config.txt
	cp /tmp/config.txt /boot/config.txt
	mkdir -p /tmp/p1
	mount /dev/mmcblk0p1 /tmp/p1
	sed -i 's/silentinstall//' /tmp/p1/recovery.cmdline
	umount /tmp/p1
	shutdown -r now
fi

exit 0@" /etc/rc.local
	fi
	if grep -q NOOBS /boot/config.txt; then
		tac /boot/config.txt | sed '1,9d' | tac > /tmp/config.txt
		sudo cp /tmp/config.txt /boot/config.txt
	fi
fi

#X# Configure keyboard, timezone, and locale
#!# Applied with changes for Jessie
sudo rm /etc/default/keyboard
sudo debconf-set-selections <<EOF
keyboard-configuration keyboard-configuration/modelcode select pc104
keyboard-configuration keyboard-configuration/xkb-keymap select us
keyboard-configuration keyboard-configuration/layout select English (US)
keyboard-configuration keyboard-configuration/variant select English (US)
keyboard-configuration keyboard-configuration/model select Generic 104-key PC
keyboard-configuration keyboard-configuration/layoutcode select us
EOF
sudo dpkg-reconfigure -f noninteractive keyboard-configuration
sudo invoke-rc.d keyboard-setup start
sudo setupcon

#X#
sudo rm /etc/timezone
sudo debconf-set-selections <<EOF
tzdata tzdata/Areas select America
tzdata tzdata/Zones/America select Los_Angeles
EOF
sudo dpkg-reconfigure -f noninteractive tzdata

#X#
sudo rm /etc/default/locale /etc/locale.gen 2> /dev/null
sudo debconf-set-selections <<EOF
locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8, en_US ISO-8859-1
locales locales/default_environment_locale select en_US.UTF-8
EOF
sudo dpkg-reconfigure -f noninteractive locales
source /etc/default/locale

## disable running raspi-config at reboot if enabled
if [[ -e /etc/profile.d/raspi-config.sh ]]; then
	sudo rm -f /etc/profile.d/raspi-config.sh
	sudo sed -i /etc/inittab -e "s/^#\(.*\)#\s*RPICFG_TO_ENABLE\s*/\1/" -e "/#\s*RPICFG_TO_DISABLE/d"
	sudo telinit q
fi

#!# Use default root path instead of user path for all users
#!# A solution for this exists in pi-gen, but we ought to use a different one
if [ $isDebian ]; then
	# sed to English: Only in the range of line 0 to the first line containing
	# pattern /-eq 0/, replace that pattern with "-ge 0".
	sudo sed -i '0,/-eq 0/{ s/-eq 0/-ge 0/ }' /etc/profile
	source /etc/profile
fi

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
echo -n "Raspple II release number? "
read RASPPLEII_VERSION
printf -v RASPPLEII_ISSUE "Raspple II release %s\n%s" "$RASPPLEII_VERSION" "$(cat /etc/issue)"

## Install MOTD
sudo install -m644 motd.txt /etc/motd
if [ ! $isRPi ]; then
	# Delete the line about raspi-config
	sudo sed -i '/raspi-config/d' /etc/motd
fi
