#!/bin/bash
# vim: set ft=sh tabstop=4 shiftwidth=4 noexpandtab :

[[  0 ]]
wget -O /home/pi/.bash_history ivanx.com/rasppleii/bash_history-rasppleii.txt
history -c
history -r


[[  1 ]]
sudo systemctl set-default multi-user.target &> /dev/null
sudo shutdown -r now


[[  2 ]]
if ! grep -q NOOBS /etc/rc.local; then
	sudo sed -i "s@^exit 0@# Remove NOOBS's video config.txt video tampering.  The Pi's bootloader is
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


[[  3 ]]
sudo rm /etc/default/keyboard
echo "keyboard-configuration keyboard-configuration/modelcode select pc104" | sudo debconf-set-selections
echo "keyboard-configuration keyboard-configuration/xkb-keymap select us" | sudo debconf-set-selections
echo "keyboard-configuration keyboard-configuration/layout select English (US)" | sudo debconf-set-selections
echo "keyboard-configuration keyboard-configuration/variant select English (US)" | sudo debconf-set-selections
echo "keyboard-configuration keyboard-configuration/model select Generic 104-key PC" | sudo debconf-set-selections
echo "keyboard-configuration keyboard-configuration/layoutcode select us" | sudo debconf-set-selections
sudo dpkg-reconfigure -f noninteractive keyboard-configuration
sudo invoke-rc.d keyboard-setup start
sudo setupcon

sudo rm /etc/timezone
echo "tzdata tzdata/Zones/US select Eastern" | sudo debconf-set-selections
echo "tzdata tzdata/Areas select US" | sudo debconf-set-selections
sudo dpkg-reconfigure -f noninteractive tzdata

sudo rm /etc/default/locale /etc/locale.gen 2> /dev/null
echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8, en_US ISO-8859-1" | sudo debconf-set-selections
echo "locales locales/default_environment_locale select en_US.UTF-8" | sudo debconf-set-selections
sudo dpkg-reconfigure -f noninteractive locales
source /etc/default/locale

if [[ -e /etc/profile.d/raspi-config.sh ]]; then
	sudo rm -f /etc/profile.d/raspi-config.sh
	sudo sed -i /etc/inittab -e "s/^#\(.*\)#\s*RPICFG_TO_ENABLE\s*/\1/" -e "/#\s*RPICFG_TO_DISABLE/d"
	sudo telinit q
fi


[[  4 ]]
cd /tmp
wget -O setup ivanx.com/a2server/setup
source setup -y -w


[[  5 ]]
cd /tmp
rm /usr/local/adtpro/disks/A2CLOUD.* 2> /dev/null
wget -O setup ivanx.com/a2cloud/setup
source setup -y -r


[[  6 ]]
sudo wget -O /etc/issue ivanx.com/rasppleii/issue-rasppleii.txt
echo -n "Raspple II release number? "
read
sudo sed -i "s/Raspple II release.*$/Raspple II release $REPLY/" /etc/issue


[[  7 ]]
sudo wget -O /etc/motd ivanx.com/rasppleii/motd-rasppleii.txt


[[  8 ]]
mkdir -p /tmp/usbdisk
sudo mount /dev/sda1 /tmp/usbdisk
sudo rm /tmp/usbdisk/BOOT.TAR &> /dev/null
pwd="$PWD"
cd /boot
sudo tar -cvpf /tmp/usbdisk/BOOT.TAR .
cd "$pwd"
sudo umount /dev/sda1
rmdir /tmp/usbdisk


[[  9 ]]
mkdir -p /tmp/usbdisk
sudo mount /dev/sda1 /tmp/usbdisk
sudo rm /tmp/usbdisk/ROOT.TAR &> /dev/null
sudo tar -cvpf /tmp/usbdisk/ROOT.TAR /* --exclude=proc/* --exclude=sys/* --exclude=dev/pts/* --exclude=/tmp/* --exclude=/var/swap --exclude=/boot/* --exclude=/home/pi/.ssh/*
sudo umount /dev/sda1
rmdir /tmp/usbdisk
