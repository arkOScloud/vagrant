#!/usr/bin/env bash

# Add a hostname
echo "arkos-vagrant" > /etc/hostname

# Trust arkOS signing key
if [ ! -d /root/.gnupg ]
then
	mkdir /root/.gnupg
fi
pacman-key -r 0585F850
pacman-key --lsign 0585F850

# Get prerequisites
pacman --noconfirm -Sy wget

# Install arkOS package repo details
wget -O /tmp/arkos-mirrorlist.pkg.tar.xz https://pkg.arkos.io/resources/arkos-mirrorlist-latest.pkg.tar.xz
pacman --noconfirm -U /tmp/arkos-mirrorlist.pkg.tar.xz
curl "https://www.archlinux.org/mirrorlist/?country=CA&protocol=http&ip_version=4" 2>/dev/null > /etc/pacman.d/mirrorlist && sed -i 's/\#Server/Server/g' /etc/pacman.d/mirrorlist

# Update the system
pacman --noconfirm -Syu

# Install system dependencies
pacman --noconfirm -Sy --needed pkg-config binutils gcc iptables python python-virtualenv python-pip python2-pip arkos-configs python-gobject nginx git openldap fail2ban supervisor ruby nodejs npm ntp cronie redis avahi parted dbus-glib

# Prepare arkOS working environment
mkdir -p /var/lib/arkos
cd /home/vagrant
virtualenv venv
if [ ! -d /home/vagrant/core ]
then
	git clone https://git.coderouge.co/arkOS/core.git core
fi
if [ ! -d /home/vagrant/kraken ]
then
	git clone https://git.coderouge.co/arkOS/kraken.git kraken
fi
if [ ! -d /home/vagrant/genesis ]
then
	git clone https://git.coderouge.co/arkOS/genesis.git genesis
fi
if [ ! -d /var/lib/arkos/applications ]
then
	git clone https://git.coderouge.co/arkOS/apps.git /var/lib/arkos/applications
fi

cd /home/vagrant/genesis
npm install -g bower ember-cli@1.13.13 phantomjs-prebuilt
npm install
bower install --allow-root
ember build

cp /vagrant/arkostest.sh /home/vagrant/arkostest.sh
chmod +x /home/vagrant/arkostest.sh

rm /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
localectl set-locale "LANG=en_US.UTF-8"

pacman -Scc --noconfirm

source /home/vagrant/venv/bin/activate
cd /home/vagrant/core && pip install -r requirements.txt && pip install -e .
cd /home/vagrant/kraken && pip install -r requirements.txt
sudo arkosctl init ldap --yes
sudo arkosctl init nslcd
sudo arkosctl init nginx
sudo arkosctl init redis

echo "source /home/vagrant/venv/bin/activate" > "/home/vagrant/.bashrc"
